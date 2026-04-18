import ../builder
import ./utils
export utils

proc setupCard*(
  T: typedesc[Tiara],
  title: string,
  content: Html,
  step = "",
  optional = false,
  attrs: seq[(string, string)] = @[]
): Html =
  var headerParts: seq[Html] = @[]
  if step.len > 0:
    headerParts.add(
      el("span", textNode(step), @[("class", "setup-card-step")])
    )
  headerParts.add(el("h3", textNode(title), @[("class", "setup-card-title")]))

  var headerInner = joinHtml(headerParts)
  if optional:
    headerInner = joinHtml([
      headerInner,
      el("span", textNode("スキップ可"), @[("class", "setup-card-optional-badge")])
    ])

  let header = el(
    "div",
    headerInner,
    @[("class", "setup-card-header")]
  )

  let body = el("div", content, @[("class", "setup-card-body")])

  el(
    "section",
    joinHtml([header, body]),
    mergeAttrs(@[("class", "setup-card"), ("data-tiara", "setup-card")], attrs)
  )
