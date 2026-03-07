import std/[strutils, times]
import ./builder
export builder

type
  Tiara* = object

proc mergeAttrs(
  baseAttrs: openArray[(string, string)],
  extraAttrs: seq[(string, string)]
): seq[(string, string)] =
  result = @[]
  result.add(baseAttrs)

  for (rawName, rawValue) in extraAttrs:
    let name = rawName.strip()
    if name.len == 0:
      continue

    var updated = false
    for idx in 0 ..< result.len:
      if result[idx][0] != name:
        continue

      if name == "class":
        result[idx] = (name, classList([result[idx][1], rawValue]))
      elif name == "style":
        let baseStyle = result[idx][1].strip()
        let extraStyle = rawValue.strip()
        if baseStyle.len == 0:
          result[idx] = (name, extraStyle)
        elif extraStyle.len == 0:
          discard
        else:
          let separator = if baseStyle.endsWith(";"): " " else: "; "
          result[idx] = (name, baseStyle & separator & extraStyle)
      else:
        result[idx] = (name, rawValue)

      updated = true
      break

    if not updated:
      result.add((name, rawValue))

proc normalizeDomId(value: string): string =
  var normalized = newStringOfCap(value.len)
  for ch in value:
    if ch in {'a'..'z', 'A'..'Z', '0'..'9'}:
      normalized.add toLowerAscii(ch)
    elif ch in {' ', '_', '-', '.', ':'}:
      normalized.add '-'

  normalized = normalized.strip(chars = {'-'})
  if normalized.len == 0:
    return "tiara-field"

  normalized

proc resolveDateToken(value: string): string =
  let token = value.strip().toLowerAscii()
  case token
  of "":
    ""
  of "today":
    now().format("yyyy-MM-dd")
  else:
    value

proc normalizeLanguage(value: string): string =
  value.strip().toLowerAscii()

proc appendEscapedChar(output: var string, ch: char) =
  case ch
  of '&':
    output.add "&amp;"
  of '<':
    output.add "&lt;"
  of '>':
    output.add "&gt;"
  of '"':
    output.add "&quot;"
  of '\'':
    output.add "&#39;"
  else:
    output.add ch

proc appendEscaped(output: var string, value: string) =
  for ch in value:
    appendEscapedChar(output, ch)

proc isIdentifierStart(ch: char): bool =
  ch in {'a'..'z', 'A'..'Z', '_'}

proc isIdentifierChar(ch: char): bool =
  ch in {'a'..'z', 'A'..'Z', '0'..'9', '_'}

proc isKeyword(language: string, token: string): bool =
  let normalized = token.toLowerAscii()
  case normalizeLanguage(language)
  of "nim":
    normalized in [
      "proc", "func", "method", "iterator", "template", "macro",
      "let", "var", "const", "type", "object", "ref",
      "if", "elif", "else", "case", "of",
      "for", "while", "return", "discard",
      "import", "from", "when", "not", "and", "or"
    ]
  of "javascript", "js", "typescript", "ts":
    normalized in [
      "function", "const", "let", "var", "return",
      "if", "else", "switch", "case", "break",
      "for", "while", "class", "new", "import", "from",
      "export", "try", "catch", "finally", "await", "async"
    ]
  of "python", "py":
    normalized in [
      "def", "class", "return",
      "if", "elif", "else",
      "for", "while", "in", "not", "and", "or",
      "import", "from", "try", "except", "finally",
      "with", "as", "lambda", "yield"
    ]
  else:
    false

proc addHighlightedToken(output: var string, token: string, tokenClass: string) =
  if tokenClass.len == 0:
    appendEscaped(output, token)
    return

  output.add "<span class=\"code-token " & tokenClass & "\">"
  appendEscaped(output, token)
  output.add "</span>"

