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
  ## カタログ用: ライブプレビューと Crown 向け実装例（`html"""` + `{…}`）をタブで切り替え。
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
    Tiara.textarea(
      name = "bio",
      label = "Bio",
      placeholder = "Short introduction…",
      rows = 4
    ),
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

  let chatAppDemo = el(
    "div",
    Tiara.appShell(
      Tiara.chatSidebar(
        header = Tiara.text("会話", tag = "h2", attrs = @[("class", "demo-chat-sidebar-title")]),
        body = joinHtml(@[
          Tiara.chatSessionItem("プロジェクト A", meta = "昨日", active = true),
          Tiara.chatSessionItem("サポート", meta = "先週"),
          Tiara.chatSessionItem("デモ用スレッド", meta = "2026-04-01"),
        ])
      ),
      el(
        "div",
        joinHtml(@[
          el(
            "div",
            joinHtml(@[
              Tiara.chatBubble("こんにちは。何かお手伝いできますか？", role = "assistant"),
              Tiara.chatBubble("API キーを設定したいです", role = "user"),
              Tiara.chatBubble("この画面はプレビューです", role = "system"),
            ]),
            @[("class", "demo-chat-transcript")]
          ),
          Tiara.chatComposer(
            "message",
            placeholder = "メッセージを入力…",
            submitLabel = "送信"
          ),
        ]),
        @[("class", "demo-chat-main")]
      )
    ),
    @[("class", "demo-app-shell-wrap")]
  )

  let setupUiDemo = joinHtml(@[
    Tiara.alertBanner(
      "初回のみ API を登録してください。",
      title = "セットアップ",
      tone = "info"
    ),
    Tiara.setupCard(
      "API キー",
      joinHtml(@[
        Tiara.input("api_key", label = "Secret", placeholder = "sk-…",
            attrs = @[("autocomplete", "off")]),
        Tiara.fieldValidation("このフィールドは必須です。", kind = "error"),
        Tiara.fieldValidation("スキップした場合は後から設定できます。", kind = "hint"),
      ]),
      step = "1/3",
      optional = true
    ),
    Tiara.alertBanner("ネットワークに接続できません。", tone = "warning"),
  ])

  let catalogMeta = el("div", joinHtml([
    Tiara.badge("17 component groups", tone = "accent", variant = "solid"),
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
    codeNavbar = @[
      "import crown/core",
      "import tiara/components",
      "",
      "proc page*(req: Request): string =",
      "  let navbar = $Tiara.navbar(",
      "    brand = \"👑 Tiara\",",
      "    links = @[",
      "      (\"Home\", \"/\"), (\"Docs\", \"/docs\"), (\"Components\", \"/components\")",
      "    ],",
      "    action = Tiara.button(\"GitHub\", color = \"secondary\", outlined = true)",
      "  )",
      "  return html\"\"\"",
      "    <header class=\"site-header\">{navbar}</header>",
      "  \"\"\""
    ].join("\n")
    codeHero = @[
      "import crown/core",
      "import tiara/components",
      "",
      "proc page*(req: Request): string =",
      "  let hero = $Tiara.hero(",
      "    title = \"Ship search-ready Nim websites.\",",
      "    description = \"Landing pages and docs hubs from Tiara primitives.\",",
      "    kicker = \"Marketing UI\",",
      "    badges = @[\"SSR-first\", \"Docs Search\"],",
      "    actions = @[",
      "      Tiara.button(\"Open Docs\"),",
      "      Tiara.button(\"Try Search\", color = \"secondary\", outlined = true)",
      "    ],",
      "    visual = Tiara.codeBlock(\"nimble install tiara\", language = \"sh\",",
      "      title = \"terminal\", chrome = \"terminal\")",
      "  )",
      "  return html\"\"\"",
      "    <section class=\"hero-wrap\">{hero}</section>",
      "  \"\"\""
    ].join("\n")
    codeButtons = @[
      "import crown/core",
      "import tiara/components",
      "",
      "proc page*(req: Request): string =",
      "  let buttons = $joinHtml(@[",
      "    Tiara.button(\"Primary\"),",
      "    Tiara.button(\"Secondary\", color = \"secondary\"),",
      "    Tiara.button(\"Danger\", color = \"danger\"),",
      "    Tiara.button(\"Ghost\", color = \"ghost\"),",
      "    Tiara.button(\"Outline\", outlined = true),",
      "    Tiara.button(\"Small\", size = \"small\"),",
      "    Tiara.button(\"Large\", size = \"large\")",
      "  ])",
      "  return html\"\"\"",
      "    <div class=\"showcase-row\">{buttons}</div>",
      "  \"\"\""
    ].join("\n")
    codeBadges = @[
      "import crown/core",
      "import tiara/components",
      "",
      "proc page*(req: Request): string =",
      "  let badges = $joinHtml(@[",
      "    Tiara.badge(\"Accent\", tone = \"accent\"),",
      "    Tiara.badge(\"Success\", tone = \"success\", variant = \"solid\"),",
      "    Tiara.badge(\"Outline\", tone = \"warning\", variant = \"outline\")",
      "  ])",
      "  return html\"\"\"",
      "    <div class=\"badge-row\">{badges}</div>",
      "  \"\"\""
    ].join("\n")
    codeSectionHeaders = @[
      "import crown/core",
      "import tiara/components",
      "",
      "proc page*(req: Request): string =",
      "  let head = $Tiara.sectionHeader(",
      "    title = \"Documentation sections\",",
      "    description = \"Kick titles and actions across guides.\",",
      "    kicker = \"Section Header\",",
      "    actions = Tiara.button(\"Explore\", size = \"small\")",
      "  )",
      "  return html\"\"\"",
      "    <div class=\"section-head\">{head}</div>",
      "  \"\"\""
    ].join("\n")
    codeSearch = @[
      "import crown/core",
      "import tiara/components",
      "",
      "proc page*(req: Request): string =",
      "  let search = $joinHtml(@[",
      "    Tiara.searchBox(",
      "      name = \"docs-search\",",
      "      label = \"Documentation Search\",",
      "      placeholder = \"Search installation, toast...\"",
      "    ),",
      "    Tiara.searchBox(",
      "      name = \"q\",",
      "      placeholder = \"Search components...\",",
      "      variant = \"outline\",",
      "      size = \"large\"",
      "    )",
      "  ])",
      "  return html\"\"\"",
      "    <div class=\"search-stack\">{search}</div>",
      "  \"\"\""
    ].join("\n")
    codeForms = @[
      "import crown/core",
      "import tiara/components",
      "",
      "proc page*(req: Request): string =",
      "  let form = $joinHtml(@[",
      "    Tiara.input(name = \"username\", label = \"Username\",",
      "      placeholder = \"tiara-user\"),",
      "    Tiara.textarea(name = \"bio\", label = \"Bio\", rows = 4),",
      "    Tiara.datePicker(name = \"birthdate\", label = \"Birthdate\",",
      "      minDate = \"1900-01-01\", maxDate = \"today\"),",
      "    Tiara.colorPicker(name = \"theme\", label = \"Theme Color\",",
      "      default = \"#2563eb\")",
      "  ])",
      "  return html\"\"\"",
      "    <form class=\"stack\">{form}</form>",
      "  \"\"\""
    ].join("\n")
    codeChatApp = @[
      "import crown/core",
      "import tiara/components",
      "",
      "proc page*(req: Request): string =",
      "  let layout = $Tiara.appShell(",
      "    Tiara.chatSidebar(",
      "      body = Tiara.chatSessionItem(\"Thread\", meta = \"Today\", active = true)",
      "    ),",
      "    joinHtml(@[",
      "      Tiara.chatBubble(\"Hello\", role = \"assistant\"),",
      "      Tiara.chatComposer(\"message\", placeholder = \"Type…\")",
      "    ])",
      "  )",
      "  return html\"\"\"<div class=\"app\">{layout}</div>\"\"\""
    ].join("\n")
    codeSetupUi = @[
      "import crown/core",
      "import tiara/components",
      "",
      "proc page*(req: Request): string =",
      "  let panel = $joinHtml(@[",
      "    Tiara.alertBanner(\"Read this first.\", title = \"Setup\", tone = \"info\"),",
      "    Tiara.setupCard(\"API key\", Tiara.input(\"k\", label = \"Key\"),",
      "      step = \"1/3\", optional = true),",
      "    Tiara.fieldValidation(\"Invalid format\", kind = \"error\")",
      "  ])",
      "  return html\"\"\"<div class=\"stack\">{panel}</div>\"\"\""
    ].join("\n")
    codeModal = @[
      "import crown/core",
      "import tiara/components",
      "",
      "proc page*(req: Request): string =",
      "  let modal = $Tiara.modal(",
      "    id = \"my-modal\",",
      "    trigger = Tiara.button(\"Open Modal\", color = \"secondary\"),",
      "    content = Tiara.text(\"Modal body\"),",
      "    title = \"Tiara Modal\"",
      "  )",
      "  return html\"\"\"",
      "    <div class=\"modal-slot\">{modal}</div>",
      "  \"\"\""
    ].join("\n")
    codeCodeBlock = @[
      "import crown/core",
      "import tiara/components",
      "",
      "proc page*(req: Request): string =",
      "  let sample = $Tiara.codeBlock(",
      "    \"proc hello(name: string): string =\\n\" &",
      "    \"  let answer = 42\\n\" &",
      "    \"  result = \\\"Hi, \\\" & name\",",
      "    language = \"nim\",",
      "    title = \"sample.nim\"",
      "  )",
      "  return html\"\"\"",
      "    <div class=\"code-block-slot\">{sample}</div>",
      "  \"\"\""
    ].join("\n")
    codeCardVariants = @[
      "import crown/core",
      "import tiara/components",
      "",
      "proc page*(req: Request): string =",
      "  let cards = $joinHtml(@[",
      "    Tiara.card(\"Elevated\", Tiara.text(\"Featured content.\"),",
      "      variant = \"elevated\"),",
      "    Tiara.card(\"Outline\", Tiara.text(\"Secondary block.\"),",
      "      variant = \"outline\"),",
      "    Tiara.card(\"Subtle\", Tiara.text(\"Dense lists.\"),",
      "      variant = \"subtle\")",
      "  ])",
      "  return html\"\"\"",
      "    <div class=\"showcase-grid\">{cards}</div>",
      "  \"\"\""
    ].join("\n")
    codeIcons = @[
      "import crown/core",
      "import tiara/components",
      "",
      "proc page*(req: Request): string =",
      "  let icons = $joinHtml(@[",
      "    Tiara.iconWithBadge(Tiara.text(\"✉\", tag = \"span\"),",
      "      badge = \"12\", label = \"Inbox\"),",
      "    Tiara.notificationIcon(badge = \"5\"),",
      "    Tiara.profileIcon(name = \"Jane Doe\", status = \"online\",",
      "      size = \"medium\")",
      "  ])",
      "  return html\"\"\"",
      "    <div class=\"showcase-icons\">{icons}</div>",
      "  \"\"\""
    ].join("\n")
    codeCarousel = @[
      "import crown/core",
      "import tiara/components",
      "",
      "proc page*(req: Request): string =",
      "  let carousel = $Tiara.carousel(",
      "    id = \"feature-carousel\",",
      "    items = @[",
      "      Tiara.card(\"Fast SSR\", Tiara.text(\"Optimized HTML.\")),",
      "      Tiara.card(\"Pure Nim\", Tiara.text(\"No JS framework.\"))",
      "    ]",
      "  )",
      "  return html\"\"\"",
      "    <div class=\"carousel-wrap\">{carousel}</div>",
      "  \"\"\""
    ].join("\n")
    codeTabs = @[
      "import crown/core",
      "import tiara/components",
      "",
      "proc page*(req: Request): string =",
      "  let tabs = $Tiara.tabs(",
      "    id = \"my-tabs\",",
      "    items = @[",
      "      (\"Overview\", Tiara.text(\"First panel\")),",
      "      (\"Code\", Tiara.codeBlock(\"let x = 1\", language = \"nim\"))",
      "    ]",
      "  )",
      "  return html\"\"\"",
      "    <div class=\"tabs-wrap\">{tabs}</div>",
      "  \"\"\""
    ].join("\n")
    codeDropdown = @[
      "import crown/core",
      "import tiara/components",
      "",
      "proc page*(req: Request): string =",
      "  let menu = $Tiara.dropdown(",
      "    id = \"account-menu\",",
      "    label = \"Account\",",
      "    align = \"right\",",
      "    items = @[",
      "      Tiara.text(\"Profile\", tag = \"span\"),",
      "      Tiara.text(\"Sign out\", tag = \"span\")",
      "    ]",
      "  )",
      "  return html\"\"\"",
      "    <div class=\"dropdown-slot\">{menu}</div>",
      "  \"\"\""
    ].join("\n")
    codeToasts = @[
      "import crown/core",
      "import tiara/components",
      "",
      "# Toasts live in #tiara-toast-storage; trigger from the page:",
      "proc page*(req: Request): string =",
      "  let toastTrigger = $Tiara.button(",
      "    \"Notify\",",
      "    attrs = @[(\"data-tiara-toast-trigger\", \"toast-1\")]",
      "  )",
      "  return html\"\"\"",
      "    <div class=\"toast-triggers\">{toastTrigger}</div>",
      "  \"\"\""
    ].join("\n")

  let content = joinHtml([
    Tiara.text("Tiara Component Catalog", tag = "h1", attrs = @[("class",
        "page-title")]),
    Tiara.text(
        "Explore the same components shipped in the current repository, with live previews (forms, app shell, chat, setup banners). " &
        "Code tabs follow Crown: import crown/core, render Tiara to string with $, then interpolate in html\"\"\" … {name} … \"\"\". If you also import tiara/core, use except html and tiaraHtml\"\"\" to avoid clashing with Crown's html macro (see docs/crown-integration.md). Basolato tmpli + Component + $(…) is optional.",
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
    demoSection("App shell & Chat", catalogDemoWithTabs(
      chatAppDemo,
      codeChatApp,
      "catalog-tabs-chat-app")),
    demoSection("Setup & validation", catalogDemoWithTabs(
      el("div", setupUiDemo, @[("class", "stack"), ("style", "max-width: 40rem;")]),
      codeSetupUi,
      "catalog-tabs-setup-ui")),
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
.demo-app-shell-wrap { border-radius: var(--tiara-radius-lg); max-width: 100%; overflow: hidden; }
.demo-app-shell-wrap .app-shell { border: 1px solid var(--tiara-border); min-height: 22rem; }
.demo-chat-sidebar-title { font-size: 1rem; font-weight: 700; margin: 0; }
.demo-chat-main { display: flex; flex: 1; flex-direction: column; gap: 0.5rem; min-height: 0; padding: 0.75rem 1rem; }
.demo-chat-transcript { display: flex; flex: 1; flex-direction: column; gap: 0.35rem; min-height: 10rem; overflow-y: auto; }
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
