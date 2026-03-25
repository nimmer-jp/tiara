import std/strformat
import std/strutils
import ../src/tiara/components

proc demoSection(title: string, body: Html): Html =
  el(
    "section",
    Tiara.card(title = title, content = body),
    @[("class", "demo-section")]
  )

proc catalogLabel(text: string): Html =
  Tiara.text(text, tag = "p", attrs = @[("class", "tiara-catalog-label")])

proc catalogDemoWithTabs*(preview: Html, nimCode: string, id: string): Html =
  ## カタログ用: ライブプレビューと Nim の実装例をタブで切り替え。
  Tiara.tabs(
    id = id,
    items = @[
      ("プレビュー", preview),
      ("コード", Tiara.codeBlock(
        code = nimCode,
        language = "nim",
        title = "example.nim",
        chrome = "minimal"
      ))
    ],
    attrs = @[("class", "catalog-demo-tabs")]
  )

proc renderPreviewPage*(
  clientScriptSrc = "assets/tiara_client.js",
  homeHref = "#",
  docsHref = "#",
  componentsHref = "#"
): string =
  let navbarDemo = Tiara.navbar(
    brand = "👑 Tiara",
    links = @[
      ("Home", homeHref),
      ("Docs", docsHref),
      ("Components", componentsHref)
    ],
    action = el(
      "a",
      textNode("GitHub"),
      @[
        ("href", "https://github.com/nimmer-jp/tiara"),
        ("class", "btn btn-secondary btn-medium btn-outline")
      ]
    )
  )

  let heroDemo = Tiara.hero(
    title = "",
    titleHtml = rawHtml("Ship <span style=\"color:#7c3aed;\">search-ready</span> Nim websites."),
    description = "New website-facing primitives make landing pages, docs hubs, and install guides easier to compose directly from Tiara.",
    kicker = "Marketing UI",
    badges = @["SSR-first", "Docs Search", "Nimble Install"],
    actions = @[
      Tiara.button("Open Docs"),
      Tiara.button("Try Search", color = "secondary", outlined = true)
    ],
    visual = Tiara.codeBlock(
      code = "nimble install tiara",
      language = "sh",
      title = "terminal",
      chrome = "terminal"
    )
  )

  let buttonsDemo = joinHtml([
    catalogLabel("Roles"),
    el("div", joinHtml([
      Tiara.button("Primary"),
      Tiara.button("Secondary", color = "secondary"),
      Tiara.button("Danger", color = "danger"),
      Tiara.button("Ghost", color = "ghost")
    ]), @[("class", "tiara-catalog-row")]),
    catalogLabel("Outline · sizes"),
    el("div", joinHtml([
      Tiara.button("Outline", outlined = true),
      Tiara.button("Secondary outline", color = "secondary", outlined = true),
      Tiara.button("Small", size = "small"),
      Tiara.button("Large", size = "large")
    ]), @[("class", "tiara-catalog-row")])
  ])

  let formDemo = joinHtml([
    Tiara.input(name = "username", label = "Username",
        placeholder = "tiara-user"),
    Tiara.datePicker(name = "birthdate", label = "Birthdate",
        minDate = "1900-01-01", maxDate = "today"),
    Tiara.colorPicker(name = "theme", label = "Theme Color",
        default = "#2563eb")
  ])

  let modalDemo = Tiara.modal(
    id = "preview-modal",
    trigger = Tiara.button("Open Modal", color = "secondary"),
    content = Tiara.text("This modal is controlled by tiara_client.js"),
    title = "Tiara Modal"
  )

  let codeDemo = Tiara.codeBlock(
    code = """proc hello(name: string): string =
  let answer = 42 # sample
  result = "Hi, " & name""",
    language = "nim",
    title = "sample.nim"
  )

  let iconDemo = joinHtml([
    catalogLabel("Icon + count"),
    el("div", joinHtml([
      Tiara.iconWithBadge(Tiara.text("✉", tag = "span"), badge = "12",
          label = "Inbox"),
      Tiara.iconWithBadge(Tiara.text("✓", tag = "span"), badge = "3",
          label = "Tasks")
    ]), @[("class", "tiara-catalog-row")]),
    catalogLabel("Notification"),
    el("div", joinHtml([
      Tiara.notificationIcon(badge = "5"),
      Tiara.notificationIcon(badge = "1", variant = "subtle"),
      Tiara.notificationIcon(badge = "", variant = "ghost", icon = "☰"),
      Tiara.notificationIcon(badge = "9", variant = "solid")
    ]), @[("class", "tiara-catalog-row")]),
    catalogLabel("Avatar"),
    el("div", joinHtml([
      Tiara.profileIcon(name = "Jane Doe", status = "online", size = "small"),
      Tiara.profileIcon(name = "Jane Doe", status = "online", size = "medium"),
      Tiara.profileIcon(name = "Ken Watanabe", status = "away", size = "large"),
      Tiara.profileIcon(name = "ACME", variant = "brand", size = "medium"),
      Tiara.profileIcon(name = "Dev", variant = "dark", size = "medium", status = "busy")
    ]), @[("class", "tiara-catalog-row")])
  ])

  let badgeDemo = joinHtml([
    catalogLabel("Soft"),
    el("div", joinHtml([
      Tiara.badge("Neutral"),
      Tiara.badge("Accent", tone = "accent"),
      Tiara.badge("Success", tone = "success"),
      Tiara.badge("Warning", tone = "warning"),
      Tiara.badge("Error", tone = "error"),
      Tiara.badge("Info", tone = "info")
    ]), @[("class", "tiara-catalog-row")]),
    catalogLabel("Solid"),
    el("div", joinHtml([
      Tiara.badge("Neutral", variant = "solid"),
      Tiara.badge("Accent", tone = "accent", variant = "solid"),
      Tiara.badge("Success", tone = "success", variant = "solid"),
      Tiara.badge("Error", tone = "error", variant = "solid"),
      Tiara.badge("Info", tone = "info", variant = "solid")
    ]), @[("class", "tiara-catalog-row")]),
    catalogLabel("Outline"),
    el("div", joinHtml([
      Tiara.badge("Neutral", variant = "outline"),
      Tiara.badge("Accent", tone = "accent", variant = "outline"),
      Tiara.badge("Warning", tone = "warning", variant = "outline"),
      Tiara.badge("Error", tone = "error", variant = "outline")
    ]), @[("class", "tiara-catalog-row")]),
    catalogLabel("Sizes"),
    el("div", joinHtml([
      Tiara.badge("S", size = "small"),
      Tiara.badge("Medium", size = "medium"),
      Tiara.badge("Large", size = "large")
    ]), @[("class", "tiara-catalog-row")])
  ])

  let catalogMeta = el("div", joinHtml([
    Tiara.badge("15 component groups", tone = "accent", variant = "solid"),
    Tiara.badge("Interactive demos", tone = "success"),
    Tiara.badge("SSR-first", tone = "warning", variant = "outline")
  ]), @[("class", "showcase-row")])

  let sectionHeaderDemo = el("div", joinHtml([
    Tiara.sectionHeader(
      title = "Documentation sections",
      description = "Use consistent kickers, titles, and actions across guides and component indexes.",
      kicker = "Section Header",
      actions = joinHtml([
        Tiara.badge("Beta", tone = "accent", variant = "solid"),
        Tiara.button("Explore", size = "small")
    ])
  ),
    Tiara.sectionHeader(
      title = "Centered variation",
      description = "The same primitive can also anchor a centered marketing block.",
      kicker = "Variation",
      align = "center",
      size = "large"
    )
  ]), @[("class", "stack")])

  let searchDemo = el("div", joinHtml([
    Tiara.searchBox(
      name = "docs-search",
      label = "Documentation Search",
      placeholder = "Search installation, toast, customization..."
    ),
    Tiara.searchBox(
      name = "component-search",
      placeholder = "Search components...",
      variant = "outline",
      size = "large"
    )
  ]), @[("class", "stack"), ("style", "max-width: 34rem;")])

  let cardVariantDemo = el("div", joinHtml([
    Tiara.card(
      "Default",
      Tiara.text("Balanced surface for app UI and internal tools.")
    ),
    Tiara.card(
      "Elevated",
      Tiara.text("A stronger shadow helps distinguish featured content."),
      variant = "elevated"
    ),
    Tiara.card(
      "Outline",
      Tiara.text("Subtle presentation for secondary content blocks."),
      variant = "outline"
    ),
    Tiara.card(
      "Subtle",
      Tiara.text("Muted canvas for dense lists and settings panels."),
      variant = "subtle"
    ),
    Tiara.card(
      "Flat",
      Tiara.text("Border only: tables, forms, and sidebars."),
      variant = "flat"
    ),
    Tiara.card(
      "Glass",
      Tiara.text("Marketing-style translucent surface for hero callouts."),
      variant = "glass"
    )
  ]), @[("class", "showcase-grid")])

  let carouselDemo = Tiara.carousel(
    id = "feature-carousel",
    items = @[
      Tiara.card("Fast SSR", Tiara.text(
          "Compile-time optimized HTML rendering.")),
      Tiara.card("Pure Nim", Tiara.text("No external JS framework required.")),
      Tiara.card("Progressive", Tiara.text("Interactive widgets powered by tiny Nim-to-JS."))
    ]
  )

  let tabsDemo = Tiara.tabs(
    id = "overview-tabs",
    items = @[
      ("Overview", Tiara.text("Tiara is designed for SSR-first Nim apps.")),
      ("Usage", Tiara.codeBlock("""let btn = Tiara.button("Send")""",
          language = "nim")),
      ("Notes", Tiara.text("All components render accessible semantic HTML."))
    ]
  )

  let dropdownDemo = Tiara.dropdown(
    id = "account-menu",
    label = "Account",
    align = "right",
    items = @[
      Tiara.text("Profile", tag = "span"),
      Tiara.text("Billing", tag = "span"),
      Tiara.text("Sign out", tag = "span")
    ]
  )

  ## Keep toast markup in #tiara-toast-storage so hidden toasts do not reserve
  ## vertical space in the catalog layout (initTiaraClient skips moving them).
  let toastDemo = el("div", joinHtml([
      Tiara.toast("Your request has been processed successfully.", "Success",
          "success", id = "toast-1", position = "bottom-right",
          autoHideMs = 3000),
      Tiara.toast("Please check your network connection.", "Warning", "warning",
          id = "toast-2", position = "top-right", autoHideMs = 5000),
      Tiara.toast("A new software update is available.", "Update Available",
          "info", id = "toast-3", position = "top-center", autoHideMs = 4000),
      Tiara.toast("Failed to save the changes.", "Error", "error",
          id = "toast-4", position = "bottom-left")
  ]), @[("id", "tiara-toast-storage"), ("style", "display:none")])

  let
    codeNavbar = """
import tiara/components

Tiara.navbar(
  brand = "👑 Tiara",
  links = @[("Home", "/"), ("Docs", "/docs"), ("Components", "/components")],
  action = Tiara.button("GitHub", color = "secondary", outlined = true)
)
""".strip()
    codeHero = """
import tiara/components

Tiara.hero(
  title = "Ship search-ready Nim websites.",
  description = "Landing pages and docs hubs from Tiara primitives.",
  kicker = "Marketing UI",
  badges = @["SSR-first", "Docs Search"],
  actions = @[
    Tiara.button("Open Docs"),
    Tiara.button("Try Search", color = "secondary", outlined = true)
  ],
  visual = Tiara.codeBlock("nimble install tiara", language = "sh",
    title = "terminal", chrome = "terminal")
)
""".strip()
    codeButtons = """
import tiara/components

joinHtml(@[
  Tiara.button("Primary"),
  Tiara.button("Secondary", color = "secondary"),
  Tiara.button("Danger", color = "danger"),
  Tiara.button("Ghost", color = "ghost"),
  Tiara.button("Outline", outlined = true),
  Tiara.button("Small", size = "small"),
  Tiara.button("Large", size = "large")
])
""".strip()
    codeBadges = """
import tiara/components

Tiara.badge("Accent", tone = "accent")
Tiara.badge("Success", tone = "success", variant = "solid")
Tiara.badge("Outline", tone = "warning", variant = "outline")
""".strip()
    codeSectionHeaders = """
import tiara/components

Tiara.sectionHeader(
  title = "Documentation sections",
  description = "Kick titles and actions across guides.",
  kicker = "Section Header",
  actions = Tiara.button("Explore", size = "small")
)
""".strip()
    codeSearch = """
import tiara/components

Tiara.searchBox(
  name = "docs-search",
  label = "Documentation Search",
  placeholder = "Search installation, toast..."
)
Tiara.searchBox(
  name = "q",
  placeholder = "Search components...",
  variant = "outline",
  size = "large"
)
""".strip()
    codeForms = """
import tiara/components

joinHtml(@[
  Tiara.input(name = "username", label = "Username", placeholder = "tiara-user"),
  Tiara.datePicker(name = "birthdate", label = "Birthdate",
    minDate = "1900-01-01", maxDate = "today"),
  Tiara.colorPicker(name = "theme", label = "Theme Color", default = "#2563eb")
])
""".strip()
    codeModal = """
import tiara/components

Tiara.modal(
  id = "my-modal",
  trigger = Tiara.button("Open Modal", color = "secondary"),
  content = Tiara.text("Modal body"),
  title = "Tiara Modal"
)
""".strip()
    codeCodeBlock = """
import tiara/components

Tiara.codeBlock(
  "proc hello(name: string): string =\n  let answer = 42\n  result = \"Hi, \" & name",
  language = "nim",
  title = "sample.nim"
)
""".strip()
    codeCardVariants = """
import tiara/components

Tiara.card("Elevated", Tiara.text("Featured content."), variant = "elevated")
Tiara.card("Outline", Tiara.text("Secondary block."), variant = "outline")
Tiara.card("Subtle", Tiara.text("Dense lists."), variant = "subtle")
""".strip()
    codeIcons = """
import tiara/components

Tiara.iconWithBadge(Tiara.text("✉", tag = "span"), badge = "12", label = "Inbox")
Tiara.notificationIcon(badge = "5")
Tiara.profileIcon(name = "Jane Doe", status = "online", size = "medium")
""".strip()
    codeCarousel = """
import tiara/components

Tiara.carousel(
  id = "feature-carousel",
  items = @[
    Tiara.card("Fast SSR", Tiara.text("Optimized HTML.")),
    Tiara.card("Pure Nim", Tiara.text("No JS framework."))
  ]
)
""".strip()
    codeTabs = """
import tiara/components

Tiara.tabs(
  id = "my-tabs",
  items = @[
    ("Overview", Tiara.text("First panel")),
    ("Code", Tiara.codeBlock("let x = 1", language = "nim"))
  ]
)
""".strip()
    codeDropdown = """
import tiara/components

Tiara.dropdown(
  id = "account-menu",
  label = "Account",
  align = "right",
  items = @[
    Tiara.text("Profile", tag = "span"),
    Tiara.text("Sign out", tag = "span")
  ]
)
""".strip()
    codeToasts = """
import tiara/components

# Markup: Tiara.toast(..., id = "toast-1", ...)
# Trigger from a button:
Tiara.button("Notify", attrs = @[("data-tiara-toast-trigger", "toast-1")])
""".strip()

  let content = joinHtml([
    Tiara.text("Tiara Component Catalog", tag = "h1", attrs = @[("class",
        "page-title")]),
    Tiara.text("Explore the same components shipped in the current repository, with live previews and implementation-ready examples.",
        tag = "p", attrs = @[("class", "page-description")]),
    catalogMeta,

    demoSection("Navbar", catalogDemoWithTabs(navbarDemo, codeNavbar,
        "catalog-tabs-navbar")),
    demoSection("Hero", catalogDemoWithTabs(heroDemo, codeHero,
        "catalog-tabs-hero")),
    demoSection("Buttons", catalogDemoWithTabs(
      el("div", buttonsDemo, @[("class", "showcase-row")]),
      codeButtons, "catalog-tabs-buttons")),
    demoSection("Badges", catalogDemoWithTabs(
      el("div", badgeDemo, @[("class", "tiara-catalog-stack")]),
      codeBadges, "catalog-tabs-badges")),
    demoSection("Section Headers", catalogDemoWithTabs(sectionHeaderDemo,
        codeSectionHeaders, "catalog-tabs-section-headers")),
    demoSection("Search Boxes", catalogDemoWithTabs(searchDemo, codeSearch,
        "catalog-tabs-search")),
    demoSection("Forms", catalogDemoWithTabs(
      el("div", formDemo, @[("class", "stack")]),
      codeForms, "catalog-tabs-forms")),
    demoSection("Modal", catalogDemoWithTabs(modalDemo, codeModal,
        "catalog-tabs-modal")),
    demoSection("Code Block", catalogDemoWithTabs(codeDemo, codeCodeBlock,
        "catalog-tabs-code-block")),
    demoSection("Card Variants", catalogDemoWithTabs(cardVariantDemo,
        codeCardVariants, "catalog-tabs-card-variants")),
    demoSection("Badges & Profile Icons", catalogDemoWithTabs(
      el("div", iconDemo, @[("class",
        "tiara-catalog-stack showcase-icons")]),
      codeIcons, "catalog-tabs-icons")),
    demoSection("Carousel", catalogDemoWithTabs(carouselDemo, codeCarousel,
        "catalog-tabs-carousel")),
    demoSection("Tabs", catalogDemoWithTabs(tabsDemo, codeTabs,
        "catalog-tabs-tabs")),
    demoSection("Dropdown", catalogDemoWithTabs(dropdownDemo, codeDropdown,
        "catalog-tabs-dropdown")),
    demoSection("Toasts", joinHtml([
      catalogDemoWithTabs(
        el("div", joinHtml([
          Tiara.button("Show Success (Bottom Right)", "primary", attrs = @[(
              "data-tiara-toast-trigger", "toast-1")]),
          Tiara.button("Show Warning (Top Right)", "secondary", attrs = @[(
              "data-tiara-toast-trigger", "toast-2")]),
          Tiara.button("Show Info (Top Center)", "secondary", attrs = @[(
              "data-tiara-toast-trigger", "toast-3")]),
          Tiara.button("Show Error (Bottom Left)", "secondary", attrs = @[(
              "data-tiara-toast-trigger", "toast-4")])
        ]), @[("style", "display: flex; gap: 0.5rem; flex-wrap: wrap;")]),
        codeToasts,
        "catalog-tabs-toasts"),
      toastDemo
    ])),
  ])

  let body = joinHtml([
    Tiara.defaultStyles(),
    rawHtml("""
<style>
:root { color-scheme: light; }
body {
  margin: 0;
  background: radial-gradient(circle at top, #dbeafe, #f8fafc 36%, #eef2ff 100%);
  color: #0f172a;
  font-family: ui-sans-serif, system-ui, -apple-system, "Segoe UI", Roboto, "Noto Sans JP", sans-serif;
  line-height: 1.5;
}
.tiara-catalog-label { color: #64748b; font-size: 0.7rem; font-weight: 600; letter-spacing: 0.12em; margin: 0; text-transform: uppercase; }
.tiara-catalog-row { align-items: center; display: flex; flex-wrap: wrap; gap: 0.65rem; }
.tiara-catalog-stack { display: grid; gap: 1.1rem; }
.page-wrap { padding: 2.5rem 0 4rem; }
.page-title { font-size: clamp(1.5rem, 2.6vw, 2.4rem); margin: 0 0 0.4rem; }
.page-description { color: #334155; margin: 0 0 1.25rem; }
.demo-section { margin-bottom: 1rem; }
.stack { display: grid; gap: 0.875rem; }
.showcase-row { align-items: center; display: flex; flex-wrap: wrap; gap: 0.9rem; }
.showcase-grid { display: grid; gap: 0.9rem; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); }
.tabs, .carousel, .code-block, .navbar, .hero, .section-header { width: 100%; }
/* .dropdown must stay shrink-to-toggle: width 100% makes right/center menus anchor to the card edge */
.dropdown { max-width: 100%; width: fit-content; }
.demo-section .card { min-width: 0; max-width: 100%; }
/* overflow-x:auto forces overflow-y to compute to auto and clips position:absolute dropdowns */
.demo-section .card-content { min-width: 0; overflow: visible; }
/* icon badges & avatars: same row rhythm as .showcase-row; overflow visible for count pills */
.showcase-icons { align-items: center; flex-wrap: wrap; gap: 0.9rem; overflow: visible; }
.showcase-icons .icon-badge, .showcase-icons .notification-icon, .showcase-icons .profile-icon { flex: 0 0 auto; }
.hero, .navbar { box-sizing: border-box; max-width: 100%; }
.catalog-demo-tabs { min-width: 0; width: 100%; }
.catalog-demo-tabs .tabs-list { flex-wrap: wrap; }
.catalog-demo-tabs .tabs-panels { min-width: 0; padding-top: 0.65rem; }
.catalog-demo-tabs .code-block-pre { max-height: 22rem; overflow: auto; }
</style>
"""),
    el("main", Tiara.container(content), @[("class", "page-wrap")]),
    Tiara.clientScriptTag(clientScriptSrc & "?v=" & $687865) # Use a dummy version for now
  ])

  result = fmt"""<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Tiara Component Catalog</title>
</head>
<body>
{body}
</body>
</html>
"""

when isMainModule:
  import std/os

  let outputPath =
    if paramCount() >= 1:
      paramStr(1)
    else:
      "examples/dist/index.html"

  createDir(parentDir(outputPath))
  writeFile(outputPath, renderPreviewPage())
  echo "Generated: ", outputPath
