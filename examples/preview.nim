import std/strformat
import ../src/tiara/components

proc demoSection(title: string, body: Html): Html =
  el(
    "section",
    Tiara.card(title = title, content = body),
    @[("class", "demo-section")]
  )

proc renderPreviewPage*(clientScriptSrc = "assets/tiara_client.js"): string =
  let navbarDemo = Tiara.navbar(
    brand = "👑 Tiara",
    links = @[
      ("Docs", "#"),
      ("Components", "#"),
      ("Search", "#")
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
    Tiara.button("Primary"),
    Tiara.button("Secondary", color = "secondary"),
    Tiara.button("Outline", outlined = true),
    Tiara.button("Large", size = "large")
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
    Tiara.iconWithBadge(Tiara.text("✉", tag = "span"), badge = "12",
        label = "Inbox"),
    Tiara.notificationIcon(badge = "5"),
    Tiara.profileIcon(name = "Jane Doe", status = "online", size = "medium"),
    Tiara.profileIcon(name = "Ken Watanabe", status = "away", size = "large")
  ])

  let badgeDemo = el("div", joinHtml([
    Tiara.badge("Neutral"),
    Tiara.badge("Accent", tone = "accent"),
    Tiara.badge("Success", tone = "success", variant = "solid"),
    Tiara.badge("Warning", tone = "warning", variant = "outline")
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

  let toastDemo = joinHtml([
      Tiara.toast("Your request has been processed successfully.", "Success",
          "success", id = "toast-1", position = "bottom-right",
          autoHideMs = 3000),
      Tiara.toast("Please check your network connection.", "Warning", "warning",
          id = "toast-2", position = "top-right", autoHideMs = 5000),
      Tiara.toast("A new software update is available.", "Update Available",
          "info", id = "toast-3", position = "top-center", autoHideMs = 4000),
      Tiara.toast("Failed to save the changes.", "Error", "error",
          id = "toast-4", position = "bottom-left")
  ])

  let content = joinHtml([
    Tiara.text("Tiara Component Preview", tag = "h1", attrs = @[("class",
        "page-title")]),
    Tiara.text("This page renders components directly from the current repository implementation.",
        tag = "p", attrs = @[("class", "page-description")]),

    demoSection("Navbar", navbarDemo),
    demoSection("Hero", heroDemo),
    demoSection("Buttons", el("div", buttonsDemo, @[("class",
        "showcase-row")])),
    demoSection("Badges", badgeDemo),
    demoSection("Section Headers", sectionHeaderDemo),
    demoSection("Search Boxes", searchDemo),
    demoSection("Forms", el("div", formDemo, @[("class", "stack")])),
    demoSection("Modal", modalDemo),
    demoSection("Code Block", codeDemo),
    demoSection("Card Variants", cardVariantDemo),
    demoSection("Badges & Profile Icons", el("div", iconDemo, @[("class",
        "showcase-row")])),
    demoSection("Carousel", carouselDemo),
    demoSection("Tabs", tabsDemo),
    demoSection("Dropdown", dropdownDemo),
    demoSection("Toasts", el("div", joinHtml([
      Tiara.button("Show Success (Bottom Right)", "primary", attrs = @[(
          "data-tiara-toast-trigger", "toast-1")]),
      Tiara.button("Show Warning (Top Right)", "secondary", attrs = @[(
          "data-tiara-toast-trigger", "toast-2")]),
      Tiara.button("Show Info (Top Center)", "secondary", attrs = @[(
          "data-tiara-toast-trigger", "toast-3")]),
      Tiara.button("Show Error (Bottom Left)", "secondary", attrs = @[(
          "data-tiara-toast-trigger", "toast-4")])
    ]), @[("style", "display: flex; gap: 0.5rem; flex-wrap: wrap;")])),
    toastDemo
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
  font-family: \"Avenir Next\", \"Hiragino Sans\", \"Noto Sans JP\", sans-serif;
  line-height: 1.5;
}
.page-wrap { padding: 2.5rem 0 4rem; }
.page-title { font-size: clamp(1.5rem, 2.6vw, 2.4rem); margin: 0 0 0.4rem; }
.page-description { color: #334155; margin: 0 0 1.25rem; }
.demo-section { margin-bottom: 1rem; }
.stack { display: grid; gap: 0.875rem; }
.showcase-row { align-items: center; display: flex; flex-wrap: wrap; gap: 0.9rem; }
.showcase-grid { display: grid; gap: 0.9rem; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); }
.tabs, .dropdown, .toast, .carousel, .code-block { width: 100%; }
.navbar, .hero, .section-header { width: 100%; }
</style>
"""),
    el("main", Tiara.container(content), @[("class", "page-wrap")]),
    Tiara.clientScriptTag(clientScriptSrc)
  ])

  result = fmt"""<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Tiara Component Preview</title>
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
