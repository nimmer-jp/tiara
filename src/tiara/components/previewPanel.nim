import ../builder
import ./utils
export utils

proc previewPanel*(
  T: typedesc[Tiara],
  content: Html,
  attrs: seq[(string, string)] = @[]
): Html =
  ## Midnote `mn-doc-preview` に相当する本文プレビュー枠（Markdown レンダ結果の受け皿）。
  el(
    "div",
    el("div", content, @[("class", "tiara-preview-panel-inner tiara-prose")]),
    mergeAttrs(@[
      ("class", "tiara-preview-panel"),
      ("data-tiara", "preview-panel"),
    ], attrs)
  )
