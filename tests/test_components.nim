import std/[strutils, times, unittest]
import tiara/components

suite "Tiara components":
  test "button generates expected classes":
    let html = $Tiara.button("送信する", color = "primary", size = "large", outlined = true)
    check html == "<button class=\"btn btn-primary btn-large btn-outline\">送信する</button>"

  test "card wraps title and content":
    let html = $Tiara.card(
      title = "ユーザー情報",
      content = Tiara.text("ここにユーザーの詳細が表示されます。")
    )
    check html.contains("<section class=\"card\">")
    check html.contains("<h3 class=\"card-title\">ユーザー情報</h3>")
    check html.contains("<div class=\"card-content\"><p>ここにユーザーの詳細が表示されます。</p></div>")

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
    check html.contains("<dialog id=\"confirm-modal\" class=\"modal modal-medium\" data-tiara=\"modal\"")
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

  test "notification icon renders badge":
    let html = $Tiara.notificationIcon(badge = "7")
    check html.contains("data-tiara=\"notification-icon\"")
    check html.contains("class=\"icon-badge notification-icon\"")
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

  test "profile icon supports initials and status":
    let html = $Tiara.profileIcon(name = "Jane Doe", status = "online", size = "large")
    check html.contains("data-tiara=\"profile-icon\"")
    check html.contains("class=\"profile-icon profile-icon-large\"")
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
    check css.contains(".dropdown-menu-center { left: 50%; --tiara-dropdown-x: -50%; }")
