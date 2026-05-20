import ../builder
import ./utils
import ./dashboardShell
export utils, dashboardShell

proc sidebarNavLink*(
  T: typedesc[Tiara],
  label: string,
  href: string,
  active = false,
  attrs: seq[(string, string)] = @[]
): Html =
  let classes = classList([
    "admin-nav-link",
    if active: "is-active" else: "",
  ])
  el(
    "a",
    textNode(label),
    mergeAttrs(@[
      ("href", href),
      ("class", classes),
    ], attrs)
  )

proc adminLayout*(
  T: typedesc[Tiara],
  brand: string,
  main: Html,
  subtitle = "",
  links: seq[(string, string)] = @[],
  activeHref = "",
  footer: Html = rawHtml(""),
  attrs: seq[(string, string)] = @[]
): Html =
  ## Admin dashboard preset: sticky sidebar, vertical nav, and footer slot (e.g. logout form).
  var brandBlocks: seq[Html] = @[
    el("h1", textNode(brand), @[("class", "admin-layout-brand")])
  ]
  if subtitle.len > 0:
    brandBlocks.add(el("p", textNode(subtitle), @[("class", "admin-layout-subtitle")]))

  var navLinks: seq[Html] = @[]
  for (label, href) in links:
    if label.len == 0:
      continue
    navLinks.add Tiara.sidebarNavLink(label, href, active = href == activeHref)

  var sidebarBlocks: seq[Html] = @[
    el("div", joinHtml(brandBlocks), @[("class", "admin-layout-brand-block")]),
  ]
  if navLinks.len > 0:
    sidebarBlocks.add(el("nav", joinHtml(navLinks), @[("class", "admin-layout-nav")]))
  if ($footer).strip.len > 0:
    sidebarBlocks.add(el("div", footer, @[("class", "admin-layout-footer")]))

  let sidebar = el(
    "div",
    joinHtml(sidebarBlocks),
    @[("class", "admin-layout-sidebar-inner")]
  )

  Tiara.dashboardShell(
    sidebar,
    main,
    mergeAttrs(@[
      ("class", "admin-layout"),
      ("data-tiara", "admin-layout"),
    ], attrs)
  )
