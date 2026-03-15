when defined(js):
  import std/[dom, strutils, jsffi]

  var tiaraClientReady {.importc: "window.__tiaraClientReady".}: bool

  proc jsTypeof*(x: JsObject): cstring {.importcpp: "typeof #".}
  proc jsMatches*(node: JsObject, selectors: cstring): bool {.importcpp: "#.matches(#)".}
  proc jsClosest*(node: JsObject, selectors: cstring): JsObject {.importcpp: "#.closest(#)".}
  proc jsContains*(list: JsObject, class: cstring): bool {.importcpp: "#.contains(#)".}
  proc jsContainsNode*(parent: JsObject,
      child: JsObject): bool {.importcpp: "#.contains(#)".}

  proc hasClassList*(node: Element): bool =
    let jsNode = node.toJs()
    return not isUndefined(jsNode.classList) and not isNull(jsNode.classList)

  proc contains*(list: ClassList, class: cstring): bool =
    return jsContains(list.toJs(), class)

  proc contains*(parent: Node | Element | EventTarget, child: Node | Element |
      EventTarget): bool =
    return jsContainsNode(parent.toJs(), child.toJs())

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

  proc hideToast*(toast: Element) =
    if toast.isNil: return

    # Check if there is a tiaraHideTimer property
    let jsToast = toast.toJs()
    if not isUndefined(jsToast.tiaraHideTimer) and not isNull(
        jsToast.tiaraHideTimer):
      window.clearTimeout(jsToast.tiaraHideTimer.to(TimeOut))
      jsToast.tiaraHideTimer = jsNull

    if toast.hasClassList():
      toast.classList.remove("is-open")
      toast.classList.add("is-closing")

    discard window.setTimeout(proc() =
      if toast.hasClassList():
        toast.classList.remove("is-closing")
      let wrapper = toast.closest(".toast-wrapper")
      let storage = document.getElementById("tiara-toast-storage")
      if not storage.isNil:
        storage.appendChild(toast)
      elif not toast.parentNode.isNil:
        toast.parentNode.removeChild(toast)

      # Remove wrapper if empty
      if not wrapper.isNil and wrapper.children.len == 0:
        if not wrapper.parentNode.isNil:
          wrapper.parentNode.removeChild(wrapper)
    , 400)

  proc showToast*(toast: Element) =
    asm """console.log('TIARA_CLIENT: showToast called for:', `toast`);"""
    if toast.isNil:
      asm """console.error('TIARA_CLIENT: showToast received nil toast');"""
      return

    var position = toast.getAttribute("data-tiara-toast-position")
    if position.isNil or $position == "":
      position = "bottom-right"

    let wrapperClass = "toast-" & $position
    var wrapper = document.querySelector(".toast-wrapper." & wrapperClass)

    if wrapper.isNil:
      wrapper = document.createElement("div")
      wrapper.setAttribute("class", "toast-wrapper " & wrapperClass)
      document.body.appendChild(wrapper)

    # If the toast is already somewhere else, remove it first
    if not toast.parentNode.isNil:
      toast.parentNode.parentNode.removeChild(
          toast.parentNode) # Remove the wrapper if it's already there
      # toast.parentNode.removeChild(toast) # This would remove the toast from its current wrapper

    wrapper.appendChild(toast)

    # Hide initially if not already
    toast.classList.remove("is-open")
    toast.classList.remove("is-closing")

    # Use a small delay to ensure the browser has rendered the initial state
    # before we add the 'is-open' class to trigger the transition.
    discard window.setTimeout(proc() =
      toast.classList.add("is-open")
      # Force a re-style
      discard window.getComputedStyle(toast).opacity
    , 50)

    let hideAfterStr = toast.getAttribute("data-tiara-toast-autohide")
    var hideAfter = 0
    if not hideAfterStr.isNil and $hideAfterStr != "":
      try: hideAfter = parseInt($hideAfterStr)
      except ValueError: discard

    if hideAfter > 0:
      let jsToast = toast.toJs()
      jsToast.tiaraHideTimer = window.setTimeout(proc() =
        hideToast(toast)
      , hideAfter)

  proc initTiaraClient*() =
    asm """console.log('TIARA_CLIENT: Initializing...');"""
    if tiaraClientReady:
      asm """console.log('TIARA_CLIENT: Already initialized.');"""
      return
    tiaraClientReady = true

    document.addEventListener("click", proc(event: Event) =
      let target = event.target
      asm """console.log('TIARA_CLIENT: Click target:', `target`);"""
      if target.matches("dialog[data-tiara=\"modal\"]"):
        asm """console.log('TIARA_CLIENT: Modal backdrop click');"""
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
        # Dropdown items might also trigger modals or toasts, so do not return here
        # unless it's strictly a dropdown action. Actually, just let it fall through.

      let toastClose = target.closest("[data-tiara-toast-close]")
      if not toastClose.isNil:
        let toast = toastClose.closest("[data-tiara=\"toast\"]")
        if not toast.isNil:
          hideToast(toast.Element)
        return

      let toastTrigger = target.closest("[data-tiara-toast-trigger]")
      if not toastTrigger.isNil:
        let targetId = toastTrigger.getAttribute("data-tiara-toast-trigger")
        if not targetId.isNil:
          let toastTarget = document.getElementById($targetId)
          if not toastTarget.isNil:
            showToast(toastTarget)
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

    # Create a hidden container for inactive toasts so they aren't lost from DOM
    var toastStorage = document.getElementById("tiara-toast-storage")
    if toastStorage.isNil:
      toastStorage = document.createElement("div")
      toastStorage.id = "tiara-toast-storage"
      toastStorage.style.display = "none"
      document.body.appendChild(toastStorage)

    # Initial rendering hides toast from normal flow since it mounts conditionally on trigger.
    let toasts = document.querySelectorAll("[data-tiara=\"toast\"]")
    for i in 0 ..< toasts.len:
      let toastNode = toasts[i]
      if toastNode.parentNode != nil and toastNode.closest(
          ".toast-wrapper").isNil and toastNode.closest(
          "#tiara-toast-storage").isNil:
        toastStorage.appendChild(toastNode)

  if document.toJs().readyState.to(cstring) == cstring("loading"):
    asm """console.log('TIARA_CLIENT: Waiting for DOMContentLoaded...');"""
    document.addEventListener("DOMContentLoaded", proc(
        event: Event) =
      asm """console.log('TIARA_CLIENT: DOMContentLoaded fired.');"""
      initTiaraClient()
    )
  else:
    asm """console.log('TIARA_CLIENT: DOM already ready, initializing immediately.');"""
    initTiaraClient()

else:
  const TiaraClientBundle* = slurp("client.js")
  proc initTiaraClient*() =
    discard
