import basolato/view
import ../layouts/application_view


proc impl(name: string): Component =
  let style = styleTmpl(Css, """
    <style>
      body {
        background-color: black;
      }

      article {
        margin: 16px;
      }

      .title {
        color: goldenrod;
        text-align: center;
      }

      .topImage {
        background-color: gray;
        text-align: center;
      }

      .goldFont {
        color: goldenrod;
      }

      .whiteFont {
        color: silver;
      }

      .ulLink li {
        margin: 8px;
      }

      .ulLink li a {
        color: skyblue;
      }

      .architecture {
        padding: 10px
      }

      .architecture h2 {
        color: goldenrod;
      }

      .components {
        display:flex;
      }

      .discription {
        width: 50vw;
      }

      .discription h3 {
        color: goldenrod;
      }

      .discription p {
        color: white;
      }

      .sourceCode {
        width: 50vw
      }

      .sourceCode p {
        color: white;
        margin-bottom: 0;
      }

      .sourceCode pre {
        margin-top: 0;
      }
    </style>
  """)

  tmpli html"""
    <div class="blob-bg"></div>
    <div class="blob-bg blob-bg-2"></div>

    <nav class="navbar">
        <div class="nav-brand">👑 Tiara</div>
        <div class="nav-links">
            <a href="#features">Features</a>
            <a href="#docs">Docs</a>
            <a href="https://github.com/nimmer-jp/tiara" target="_blank" class="btn-outline">GitHub</a>
        </div>
    </nav>

    <header class="hero">
        <div class="hero-content">
            <h1 class="hero-title">Elevate Your <span>Nim</span> Apps.</h1>
            <p class="hero-description">
                Tiaraは、SSRに最適化された、ピュアNimによるモダンで超軽量なUIコンポーネントライブラリです。
                JavaScriptの肥大化を防ぎ、最高速のWeb体験を提供します。
            </p>
            <div class="hero-actions">
                <a href="#install" class="btn-primary">Get Started 🚀</a>
                <a href="#docs" class="btn-secondary">View Documentation</a>
            </div>
        </div>
        
        <div class="hero-visual">
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
            <div class="floating-badge badge-1">Zero JS Bloat</div>
            <div class="floating-badge badge-2">SSR First</div>
        </div>
    </header>

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
  """

proc welcomeView*(name: string): string =
  let title = "Tiara | Pure Nim UI Component Library"
  return $applicationView(title, impl(name))
