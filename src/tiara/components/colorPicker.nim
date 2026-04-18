import ../builder
import ./utils
export utils

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

  let preview = el(
    "span",
    rawHtml(""),
    @[
      ("class", "color-preview"),
      ("data-tiara-color-preview", inputId),
      ("style", "background-color: " & `default`)
    ]
  )

  let inputElement = voidEl("input", mergeAttrs(inputAttrs, attrs))
  var body = joinHtml([inputElement, preview])

  if label.len > 0:
    body = joinHtml([
      el("label", textNode(label), @[("for", inputId), ("class", "field-label")]),
      body
    ])

  el("div", body, @[("class", "field field-color")])

