import ../builder
import ./utils
export utils

proc pageHeading*(
  T: typedesc[Tiara],
  title: string,
  description = "",
  actions: Html = rawHtml(""),
  attrs: seq[(string, string)] = @[]
): Html =
  ## Primary page title block for admin / list views (tategaki admin2 main header).
  var copyBlocks: seq[Html] = @[
    el("h2", textNode(title), @[("class", "page-heading-title")])
  ]
  if description.len > 0:
    copyBlocks.add(el("p", textNode(description), @[("class", "page-heading-description")]))

  let headingBlock = el(
    "div",
    joinHtml(copyBlocks),
    @[("class", "page-heading-copy")],
  )
  var innerParts = @[headingBlock]
  if ($actions).strip.len > 0:
    innerParts.add(el("div", actions, @[("class", "page-heading-actions")]))

  el(
    "header",
    joinHtml(innerParts),
    mergeAttrs(@[
      ("class", "page-heading"),
      ("data-tiara", "page-heading"),
    ], attrs)
  )
