# Crown + Tiara 統合ガイド

Crown（ページテンプレート・レイアウト）と Tiara（UI コンポーネント）を同じ Basolato アプリで使うときの実用的なパターンです。

## 推奨フロー

1. **Crown** で `proc page*(req: Request): string`（またはプロジェクトの規約に従う）を定義し、戻り値は `html""" … """` で組み立てる。
2. **Tiara** でマークアップ断片を組み、`$` で文字列にして Crown のテンプレートへ埋め込む。

```nim
import crown/core
import tiara/components

proc page*(req: Request): string =
  let toolbar = $joinHtml(@[
    Tiara.button("Save", color = "primary"),
    Tiara.badge("Beta", tone = "accent"),
  ])
  return html"""
    <main class="stack">{toolbar}</main>
  """
```

## `html` マクロが二つあるとき

Crown と Tiara はどちらも HTML を扱うため、`html` という名前が衝突します。

**パターン A（最も単純）:** Tiara は `import tiara/components` のみ。Tiara の `html"""` マクロは import しない。コンポーネント内部のマクロ利用はライブラリ側に閉じる。

**パターン B:** Tiara のインタポレーション付きマクロもページで使う。

```nim
import crown/core
import tiara/core except html
import tiara/components

let name = "Tiara"
let snippet = $tiaraHtml"""<span class="pill">{name}</span>"""
```

`tiaraHtml` は `html` と同じ意味です（`tiara-on:*` → `data-tiara-on-*` の変換を含む）。

## `Html` 型

Tiara のマークアップ型は `tiara/builder` の `Html`（`tiara/components` 経由でも利用可能）です。Crown 側に別の `Html` がある場合は、モジュール修飾またはどちらか一方に統一してください。

## レイアウトとスタイル

- **グローバル CSS／Tailwind／システムスクリプト** は Crown のレイアウトや `crown.json` のワークフローに合わせる（詳細は Crown のドキュメント）。
- **コンポーネント単位のマーカー**（`data-tiara` など）は Tiara が出力します。`defaultStyles` で注入するスタイルが必要なら、レイアウトの `<head>` か適切なブロックに `$Tiara.defaultStyles()` を含めます（プロジェクトの Crown テンプレートに依存）。

## 関連ドキュメント

- [tiara-improvement-plan.md](./tiara-improvement-plan.md) — 上流での改善トラッキング
- [improvement-plan-index.md](./improvement-plan-index.md) — Crown / Tiara 共通の索引
