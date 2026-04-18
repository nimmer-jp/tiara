import ../builder
import ./utils
export utils

proc appShell*(
  T: typedesc[Tiara],
  sidebar: Html,
  main: Html,
  attrs: seq[(string, string)] = @[]
): Html =
  let shell = joinHtml([
    el("div", sidebar, @[("class", "app-shell-sidebar")]),
    el("main", main, @[("class", "app-shell-main")])
  ])

  el(
    "div",
    shell,
    mergeAttrs(@[("class", "app-shell"), ("data-tiara", "app-shell")], attrs)
  )
