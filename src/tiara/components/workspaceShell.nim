import ../builder
import ./utils
export utils

proc workspaceShell*(
  T: typedesc[Tiara],
  drawerId: string,
  topbarStart: Html,
  topbarEnd: Html,
  sidebar: Html,
  main: Html,
  attrs: seq[(string, string)] = @[]
): Html =
  ## Full-viewport workspace with a glass top bar and a drawer sidebar on narrow screens (Midnote workspace shell).
  let safeId = normalizeDomId(drawerId)
  let inset = joinHtml(@[
    voidEl("input", @[
      ("type", "checkbox"),
      ("id", safeId),
      ("class", "workspace-shell-drawer-cb"),
      ("autocomplete", "off"),
    ]),
    el(
      "header",
      joinHtml(@[
        el("div", topbarStart, @[("class", "workspace-shell-top-start")]),
        el("div", topbarEnd, @[("class", "workspace-shell-top-end")]),
      ]),
      @[("class", "workspace-shell-topbar")],
    ),
    el(
      "div",
      joinHtml(@[
        el("aside", sidebar, @[("class", "workspace-shell-sidebar")]),
        el(
          "div",
          el("main", main, @[("class", "workspace-shell-main")]),
          @[("class", "workspace-shell-main-wrap")],
        ),
      ]),
      @[("class", "workspace-shell-grid")],
    ),
    el("label", rawHtml(""), @[("for", safeId), ("class", "workspace-shell-backdrop"), ("aria-hidden", "true")]),
  ])

  el(
    "div",
    joinHtml(@[
      voidEl("div", @[("class", "workspace-shell-bg")]),
      el("div", inset, @[("class", "workspace-shell-inset")]),
    ]),
    mergeAttrs(@[
      ("class", "workspace-shell"),
      ("data-tiara", "workspace-shell"),
    ], attrs)
  )

proc workspaceDrawerToggle*(
  T: typedesc[Tiara],
  drawerId: string,
  label = "Open sidebar",
  attrs: seq[(string, string)] = @[]
): Html =
  ## Burger control paired with `workspaceShell` (must use the same `drawerId`).
  let safeId = normalizeDomId(drawerId)
  el(
    "label",
    el("span", textNode("☰"), @[]),
    mergeAttrs(@[
      ("for", safeId),
      ("class", "workspace-shell-burger"),
      ("aria-label", label),
    ], attrs)
  )
