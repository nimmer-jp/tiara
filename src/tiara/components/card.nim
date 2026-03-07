import ../builder
import ./utils
export utils

proc card*(
  T: typedesc[Tiara],
  title: string,
  content: Html,
  footer: Html = rawHtml(""),
  variant = "",
  attrs: seq[(string, string)] = @[]
): Html =
  var segments: seq[Html] = @[
    el("h3", textNode(title), @[("class", "card-title")]),
    el("div", content, @[("class", "card-content")])
  ]

  if $footer != "":
    segments.add(el("div", footer, @[("class", "card-footer")]))

  el(
    "section",
    joinHtml(segments),
    mergeAttrs(@[("class", classList(["card", if variant.len > 0: "card-" & variant else: ""]))], attrs)
  )
