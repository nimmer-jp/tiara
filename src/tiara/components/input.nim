import ../builder
import ./utils
export utils

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

