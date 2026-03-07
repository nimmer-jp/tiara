import ../builder
import ./utils
export utils

proc badge*(
  T: typedesc[Tiara],
  label: string,
  tone = "neutral",
  variant = "soft",
  size = "medium",
  attrs: seq[(string, string)] = @[]
): Html =
  let classes = classList([
    "badge",
    if tone.len > 0: "badge-" & tone else: "",
    if variant.len > 0: "badge-" & variant else: "",
    if size.len > 0: "badge-" & size else: ""
  ])

  el(
    "span",
    textNode(label),
    mergeAttrs(@[("class", classes), ("data-tiara", "badge")], attrs)
  )
