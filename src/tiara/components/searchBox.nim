import ../builder
import ./utils
export utils

proc searchBox*(
  T: typedesc[Tiara],
  name: string,
  label = "",
  value = "",
  placeholder = "Search...",
  icon = "⌕",
  variant = "subtle",
  size = "medium",
  inputAttrs: seq[(string, string)] = @[],
  attrs: seq[(string, string)] = @[]
): Html =
  let inputId = "tiara-search-" & normalizeDomId(name)
  let accessibleLabel =
    if label.len > 0:
      label
    elif placeholder.len > 0:
      placeholder
    else:
      name

  var normalizedInputAttrs = @[
    ("id", inputId),
    ("name", name),
    ("type", "search"),
    ("class", "search-box-input"),
    ("placeholder", placeholder),
    ("aria-label", accessibleLabel),
    ("autocomplete", "off"),
    ("spellcheck", "false")
  ]

  if value.len > 0:
    normalizedInputAttrs.add(("value", value))

  normalizedInputAttrs = mergeAttrs(normalizedInputAttrs, inputAttrs)

  let control = el(
    "div",
    joinHtml([
      el("span", textNode(icon), @[("class", "search-box-icon"), ("aria-hidden", "true")]),
      voidEl("input", normalizedInputAttrs)
    ]),
    @[("class", "search-box-control")]
  )

  var segments: seq[Html] = @[]
  if label.len > 0:
    segments.add(el("label", textNode(label), @[("for", inputId), ("class", "field-label")]))
  segments.add(control)

  let classes = classList([
    "search-box",
    if variant.len > 0: "search-box-" & variant else: "",
    if size.len > 0: "search-box-" & size else: ""
  ])

  el(
    "div",
    joinHtml(segments),
    mergeAttrs(@[("class", classes), ("data-tiara", "search-box")], attrs)
  )
