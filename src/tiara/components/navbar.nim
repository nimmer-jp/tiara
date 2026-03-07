import ../builder
import ./utils
export utils

proc navbar*(
  T: typedesc[Tiara],
  brand: string,
  links: seq[(string, string)] = @[],
  brandHref = "/",
  action: Html = rawHtml(""),
  variant = "glass",
  size = "medium",
  attrs: seq[(string, string)] = @[]
): Html =
  let brandContent = textNode(brand)
  let brandNode =
    if brandHref.len > 0:
      el("a", brandContent, @[("href", brandHref), ("class", "nav-brand")])
    else:
      el("span", brandContent, @[("class", "nav-brand")])

  var linkNodes: seq[Html] = @[]
  for (label, href) in links:
    if label.len == 0:
      continue
    linkNodes.add(el("a", textNode(label), @[("href", href), ("class", "nav-link")]))

  if $action != "":
    linkNodes.add(action)

  let classes = classList([
    "navbar",
    if variant.len > 0: "navbar-" & variant else: "",
    if size.len > 0: "navbar-" & size else: ""
  ])

  el(
    "nav",
    joinHtml([
      brandNode,
      el("div", joinHtml(linkNodes), @[("class", "nav-links")])
    ]),
    mergeAttrs(@[("class", classes), ("data-tiara", "navbar")], attrs)
  )
