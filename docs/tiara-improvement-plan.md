# Tiara 側の改善項目（upstream 向け）

Tiara 単体および **Crown + Basolato** との組み合わせで、ドキュメントと API で埋めたいギャップです。実装の手引きは [crown-integration.md](./crown-integration.md) を参照してください。

## 1. Crown との統合パス

**推奨パターン**

- ページの骨格とテンプレート文字列は **Crown** の `html"""…"""`（`import crown/core`）に任せる。
- UI の部品は **Tiara** のコンポーネント（`Tiara.button` など）で `Html` を組み立て、`$fragment` で文字列化して Crown 側の `{…}` に渡す。
- インタラクティブなコンポーネント用に `tiara_client.js` と、必要なら `import tiara/client` 由来のクライアント束をレイアウトへ載せる（Crown の head／レイアウトと整合させる）。

**避けたいこと**

- 同一モジュールで Crown の `html` と Tiara の `html` を無修飾のまま両方 import すること（シンボル衝突）。

## 2. `Html` / `html` マクロの衝突

| 状況 | 対処 |
|------|------|
| Crown の `html` だけ使い、Tiara は部品 API のみ | `import tiara/components`（および必要なら `tiara/builder`）。`html` マクロは読み込まない。 |
| Tiara の文字列テンプレートマクロも使う | `import tiara/core except html` のうえで **`tiaraHtml"""…"""`** を使う（`html` と同等）。 |
| 型名 `Html` が二重定義に見える | Nim のモジュール境界では通常どちらか一方を qualify（例: 実質的には `tiara/builder` の `Html` のみ使用）。 |

Tiara コンポーネント実装内部では従来どおり `html"""…"""` を使います。アプリコードで Crown と併用する場合が上表の対象です。

## 3. コンポーネントとレイアウトの責務

| 層 | 責務 |
|----|------|
| **Crown / アプリの layout** | `<html>`〜`<body>`、メタ、グローバル CSS／JS、`injectCrownSystem`、Tailwind ビルド成果物の読み込み。 |
| **Tiara** | 再利用可能な UI 断片（`Html`）、`data-tiara-*` などのマーカー、コンポーネント別のクライアント挙動。ページ全体のラッパーは「コンポーネント」として提供できるが、**アプリの唯一のレイアウト契約**は Crown 側に置くのが自然。 |

## 4. 橋渡しパッケージ（将来・スケッチ）

要件が固まったら、例として **`tiara_crown`** のような薄い Nimble パッケージを検討できます。

- `tiara/builder` + `tiara/components` の再 export
- Crown 併用時の推奨 import セットのコメント付きラッパ
- サンプルの `nimble` 依存関係一行化

現時点では **ドキュメント + `tiaraHtml`** で十分な場合が多いです。

## 5. サンプルリポジトリ

「最小 Crown + Tiara + Tailwind」の参照実装は、upstream のメンテナンス対象として別リポジトリまたは monorepo の example に置くと、Geo3 のような実アプリへの移行検証がしやすくなります。
