import ../builder
import ./utils
export utils

proc text*(
  T: typedesc[Tiara],
  content: string,
  tag = "p",
  attrs: seq[(string, string)] = @[]
): Html =
  el(tag, textNode(content), attrs)

