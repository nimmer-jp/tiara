import std/[strutils, times, unittest]
import tiara/components

suite "Tiara components":
  test "badge supports tone and variant classes":
    let html = $Tiara.badge("Beta", tone = "accent", variant = "solid", size = "small")
    check html.contains("class=\"badge badge-accent badge-solid badge-small\"")
    check html.contains(">Beta<")

  test "navbar renders brand links and action slot":
    let html = $Tiara.navbar(
      brand = "Tiara",
      links = @[
        ("Docs", "/docs"),
        ("Search", "/search")
      ],
      action = Tiara.badge("New", tone = "accent"),
      variant = "solid"
    )
    check html.contains("data-tiara=\"navbar\"")
    check html.contains("class=\"navbar navbar-solid navbar-medium\"")
    check html.contains("<a href=\"/docs\" class=\"nav-link\">Docs</a>")
    check html.contains("data-tiara=\"badge\"")

  test "hero renders title html and badges":
    let html = $Tiara.hero(
      title = "",
      titleHtml = rawHtml("Fast <span>Nim</span> docs"),
      description = "Search and install content.",
      kicker = "Website",
      badges = @["SSR-first", "Docs Search"],
      actions = @[Tiara.button("Read Docs")],
      visual = Tiara.codeBlock("nimble install tiara", chrome = "terminal"),
      layout = "stacked",
      align = "center"
    )
    check html.contains("data-tiara=\"hero\"")
    check html.contains("class=\"hero hero-stacked hero-align-center\"")
    check html.contains("<h1 class=\"hero-title\">Fast <span>Nim</span> docs</h1>")
    check html.contains("hero-badges")
    check html.contains("code-block-terminal")

  test "section header supports alignment and actions":
    let html = $Tiara.sectionHeader(
      title = "Components",
      description = "Reusable blocks",
      kicker = "Docs",
      align = "center",
      actions = Tiara.button("Explore", size = "small")
    )
    check html.contains("data-tiara=\"section-header\"")
    check html.contains("class=\"section-header section-header-center section-header-medium\"")
    check html.contains("section-header-actions")

  test "search box renders icon and search input":
    let html = $Tiara.searchBox(
      name = "docs",
      label = "Search docs",
      placeholder = "Search installation...",
      variant = "outline",
      size = "large"
    )
    check html.contains("data-tiara=\"search-box\"")
    check html.contains("class=\"search-box search-box-outline search-box-large\"")
    check html.contains("type=\"search\"")
    check html.contains("search-box-icon")

  test "button generates expected classes":
    let html = $Tiara.button("送信する", color = "primary", size = "large", outlined = true)
    check html == "<button class=\"btn btn-primary btn-large btn-outline\">送信する</button>"

  test "button supports danger and ghost roles":
    check ($Tiara.button("Delete", color = "danger")).contains("btn-danger")
    check ($Tiara.button("More", color = "ghost")).contains("btn-ghost")

  test "card wraps title and content":
    let html = $Tiara.card(
      title = "ユーザー情報",
      content = Tiara.text("ここにユーザーの詳細が表示されます。")
    )
    check html.contains("<section class=\"card\">")
    check html.contains("<h3 class=\"card-title\">ユーザー情報</h3>")
    check html.contains("<div class=\"card-content\"><p>ここにユーザーの詳細が表示されます。</p></div>")

  test "card supports marketing variants":
    let html = $Tiara.card(
      title = "Glass",
      content = Tiara.text("marketing"),
      variant = "glass"
    )
    check html.contains("class=\"card card-glass\"")

  test "card supports subtle and flat surfaces":
    check ($Tiara.card("S", Tiara.text("x"), variant = "subtle")).contains("card-subtle")
    check ($Tiara.card("F", Tiara.text("x"), variant = "flat")).contains("card-flat")

  test "date picker resolves today token":
    let html = $Tiara.datePicker(
      name = "birthdate",
      label = "生年月日",
      minDate = "1900-01-01",
      maxDate = "today"
    )
    check html.contains("type=\"date\"")
    check html.contains("min=\"1900-01-01\"")
    check html.contains("max=\"" & now().format("yyyy-MM-dd") & "\"")

  test "color picker includes preview hook":
    let html = $Tiara.colorPicker(
      name = "theme",
      label = "ブランドカラー",
      default = "#FF5733"
    )
    check html.contains("type=\"color\"")
    check html.contains("data-tiara-color-preview")
    check html.contains("background-color: #FF5733")

  test "modal includes open and close hooks":
    let html = $Tiara.modal(
      id = "confirm-modal",
      trigger = Tiara.button("削除"),
      content = Tiara.text("本当に削除しますか？")
    )
    check html.contains("data-tiara-modal-open=\"confirm-modal\"")
    check html.contains("<dialog id=\"confirm-modal\" class=\"modal modal-medium\" aria-modal=\"true\" role=\"dialog\" data-tiara=\"modal\"")
    check html.contains("data-tiara-motion-ms=\"220\"")
    check html.contains("data-tiara-modal-close=\"confirm-modal\"")

  test "code block highlights tokens":
    let html = $Tiara.codeBlock(
      code = "let answer = 42 # comment",
      language = "nim",
      title = "example.nim"
    )
    check html.contains("data-tiara=\"code-block\"")
    check html.contains("<span class=\"code-token code-keyword\">let</span>")
    check html.contains("<span class=\"code-token code-number\">42</span>")
    check html.contains("<span class=\"code-token code-comment\"># comment</span>")

  test "code block terminal chrome renders traffic lights":
    let html = $Tiara.codeBlock(
      code = "nimble install tiara",
      language = "sh",
      title = "terminal",
      chrome = "terminal"
    )
    check html.contains("class=\"code-block code-block-terminal\"")
    check html.contains("code-block-traffic")
    check html.contains("code-block-dot-red")

  test "badge supports error and info tones":
    check ($Tiara.badge("E", tone = "error")).contains("badge-error")
    check ($Tiara.badge("I", tone = "info", variant = "solid")).contains("badge-info")

  test "notification icon renders badge":
    let html = $Tiara.notificationIcon(badge = "7")
    check html.contains("data-tiara=\"notification-icon\"")
    check html.contains("notification-icon-default")
    check html.contains("icon-badge")
    check html.contains("<span class=\"icon-badge-count\">7</span>")

  test "carousel renders controls and slides":
    let html = $Tiara.carousel(
      id = "hero-carousel",
      items = @[
        Tiara.card("Slide 1", Tiara.text("alpha")),
        Tiara.card("Slide 2", Tiara.text("beta"))
      ]
    )
    check html.contains("id=\"hero-carousel\"")
    check html.contains("data-tiara=\"carousel\"")
    check html.contains("data-tiara-carousel-action=\"prev\"")
    check html.contains("data-tiara-carousel-action=\"next\"")
    check html.contains("data-tiara-carousel-indicator=\"1\"")

  test "notification icon supports style variants":
    check ($Tiara.notificationIcon(badge = "1", variant = "solid")).contains("notification-icon-solid")
    check ($Tiara.notificationIcon(badge = "", variant = "ghost")).contains("notification-icon-ghost")

  test "profile icon supports style variants":
    check ($Tiara.profileIcon(name = "X", variant = "brand")).contains("profile-icon-brand")

  test "profile icon supports initials and status":
    let html = $Tiara.profileIcon(name = "Jane Doe", status = "online", size = "large")
    check html.contains("data-tiara=\"profile-icon\"")
    check html.contains("profile-icon-large")
    check html.contains("profile-icon-neutral")
    check html.contains(">JD<")
    check html.contains("profile-icon-status-online")

  test "tabs renders active tab and panel markers":
    let html = $Tiara.tabs(
      id = "settings-tabs",
      items = @[
        ("General", Tiara.text("general panel")),
        ("Security", Tiara.text("security panel"))
      ],
      activeIndex = 1
    )
    check html.contains("data-tiara=\"tabs\"")
    check html.contains("data-tiara-tabs-target=\"settings-tabs\"")
    check html.contains("data-tiara-tabs-index=\"1\"")
    check html.contains("class=\"tabs-trigger is-active\"")
    check html.contains("id=\"settings-tabs-panel-1\"")

  test "dropdown renders toggle and menu":
    let html = $Tiara.dropdown(
      id = "user-menu",
      label = "Account",
      items = @[
        Tiara.text("Profile", tag = "span"),
        Tiara.text("Sign out", tag = "span")
      ],
      align = "right"
    )
    check html.contains("data-tiara=\"dropdown\"")
    check html.contains("data-tiara-dropdown-toggle=\"user-menu\"")
    check html.contains("class=\"dropdown-menu dropdown-menu-right\"")
    check html.contains("data-tiara-dropdown-item=\"1\"")

  test "toast includes tone and close behavior hooks":
    let html = $Tiara.toast(
      message = "Saved successfully",
      title = "Done",
      tone = "success",
      dismissible = true,
      autoHideMs = 3000
    )
    check html.contains("data-tiara=\"toast\"")
    check html.contains("class=\"toast toast-success\"")
    check html.contains("data-tiara-toast-close")
    check html.contains("data-tiara-toast-autohide=\"3000\"")

  test "attrs merge allows class and style customization":
    let html = $Tiara.button(
      "Custom",
      attrs = @[
        ("class", "is-pill"),
        ("style", "letter-spacing: 0.08em")
      ]
    )
    check html.contains("class=\"btn btn-primary btn-medium is-pill\"")
    check html.contains("style=\"letter-spacing: 0.08em\"")

  test "modal supports size and motion customization":
    let html = $Tiara.modal(
      id = "motion-modal",
      trigger = Tiara.button("Open"),
      content = Tiara.text("content"),
      size = "large",
      motionMs = 320,
      attrs = @[
        ("class", "custom-modal"),
        ("style", "border: 2px solid #111")
      ]
    )
    check html.contains("class=\"modal modal-large custom-modal\"")
    check html.contains("data-tiara-motion-ms=\"320\"")
    check html.contains("style=\"border: 2px solid #111\"")

  test "dropdown supports size and motion customization":
    let html = $Tiara.dropdown(
      id = "motion-dropdown",
      items = @[
        Tiara.text("A", tag = "span")
      ],
      size = "small",
      motionMs = 260,
      attrs = @[
        ("class", "custom-dropdown"),
        ("style", "z-index: 30")
      ]
    )
    check html.contains("class=\"dropdown dropdown-small custom-dropdown\"")
    check html.contains("data-tiara-motion-ms=\"260\"")
    check html.contains("style=\"z-index: 30\"")

  test "default styles keep center dropdown alignment with motion":
    let css = $Tiara.defaultStyles()
    check css.contains(".dropdown-menu { --tiara-dropdown-x: 0;")
    check css.contains(".dropdown-menu-center { left: 50%; right: auto; --tiara-dropdown-x: -50%; transform-origin: top center; }")
    check css.contains(".navbar-glass {")
    check css.contains(".hero-split { grid-template-columns:")

  test "input merges attrs without duplicate id":
    let html = $Tiara.input(
      "email",
      attrs = @[("id", "login-email"), ("class", "is-wide")]
    )
    check html.count("id=\"") == 1
    check html.contains("id=\"login-email\"")
    check html.contains("class=\"input is-wide\"")

  test "textarea renders rows and data marker":
    let html = $Tiara.textarea(
      "body",
      label = "本文",
      placeholder = "入力",
      rows = 6,
      required = true
    )
    check html.contains("data-tiara=\"textarea\"")
    check html.contains("rows=\"6\"")
    check html.contains("<textarea")
    check html.contains("required")
    check html.contains("for=\"tiara-body\"")

  test "textarea attrs override id once":
    let html = $Tiara.textarea("x", attrs = @[("id", "custom-id")])
    check html.count("id=\"") == 1
    check html.contains("id=\"custom-id\"")

  test "chat composer nests textarea and submit":
    let html = $Tiara.chatComposer("msg", placeholder = "メッセージ", submitLabel = "送る")
    check html.contains("data-tiara=\"chat-composer\"")
    check html.contains("data-tiara=\"textarea\"")
    check html.contains("type=\"submit\"")
    check html.contains("送る")

  test "chat bubble marks role":
    let html = $Tiara.chatBubble("Hi", role = "user")
    check html.contains("data-tiara=\"chat-bubble\"")
    check html.contains("chat-bubble-user")

  test "app shell wraps sidebar and main":
    let html = $Tiara.appShell(
      Tiara.text("nav"),
      Tiara.text("content")
    )
    check html.contains("data-tiara=\"app-shell\"")
    check html.contains("app-shell-sidebar")
    check html.contains("app-shell-main")

  test "alert banner uses tone class":
    let html = $Tiara.alertBanner("詳細", title = "注意", tone = "warning")
    check html.contains("data-tiara=\"alert-banner\"")
    check html.contains("alert-banner-warning")

  test "setup card shows optional badge":
    let html = $Tiara.setupCard(
      "APIキー",
      Tiara.text("説明"),
      step = "1/3",
      optional = true
    )
    check html.contains("data-tiara=\"setup-card\"")
    check html.contains("スキップ可")

  test "field validation maps kinds":
    check ($Tiara.fieldValidation("必須です", kind = "error")).contains("field-validation-error")
    check ($Tiara.fieldValidation("ヒント", kind = "hint")).contains("field-validation-hint")

  test "default styles include app shell and textarea":
    let css = $Tiara.defaultStyles()
    check css.contains(".app-shell {")
    check css.contains(".textarea:focus")
    check css.contains(".chat-composer")
