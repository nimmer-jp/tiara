import ../builder
import ./utils
export utils

proc sectionHeader*(
  T: typedesc[Tiara],
  title: string,
  description = "",
  kicker = "",
  align = "left",
  size = "medium",
  titleTag = "h2",
  actions: Html = rawHtml(""),
  attrs: seq[(string, string)] = @[]
): Html =
  var copySegments: seq[Html] = @[]

  if kicker.len > 0:
    copySegments.add(el("p", textNode(kicker), @[("class", "section-kicker")]))

  copySegments.add(
    el(
      titleTag,
      textNode(title),
      @[("class", classList([
        "section-title",
        if align == "left": "section-title-left" else: ""
      ]))]
    )
  )

  if description.len > 0:
    copySegments.add(
      el("p", textNode(description), @[("class", "section-description")])
    )

  var sections: seq[Html] = @[
    el("div", joinHtml(copySegments), @[("class", "section-header-copy")])
  ]

  if $actions != "":
    sections.add(el("div", actions, @[("class", "section-header-actions")]))

  let classes = classList([
    "section-header",
    if align.len > 0: "section-header-" & align else: "",
    if size.len > 0: "section-header-" & size else: ""
  ])

  el(
    "header",
    joinHtml(sections),
    mergeAttrs(@[("class", classes), ("data-tiara", "section-header")], attrs)
  )
