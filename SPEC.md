# Tiara - The Pure Nim UI Component Library

**Tiara** は、Nim言語のパフォーマンスを極限まで引き出すために設計された、ゼロ・デペンデンシー（外部JS依存なし）のUIコンポーネントライブラリです。
Basolatoなどのサーバーサイドレンダリング（SSR）フレームワークとシームレスに統合し、美しく、型安全で、超高速なWebインターフェースを提供します。

## 👑 コアコンセプト

1. **Pure Nim Architecture (ゼロ・デペンデンシー)**
   React, Vue, Alpine.js, HTMXなどの外部JavaScriptライブラリには一切依存しません。サーバー側のHTML生成から、クライアント側の動的なUI制御（モーダル、Date Pickerなど）まで、すべてNim言語で記述されます。
2. **Blazing Fast SSR (超高速サーバーレンダリング)**
   Nimのマクロとコンパイル時評価を活用し、実行時のオーバーヘッドがゼロに近い文字列連結ベースのHTMLビルダーを提供します。
3. **Isomorphic Interactivity (Nim-to-JS)**
   高度な操作が必要なコンポーネント（Color Picker, Date Picker等）は、HTML5の標準機能をベースにしつつ、Nimからコンパイルされた極小サイズのピュアJavaScript（Vanilla JS）によってプログレッシブに拡張されます。
4. **Basolato First**
   Basolatoのコントローラーやビューにそのまま組み込める関数型/DSLアプローチを採用しています。

## 🏛️ アーキテクチャと動作原理

Tiaraのコンポーネントは、以下の2つの側面を持っています。

* **Server Side (C/C++ backend):** リクエストを受け取った際、NimのネイティブスピードでHTML文字列とCSSクラス（Tailwind等）を組み立ててブラウザに返します。
* **Client Side (JS backend):**
  動的コンポーネントに付随する挙動（「クリックでカレンダーを開く」「色をプレビューする」など）は、別途NimからJSにコンパイルされたスクリプト (`tiara_client.js`) によって軽量に制御されます。

## 📦 コンポーネント仕様

### 1. Basic Components (静的コンポーネント)
ボタンやタイポグラフィなど、JSを必要としない純粋なHTML/CSSコンポーネントです。

```nim
# Nim (Server-side)
import tiara/components

let myBtn = Tiara.button("送信する", color = "primary", size = "large", outlined = true)
# => <button class="btn btn-primary btn-large btn-outline">送信する</button>

let myCard = Tiara.card(
  title = "ユーザー情報",
  content = Tiara.text("ここにユーザーの詳細が表示されます。")
)
```

### 2. Advanced Components (動的コンポーネント)
実装が複雑なコンポーネント群です。HTML5標準の `<input>` を美しくラップしつつ、必要に応じてNimコンパイル済みの軽量JSが自動でアタッチされます。

```nim
# Nim (Server-side)
import tiara/components

# 日付選択 (ネイティブの <input type="date"> を高度にスタイリング)
let dateInput = Tiara.datePicker(
  name = "birthdate",
  label = "生年月日",
  minDate = "1900-01-01",
  maxDate = "today"
)

# カラーピッカー (ネイティブの <input type="color"> を拡張したカスタムUI)
let colorInput = Tiara.colorPicker(
  name = "theme",
  label = "ブランドカラー",
  default = "#FF5733"
)

# モーダルウィンドウ (JSなしの <dialog> 要素をベースに、Nim-JSで開閉制御)
let myModal = Tiara.modal(
  id = "confirm-modal",
  trigger = Tiara.button("削除"),
  content = Tiara.text("本当に削除しますか？")
)
```

## 🚀 開発ロードマップ

* [ ] **Phase 1: Core Engine & Basic UI**
  * マクロ/テンプレートベースの高速HTMLビルダー基盤の構築
  * Button, Input, Card, Container などの静的コンポーネント実装
* [ ] **Phase 2: Complex Components (HTML5 Based)**
  * Date Picker, Color Picker, Select などのフォーム要素の実装
  * CSSによる高度なカスタマイズとスタイリングの適用
* [ ] **Phase 3: Nim-to-JS Integration**
  * クライアントサイドでの動的制御（Modal, Toast Notifications等）をNimからJSへコンパイルする仕組みの統合
  * 開発者がJSを意識せずに動的UIを使えるDXの確立
