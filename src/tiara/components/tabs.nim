import ../builder
import ./utils
export utils

proc tabs*(
  T: typedesc[Tiara],
  id: string,
  items: openArray[(string, Html)],
  activeIndex = 0,
  attrs: seq[(string, string)] = @[]
): Html =
  let safeId =
    if id.strip().len == 0:
      "tiara-tabs"
    else:
      normalizeDomId(id)

  var normalizedItems: seq[(string, Html)] = @[]
  if items.len == 0:
    normalizedItems.add(("Tab 1", Tiara.text("No content")))
  else:
    for item in items:
      normalizedItems.add(item)

  let lastIndex = normalizedItems.len - 1
  let selectedIndex = max(0, min(activeIndex, lastIndex))

  var triggers: seq[Html] = @[]
  var panels: seq[Html] = @[]
  for idx, entry in normalizedItems:
    let tabId = safeId & "-tab-" & $idx
    let panelId = safeId & "-panel-" & $idx
    let isActive = idx == selectedIndex

    triggers.add(
      el(
        "button",
        textNode(entry[0]),
        @[
          ("id", tabId),
          ("type", "button"),
          ("role", "tab"),
          ("class", classList(["tabs-trigger", if isActive: "is-active" else: ""])),
          ("aria-selected", if isActive: "true" else: "false"),
          ("tabindex", if isActive: "0" else: "-1"),
          ("aria-controls", panelId),
          ("data-tiara-tabs-target", safeId),
          ("data-tiara-tabs-index", $idx)
        ]
      )
    )

    panels.add(
      el(
        "section",
        entry[1],
        @[
          ("id", panelId),
          ("role", "tabpanel"),
          ("class", classList(["tabs-panel", if isActive: "is-active" else: ""])),
          ("aria-labelledby", tabId),
          ("data-tiara-tabs-panel", $idx),
          (if isActive: ("aria-hidden", "false") else: ("hidden", "")),
          (if isActive: ("", "") else: ("aria-hidden", "true"))
        ]
      )
    )

  el(
    "section",
    joinHtml([
      el("div", joinHtml(triggers), @[("class", "tabs-list"), ("role", "tablist")]),
      el("div", joinHtml(panels), @[("class", "tabs-panels")])
    ]),
    mergeAttrs(
      @[
        ("id", safeId),
        ("class", "tabs"),
        ("data-tiara", "tabs"),
        ("data-tiara-tabs-index", $selectedIndex),
        ("data-tiara-tabs-size", $normalizedItems.len)
      ],
      attrs
    )
  )

