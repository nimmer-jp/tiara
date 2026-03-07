when defined(js):
  import std/[dom, strutils, jsffi]

  var tiaraClientReady {.importc: "window.__tiaraClientReady".}: bool

  proc jsTypeof*(x: JsObject): cstring {.importcpp: "typeof #".}
  proc jsMatches*(node: JsObject, selectors: cstring): bool {.importcpp: "#.matches(#)".}
  proc jsClosest*(node: JsObject, selectors: cstring): JsObject {.importcpp: "#.closest(#)".}
  proc jsContains*(list: JsObject, class: cstring): bool {.importcpp: "#.contains(#)".}

  proc hasClassList*(node: Element): bool =
    let jsNode = node.toJs()
    return not isUndefined(jsNode.classList) and not isNull(jsNode.classList)

  proc contains*(list: ClassList, class: cstring): bool =
    return jsContains(list.toJs(), class)

  proc matches*(node: Node | Element | EventTarget, selectors: cstring): bool =
    let jsNode = node.toJs()
    if not isUndefined(jsNode) and not isNull(jsNode) and jsTypeof(jsNode[
        cstring("matches")]) == cstring("function"):
      return jsMatches(jsNode, selectors)
    return false

  proc closest*(node: Node | Element | EventTarget,
      selectors: cstring): Element =
    let jsNode = node.toJs()
    if not isUndefined(jsNode) and not isNull(jsNode) and jsTypeof(jsNode[
        cstring("closest")]) == cstring("function"):
      let res = jsClosest(jsNode, selectors)
      if isNull(res) or isUndefined(res): return nil
      return res.to(Element)
    return nil

  proc setProperty*(style: Style, prop: cstring, val: cstring) =
    style.toJs().setProperty(prop, val)

  proc removeAttribute*(node: Element, attr: cstring) =
    node.toJs().removeAttribute(attr)

  proc hasAttribute*(node: Element, attr: cstring): bool =
    return node.toJs().hasAttribute(attr).to(bool)

  proc showModal*(dialog: Element) =
    let jsDialog = dialog.toJs()
    if jsTypeof(jsDialog.showModal) == cstring("function"):
      jsDialog.showModal()

  proc closeDialog*(dialog: Element) =
    let jsDialog = dialog.toJs()
    if jsTypeof(jsDialog.close) == cstring("function"):
      jsDialog.close()

  proc isOpen*(dialog: Element): bool =
    let jsDialog = dialog.toJs()
    if not isUndefined(jsDialog.open) and not isNull(jsDialog.open):
      return jsDialog.open.to(bool)
    return false

  proc requestAnimationFrame*(cb: proc()) {.importc.}

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

  proc updateCarousel(carousel: Element, nextIndex: int) =
    if carousel.isNil: return
    let track = carousel.querySelector("[data-tiara-carousel-track]")
    if track.isNil: return

    var size = 0
    let sizeStr = carousel.getAttribute("data-tiara-carousel-size")
    if not sizeStr.isNil and $sizeStr != "":
      try: size = parseInt($sizeStr)
      except ValueError: discard

    if size <= 0: return

    let boundedIndex = ((nextIndex mod size) + size) mod size
    carousel.setAttribute("data-tiara-carousel-index", cstring($boundedIndex))
    track.style.transform = cstring("translateX(" & $(-boundedIndex * 100) & "%)")

    let slides = carousel.querySelectorAll("[data-tiara-carousel-slide]")
    for i in 0 ..< slides.len:
      let slide = slides[i]
      slide.setAttribute("aria-hidden", cstring(if i ==
          boundedIndex: "false" else: "true"))

    let indicators = carousel.querySelectorAll("[data-tiara-carousel-indicator]")
    for j in 0 ..< indicators.len:
      let indicator = indicators[j]
      indicator.setAttribute("aria-current", cstring(if j ==
          boundedIndex: "true" else: "false"))
      if indicator.hasClassList():
        if j == boundedIndex: indicator.classList.add("is-active")
        else: indicator.classList.remove("is-active")

  proc updateTabs(tabs: Element, nextIndex: int) =
    if tabs.isNil: return
    let triggers = tabs.querySelectorAll("[data-tiara-tabs-index]")
    let panels = tabs.querySelectorAll("[data-tiara-tabs-panel]")
    let size = min(triggers.len, panels.len)
    if size <= 0: return

    let boundedIndex = ((nextIndex mod size) + size) mod size
    tabs.setAttribute("data-tiara-tabs-index", cstring($boundedIndex))

    for i in 0 ..< size:
      let isActive = i == boundedIndex
      let trigger = triggers[i]
      let panel = panels[i]

      trigger.setAttribute("aria-selected", cstring(
          if isActive: "true" else: "false"))
      trigger.setAttribute("tabindex", cstring(if isActive: "0" else: "-1"))
      if trigger.hasClassList():
        if isActive: trigger.classList.add("is-active")
        else: trigger.classList.remove("is-active")

      if isActive:
        panel.removeAttribute("hidden")
        panel.setAttribute("aria-hidden", cstring("false"))
      else:
        panel.setAttribute("hidden", cstring(""))
        panel.setAttribute("aria-hidden", cstring("true"))

      if panel.hasClassList():
        if isActive: panel.classList.add("is-active")
        else: panel.classList.remove("is-active")

  proc openModal(dialog: Element) =
    if dialog.isNil: return
    let motionMs = getMotionMs(dialog, 220)
    dialog.style.setProperty("--tiara-motion-ms", cstring($motionMs & "ms"))

    let jsDialog = dialog.toJs()
    if not isUndefined(jsDialog.tiaraCloseTimer) and not isNull(
        jsDialog.tiaraCloseTimer):
      window.clearTimeout(jsDialog.tiaraCloseTimer.to(TimeOut))
      jsDialog.tiaraCloseTimer = jsNull

    if not dialog.isOpen():
      dialog.showModal()

    if dialog.hasClassList():
      dialog.classList.remove("is-closing")
      dialog.classList.remove("is-opening")

    requestAnimationFrame(proc() =
      if dialog.hasClassList():
        dialog.classList.add("is-open")
    )

  proc closeModal(dialog: Element) =
    if dialog.isNil: return
    let motionMs = getMotionMs(dialog, 220)
    dialog.style.setProperty("--tiara-motion-ms", cstring($motionMs & "ms"))

    let jsDialog = dialog.toJs()
    if not isUndefined(jsDialog.tiaraCloseTimer) and not isNull(
        jsDialog.tiaraCloseTimer):
      window.clearTimeout(jsDialog.tiaraCloseTimer.to(TimeOut))
      jsDialog.tiaraCloseTimer = jsNull

    if dialog.hasClassList():
      dialog.classList.remove("is-open")
      dialog.classList.add("is-closing")

    jsDialog.tiaraCloseTimer = window.setTimeout(proc() =
      jsDialog.tiaraCloseTimer = jsNull
      if dialog.hasClassList():
        dialog.classList.remove("is-closing")
      if dialog.isOpen():
        dialog.closeDialog()
    , motionMs)

  proc setDropdownOpen(dropdown: Element, isOpen: bool) =
    if dropdown.isNil: return
    let menu = dropdown.querySelector("[data-tiara-dropdown-menu]")
    let toggle = dropdown.querySelector("[data-tiara-dropdown-toggle]")
    let motionMs = getMotionMs(dropdown, 180)

    dropdown.style.setProperty("--tiara-motion-ms", cstring($motionMs & "ms"))
    dropdown.setAttribute("data-tiara-dropdown-open", cstring(
        if isOpen: "true" else: "false"))

    if not toggle.isNil:
      toggle.setAttribute("aria-expanded", cstring(
          if isOpen: "true" else: "false"))

    if menu.isNil: return
    let jsMenu = menu.toJs()
    if not isUndefined(jsMenu.tiaraClosingTimer) and not isNull(
        jsMenu.tiaraClosingTimer):
      window.clearTimeout(jsMenu.tiaraClosingTimer.to(TimeOut))
      jsMenu.tiaraClosingTimer = jsNull

    menu.style.setProperty("--tiara-motion-ms", cstring($motionMs & "ms"))
    if isOpen:
      menu.removeAttribute("hidden")
      if menu.hasClassList():
        menu.classList.remove("is-closing")
      requestAnimationFrame(proc() =
        if menu.hasClassList():
          menu.classList.add("is-open")
      )
    else:
      if menu.hasAttribute("hidden") and (not menu.hasClassList() or
          not menu.classList.contains("is-open")):
        if menu.hasClassList():
          menu.classList.remove("is-closing")
        return

      if menu.hasClassList():
        menu.classList.remove("is-open")
        menu.classList.add("is-closing")

      jsMenu.tiaraClosingTimer = window.setTimeout(proc() =
        if menu.hasClassList():
          menu.classList.remove("is-closing")
        menu.setAttribute("hidden", cstring(""))
      , motionMs)

  proc closeAllDropdowns(exceptDropdown: Element) =
    let openDropdowns = document.querySelectorAll("[data-tiara=\"dropdown\"][data-tiara-dropdown-open=\"true\"]")
    for i in 0 ..< openDropdowns.len:
      let drop = openDropdowns[i]
      if not exceptDropdown.isNil and drop == exceptDropdown:
        continue
      setDropdownOpen(drop, false)

  proc hideToast(toast: Element) =
    if not toast.isNil:
      toast.setAttribute("hidden", cstring(""))

  proc initTiaraClient*() =
    if tiaraClientReady: return
    tiaraClientReady = true

    document.addEventListener("click", proc(event: Event) =
      let target = event.target
      if target.matches("dialog[data-tiara=\"modal\"]"):
        closeModal(target.Element)
        return

      let opener = target.closest("[data-tiara-modal-open]")
      if not opener.isNil:
        let dialogId = opener.getAttribute("data-tiara-modal-open")
        if not dialogId.isNil:
          let dialog = document.getElementById($dialogId)
          if not dialog.isNil: openModal(dialog.Element)
        return

      let closeButton = target.closest("[data-tiara-modal-close]")
      if not closeButton.isNil:
        let hostDialog = closeButton.closest("dialog")
        if not hostDialog.isNil: closeModal(hostDialog.Element)
        return

      let tabsTrigger = target.closest("[data-tiara-tabs-target]")
      if not tabsTrigger.isNil:
        let tabsId = tabsTrigger.getAttribute("data-tiara-tabs-target")
        var tabs: Element = nil
        if not tabsId.isNil and $tabsId != "":
          tabs = document.getElementById($tabsId).Element
        else:
          let tNode = tabsTrigger.closest("[data-tiara=\"tabs\"]")
          if not tNode.isNil: tabs = tNode.Element

        if not tabs.isNil:
          let tabIndexStr = tabsTrigger.getAttribute("data-tiara-tabs-index")
          var tabIndex = 0
          if not tabIndexStr.isNil and $tabIndexStr != "":
            try: tabIndex = parseInt($tabIndexStr)
            except ValueError: discard
          updateTabs(tabs, tabIndex)
        return

      let dropdownToggle = target.closest("[data-tiara-dropdown-toggle]")
      if not dropdownToggle.isNil:
        let dropdownId = dropdownToggle.getAttribute("data-tiara-dropdown-toggle")
        var dropdown: Element = nil
        if not dropdownId.isNil and $dropdownId != "":
          dropdown = document.getElementById($dropdownId).Element
        else:
          let dNode = dropdownToggle.closest("[data-tiara=\"dropdown\"]")
          if not dNode.isNil: dropdown = dNode.Element

        if not dropdown.isNil:
          let openedStr = dropdown.getAttribute("data-tiara-dropdown-open")
          let opened = not openedStr.isNil and $openedStr == "true"
          closeAllDropdowns(dropdown)
          setDropdownOpen(dropdown, not opened)
        return

      let dropdownItem = target.closest("[data-tiara-dropdown-item]")
      if not dropdownItem.isNil:
        let itemDropdown = dropdownItem.closest("[data-tiara=\"dropdown\"]")
        if not itemDropdown.isNil:
          setDropdownOpen(itemDropdown.Element, false)
        return

      let toastClose = target.closest("[data-tiara-toast-close]")
      if not toastClose.isNil:
        let toast = toastClose.closest("[data-tiara=\"toast\"]")
        if not toast.isNil:
          hideToast(toast.Element)
        return

      let carouselControl = target.closest("[data-tiara-carousel-action]")
      if not carouselControl.isNil:
        let targetId = carouselControl.getAttribute("data-tiara-carousel-target")
        var carousel: Element = nil
        if not targetId.isNil and $targetId != "":
          carousel = document.getElementById($targetId).Element

        if not carousel.isNil:
          let action = carouselControl.getAttribute("data-tiara-carousel-action")
          let currentStr = carousel.getAttribute("data-tiara-carousel-index")
          var current = 0
          if not currentStr.isNil and $currentStr != "":
            try: current = parseInt($currentStr)
            except ValueError: discard

          if not action.isNil:
            if $action == "prev":
              updateCarousel(carousel, current - 1)
            elif $action == "next":
              updateCarousel(carousel, current + 1)
            elif $action == "go":
              let goIndexStr = carouselControl.getAttribute("data-tiara-carousel-go")
              if not goIndexStr.isNil and $goIndexStr != "":
                try:
                  let goIndex = parseInt($goIndexStr)
                  updateCarousel(carousel, goIndex)
                except ValueError: discard
        return

      closeAllDropdowns(nil)
    )

    document.addEventListener("keydown", proc(event: Event) =
      let kEvent = cast[KeyboardEvent](event)
      if $kEvent.key == "Escape":
        closeAllDropdowns(nil)
    )

    document.addEventListener("cancel", proc(event: Event) =
      let target = event.target
      if target.matches("dialog[data-tiara=\"modal\"]"):
        event.preventDefault()
        closeModal(target.Element)
    , true)

    document.addEventListener("input", proc(event: Event) =
      let inputEl = event.target.Element
      if inputEl.matches("input[type='color'][data-tiara-color-input]"):
        let previewId = inputEl.getAttribute("data-tiara-color-input")
        if not previewId.isNil:
          let swatch = document.querySelector("[data-tiara-color-preview='" &
              $previewId & "']")
          if not swatch.isNil:
            swatch.style.backgroundColor = inputEl.toJs().value.to(cstring)
    )

    let carousels = document.querySelectorAll("[data-tiara=\"carousel\"]")
    for i in 0 ..< carousels.len:
      let c = carousels[i]
      let initStr = c.getAttribute("data-tiara-carousel-index")
      var initialCarouselIndex = 0
      if not initStr.isNil and $initStr != "":
        try: initialCarouselIndex = parseInt($initStr)
        except ValueError: discard
      updateCarousel(c, initialCarouselIndex)

    let tabsList = document.querySelectorAll("[data-tiara=\"tabs\"]")
    for i in 0 ..< tabsList.len:
      let t = tabsList[i]
      let initStr = t.getAttribute("data-tiara-tabs-index")
      var initialTabIndex = 0
      if not initStr.isNil and $initStr != "":
        try: initialTabIndex = parseInt($initStr)
        except ValueError: discard
      updateTabs(t, initialTabIndex)

    let dropdowns = document.querySelectorAll("[data-tiara=\"dropdown\"]")
    for i in 0 ..< dropdowns.len:
      setDropdownOpen(dropdowns[i], false)

    let toasts = document.querySelectorAll("[data-tiara=\"toast\"][data-tiara-toast-autohide]")
    for i in 0 ..< toasts.len:
      let toastNode = toasts[i]
      let hideAfterStr = toastNode.getAttribute("data-tiara-toast-autohide")
      var hideAfter = 0
      if not hideAfterStr.isNil and $hideAfterStr != "":
        try: hideAfter = parseInt($hideAfterStr)
        except ValueError: discard

      if hideAfter > 0:
        discard window.setTimeout(proc() =
          hideToast(toastNode)
        , hideAfter)

  initTiaraClient()

else:
  const TiaraClientBundle* = slurp("client.js")
  proc initTiaraClient*() =
    discard
