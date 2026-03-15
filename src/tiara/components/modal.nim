import ../core
import ./utils
export utils

when defined(js):
  import std/dom

  proc getMotionMs(node: Element, fallbackMs: int): int =
    if node.isNil: return fallbackMs
    let rawStr = node.getAttribute("data-tiara-motion-ms")
    if rawStr.isNil or $rawStr == "": return fallbackMs
    try:
      let raw = parseInt($rawStr)
      if raw > 0: return raw
    except ValueError:
      discard
    return fallbackMs

  proc requestAnimationFrame(cb: proc()) {.importc.}

  proc tiaraModalOpen*(e: Event) {.client.} =
    let opener = e.target.Element.closest("[data-tiara-modal-target]")
    if not opener.isNil:
      let dialogId = opener.getAttribute("data-tiara-modal-target")
      if not dialogId.isNil:
        let dialog = document.getElementById($dialogId)
        if not dialog.isNil:
          let motionMs = getMotionMs(dialog, 220)
          dialog.style.setProperty("--tiara-motion-ms", cstring($motionMs & "ms"))
          
          let jsDialog = dialog.toJs()
          if not isUndefined(jsDialog.tiaraCloseTimer) and not isNull(jsDialog.tiaraCloseTimer):
            window.clearTimeout(jsDialog.tiaraCloseTimer.to(TimeOut))
            jsDialog.tiaraCloseTimer = jsNull
            
          if jsTypeof(jsDialog.showModal) == cstring("function"):
            jsDialog.showModal()
            
          if dialog.hasClassList():
            dialog.classList.remove("is-closing")
            dialog.classList.remove("is-opening")
            
          requestAnimationFrame(proc() =
            if dialog.hasClassList():
              dialog.classList.add("is-open")
          )

  proc doModalClose(dialog: Element) =
    if dialog.isNil: return
    let motionMs = getMotionMs(dialog, 220)
    dialog.style.setProperty("--tiara-motion-ms", cstring($motionMs & "ms"))
    
    let jsDialog = dialog.toJs()
    if not isUndefined(jsDialog.tiaraCloseTimer) and not isNull(jsDialog.tiaraCloseTimer):
      window.clearTimeout(jsDialog.tiaraCloseTimer.to(TimeOut))
      jsDialog.tiaraCloseTimer = jsNull
      
    if dialog.hasClassList():
      dialog.classList.remove("is-open")
      dialog.classList.add("is-closing")
      
    jsDialog.tiaraCloseTimer = window.setTimeout(proc() =
      jsDialog.tiaraCloseTimer = jsNull
      if dialog.hasClassList():
        dialog.classList.remove("is-closing")
      if jsTypeof(jsDialog.close) == cstring("function"):
        jsDialog.close()
    , motionMs)

  proc tiaraModalClose*(e: Event) {.client.} =
    let btn = e.target.Element.closest("[data-tiara-modal-close]")
    if not btn.isNil:
      let hostDialog = btn.closest("dialog")
      if not hostDialog.isNil:
        doModalClose(hostDialog)
        
  proc tiaraModalBackdropClick*(e: Event) {.client.} =
    let target = e.target.Element
    if target.matches("dialog[data-tiara=\"modal\"]"):
      doModalClose(target)

proc modal*(
  T: typedesc[Tiara],
  id: string,
  trigger: Html,
  content: Html,
  title = "",
  closeLabel = "閉じる",
  size = "medium",
  motionMs = 220,
  attrs: seq[(string, string)] = @[]
): Html =
  let safeId =
    if id.strip().len == 0:
      "tiara-modal"
    else:
      id
  let sizeClass =
    case normalizeDomId(size)
    of "small", "large":
      normalizeDomId(size)
    else:
      "medium"

  let titleHtml = if title.len > 0: html"""<h2 class="modal-title">{title}</h2>""" else: rawHtml("")

  let closeButtonClass = "btn btn-secondary btn-small"
  let closeButtonHtml = html"""<button type="button" class="{closeButtonClass}" data-tiara-modal-close tiara-on:click="tiaraModalClose">{closeLabel}</button>"""

  let baseClassStr = "modal modal-" & sizeClass
  var classes = baseClassStr
  for attr in attrs:
    if attr[0] == "class":
      classes = mergeClasses(baseClassStr, attr[1])
      
  var extraAttrs = ""
  for attr in attrs:
    if attr[0] != "class":
      extraAttrs &= " " & attr[0] & "=\"" & escapeHtml(attr[1]) & "\""

  let safeMotionMs = max(80, motionMs)

  result = html"""
<span class="modal-trigger" data-tiara-modal-target="{safeId}" tiara-on:click="tiaraModalOpen">{trigger}</span>
<dialog id="{safeId}" class="{classes}" aria-modal="true" role="dialog" data-tiara="modal" data-tiara-motion-ms="{safeMotionMs}" tiara-on:click="tiaraModalBackdropClick"{extraAttrs}>
  {titleHtml}
  <div class="modal-content">
    {content}
  </div>
  <div class="modal-actions">
    {closeButtonHtml}
  </div>
</dialog>
"""

