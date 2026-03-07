import basolato/view
import tiara/components as tc
import ../layouts/application_view


proc impl(): Component =
  let topNav = $tc.Tiara.navbar(
    brand = "👑 Tiara",
    links = @[
      ("Features", "#features"),
      ("Install", "#install"),
      ("Docs", "/docs")
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

  let heroVisual = tc.joinHtml([
    tc.rawHtml("""
<div class="glass-card">
  <div class="card-header">
    <div class="dot dot-red"></div>
    <div class="dot dot-yellow"></div>
    <div class="dot dot-green"></div>
  </div>
  <div class="card-body">
    <pre><code><span class="keyword">import</span> tiara/components/toast

<span class="keyword">let</span> myToast = renderToast(
  message = <span class="string">"Ready to deploy! 🚀"</span>,
  position = <span class="string">"bottom-right"</span>
)

<span class="function">echo</span> myToast</code></pre>
  </div>
</div>
"""),
    tc.el("div", tc.textNode("Zero JS Bloat"), @[("class", "floating-badge badge-1")]),
    tc.el("div", tc.textNode("SSR First"), @[("class", "floating-badge badge-2")])
  ])

  let heroSection = $tc.Tiara.hero(
    title = "",
    titleHtml = tc.rawHtml("Elevate Your <span>Nim</span> Apps."),
    description = "Tiaraは、SSRに最適化された、ピュアNimによるモダンで超軽量なUIコンポーネントライブラリです。JavaScriptの肥大化を防ぎ、最高速のWeb体験を提供します。",
    actions = @[
      tc.el("a", tc.textNode("Get Started 🚀"), @[("href", "#install"), ("class", "btn-primary")]),
      tc.el("a", tc.textNode("View Documentation"), @[("href", "/docs"), ("class", "btn-secondary")])
    ],
    visual = heroVisual
  )

  let installMeta = $tc.joinHtml([
    tc.Tiara.badge("Pure Nim package"),
    tc.Tiara.badge("Fast install path"),
    tc.Tiara.badge("SSR-first workflow")
  ])

  tmpli html"""
    <div class="blob-bg"></div>
    <div class="blob-bg blob-bg-2"></div>

    $(topNav)
    $(heroSection)

    <section id="install" class="install-section">
      <div class="install-copy">
        <p class="section-kicker">Install</p>
        <h2 class="section-title section-title-left">Install Tiara from Nimble</h2>
        <p class="hero-description">
          ドキュメントを見る前に、まずは 1 コマンドで導入できます。Nimble からそのまま取得できることを
          コードブロックで明示し、最初の一歩を迷わせません。
        </p>
        <div class="install-inline-meta">
          $(installMeta)
        </div>
      </div>

      <div class="install-code-card">
        <div class="terminal-header">
          <span></span><span></span><span></span>
        </div>
        <pre><code>nimble install tiara</code></pre>
        <p class="install-card-note">
          <code>website</code>、<code>tests</code>、<code>docs</code>、<code>examples</code> は配布物に含めず、
          軽量なパッケージとしてインストールされます。
        </p>
      </div>
    </section>

    <section id="features" class="features-section">
      <h2 class="section-title">Why Tiara?</h2>
      <div class="features-grid">
        <div class="feature-card">
          <div class="feature-icon">⚡️</div>
          <h3>Blazing Fast</h3>
          <p>Nimのコンパイル速度と実行速度をそのままWebに。サーバーサイドレンダリングで最速の初期ロードを実現します。</p>
        </div>
        <div class="feature-card">
          <div class="feature-icon">💎</div>
          <h3>Modern Aesthetics</h3>
          <p>グラスモーフィズム、ダークテーマをデフォルトでサポート。美しく、アクセシブルなUIを数行のコードで実現。</p>
        </div>
        <div class="feature-card">
          <div class="feature-icon">🛠</div>
          <h3>Highly Customizable</h3>
          <p>コンポーネントは完全に独立しており、必要なものだけをインポートできます。独自のスタイルオーバーライドも簡単。</p>
        </div>
      </div>
    </section>

    <section id="docs" class="docs-section">
      <div class="docs-copy">
        <p class="section-kicker">Docs</p>
        <h2 class="section-title section-title-left">Documentation page with search</h2>
        <p class="hero-description">
          専用の <code>/docs</code> ページでは、Getting Started、コンポーネント例、カスタマイズの入口をまとめて確認できます。
          検索ボックスからキーワードで絞り込み、必要な情報にすぐ到達できます。
        </p>
        <a href="/docs" class="btn-primary">Open Docs Page</a>
      </div>

      <div class="docs-preview-card">
        <div class="docs-preview-search">
          <span>⌕</span>
          <span>Search installation, toast, customization...</span>
        </div>
        <div class="docs-preview-item">
          <p>Getting Started</p>
          <strong>Install and render your first component</strong>
        </div>
        <div class="docs-preview-item">
          <p>Docs Search</p>
          <strong>Filter guides and components instantly</strong>
        </div>
        <div class="docs-preview-item">
          <p>Customization</p>
          <strong>Override default styles safely</strong>
        </div>
      </div>
    </section>
  """

proc welcomeView*(): string =
  let title = "Tiara | Pure Nim UI Component Library"
  return $applicationView(title, impl())
