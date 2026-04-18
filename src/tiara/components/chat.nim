import ../builder
import ./utils
from ./textarea import textarea
from ./button import button
export utils

proc chatSidebar*(
  T: typedesc[Tiara],
  body: Html,
  header: Html = rawHtml(""),
  attrs: seq[(string, string)] = @[]
): Html =
  var inner: seq[Html] = @[]
  if $header != "":
    inner.add(el("div", header, @[("class", "chat-sidebar-header")]))
  inner.add(el("div", body, @[("class", "chat-sidebar-body")]))

  el(
    "aside",
    joinHtml(inner),
    mergeAttrs(@[("class", "chat-sidebar"), ("data-tiara", "chat-sidebar")], attrs)
  )

proc chatSessionItem*(
  T: typedesc[Tiara],
  title: string,
  meta = "",
  active = false,
  attrs: seq[(string, string)] = @[]
): Html =
  var segments: seq[Html] = @[el("div", textNode(title), @[("class", "chat-session-title")])]
  if meta.len > 0:
    segments.add(el("div", textNode(meta), @[("class", "chat-session-meta")]))

  var classes = classList([
    "chat-session-item",
    if active: "is-active" else: ""
  ])

  el(
    "div",
    el("div", joinHtml(segments), @[("class", "chat-session-inner")]),
    mergeAttrs(@[("class", classes), ("data-tiara", "chat-session-item")], attrs)
  )

proc chatBubble*(
  T: typedesc[Tiara],
  message: string,
  role = "assistant",
  attrs: seq[(string, string)] = @[]
): Html =
  let roleNorm = strip(role).toLowerAscii()
  let roleClass =
    case roleNorm
    of "user":
      "chat-bubble-user"
    of "system":
      "chat-bubble-system"
    else:
      "chat-bubble-assistant"

  let classes = classList(["chat-bubble", roleClass])
  el(
    "div",
    el("div", textNode(message), @[("class", "chat-bubble-content")]),
    mergeAttrs(@[("class", classes), ("data-tiara", "chat-bubble"), ("data-chat-role", role)], attrs)
  )

proc chatComposer*(
  T: typedesc[Tiara],
  name: string,
  placeholder = "",
  submitLabel = "送信",
  rows = 3,
  required = false,
  trailing: Html = rawHtml(""),
  attrs: seq[(string, string)] = @[]
): Html =
  let field = textarea(
    Tiara,
    name,
    label = "",
    value = "",
    placeholder = placeholder,
    required = required,
    rows = rows,
    attrs = @[("class", "chat-composer-input")]
  )
  var actionsInner: seq[Html] = @[]
  if $trailing != "":
    actionsInner.add(el("div", trailing, @[("class", "chat-composer-trailing")]))
  actionsInner.add(
    button(
      Tiara,
      submitLabel,
      color = "primary",
      buttonType = "submit",
      attrs = @[("class", "chat-composer-submit")]
    )
  )

  let actions = el("div", joinHtml(actionsInner), @[("class", "chat-composer-actions")])
  let inner = joinHtml([
    el("div", field, @[("class", "chat-composer-field")]),
    actions
  ])

  el(
    "div",
    inner,
    mergeAttrs(@[("class", "chat-composer"), ("data-tiara", "chat-composer")], attrs)
  )
