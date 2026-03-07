import basolato/view
import tiara/components as tc
import ../html_component
import ../layouts/application_view


proc demoCard(
  title: string,
  description: string,
  searchTokens: string,
  preview: tc.Html,
  codeSample: tc.Html
): Component =
  htmlComponent($tc.el(
    "article",
    tc.joinHtml([
      tc.el(
        "div",
        tc.joinHtml([
          tc.el("p", tc.textNode("Component demo"), @[("class", "component-demo-kicker")]),
          tc.el("h3", tc.textNode(title), @[("class", "component-demo-title")]),
          tc.el("p", tc.textNode(description), @[("class", "component-demo-description")])
        ]),
        @[("class", "component-demo-copy")]
      ),
      tc.el(
        "div",
        tc.joinHtml([
          tc.el("span", tc.textNode("Live preview"), @[("class", "component-demo-label")]),
          preview
        ]),
        @[("class", "component-demo-preview")]
      ),
      tc.el("div", codeSample, @[("class", "component-demo-code")])
    ]),
    @[
      ("class", "component-demo-card"),
      ("data-doc-item", ""),
      ("data-doc-search", searchTokens)
    ]
  ))


proc impl(): Component =
  let topNav = htmlComponent($tc.Tiara.navbar(
    brand = "👑 Tiara",
    links = @[
      ("Home", "/"),
      ("Catalog", "/components"),
      ("Search", "#search"),
      ("Install", "#install")
    ],
    action = tc.el(
      "a",
      tc.textNode("GitHub"),
      @[
        ("href", "https://github.com/nimmer-jp/tiara"),
        ("target", "_blank"),
        ("class", "btn-outline")
      ]
    )
  ))

  let docsSearchHead = htmlComponent($tc.Tiara.sectionHeader(
    title = "Find a guide or component fast",
    kicker = "Search",
    actions = tc.el(
      "p",
      tc.textNode("9 sections"),
      @[("class", "docs-search-meta"), ("data-doc-count", "")]
    ),
    attrs = @[("class", "docs-search-head")]
  ))

  let docsSearchInput = htmlComponent($tc.Tiara.searchBox(
    name = "docs-search",
    placeholder = "Search installation, toast, customization...",
    attrs = @[("class", "docs-search-box")],
    inputAttrs = @[("data-doc-search-input", "")]
  ))

  let componentsHead = htmlComponent($tc.Tiara.sectionHeader(
    title = "Live component demos",
    description = "ここでは主要な demo を抜粋表示しています。完全な一覧と interactive showcase は /components にまとめています。",
    kicker = "Components",
    actions = tc.el(
      "a",
      tc.textNode("Open full catalog"),
      @[("href", "/components"), ("class", "btn-secondary docs-component-link")]
    ),
    attrs = @[("class", "docs-component-head")]
  ))

  let buttonDemo = demoCard(
    title = "Buttons and status badges",
    description = "CTA と補助アクション、状態バッジの組み合わせをそのまま確認できます。",
    searchTokens = "button buttons badge badges primary secondary outline cta status component demo",
    preview = tc.joinHtml([
      tc.el(
        "div",
        tc.joinHtml([
          tc.Tiara.button("Create project", attrs = @[("type", "button")]),
          tc.Tiara.button("Preview docs", color = "secondary", attrs = @[("type", "button")]),
          tc.Tiara.button("CLI install", outlined = true, attrs = @[("type", "button")])
        ]),
        @[("class", "demo-button-row")]
      ),
      tc.el(
        "div",
        tc.joinHtml([
          tc.Tiara.badge("Stable", tone = "success"),
          tc.Tiara.badge("Pure Nim", tone = "accent", variant = "solid"),
          tc.Tiara.badge("CLI ready", tone = "warning", variant = "outline")
        ]),
        @[("class", "demo-badge-row")]
      )
    ]),
    codeSample = tc.Tiara.codeBlock(
      """import tiara/components

let toolbar = tc.joinHtml([
  Tiara.button("Create project", attrs = @[("type", "button")]),
  Tiara.button("Preview docs", color = "secondary", attrs = @[("type", "button")]),
  Tiara.badge("Stable", tone = "success")
])""",
      language = "nim",
      title = "buttons_and_badges.nim"
    )
  )

  let cardDemo = demoCard(
    title = "Cards for release summaries",
    description = "情報量が多い説明でも、本文と footer を分けて読みやすく配置できます。",
    searchTokens = "card cards glass summary release footer content marketing docs component demo",
    preview = tc.Tiara.card(
      title = "Release summary",
      content = tc.joinHtml([
        tc.el(
          "p",
          tc.textNode("Website docs, searchable guides, and install snippets now ship from the same Tiara package."),
          @[("class", "demo-card-copy")]
        ),
        tc.el(
          "div",
          tc.joinHtml([
            tc.Tiara.badge("Docs synced", tone = "accent"),
            tc.Tiara.badge("SSR first", tone = "success")
          ]),
          @[("class", "demo-badge-row")]
        )
      ]),
      footer = tc.Tiara.button("Read getting started", color = "secondary", attrs = @[("type", "button")]),
      variant = "glass"
    ),
    codeSample = tc.Tiara.codeBlock(
      """import tiara/components

let summary = Tiara.card(
  title = "Release summary",
  content = tc.el("p", tc.textNode("Docs and package output stay aligned.")),
  footer = Tiara.button("Read getting started", attrs = @[("type", "button")]),
  variant = "glass"
)""",
      language = "nim",
      title = "card_demo.nim"
    )
  )

  let codeBlockDemo = demoCard(
    title = "Code blocks with terminal chrome",
    description = "インストール手順やサンプルコードを terminal 風の見た目で見せられます。",
    searchTokens = "code block terminal install command sample syntax highlight component demo",
    preview = tc.Tiara.codeBlock(
      """nimble install tiara
nimble test
nim c -r examples/preview.nim""",
      language = "text",
      title = "install.sh",
      chrome = "terminal"
    ),
    codeSample = tc.Tiara.codeBlock(
      """import tiara/components

let install = Tiara.codeBlock(
  "nimble install tiara",
  title = "install.sh",
  chrome = "terminal"
)""",
      language = "nim",
      title = "code_block.nim"
    )
  )

  let toastDemo = demoCard(
    title = "Toast notifications without heavy JS",
    description = "完了通知や警告を軽量に差し込めます。docs では静的プレビューとして開いた状態を表示しています。",
    searchTokens = "toast notification success warning feedback alert component demo",
    preview = tc.el(
      "div",
      tc.Tiara.toast(
        message = "Static preview for the docs page.",
        title = "Deployment ready",
        tone = "success",
        dismissible = false,
        attrs = @[("class", "is-open")]
      ),
      @[("class", "demo-toast-stage")]
    ),
    codeSample = tc.Tiara.codeBlock(
      """import tiara/components

let notice = Tiara.toast(
  title = "Deployment ready",
  message = "Static preview for the docs page.",
  tone = "success"
)""",
      language = "nim",
      title = "toast_demo.nim"
    )
  )

  tmpli html"""
    <div class="blob-bg"></div>
    <div class="blob-bg blob-bg-2"></div>

    $(topNav)

    <main class="docs-page">
      <section class="docs-hero">
        <div class="docs-hero-copy">
          <p class="section-kicker">Documentation</p>
          <h1 class="docs-title">Tiara docs with built-in search.</h1>
          <p class="docs-description">
            使い始めるための導線、コンポーネント探索、カスタマイズの入口を 1 ページにまとめています。
            下の検索ボックスから、インストール方法やコンポーネントのトピックをすぐに絞り込めます。
            さらにそのまま下へ進むと、主要コンポーネントの live demo も確認できます。
          </p>
        </div>

        <div class="docs-hero-panel">
          <p class="panel-label">Install with Nimble</p>
          <pre><code>nimble install tiara</code></pre>
          <p class="panel-note">
            <code>website</code>、<code>tests</code>、<code>docs</code>、<code>examples</code> は配布物から除外されるため、
            軽量に導入できます。
          </p>
        </div>
      </section>

      <section id="search" class="docs-search-shell">
        $(docsSearchHead)
        $(docsSearchInput)

        <div class="docs-grid">
          <article class="doc-card" data-doc-item data-doc-search="getting started install nimble setup package manager introduction first steps">
            <p class="doc-card-tag">Getting Started</p>
            <h3>Install and render your first component</h3>
            <p>最短で導入するなら、まず <code>nimble install tiara</code> を実行してから <code>tiara/components/toast</code> を読み込みます。</p>
            <pre><code>nimble install tiara</code></pre>
          </article>

          <article class="doc-card" data-doc-item data-doc-search="toast component feedback notification bottom-right renderToast example">
            <p class="doc-card-tag">Component Guide</p>
            <h3>Toast example</h3>
            <p>通知 UI の最小例です。SSR のレスポンスにそのまま差し込める構成になっています。</p>
            <pre><code>import tiara/components/toast

let myToast = renderToast(
  message = "Ready to deploy!",
  position = "bottom-right"
)</code></pre>
          </article>

          <article class="doc-card" data-doc-item data-doc-search="search docs search guide discover component keyword filter">
            <p class="doc-card-tag">Docs Search</p>
            <h3>Search by guide, component, or keyword</h3>
            <p>このページの検索ボックスでは、ガイド名・用途・キーワードを横断して絞り込めます。新しいユーザーが迷いにくい構成です。</p>
          </article>

          <article class="doc-card" data-doc-item data-doc-search="customization styles defaultStyles override theme brand glass dark mode css">
            <p class="doc-card-tag">Customization</p>
            <h3>Override default styles safely</h3>
            <p><code>tiara/components/defaultStyles.nim</code> を起点に、ブランドカラーや UI トーンを段階的に置き換えられます。</p>
          </article>

          <article class="doc-card" data-doc-item data-doc-search="docs source markdown getting-started repository examples reference">
            <p class="doc-card-tag">Docs Source</p>
            <h3>Keep website docs aligned with <code>/docs</code></h3>
            <p>リポジトリの <code>docs/getting-started.md</code> と website の導線を揃えておくと、Nimble と GitHub の両方から理解しやすくなります。</p>
          </article>
        </div>

        <p class="docs-empty-state" data-doc-empty hidden>No matching documentation sections.</p>
      </section>

      <section id="components" class="docs-components-section">
        $(componentsHead)

        <div class="component-demo-grid">
          $(buttonDemo)
          $(cardDemo)
          $(codeBlockDemo)
          $(toastDemo)
        </div>
      </section>

      <section id="install" class="docs-install">
        <div class="install-copy">
          <p class="section-kicker">Install</p>
          <h2 class="section-title section-title-left">Show the Nimble command directly</h2>
          <p class="docs-description">
            ドキュメントの最上部にコマンドをコードブロックで見せることで、初回訪問時の次アクションが明確になります。
          </p>
        </div>

        <div class="install-code-card">
          <div class="terminal-header">
            <span></span><span></span><span></span>
          </div>
          <pre><code>nimble install tiara</code></pre>
        </div>
      </section>
    </main>
  """

proc docsView*(): string =
  let title = "Tiara Docs | Searchable documentation and installation"
  return $applicationView(title, impl())