proc renderHighlightedCode(code: string, language: string): string =
  let lang = normalizeLanguage(language)
  var i = 0

  while i < code.len:
    let ch = code[i]

    if (lang in ["nim", "python", "py"]) and ch == '#':
      var j = i
      while j < code.len and code[j] != '\n':
        inc j
      addHighlightedToken(result, code[i ..< j], "code-comment")
      i = j
      continue

    if (lang in ["javascript", "js", "typescript", "ts"]) and ch == '/' and i + 1 < code.len and code[i + 1] == '/':
      var j = i
      while j < code.len and code[j] != '\n':
        inc j
      addHighlightedToken(result, code[i ..< j], "code-comment")
      i = j
      continue

    if ch == '"' or ch == '\'':
      var j = i + 1
      while j < code.len:
        if code[j] == '\\':
          if j + 1 < code.len:
            j += 2
          else:
            inc j
          continue
        if code[j] == ch:
          inc j
          break
        if code[j] == '\n':
          break
        inc j
      addHighlightedToken(result, code[i ..< j], "code-string")
      i = j
      continue

    if ch in {'0'..'9'}:
      var j = i + 1
      while j < code.len and code[j] in {'0'..'9', '.', '_'}:
        inc j
      addHighlightedToken(result, code[i ..< j], "code-number")
      i = j
      continue

    if isIdentifierStart(ch):
      var j = i + 1
      while j < code.len and isIdentifierChar(code[j]):
        inc j
      let token = code[i ..< j]
      if isKeyword(lang, token):
        addHighlightedToken(result, token, "code-keyword")
      else:
        addHighlightedToken(result, token, "")
      i = j
      continue

    appendEscapedChar(result, ch)
    inc i

proc initialsFromName(name: string): string =
  for part in name.strip().splitWhitespace():
    if part.len == 0:
      continue
    result.add toUpperAscii(part[0])
    if result.len == 2:
      break

  if result.len == 0:
    result = "?"

proc text*(
  T: typedesc[Tiara],
  content: string,
  tag = "p",
  attrs: seq[(string, string)] = @[]
): Html =
  el(tag, textNode(content), attrs)

proc button*(
  T: typedesc[Tiara],
  label: string,
  color = "primary",
  size = "medium",
  outlined = false,
  buttonType = "",
  attrs: seq[(string, string)] = @[]
): Html =
  let classes = classList([
    "btn",
    if color.len > 0: "btn-" & color else: "",
    if size.len > 0: "btn-" & size else: "",
    if outlined: "btn-outline" else: ""
  ])

  var baseAttrs = @[("class", classes)]
  if buttonType.len > 0:
    baseAttrs.add(("type", buttonType))

  el("button", textNode(label), mergeAttrs(baseAttrs, attrs))

proc card*(
  T: typedesc[Tiara],
  title: string,
  content: Html,
  footer: Html = rawHtml(""),
  attrs: seq[(string, string)] = @[]
): Html =
  var segments: seq[Html] = @[
    el("h3", textNode(title), @[("class", "card-title")]),
    el("div", content, @[("class", "card-content")])
  ]

  if $footer != "":
    segments.add(el("div", footer, @[("class", "card-footer")]))

  el(
    "section",
    joinHtml(segments),
    mergeAttrs(@[("class", "card")], attrs)
  )

proc codeBlock*(
  T: typedesc[Tiara],
  code: string,
  language = "text",
  title = "",
  attrs: seq[(string, string)] = @[]
): Html =
  let normalizedLang = normalizeLanguage(language)
  let languageClass =
    if normalizedLang.len > 0 and normalizedLang != "text":
      "language-" & normalizedLang
    else:
      ""

  var segments: seq[Html] = @[]
  if title.len > 0 or (normalizedLang.len > 0 and normalizedLang != "text"):
    var headerSegments: seq[Html] = @[]

    if title.len > 0:
      headerSegments.add(el("span", textNode(title), @[("class", "code-block-title")]))

    if normalizedLang.len > 0 and normalizedLang != "text":
      headerSegments.add(
        el("span", textNode(toUpperAscii(normalizedLang)), @[("class", "code-block-language")])
      )

    segments.add(el("figcaption", joinHtml(headerSegments), @[("class", "code-block-header")]))

  let highlighted = rawHtml(renderHighlightedCode(code, normalizedLang))
  let codeNode = el(
    "code",
    highlighted,
    @[("class", classList(["code-block-code", languageClass]))]
  )
  segments.add(el("pre", codeNode, @[("class", "code-block-pre")]))

  el(
    "figure",
    joinHtml(segments),
    mergeAttrs(@[("class", "code-block"), ("data-tiara", "code-block")], attrs)
  )

