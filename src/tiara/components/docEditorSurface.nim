import ../builder
import ./utils
export utils

proc docEditorSurface*(
  T: typedesc[Tiara],
  header: Html,
  body: Html,
  breadcrumb: Html = rawHtml(""),
  attrs: seq[(string, string)] = @[]
): Html =
  ## ノート1枚のドキュメント UI 枠（パンくず・見出し行・本文）。Midnote `mn-doc-surface` 相当。
  var sections: seq[Html] = @[]
  if ($breadcrumb).len > 0:
    sections.add(el("div", breadcrumb, @[("class", "doc-editor-breadcrumb")]))
  sections.add(el("header", header, @[("class", "doc-editor-head")]))
  sections.add(el("div", body, @[("class", "doc-editor-body")]))

  el(
    "article",
    joinHtml(sections),
    mergeAttrs(@[
      ("class", "doc-editor-surface"),
      ("data-tiara", "doc-editor-surface"),
    ], attrs)
  )
