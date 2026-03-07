# Tiara (ティアァラ) - Getting Started

Tiaraは、Nim言語で書かれたSSR (Server-Side Rendering) 主体のアプリケーションに最適な、ピュアNimのUIコンポーネントライブラリです。過剰なJavaScriptに依存せず、軽量で高速、かつアクセシビリティに配慮したモダンなUIを提供します。

## 概要

TiaraはTailwind CSSやHeadless UIの考え方にインスパイアされており、デフォルトで美しく整ったスタイル（グラスモーフィズム、ダークモード対応、スムーズなアニメーションなど）を備えています。

## インストール方法

Nimのパッケージマネージャ `nimble` を使って簡単にインストールできます。

```sh
nimble install tiara
```

※ `website`, `tests`, `docs`, `examples` ディレクトリはパッケージに含まれないよう設定されているため、マシンの容量を圧迫しません。

## 最初のステップ

インストールが完了したら、あなたのNimプロジェクトにインポートして使い始めましょう。

### トースト (Toast) の表示例

```nim
import tiara/components/toast

let myToast = renderToast(
  message = "操作が正常に完了しました！",
  position = "bottom-right",
  duration = 3000
)

# Web層 (例: Jester, Prologue など) でHTMLとして出力します
echo myToast
```

## プロジェクト構成のベストプラクティス

Tiaraはコンポーネント指向で構築されています。`tiara/components/` 以下から必要なコンポーネントだけを選択してインポートすることをお勧めします。これにより、最終的なバイナリサイズやレンダリング負荷を最小限に抑えることができます。

## 次のステップ

- **コンポーネント一覧**: 提供されているUIコンポーネント（ボタン、バッジ、モーダルなど）の詳細については公式サイトのリファレンスを参照してください。
- **スタイルのカスタマイズ**: `tiara/components/defaultStyles.nim` を独自のスタイルに上書きすることで、プロジェクトの要件に合わせた自由なカスタマイズが可能です。
