import ../builder
import ./utils
export utils

proc dropdown*(
  T: typedesc[Tiara],
  id: string,
  items: openArray[Html],
  label = "Menu",
  trigger: Html = rawHtml(""),
  align = "left",
  size = "medium",
  motionMs = 180,
  attrs: seq[(string, string)] = @[]
): Html =
  let safeId =
    if id.strip().len == 0:
      "tiara-dropdown"
    else:
      normalizeDomId(id)
  let menuId = safeId & "-menu"
  let alignment =
    case normalizeDomId(align)
    of "right":
      "right"
    of "center":
      "center"
    else:
      "left"
  let sizeClass =
    case normalizeDomId(size)
    of "small", "large":
      normalizeDomId(size)
    else:
      "medium"

  var menuItems: seq[Html] = @[]
  if items.len == 0:
    menuItems.add(
      el(
        "li",
        textNode("No actions"),
        @[
          ("class", "dropdown-item is-disabled"),
          ("aria-disabled", "true")
        ]
      )
    )
  else:
    for idx, item in items:
      menuItems.add(
        el(
          "li",
          item,
          @[
            ("class", "dropdown-item"),
            ("data-tiara-dropdown-item", $idx)
          ]
        )
      )

  let triggerBody =
    if $trigger == "":
      textNode(label)
    else:
      trigger

  let toggle = el(
    "button",
    triggerBody,
    @[
      ("type", "button"),
      ("class", "dropdown-toggle"),
      ("aria-expanded", "false"),
      ("aria-controls", menuId),
      ("data-tiara-dropdown-toggle", safeId)
    ]
  )

  let menu = el(
    "ul",
    joinHtml(menuItems),
    @[
      ("id", menuId),
      ("class", classList(["dropdown-menu", "dropdown-menu-" & alignment])),
      ("data-tiara-dropdown-menu", safeId),
      ("hidden", "")
    ]
  )

  el(
    "div",
    joinHtml([toggle, menu]),
    mergeAttrs(
      @[
        ("id", safeId),
        ("class", classList(["dropdown", "dropdown-" & sizeClass])),
        ("data-tiara", "dropdown"),
        ("data-tiara-dropdown-open", "false"),
        ("data-tiara-motion-ms", $max(80, motionMs))
      ],
      attrs
    )
  )

