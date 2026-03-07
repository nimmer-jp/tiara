import ../builder
import ./utils
export utils

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

