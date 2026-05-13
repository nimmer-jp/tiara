import std/strformat
import tiara/components
import ./site_shell

proc fullHtml*: string =
  let topNav = $el("header", Tiara.navbar(
    brand = "👑 Tiara",
    links = @[
      ("Features", "#features"),
      ("Components", "/components"),
      ("Install", "#install"),
      ("Docs", "/docs")
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
  ), @[("class", "site-header")])

  let heroVisual = joinHtml([
    rawHtml("""
<div class="glass-card">
  <div class="card-header">
    <div class="dot dot-red"></div>
    <div class="dot dot-yellow"></div>
    <div class="dot dot-green"></div>
  </div>
  <div class="card-body">
    <pre><code><span class="keyword">import</span> tiara/components

<span class="keyword">let</span> notice = $Tiara.toast(
  <span class="string">"Ready!"</span>, <span class="string">"Done"</span>, <span class="string">"success"</span>
)</code></pre>
  </div>
</div>
"""),
    el("div", textNode("Zero JS Bloat"), @[("class", "floating-badge badge-1")]),
    el("div", textNode("SSR First"), @[("class", "floating-badge badge-2")]),
  ])

  let heroSection = $Tiara.hero(
    title = "",
    titleHtml = rawHtml(
      "Elevate Your <span style=\"color:#7c3aed;\">Nim</span> Apps."),
    description = "Tiara は SSR 向けのピュア Nim UI プリミティブです。Crown と組み合わせて、そのまま本番ページを組み立てられます。",
    actions = @[
      el("a", textNode("Get Started 🚀"), @[("href", "#install"), ("class", "btn btn-primary btn-medium")]),
      el("a", textNode("Browse Components"), @[("href", "/components"), ("class", "btn btn-secondary btn-medium")]),
    ],
    visual = heroVisual,
  )

  let installBadges = $joinHtml(@[
    Tiara.badge("Pure Nim package"),
    Tiara.badge("Crown ready"),
    Tiara.badge("Component catalog"),
  ])

  let mainInner = fmt"""
    <div class="blob-bg"></div>
    <div class="blob-bg blob-bg-2"></div>
    {topNav}
    {heroSection}

    <section id="install" class="install-section">
      <div class="install-copy">
        <p class="section-kicker">Install</p>
        <h2 class="section-title section-title-left">Nimble から 1 コマンド</h2>
        <p class="hero-description">
          Crown アプリの <code>nimble</code> と同じ要領で依存に追加し、<code>tiara/components</code> を import して HTML を組み立てます。
        </p>
        <div class="install-inline-meta">{installBadges}</div>
      </div>
      <div class="install-code-card">
        <div class="terminal-header"><span></span><span></span><span></span></div>
        <pre><code>nimble install tiara</code></pre>
        <p class="install-card-note">
          ライブラリ配布では <code>website</code> / <code>examples</code> はパッケージに含めません。デモはこのリポジトリで <code>crown dev</code> を参照してください。
        </p>
      </div>
    </section>

    <section id="features" class="features-section">
      <h2 class="section-title">Why Tiara?</h2>
      <div class="features-grid">
        <div class="feature-card">
          <div class="feature-icon">⚡️</div>
          <h3>Blazing Fast</h3>
          <p>Nim のコンパイル時・実行時性能を活かし、SSR で初期表示を最小化します。</p>
        </div>
        <div class="feature-card">
          <div class="feature-icon">💎</div>
          <h3>Modern Aesthetics</h3>
          <p>デフォルトスタイルとバリアントで、ダーク/ライト含むモダンな表面を素早く再現できます。</p>
        </div>
        <div class="feature-card">
          <div class="feature-icon">🛠</div>
          <h3>Crown ファースト</h3>
          <p>本サイトも Crown ルート。ルーティングと Tiara の組み合わせがそのままテンプレートになります。</p>
        </div>
      </div>
    </section>

    <section id="components" class="catalog-section">
      <div class="catalog-copy">
        <p class="section-kicker">Catalog</p>
        <h2 class="section-title section-title-left">実装済みカタログ</h2>
        <p class="hero-description">
          <code>/components</code> では Tiara Lab（preview.nim と同内容）を全文表示します。フォーム・シェル・エディタ UI までを一気に確認できます。
        </p>
        <div class="catalog-actions">
          <a href="/components" class="btn-primary">Open Component Catalog</a>
          <a href="/docs" class="btn-secondary">Read Guides</a>
        </div>
      </div>
      <div class="catalog-grid">
        <article class="catalog-card">
          <p class="catalog-card-kicker">Layout &amp; Marketing</p>
          <h3>Navbar, Hero, Section Header</h3>
          <p>LP やドキュメントハブ向けのブロックを優先的に揃えています。</p>
        </article>
        <article class="catalog-card">
          <p class="catalog-card-kicker">App Shells</p>
          <h3>Workspace, Dashboard, Auth</h3>
          <p>実アプリ由来のシェル・同意バナー・認証カードをプリミティブ化しました。</p>
        </article>
        <article class="catalog-card">
          <p class="catalog-card-kicker">Editor &amp; Docs</p>
          <h3>Split editor, Doc surface</h3>
          <p>Markdown ワークスペース風の分割レイアウトとドキュメント頭部を用意しています。</p>
        </article>
      </div>
    </section>

    <section id="docs" class="docs-section">
      <div class="docs-copy">
        <p class="section-kicker">Docs</p>
        <h2 class="section-title section-title-left">検索付きガイド</h2>
        <p class="hero-description">
          <code>/docs</code> ではガイド断片の検索と代表的なコンポーネントデモを同一ページにまとめています。完全な一覧は <code>/components</code> へどうぞ。
        </p>
        <div class="catalog-actions">
          <a href="/docs" class="btn-primary">Open Docs Page</a>
          <a href="/components" class="btn-secondary">Open Component Catalog</a>
        </div>
      </div>
      <div class="docs-preview-card">
        <div class="docs-preview-search"><span>⌕</span><span>Search installation, toast…</span></div>
        <div class="docs-preview-item"><p>Getting Started</p><strong>Install and render</strong></div>
        <div class="docs-preview-item"><p>Docs Search</p><strong>Filter sections</strong></div>
        <div class="docs-preview-item"><p>Customization</p><strong>defaultStyles.nim</strong></div>
      </div>
    </section>
  """

  siteShell("Tiara | Pure Nim UI (Crown)", mainInner)
