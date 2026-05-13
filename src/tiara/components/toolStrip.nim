import ../builder
import ./utils
export utils

proc toolStrip*(
  T: typedesc[Tiara],
  children: openArray[Html],
  variant = "plain",
  attrs: seq[(string, string)] = @[]
): Html =
  ## Flex row for format-tool buttons (Editro toolbar) and compact action clusters.
  let variantClass =
    case variant.normalizeLanguage()
    of "elevated":
      "tool-strip-elevated"
    of "subtle":
      "tool-strip-subtle"
    else:
      "tool-strip-plain"

  el(
    "div",
    joinHtml(children),
    mergeAttrs(@[
      ("class", classList(@["tool-strip", variantClass])),
      ("data-tiara", "tool-strip")
    ], attrs)
  )
