import ../core
import ./utils
export utils

when defined(js):
  import std/dom
  
  proc tiaraToastClose*(e: Event) {.client.} =
    let target = e.target.Element
    let toast = target.closest(".toast")
    if not toast.isNil:
      toast.classList.remove("is-open")
      toast.classList.add("is-closing")
      discard window.setTimeout(proc() =
        if toast.hasClassList():
          toast.classList.remove("is-closing")
        if not toast.parentNode.isNil:
          toast.parentNode.removeChild(toast)
      , 400)

proc toast*(
  T: typedesc[Tiara],
  message: string,
  title = "",
  tone = "info",
  dismissible = true,
  autoHideMs = 0,
  position = "bottom-right",
  id = "",
  attrs: seq[(string, string)] = @[]
): Html =
  let normalizedTone =
    case normalizeDomId(tone)
    of "success", "warning", "error":
      normalizeDomId(tone)
    else:
      "info"

  let titleHtml = if title.strip().len > 0: html"""<h4 class="toast-title">{title}</h4>""" else: rawHtml("")
  let closeBtn = if dismissible: html"""<button type="button" class="toast-close" aria-label="Dismiss notification" tiara-on:click="tiaraToastClose">x</button>""" else: rawHtml("")
  
  let baseClassStr = "toast toast-" & normalizedTone
  var classes = baseClassStr
  for attr in attrs:
    if attr[0] == "class":
      classes = mergeClasses(baseClassStr, attr[1])
  
  let idAttr = if id != "": "id=\"" & escapeHtml(id) & "\"" else: ""
  var extraAttrs = ""
  for attr in attrs:
    if attr[0] != "class":
      extraAttrs &= " " & attr[0] & "=\"" & escapeHtml(attr[1]) & "\""
      
  let autoHideScript = if autoHideMs > 0 and id != "":
    # if an element has an ID, we can auto-hide it easily via script
    html"""<script>setTimeout(function()\{ var t = document.getElementById('{id}'); if(t && typeof window.TiaraApp_tiaraToastClose === 'function') \{ window.TiaraApp_tiaraToastClose(\{target: t\}); \} \}, {autoHideMs});</script>"""
  else:
    rawHtml("")

  result = html"""
<aside class="{classes}" role="status" {idAttr} data-tiara="toast" data-tiara-toast-position="{position}"{extraAttrs}>
  <div class="toast-content">
    {titleHtml}
    <p class="toast-message">{message}</p>
  </div>
  {closeBtn}
</aside>
{autoHideScript}
  """

