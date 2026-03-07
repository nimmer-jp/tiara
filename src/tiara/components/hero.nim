import ../builder
import ./utils
import ./badge
export utils

proc hero*(
  T: typedesc[Tiara],
  title: string,
  description = "",
  kicker = "",
  layout = "split",
  align = "left",
  titleHtml: Html = rawHtml(""),
  actions: seq[Html] = @[],
  visual: Html = rawHtml(""),
  badges: seq[string] = @[],
  attrs: seq[(string, string)] = @[]
): Html =
  var contentSegments: seq[Html] = @[]

  if kicker.len > 0:
    contentSegments.add(el("p", textNode(kicker), @[("class", "section-kicker")]))

  let resolvedTitle =
    if $titleHtml != "":
      titleHtml
    else:
      textNode(title)

  contentSegments.add(el("h1", resolvedTitle, @[("class", "hero-title")]))

  if description.len > 0:
    contentSegments.add(
      el("p", textNode(description), @[("class", "hero-description")])
    )

  if badges.len > 0:
    var badgeNodes: seq[Html] = @[]
    for item in badges:
      if item.strip().len == 0:
        continue
      badgeNodes.add(
        Tiara.badge(
          item.strip(),
          tone = "accent",
          variant = "soft",
          size = "small",
          attrs = @[("class", "hero-badge")]
        )
      )

    if badgeNodes.len > 0:
      contentSegments.add(el("div", joinHtml(badgeNodes), @[("class", "hero-badges")]))

  if actions.len > 0:
    contentSegments.add(el("div", joinHtml(actions), @[("class", "hero-actions")]))

  var sections: seq[Html] = @[
    el("div", joinHtml(contentSegments), @[("class", "hero-content")])
  ]

  if $visual != "":
    sections.add(el("div", visual, @[("class", "hero-visual")]))

  let classes = classList([
    "hero",
    if layout.len > 0: "hero-" & layout else: "",
    if align.len > 0: "hero-align-" & align else: ""
  ])

  el(
    "section",
    joinHtml(sections),
    mergeAttrs(@[("class", classes), ("data-tiara", "hero")], attrs)
  )
