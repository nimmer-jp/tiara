import std/strformat
import ../src/tiara/components

proc demoSection(title: string, body: Html): Html =
  el(
    "section",
    Tiara.card(title = title, content = body),
    @[("class", "demo-section")]
  )

proc renderPreviewPage*(clientScriptSrc = "assets/tiara_client.js"): string =
  let buttonsDemo = joinHtml([
    Tiara.button("Primary"),
    Tiara.button("Secondary", color = "secondary"),
    Tiara.button("Outline", outlined = true),
    Tiara.button("Large", size = "large")
  ])

  let formDemo = joinHtml([
    Tiara.input(name = "username", label = "Username", placeholder = "tiara-user"),
    Tiara.datePicker(name = "birthdate", label = "Birthdate", minDate = "1900-01-01", maxDate = "today"),
    Tiara.colorPicker(name = "theme", label = "Theme Color", default = "#2563eb")
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
    Tiara.iconWithBadge(Tiara.text("✉", tag = "span"), badge = "12", label = "Inbox"),
    Tiara.notificationIcon(badge = "5"),
    Tiara.profileIcon(name = "Jane Doe", status = "online", size = "medium"),
    Tiara.profileIcon(name = "Ken Watanabe", status = "away", size = "large")
  ])

  let carouselDemo = Tiara.carousel(
    id = "feature-carousel",
    items = @[
      Tiara.card("Fast SSR", Tiara.text("Compile-time optimized HTML rendering.")),
      Tiara.card("Pure Nim", Tiara.text("No external JS framework required.")),
      Tiara.card("Progressive", Tiara.text("Interactive widgets powered by tiny Nim-to-JS."))
    ]
  )

  let tabsDemo = Tiara.tabs(
    id = "overview-tabs",
    items = @[
      ("Overview", Tiara.text("Tiara is designed for SSR-first Nim apps.")),
      ("Usage", Tiara.codeBlock("""let btn = Tiara.button("Send")""", language = "nim")),
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
    Tiara.toast("Saved changes successfully.", title = "Success", tone = "success"),
    Tiara.toast("Storage is almost full.", title = "Warning", tone = "warning", autoHideMs = 5000),
    Tiara.toast("Unable to sync latest data.", title = "Error", tone = "error")
  ])

  let content = joinHtml([
    Tiara.text("Tiara Component Preview", tag = "h1", attrs = @[("class", "page-title")]),
    Tiara.text("This page renders components directly from the current repository implementation.", tag = "p", attrs = @[("class", "page-description")]),

    demoSection("Buttons", el("div", buttonsDemo, @[("class", "showcase-row")])),
    demoSection("Forms", el("div", formDemo, @[("class", "stack")])),
    demoSection("Modal", modalDemo),
    demoSection("Code Block", codeDemo),
    demoSection("Badges & Profile Icons", el("div", iconDemo, @[("class", "showcase-row")])),
    demoSection("Carousel", carouselDemo),
    demoSection("Tabs", tabsDemo),
    demoSection("Dropdown", dropdownDemo),
    demoSection("Toasts", el("div", toastDemo, @[("class", "stack")]))
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
.tabs, .dropdown, .toast, .carousel, .code-block { width: 100%; }
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
