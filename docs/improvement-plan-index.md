# Crown / Tiara 改善計画（索引）

フレームワーク側で直せる問題を **Crown** と **Tiara** に分けて記載しています。

| ドキュメント | 内容 |
|--------------|------|
| [crown-improvement-plan.md](./crown-improvement-plan.md) | `disableLayout` と `injectCrownSystem`、レイアウト適用条件、生成コードの警告、Basolato / `.env` とのドキュメント連携など（**Crown リポジトリ側の追跡用**） |
| [tiara-improvement-plan.md](./tiara-improvement-plan.md) | Crown との統合パス、`Html` / `html` マクロの衝突回避、コンポーネントとレイアウトの責務など |

---

## 共通の背景

Geo3 の `app/` では、ツール連携上の摩擦を避けるため、生 HTML・手動 CDN・Tiara 非依存などの回避を行ってきました。リポジトリ内の実装要件ではなく、**upstream（[nimmer-jp/crown](https://github.com/nimmer-jp/crown)・[nimmer-jp/tiara](https://github.com/nimmer-jp/tiara)）向けの提案**として各ファイルに整理しています。

---

## 実施順序の目安（両方）

1. **Crown:** `disableLayout` と `injectCrownSystem` の仕様整理 → フルページでも注入を選べるようにする（コードまたはドキュメント）
2. **Tiara + Crown:** 衝突回避パターンを文書化 → 必要なら橋渡しパッケージのスケッチ（Tiara 側は [crown-integration.md](./crown-integration.md) と `tiaraHtml` マクロ）
3. **両方:** サンプルリポジトリ（最小 Crown + Tiara + Tailwind）をメンテする
4. **Geo3:** upstream が整ったら、`app/` の手動 CDN 重複を削減できるか検証する

---

## スコープ外・リスク（共通）

| 項目 | 理由 |
|------|------|
| Basolato 0.15 / 0.16 の gcsafe 問題 | Nim / Basolato 側。`app/nim.cfg` の回避は `app/README.md` 等で継続記載でよい |
| `web`（Next）と API の CORS | アプリ・インフラ設定の領域 |
| MapLibre のバージョン固定 | アプリ資産（CDN URL 等）の責務 |

---

## 参考（Geo3 リポジトリ内）

| ファイル | 備考 |
|----------|------|
| `app/src/app/map/page.nim` | `disableLayout` + 手動 Tailwind / MapLibre CDN |
| `app/src/app/layout/layout.nim` | Crown レイアウト + `injectCrownSystem` 前提の `</head>` |
| `app/crown.json` | `tailwind: true` 時の挙動とフルページの関係 |
| `IMPLEMENTATION_GAPS.md` | 歴史的経緯のメモ |

---

*作成意図: Crown／Tiara が「不完全」に見えた原因のうち、upstream で直せるものを追跡可能な形に残す。*
