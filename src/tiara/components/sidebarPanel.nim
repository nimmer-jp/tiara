import ../builder
import ./utils
export utils

proc sidebarPanel*(
  T: typedesc[Tiara],
  header: Html,
  body: Html,
  attrs: seq[(string, string)] = @[]
): Html =
  ## Frosted sidebar panel for outline lists (Editro document outline aside).
  el(
    "aside",
    joinHtml(@[
      el("div", header, @[("class", "sidebar-panel-header")]),
      el("div", body, @[("class", "sidebar-panel-body")]),
    ]),
    mergeAttrs(@[
      ("class", "sidebar-panel"),
      ("data-tiara", "sidebar-panel"),
    ], attrs)
  )