proc iconWithBadge*(
  T: typedesc[Tiara],
  icon: Html,
  badge: string,
  label = "",
  attrs: seq[(string, string)] = @[]
): Html =
  var segments: seq[Html] = @[
    el("span", icon, @[("class", "icon-badge-icon"), ("aria-hidden", "true")])
  ]

  if badge.strip().len > 0:
    segments.add(el("span", textNode(badge.strip()), @[("class", "icon-badge-count")]))

  var baseAttrs = @[
    ("class", "icon-badge"),
    ("data-tiara", "icon-badge")
  ]
  if label.strip().len > 0:
    baseAttrs.add(("aria-label", label.strip()))

  el("span", joinHtml(segments), mergeAttrs(baseAttrs, attrs))

proc notificationIcon*(
  T: typedesc[Tiara],
  badge: string,
  icon = "🔔",
  label = "Notifications",
  attrs: seq[(string, string)] = @[]
): Html =
  var segments: seq[Html] = @[
    el("span", textNode(icon), @[("class", "icon-badge-icon"), ("aria-hidden", "true")])
  ]
  if badge.strip().len > 0:
    segments.add(el("span", textNode(badge.strip()), @[("class", "icon-badge-count")]))

  el(
    "button",
    joinHtml(segments),
    mergeAttrs(
      @[
        ("type", "button"),
        ("class", "icon-badge notification-icon"),
        ("data-tiara", "notification-icon"),
        ("aria-label", label)
      ],
      attrs
    )
  )

proc carousel*(
  T: typedesc[Tiara],
  id: string,
  items: openArray[Html],
  showIndicators = true,
  attrs: seq[(string, string)] = @[]
): Html =
  let safeId =
    if id.strip().len == 0:
      "tiara-carousel"
    else:
      normalizeDomId(id)

  var slides: seq[Html] = @[]
  for idx, item in items:
    slides.add(
      el(
        "article",
        item,
        @[
          ("class", "carousel-slide"),
          ("data-tiara-carousel-slide", $idx),
          ("aria-hidden", if idx == 0: "false" else: "true")
        ]
      )
    )

  if slides.len == 0:
    slides.add(
      el(
        "article",
        Tiara.text("No items"),
        @[
          ("class", "carousel-slide"),
          ("data-tiara-carousel-slide", "0"),
          ("aria-hidden", "false")
        ]
      )
    )

  let size = slides.len
  let track = el(
    "div",
    joinHtml(slides),
    @[
      ("class", "carousel-track"),
      ("data-tiara-carousel-track", ""),
      ("style", "transform: translateX(0%);")
    ]
  )

  var bodySegments: seq[Html] = @[track]

  if size > 1:
    bodySegments.add(
      el(
        "button",
        textNode("‹"),
        @[
          ("type", "button"),
          ("class", "carousel-nav carousel-nav-prev"),
          ("aria-label", "Previous slide"),
          ("data-tiara-carousel-action", "prev"),
          ("data-tiara-carousel-target", safeId)
        ]
      )
    )

    bodySegments.add(
      el(
        "button",
        textNode("›"),
        @[
          ("type", "button"),
          ("class", "carousel-nav carousel-nav-next"),
          ("aria-label", "Next slide"),
          ("data-tiara-carousel-action", "next"),
          ("data-tiara-carousel-target", safeId)
        ]
      )
    )

    if showIndicators:
      var indicatorNodes: seq[Html] = @[]
      for idx in 0 ..< size:
        indicatorNodes.add(
          el(
            "button",
            rawHtml(""),
            @[
              ("type", "button"),
              ("class", classList(["carousel-indicator", if idx == 0: "is-active" else: ""])),
              ("data-tiara-carousel-action", "go"),
              ("data-tiara-carousel-target", safeId),
              ("data-tiara-carousel-go", $idx),
              ("data-tiara-carousel-indicator", $idx),
              ("aria-label", "Go to slide " & $(idx + 1)),
              ("aria-current", if idx == 0: "true" else: "false")
            ]
          )
        )

      bodySegments.add(el("div", joinHtml(indicatorNodes), @[("class", "carousel-indicators")]))

  el(
    "section",
    joinHtml(bodySegments),
    mergeAttrs(
      @[
        ("id", safeId),
        ("class", "carousel"),
        ("data-tiara", "carousel"),
        ("data-tiara-carousel-index", "0"),
        ("data-tiara-carousel-size", $size)
      ],
      attrs
    )
  )

