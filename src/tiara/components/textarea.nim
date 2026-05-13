import ../builder
import ./utils
export utils

proc textarea*(
  T: typedesc[Tiara],
  name: string,
  label = "",
  value = "",
  placeholder = "",
  required = false,
  rows = 4,
  variant = "default",
  attrs: seq[(string, string)] = @[]
): Html =
  let inputId = "tiara-" & normalizeDomId(name)
  let editorLike = variant.normalizeLanguage() == "editor"
  let areaClass =
    if editorLike:
      classList(@["textarea", "textarea-editor"])
    else:
      "textarea"
  var baseAttrs = @[
    ("id", inputId),
    ("name", name),
    ("class", areaClass),
    ("rows", $rows),
    ("data-tiara", "textarea")
  ]

  if editorLike:
    baseAttrs.add(("spellcheck", "false"))

  if placeholder.len > 0:
    baseAttrs.add(("placeholder", placeholder))
  if required:
    baseAttrs.add(("required", ""))

  let mergedAttrs = mergeAttrs(baseAttrs, attrs)
  let inner =
    if value.len > 0:
      textNode(value)
    else:
      rawHtml("")

  let areaEl = el("textarea", inner, mergedAttrs)
  if label.len == 0:
    return areaEl

  el(
    "div",
    joinHtml([
      el("label", textNode(label), @[("for", inputId), ("class", "field-label")]),
      areaEl
    ]),
    @[("class", "field")]
  )
