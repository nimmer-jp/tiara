import ../builder
import ./utils
export utils

proc editorSplit*(
  T: typedesc[Tiara],
  editorPane: Html,
  previewPane: Html,
  attrs: seq[(string, string)] = @[]
): Html =
  ## Editro 風の「エディタ | プレビュー」2 ペイン。クライアントで表示切替する場合はホスト側スクリプトと組み合わせます。
  el(
    "div",
    joinHtml(@[
      el("div", editorPane, @[("class", "editor-split-pane")]),
      el("div", previewPane, @[("class", "editor-split-preview")]),
    ]),
    mergeAttrs(@[
      ("class", "editor-split"),
      ("data-tiara", "editor-split"),
    ], attrs)
  )