proc profileIcon*(
  T: typedesc[Tiara],
  name: string,
  imageUrl = "",
  size = "medium",
  status = "",
  attrs: seq[(string, string)] = @[]
): Html =
  let initials = initialsFromName(name)
  let sizeClass =
    if size.strip().len == 0:
      "medium"
    else:
      normalizeDomId(size)

  var segments: seq[Html] = @[]
  if imageUrl.strip().len > 0:
    segments.add(
      voidEl(
        "img",
        @[
          ("src", imageUrl.strip()),
          ("alt", name),
          ("class", "profile-icon-image")
        ]
      )
    )
  else:
    segments.add(el("span", textNode(initials), @[("class", "profile-icon-initials")]))

  if status.strip().len > 0:
    segments.add(
      el(
        "span",
        rawHtml(""),
        @[
          ("class", classList(["profile-icon-status", "profile-icon-status-" & normalizeDomId(status)])),
          ("title", status)
        ]
      )
    )

  el(
    "span",
    joinHtml(segments),
    mergeAttrs(
      @[
        ("class", classList(["profile-icon", "profile-icon-" & sizeClass])),
        ("data-tiara", "profile-icon"),
        ("title", name)
      ],
      attrs
    )
  )

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
    normalizedItems.add(("Tab 1", Tiara.text("No content")))
  else:
    for item in items:
      normalizedItems.add(item)

  let lastIndex = normalizedItems.len - 1
  let selectedIndex = max(0, min(activeIndex, lastIndex))

  var triggers: seq[Html] = @[]
  var panels: seq[Html] = @[]
  for idx, entry in normalizedItems:
    let tabId = safeId & "-tab-" & $idx
    let panelId = safeId & "-panel-" & $idx
    let isActive = idx == selectedIndex

    triggers.add(
      el(
        "button",
        textNode(entry[0]),
        @[
          ("id", tabId),
          ("type", "button"),
          ("role", "tab"),
          ("class", classList(["tabs-trigger", if isActive: "is-active" else: ""])),
          ("aria-selected", if isActive: "true" else: "false"),
          ("tabindex", if isActive: "0" else: "-1"),
          ("aria-controls", panelId),
          ("data-tiara-tabs-target", safeId),
          ("data-tiara-tabs-index", $idx)
        ]
      )
    )

    panels.add(
      el(
        "section",
        entry[1],
        @[
          ("id", panelId),
          ("role", "tabpanel"),
          ("class", classList(["tabs-panel", if isActive: "is-active" else: ""])),
          ("aria-labelledby", tabId),
          ("data-tiara-tabs-panel", $idx),
          (if isActive: ("aria-hidden", "false") else: ("hidden", "")),
          (if isActive: ("", "") else: ("aria-hidden", "true"))
        ]
      )
    )

  el(
    "section",
    joinHtml([
      el("div", joinHtml(triggers), @[("class", "tabs-list"), ("role", "tablist")]),
      el("div", joinHtml(panels), @[("class", "tabs-panels")])
    ]),
    mergeAttrs(
      @[
        ("id", safeId),
        ("class", "tabs"),
        ("data-tiara", "tabs"),
        ("data-tiara-tabs-index", $selectedIndex),
        ("data-tiara-tabs-size", $normalizedItems.len)
      ],
      attrs
    )
  )

