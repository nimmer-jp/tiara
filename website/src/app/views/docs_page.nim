import std/strformat
import tiara/components
import ./site_shell

proc demoCardHtml(title, description, searchTokens: string; preview,
    codeSample: Html): string =
  let card = el(
    "article",
    joinHtml([
      el(
        "div",
        joinHtml([
          el("p", textNode("Component demo"), @[("class", "component-demo-kicker")]),
          el("h3", textNode(title), @[("class", "component-demo-title")]),
          el("p", textNode(description), @[("class", "component-demo-description")]),
        ]),
        @[("class", "component-demo-copy")],
      ),
      el(
        "div",
        joinHtml([
          el("span", textNode("Live preview"), @[("class", "component-demo-label")]),
          preview,
        ]),
        @[("class", "component-demo-preview")],
      ),
      el("div", codeSample, @[("class", "component-demo-code")]),
    ]),
    @[
      ("class", "component-demo-card"),
      ("data-doc-item", ""),
      ("data-doc-search", searchTokens),
    ],
  )
  $card

proc fullHtml*: string =
  let topNav = $Tiara.navbar(
    brand = "👑 Tiara",
    links = @[
      ("Home", "/"),
      ("Catalog", "/components"),
      ("Search", "#search"),
      ("Install", "#install")
    ],
    action = el(
      "a",
      textNode("GitHub"),
      @[
        ("href", "https://github.com/nimmer-jp/tiara"),
        ("target", "_blank"),
        ("rel", "noopener noreferrer"),
        ("class", "btn btn-secondary btn-medium btn-outline")
      ]
    )
  )

  let docsSearchHead = $Tiara.sectionHeader(
    title = "Find a guide or component fast",
    kicker = "Search",
    actions = el(
      "p",
      textNode("9 sections"),
      @[("class", "docs-search-meta"), ("data-doc-count", "")]
    ),
    attrs = @[("class", "docs-search-head")],
  )

  let docsSearchInput = $Tiara.searchBox(
    name = "docs-search",
    placeholder = "Search installation, toast, customization...",
    attrs = @[("class", "docs-search-box")],
    inputAttrs = @[("data-doc-search-input", "")],
  )

  let componentsHead = $Tiara.sectionHeader(
    title = "Live component demos",
    description = "抜粋デモです。完全版は /components の Tiara Lab を参照してください。",
    kicker = "Components",
    actions = el(
      "a",
      textNode("Open full catalog"),
      @[("href", "/components"), ("class", "btn btn-secondary btn-medium docs-component-link")]
    ),
    attrs = @[("class", "docs-component-head")],
  )

  let buttonDemo = demoCardHtml(
    title = "Buttons and status badges",
    description = "CTA とバッジの組み合わせ例です。",
    searchTokens = "button badge primary secondary outline cta",
    preview = joinHtml([
      el(
        "div",
        joinHtml([
          Tiara.button("Create project", attrs = @[("type", "button")]),
          Tiara.button("Preview docs", color = "secondary", attrs = @[("type", "button")]),
          Tiara.button("CLI install", outlined = true, attrs = @[("type", "button")]),
        ]),
        @[("class", "demo-button-row")],
      ),
      el(
        "div",
        joinHtml([
          Tiara.badge("Stable", tone = "success"),
          Tiara.badge("Pure Nim", tone = "accent", variant = "solid"),
        ]),
        @[("class", "demo-badge-row")],
      ),
    ]),
    codeSample = Tiara.codeBlock(
      """import tiara/components

let toolbar = joinHtml(@[
  Tiara.button("Create"),
  Tiara.badge("Stable", tone = "success")
])""",
      language = "nim",
      title = "buttons.nim",
    ),
  )

  let cardDemo = demoCardHtml(
    title = "Cards for summaries",
    description = "ガラスカードバリアントの例です。",
    searchTokens = "card glass summary marketing",
    preview = Tiara.card(
      title = "Release summary",
      content = el(
        "p",
        textNode("Docs とパッケージ出力を揃えて運用できます。"),
        @[("class", "demo-card-copy")],
      ),
      footer = Tiara.button("Read guide", color = "secondary", attrs = @[("type", "button")]),
      variant = "glass",
    ),
    codeSample = Tiara.codeBlock(
      "let card = Tiara.card(\"Hi\", Tiara.text(\"…\"), variant = \"glass\")",
      language = "nim",
      title = "card.nim",
    ),
  )

  let toastDemo = demoCardHtml(
    title = "Toast (static preview)",
    description = "インタラクティブ版はカタログの Toasts を参照してください。",
    searchTokens = "toast notification success feedback",
    preview = el(
      "div",
      Tiara.toast(
        message = "Static preview for the docs page.",
        title = "Deployment ready",
        tone = "success",
        dismissible = false,
        attrs = @[("class", "is-open")],
      ),
      @[("class", "demo-toast-stage")],
    ),
    codeSample = Tiara.codeBlock(
      "let t = Tiara.toast(\"msg\", \"title\", \"success\")",
      language = "nim",
      title = "toast.nim",
    ),
  )

  let mainInner = fmt"""
    <div class="blob-bg"></div>
    <div class="blob-bg blob-bg-2"></div>
    {topNav}
    <main class="docs-page">
      <section class="docs-hero">
        <div class="docs-hero-copy">
          <p class="section-kicker">Documentation</p>
          <h1 class="docs-title">Tiara docs（Crown + Tiara）</h1>
          <p class="docs-description">
            導線・検索・コンポーネント抜粋を 1 ページにまとめています。ルーティングは Crown、マークアップは Tiara のみです。
          </p>
        </div>
        <div class="docs-hero-panel">
          <p class="panel-label">Install with Nimble</p>
          <pre><code>nimble install tiara</code></pre>
        </div>
      </section>
      <section id="search" class="docs-search-shell">
        {docsSearchHead}
        {docsSearchInput}
        <div class="docs-grid">
          <article class="doc-card" data-doc-item data-doc-search="getting started install nimble crown setup">
            <p class="doc-card-tag">Getting Started</p>
            <h3>Install and render</h3>
            <p><code>nimble install tiara</code> の後、<code>import tiara/components</code> から利用します。</p>
          </article>
          <article class="doc-card" data-doc-item data-doc-search="crown routing framework website">
            <p class="doc-card-tag">Crown</p>
            <h3>このサイトの構成</h3>
            <p><code>website/</code> で <code>crown dev</code>。ページは <code>src/app/**/page.nim</code> に配置します。</p>
          </article>
          <article class="doc-card" data-doc-item data-doc-search="toast notification component">
            <p class="doc-card-tag">Components</p>
            <h3>Toast example</h3>
            <p>通知 UI の静的プレビューとカタログのトラベルがあります。</p>
          </article>
          <article class="doc-card" data-doc-item data-doc-search="customization defaultStyles css">
            <p class="doc-card-tag">Customization</p>
            <h3>defaultStyles.nim</h3>
            <p>CSS 変数とクラスを段階的に差し替えてブランドに寄せられます。</p>
          </article>
        </div>
        <p class="docs-empty-state" data-doc-empty hidden>No matching documentation sections.</p>
      </section>
      <section id="components" class="docs-components-section">
        {componentsHead}
        <div class="component-demo-grid">
          {buttonDemo}
          {cardDemo}
          {toastDemo}
        </div>
      </section>
      <section id="install" class="docs-install">
        <div class="install-copy">
          <p class="section-kicker">Install</p>
          <h2 class="section-title section-title-left">Nimble</h2>
          <p class="docs-description">ドキュメントと同じコマンドでライブラリを取得します。</p>
        </div>
        <div class="install-code-card">
          <div class="terminal-header"><span></span><span></span><span></span></div>
          <pre><code>nimble install tiara</code></pre>
        </div>
      </section>
    </main>
  """

  siteShell("Tiara Docs | Crown + Tiara", mainInner)
