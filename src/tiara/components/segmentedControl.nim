import ../builder
import ./utils
export utils

proc segmentedControl*(
  T: typedesc[Tiara],
  id: string,
  items: seq[tuple[label: string; selected: bool]],
  size = "medium",
  attrs: seq[(string, string)] = @[]
): Html =
  ## Inline pill control for editor / preview toggles (compare Midnote mode pills + Editro view tabs).
  let sizeClass =
    case size.normalizeLanguage()
    of "small":
      "segmented-control-small"
    else:
      "segmented-control-medium"

  var buttons: seq[Html] = @[]
  for idx, it in items:
    let itemClass = classList(@[
      "segmented-item",
      if it.selected: "is-active" else: ""
    ])
    var itemAttrs = @[
      ("type", "button"),
      ("class", itemClass),
      ("aria-pressed", if it.selected: "true" else: "false"),
      ("data-tiara-segment-index", $idx)
    ]
    buttons.add(el("button", textNode(it.label), itemAttrs))

  el(
    "div",
    joinHtml(buttons),
    mergeAttrs(@[
      ("id", id),
      ("class", classList(@["segmented-control", sizeClass])),
      ("role", "group"),
      ("aria-label", "View mode"),
      ("data-tiara", "segmented-control")
    ], attrs)
  )