proc dropdown*(
  T: typedesc[Tiara],
  id: string,
  items: openArray[Html],
  label = "Menu",
  trigger: Html = rawHtml(""),
  align = "left",
  size = "medium",
  motionMs = 180,
  attrs: seq[(string, string)] = @[]
): Html =
  let safeId =
    if id.strip().len == 0:
      "tiara-dropdown"
    else:
      normalizeDomId(id)
  let menuId = safeId & "-menu"
  let alignment =
    case normalizeDomId(align)
    of "right":
      "right"
    of "center":
      "center"
    else:
      "left"
  let sizeClass =
    case normalizeDomId(size)
    of "small", "large":
      normalizeDomId(size)
    else:
      "medium"

  var menuItems: seq[Html] = @[]
  if items.len == 0:
    menuItems.add(
      el(
        "li",
        textNode("No actions"),
        @[
          ("class", "dropdown-item is-disabled"),
          ("aria-disabled", "true")
        ]
      )
    )
  else:
    for idx, item in items:
      menuItems.add(
        el(
          "li",
          item,
          @[
            ("class", "dropdown-item"),
            ("data-tiara-dropdown-item", $idx)
          ]
        )
      )

  let triggerBody =
    if $trigger == "":
      textNode(label)
    else:
      trigger

  let toggle = el(
    "button",
    triggerBody,
    @[
      ("type", "button"),
      ("class", "dropdown-toggle"),
      ("aria-expanded", "false"),
      ("aria-controls", menuId),
      ("data-tiara-dropdown-toggle", safeId)
    ]
  )

  let menu = el(
    "ul",
    joinHtml(menuItems),
    @[
      ("id", menuId),
      ("class", classList(["dropdown-menu", "dropdown-menu-" & alignment])),
      ("data-tiara-dropdown-menu", safeId),
      ("hidden", "")
    ]
  )

  el(
    "div",
    joinHtml([toggle, menu]),
    mergeAttrs(
      @[
        ("id", safeId),
        ("class", classList(["dropdown", "dropdown-" & sizeClass])),
        ("data-tiara", "dropdown"),
        ("data-tiara-dropdown-open", "false"),
        ("data-tiara-motion-ms", $max(80, motionMs))
      ],
      attrs
    )
  )

proc toast*(
  T: typedesc[Tiara],
  message: string,
  title = "",
  tone = "info",
  dismissible = true,
  autoHideMs = 0,
  attrs: seq[(string, string)] = @[]
): Html =
  let normalizedTone =
    case normalizeDomId(tone)
    of "success", "warning", "error":
      normalizeDomId(tone)
    else:
      "info"

  var bodySegments: seq[Html] = @[]
  if title.strip().len > 0:
    bodySegments.add(el("strong", textNode(title), @[("class", "toast-title")]))
  bodySegments.add(el("span", textNode(message), @[("class", "toast-message")]))

  var outerSegments: seq[Html] = @[
    el("div", joinHtml(bodySegments), @[("class", "toast-content")])
  ]
  if dismissible:
    outerSegments.add(
      el(
        "button",
        textNode("x"),
        @[
          ("type", "button"),
          ("class", "toast-close"),
          ("aria-label", "Dismiss notification"),
          ("data-tiara-toast-close", "")
        ]
      )
    )

  var baseAttrs = @[
    ("class", classList(["toast", "toast-" & normalizedTone])),
    ("role", "status"),
    ("data-tiara", "toast")
  ]
  if autoHideMs > 0:
    baseAttrs.add(("data-tiara-toast-autohide", $autoHideMs))

  el("aside", joinHtml(outerSegments), mergeAttrs(baseAttrs, attrs))

proc container*(
  T: typedesc[Tiara],
  content: Html,
  maxWidth = "xl",
  attrs: seq[(string, string)] = @[]
): Html =
  let classes = classList(["container", "container-" & maxWidth])
  el("div", content, mergeAttrs(@[("class", classes)], attrs))

proc input*(
  T: typedesc[Tiara],
  name: string,
  label = "",
  value = "",
  inputType = "text",
  placeholder = "",
  required = false,
  attrs: seq[(string, string)] = @[]
): Html =
  let inputId = "tiara-" & normalizeDomId(name)
  var inputAttrs = @[
    ("id", inputId),
    ("name", name),
    ("type", inputType),
    ("class", "input")
  ]

  if value.len > 0:
    inputAttrs.add(("value", value))
  if placeholder.len > 0:
    inputAttrs.add(("placeholder", placeholder))
  if required:
    inputAttrs.add(("required", ""))

  inputAttrs.add(attrs)

  let inputElement = voidEl("input", inputAttrs)
  if label.len == 0:
    return inputElement

  el(
    "div",
    joinHtml([
      el("label", textNode(label), @[("for", inputId), ("class", "field-label")]),
      inputElement
    ]),
    @[("class", "field")]
  )

