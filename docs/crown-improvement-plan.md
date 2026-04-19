# Crown 側の改善項目（索引・upstream 向け）

このファイルは **Tiara リポジトリ内の索引** です。実装・Issue の一次ソースは **[nimmer-jp/crown](https://github.com/nimmer-jp/crown)** を想定しています。

## 追跡したいテーマ

| テーマ | 概要 |
|--------|------|
| `disableLayout` | フルページ HTML などでレイアウトを外すときの挙動とドキュメントの一致 |
| `injectCrownSystem` | システムスクリプト／スタイルの注入タイミング。フルページでも注入を選べるか |
| レイアウト適用条件 | `crown.json` の `tailwind` 等とページ種別の組み合わせ |
| 生成コードの警告 | テンプレート生成物に対するコンパイラ／ツール警告の扱い |
| Basolato / `.env` | ドキュメント連携と設定の見える化 |

詳細は Crown リポジトリのドキュメント・Issue に集約するのが適切です。クロスリファレンスは [improvement-plan-index.md](./improvement-plan-index.md) を参照してください。
