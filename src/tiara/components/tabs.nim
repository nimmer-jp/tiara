import ../core
import ./utils
export utils

when defined(js):
  import std/dom

  proc tiaraTabClick*(e: Event) {.client.} =
    let trigger = e.target.Element.closest("[data-tiara-tabs-target]")
    if not trigger.isNil:
      let tabsId = trigger.getAttribute("data-tiara-tabs-target")
      var tabs: Element = nil
      if not tabsId.isNil and $tabsId != "":
        tabs = document.getElementById($tabsId).Element
      else:
        let tNode = trigger.closest("[data-tiara=\"tabs\"]")
        if not tNode.isNil: tabs = tNode.Element

      if not tabs.isNil:
        let tabIndexStr = trigger.getAttribute("data-tiara-tabs-index")
        var nextIndex = 0
        if not tabIndexStr.isNil and $tabIndexStr != "":
          try: nextIndex = parseInt($tabIndexStr)
          except ValueError: discard
          
        let triggers = tabs.querySelectorAll("[data-tiara-tabs-index]")
        let panels = tabs.querySelectorAll("[data-tiara-tabs-panel]")
        let size = min(triggers.len, panels.len)
        if size <= 0: return

        let boundedIndex = ((nextIndex mod size) + size) mod size
        tabs.setAttribute("data-tiara-tabs-index", cstring($boundedIndex))

        for i in 0 ..< size:
          let isActive = i == boundedIndex
          let tr = triggers[i]
          let pa = panels[i]

          tr.setAttribute("aria-selected", cstring(if isActive: "true" else: "false"))
          tr.setAttribute("tabindex", cstring(if isActive: "0" else: "-1"))
          if tr.hasClassList():
            if isActive: tr.classList.add("is-active")
            else: tr.classList.remove("is-active")

          if isActive:
            pa.removeAttribute("hidden")
            pa.setAttribute("aria-hidden", cstring("false"))
          else:
            pa.setAttribute("hidden", cstring(""))
            pa.setAttribute("aria-hidden", cstring("true"))

          if pa.hasClassList():
            if isActive: pa.classList.add("is-active")
            else: pa.classList.remove("is-active")

proc tabs*(
  T: typedesc[Tiara],
  id: string,
  items: openArray[(string, Html)],
  activeIndex = 0,
  attrs: seq[(string, string)] = @[]
): Html =
  let safeId =
    if id.strip().len == 0:
      "tiara-tabs"
    else:
      normalizeDomId(id)

  var normalizedItems: seq[(string, Html)] = @[]
  if items.len == 0:
    normalizedItems.add(("Tab 1", rawHtml("No content")))
  else:
    for item in items:
      normalizedItems.add(item)

  let lastIndex = normalizedItems.len - 1
  let selectedIndex = max(0, min(activeIndex, lastIndex))

  var triggersHtml = ""
  var panelsHtml = ""
  for idx, entry in normalizedItems:
    let tabId = safeId & "-tab-" & $idx
    let panelId = safeId & "-panel-" & $idx
    let isActive = idx == selectedIndex
    
    let triggerClass = if isActive: "tabs-trigger is-active" else: "tabs-trigger"
    let ariaSelected = if isActive: "true" else: "false"
    let tabIndexAttr = if isActive: "0" else: "-1"
    
    triggersHtml &= $html"""
<button id="{tabId}" type="button" role="tab" class="{triggerClass}" aria-selected="{ariaSelected}" tabindex="{tabIndexAttr}" aria-controls="{panelId}" data-tiara-tabs-target="{safeId}" data-tiara-tabs-index="{idx}" tiara-on:click="tiaraTabClick">{entry[0]}</button>
    """

    let panelClass = if isActive: "tabs-panel is-active" else: "tabs-panel"
    let panelHiddenAttr = if not isActive: "hidden" else: ""
    let ariaHidden = if isActive: "false" else: "true"
    
    panelsHtml &= $html"""
<section id="{panelId}" role="tabpanel" class="{panelClass}" aria-labelledby="{tabId}" data-tiara-tabs-panel="{idx}" {panelHiddenAttr} aria-hidden="{ariaHidden}">
  {entry[1]}
</section>
    """

  let baseClassStr = "tabs"
  var classes = baseClassStr
  for attr in attrs:
    if attr[0] == "class":
      classes = mergeClasses(baseClassStr, attr[1])
      
  var extraAttrs = ""
  for attr in attrs:
    if attr[0] != "class":
      extraAttrs &= " " & attr[0] & "=\"" & escapeHtml(attr[1]) & "\""

  result = html"""
<section id="{safeId}" class="{classes}" data-tiara="tabs" data-tiara-tabs-index="{selectedIndex}" data-tiara-tabs-size="{normalizedItems.len}"{extraAttrs}>
  <div class="tabs-list" role="tablist">
    {rawHtml(triggersHtml)}
  </div>
  <div class="tabs-panels">
    {rawHtml(panelsHtml)}
  </div>
</section>
  """