proc datePicker*(
  T: typedesc[Tiara],
  name: string,
  label = "",
  minDate = "",
  maxDate = "",
  value = "",
  attrs: seq[(string, string)] = @[]
): Html =
  let inputId = "tiara-date-" & normalizeDomId(name)
  let resolvedMin = resolveDateToken(minDate)
  let resolvedMax = resolveDateToken(maxDate)
  let resolvedValue = resolveDateToken(value)

  var inputAttrs = @[
    ("id", inputId),
    ("name", name),
    ("type", "date"),
    ("class", "input input-date"),
    ("data-tiara", "date-picker")
  ]

  if resolvedMin.len > 0:
    inputAttrs.add(("min", resolvedMin))
  if resolvedMax.len > 0:
    inputAttrs.add(("max", resolvedMax))
  if resolvedValue.len > 0:
    inputAttrs.add(("value", resolvedValue))

  inputAttrs.add(attrs)

  let inputElement = voidEl("input", inputAttrs)
  if label.len == 0:
    return inputElement

  el(
    "div",
    joinHtml([
      el("label", textNode(label), @[("for", inputId), ("class", "field-label")]),
      inputElement
    ]),
    @[("class", "field field-date")]
  )

proc colorPicker*(
  T: typedesc[Tiara],
  name: string,
  label = "",
  `default` = "#000000",
  attrs: seq[(string, string)] = @[]
): Html =
  let inputId = "tiara-color-" & normalizeDomId(name)
  var inputAttrs = @[
    ("id", inputId),
    ("name", name),
    ("type", "color"),
    ("value", `default`),
    ("class", "input input-color"),
    ("data-tiara", "color-picker"),
    ("data-tiara-color-input", inputId)
  ]

  inputAttrs.add(attrs)

  let preview = el(
    "span",
    rawHtml(""),
    @[
      ("class", "color-preview"),
      ("data-tiara-color-preview", inputId),
      ("style", "background-color: " & `default`)
    ]
  )

  let inputElement = voidEl("input", inputAttrs)
  var body = joinHtml([inputElement, preview])

  if label.len > 0:
    body = joinHtml([
      el("label", textNode(label), @[("for", inputId), ("class", "field-label")]),
      body
    ])

  el("div", body, @[("class", "field field-color")])

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
  var dialogBody: seq[Html] = @[]

  if title.len > 0:
    dialogBody.add(el("h2", textNode(title), @[("class", "modal-title")]))

  dialogBody.add(el("div", content, @[("class", "modal-content")]))

  let closeButton = Tiara.button(closeLabel, color = "secondary", size = "small", buttonType = "button", attrs = @[("data-tiara-modal-close", safeId)])
  dialogBody.add(el("div", closeButton, @[("class", "modal-actions")]))

  let triggerWrapper = el(
    "span",
    trigger,
    @[("class", "modal-trigger"), ("data-tiara-modal-open", safeId)]
  )

  let dialogElement = el(
    "dialog",
    joinHtml(dialogBody),
    mergeAttrs(
      @[
        ("id", safeId),
        ("class", classList(["modal", "modal-" & sizeClass])),
        ("data-tiara", "modal"),
        ("data-tiara-motion-ms", $max(80, motionMs))
      ],
      attrs
    )
  )

  joinHtml([triggerWrapper, dialogElement])

proc clientScriptTag*(
  T: typedesc[Tiara],
  src = "/assets/tiara_client.js"
): Html =
  el("script", rawHtml(""), @[("src", src), ("defer", "")])

