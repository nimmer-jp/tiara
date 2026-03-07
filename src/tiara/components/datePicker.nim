import ../builder
import ./utils
export utils

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

