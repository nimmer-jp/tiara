import basolato/view
import tiara/components as tc
import ../layouts/application_view


proc impl(): Component =
  let topNav = $tc.Tiara.navbar(
    brand = "👑 Tiara",
    links = @[
      ("Home", "/"),
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
  )

  let docsSearchHead = $tc.Tiara.sectionHeader(
    title = "Find a guide or component fast",
    kicker = "Search",
    actions = tc.el(
      "p",
      tc.textNode("5 sections"),
      @[("class", "docs-search-meta"), ("data-doc-count", "")]
    ),
    attrs = @[("class", "docs-search-head")]
  )

  let docsSearchInput = $tc.Tiara.searchBox(
    name = "docs-search",
    placeholder = "Search installation, toast, customization...",
    attrs = @[("class", "docs-search-box")],
    inputAttrs = @[("data-doc-search-input", "")]
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