proc defaultStyles*(T: typedesc[Tiara]): Html =
  rawHtml("""
<style>
.btn { border: 1px solid transparent; border-radius: 0.5rem; cursor: pointer; font-weight: 600; padding: 0.5rem 0.875rem; }
.btn-primary { background: #0f62fe; border-color: #0f62fe; color: #fff; }
.btn-secondary { background: #f2f4f8; border-color: #d0d7e2; color: #1f2937; }
.btn-small { font-size: 0.875rem; padding: 0.375rem 0.75rem; }
.btn-medium { font-size: 1rem; }
.btn-large { font-size: 1.125rem; padding: 0.625rem 1rem; }
.btn-outline { background: transparent; color: inherit; }
.container { margin: 0 auto; padding-inline: 1rem; width: min(100%, 1200px); }
.container-xl { width: min(100%, 1280px); }
.card { background: #fff; border: 1px solid #e5e7eb; border-radius: 0.75rem; box-shadow: 0 8px 24px rgba(0,0,0,.06); padding: 1rem; }
.card-title { font-size: 1.125rem; margin: 0 0 0.75rem; }
.card-content { color: #374151; }
.field { display: grid; gap: 0.5rem; }
.field-label { color: #374151; font-size: 0.875rem; font-weight: 500; }
.input { border: 1px solid #d1d5db; border-radius: 0.5rem; padding: 0.5rem 0.75rem; }
.field-color { align-items: center; grid-template-columns: 1fr auto; }
.color-preview { border: 1px solid #d1d5db; border-radius: 9999px; display: inline-block; height: 1.5rem; width: 1.5rem; }
.modal { --tiara-motion-ms: 220ms; border: none; border-radius: 0.75rem; max-width: 36rem; opacity: 0; padding: 1rem; transform: translateY(10px) scale(0.985); transition: opacity var(--tiara-motion-ms) cubic-bezier(0.2, 0.7, 0.2, 1), transform var(--tiara-motion-ms) cubic-bezier(0.2, 0.7, 0.2, 1); width: calc(100% - 2rem); }
.modal-medium { max-width: 36rem; }
.modal-small { max-width: 26rem; }
.modal-large { max-width: 48rem; }
.modal::backdrop { background: rgba(15, 23, 42, 0); transition: background var(--tiara-motion-ms) ease; }
.modal.is-open { opacity: 1; transform: translateY(0) scale(1); }
.modal.is-open::backdrop { background: rgba(15, 23, 42, 0.55); }
.modal-actions { display: flex; justify-content: flex-end; margin-top: 1rem; }
.code-block { background: #0b1120; border-radius: 0.75rem; color: #dbeafe; margin: 0; overflow: hidden; }
.code-block-header { align-items: center; background: #111827; display: flex; justify-content: space-between; padding: 0.5rem 0.75rem; }
.code-block-title { color: #e5e7eb; font-size: 0.875rem; font-weight: 600; }
.code-block-language { color: #9ca3af; font-family: ui-monospace, SFMono-Regular, Menlo, monospace; font-size: 0.75rem; letter-spacing: 0.06em; }
.code-block-pre { margin: 0; overflow-x: auto; padding: 0.875rem; }
.code-block-code { display: block; font-family: ui-monospace, SFMono-Regular, Menlo, monospace; font-size: 0.875rem; line-height: 1.5; white-space: pre; }
.code-token.code-keyword { color: #c4b5fd; }
.code-token.code-string { color: #fde68a; }
.code-token.code-number { color: #67e8f9; }
.code-token.code-comment { color: #6b7280; font-style: italic; }
.icon-badge { align-items: center; border: none; display: inline-flex; justify-content: center; position: relative; }
.icon-badge-icon { font-size: 1.25rem; line-height: 1; }
.icon-badge-count { background: #ef4444; border: 2px solid #fff; border-radius: 9999px; color: #fff; font-size: 0.7rem; font-weight: 700; min-width: 1.1rem; padding: 0.05rem 0.3rem; position: absolute; right: -0.45rem; text-align: center; top: -0.35rem; }
.notification-icon { background: #f8fafc; border: 1px solid #dbe1ea; border-radius: 0.625rem; cursor: pointer; padding: 0.5rem 0.65rem; }
.carousel { border-radius: 0.75rem; overflow: hidden; position: relative; }
.carousel-track { display: flex; transition: transform 220ms ease-out; }
.carousel-slide { flex: 0 0 100%; min-width: 100%; }
.carousel-nav { align-items: center; background: rgba(15, 23, 42, 0.6); border: none; border-radius: 9999px; color: #fff; cursor: pointer; display: inline-flex; font-size: 1rem; height: 2rem; justify-content: center; position: absolute; top: calc(50% - 1rem); width: 2rem; }
.carousel-nav-prev { left: 0.5rem; }
.carousel-nav-next { right: 0.5rem; }
.carousel-indicators { bottom: 0.5rem; display: flex; gap: 0.35rem; left: 50%; position: absolute; transform: translateX(-50%); }
.carousel-indicator { background: rgba(255, 255, 255, 0.55); border: none; border-radius: 9999px; cursor: pointer; height: 0.45rem; width: 0.45rem; }
.carousel-indicator.is-active { background: #fff; width: 1rem; }
.profile-icon { align-items: center; background: linear-gradient(135deg, #1d4ed8, #312e81); border-radius: 9999px; color: #fff; display: inline-flex; font-weight: 700; justify-content: center; overflow: hidden; position: relative; text-transform: uppercase; }
.profile-icon-small { font-size: 0.625rem; height: 1.75rem; width: 1.75rem; }
.profile-icon-medium { font-size: 0.825rem; height: 2.5rem; width: 2.5rem; }
.profile-icon-large { font-size: 1rem; height: 3.25rem; width: 3.25rem; }
.profile-icon-image { display: block; height: 100%; object-fit: cover; width: 100%; }
.profile-icon-status { border: 2px solid #fff; border-radius: 9999px; bottom: 0; height: 0.65rem; position: absolute; right: 0; width: 0.65rem; }
.profile-icon-status-online { background: #22c55e; }
.profile-icon-status-busy { background: #ef4444; }
.profile-icon-status-away { background: #f59e0b; }
.tabs { border: 1px solid #e5e7eb; border-radius: 0.75rem; overflow: hidden; }
.tabs-list { background: #f8fafc; border-bottom: 1px solid #e5e7eb; display: flex; gap: 0.25rem; padding: 0.35rem; }
.tabs-trigger { background: transparent; border: none; border-radius: 0.5rem; color: #64748b; cursor: pointer; font-weight: 600; padding: 0.5rem 0.75rem; }
.tabs-trigger.is-active { background: #fff; color: #0f172a; box-shadow: 0 1px 2px rgba(15, 23, 42, 0.1); }
.tabs-panels { padding: 0.875rem; }
.tabs-panel { color: #334155; }
.dropdown { --tiara-motion-ms: 180ms; display: inline-block; position: relative; }
.dropdown-toggle { align-items: center; background: #fff; border: 1px solid #d1d5db; border-radius: 0.625rem; cursor: pointer; display: inline-flex; gap: 0.5rem; padding: 0.45rem 0.75rem; }
.dropdown-small .dropdown-toggle { font-size: 0.82rem; padding: 0.35rem 0.65rem; }
.dropdown-large .dropdown-toggle { font-size: 1rem; padding: 0.6rem 0.9rem; }
.dropdown-menu { --tiara-dropdown-x: 0; background: #fff; border: 1px solid #e5e7eb; border-radius: 0.625rem; box-shadow: 0 12px 28px rgba(15, 23, 42, 0.14); list-style: none; margin: 0.45rem 0 0; min-width: 12rem; opacity: 0; padding: 0.35rem; pointer-events: none; position: absolute; transform: translate(var(--tiara-dropdown-x), -6px) scale(0.985); transform-origin: top; transition: opacity var(--tiara-motion-ms) ease, transform var(--tiara-motion-ms) ease; z-index: 20; }
.dropdown-menu.is-open { opacity: 1; pointer-events: auto; transform: translate(var(--tiara-dropdown-x), 0) scale(1); }
.dropdown-menu.is-closing { opacity: 0; pointer-events: none; transform: translate(var(--tiara-dropdown-x), -4px) scale(0.985); }
.dropdown-menu-left { left: 0; --tiara-dropdown-x: 0; }
.dropdown-menu-right { right: 0; --tiara-dropdown-x: 0; }
.dropdown-menu-center { left: 50%; --tiara-dropdown-x: -50%; }
.dropdown-item { border-radius: 0.5rem; margin: 0; padding: 0.4rem 0.55rem; }
.dropdown-item:hover { background: #f1f5f9; }
.dropdown-item.is-disabled { color: #9ca3af; }
.toast { align-items: flex-start; border: 1px solid transparent; border-radius: 0.75rem; display: flex; gap: 0.625rem; max-width: 26rem; padding: 0.75rem 0.875rem; }
.toast-content { display: grid; gap: 0.15rem; }
.toast-title { color: #0f172a; font-size: 0.9rem; }
.toast-message { color: #334155; font-size: 0.875rem; }
.toast-close { background: transparent; border: none; color: #64748b; cursor: pointer; font-size: 0.875rem; line-height: 1; padding: 0.125rem; }
.toast-info { background: #eff6ff; border-color: #bfdbfe; }
.toast-success { background: #ecfdf5; border-color: #86efac; }
.toast-warning { background: #fffbeb; border-color: #fcd34d; }
.toast-error { background: #fef2f2; border-color: #fca5a5; }
</style>
""")
