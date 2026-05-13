import ../builder
import ./utils
export utils

proc dashboardShell*(
  T: typedesc[Tiara],
  sidebar: Html,
  main: Html,
  attrs: seq[(string, string)] = @[]
): Html =
  ## Sticky sidebar + scrollable main region (tategaki admin2 dashboard layout).
  el(
    "div",
    joinHtml([
      el("aside", sidebar, @[("class", "dashboard-shell-sidebar")]),
      el("div", main, @[("class", "dashboard-shell-main")]),
    ]),
    mergeAttrs(@[
      ("class", "dashboard-shell"),
      ("data-tiara", "dashboard-shell"),
    ], attrs)
  )
