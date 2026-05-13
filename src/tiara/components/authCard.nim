import ../builder
import ./utils
export utils

proc authCard*(
  T: typedesc[Tiara],
  title: string,
  body: Html,
  kicker = "",
  description = "",
  attrs: seq[(string, string)] = @[]
): Html =
  ## Centered authentication surface (admin2 login card + Midnote auth shell).
  var stack: seq[Html] = @[]
  if kicker.len > 0:
    stack.add(el("p", textNode(kicker), @[("class", "auth-card-kicker")]))

  stack.add(el("h1", textNode(title), @[("class", "auth-card-title")]))

  if description.len > 0:
    stack.add(el("p", textNode(description), @[("class", "auth-card-description")]))

  stack.add(el("div", body, @[("class", "auth-card-body")]))

  el(
    "section",
    joinHtml(stack),
    mergeAttrs(@[
      ("class", "auth-card"),
      ("data-tiara", "auth-card"),
    ], attrs)
  )

proc authScreen*(
  T: typedesc[Tiara],
  card: Html,
  attrs: seq[(string, string)] = @[]
): Html =
  ## Full-height grid wrapper that centers `authCard`.
  el(
    "div",
    card,
    mergeAttrs(@[
      ("class", "auth-screen"),
      ("data-tiara", "auth-screen"),
    ], attrs)
  )
