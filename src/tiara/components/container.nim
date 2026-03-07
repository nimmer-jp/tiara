import ../builder
import ./utils
export utils

proc container*(
  T: typedesc[Tiara],
  content: Html,
  maxWidth = "xl",
  attrs: seq[(string, string)] = @[]
): Html =
  let classes = classList(["container", "container-" & maxWidth])
  el("div", content, mergeAttrs(@[("class", classes)], attrs))

