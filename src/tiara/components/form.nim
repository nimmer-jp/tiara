import ../builder
import ./utils
export utils

proc form*(
  T: typedesc[Tiara],
  action: string,
  body: Html,
  formMethod = "post",
  enctype = "",
  inline = false,
  attrs: seq[(string, string)] = @[]
): Html =
  var baseAttrs = @[
    ("action", action),
    ("method", formMethod),
    ("class", if inline: "form-inline" else: "form"),
  ]
  if enctype.len > 0:
    baseAttrs.add(("enctype", enctype))

  el(
    "form",
    body,
    mergeAttrs(baseAttrs, mergeAttrs(@[("data-tiara", "form")], attrs))
  )

proc hidden*(
  T: typedesc[Tiara],
  name: string,
  value: string,
  attrs: seq[(string, string)] = @[]
): Html =
  voidEl(
    "input",
    mergeAttrs(@[
      ("type", "hidden"),
      ("name", name),
      ("value", value),
      ("data-tiara", "hidden"),
    ], attrs)
  )

proc formActions*(
  T: typedesc[Tiara],
  actions: openArray[Html],
  align = "end",
  attrs: seq[(string, string)] = @[]
): Html =
  let classes = classList([
    "form-actions",
    if align.len > 0: "form-actions-" & align else: "",
  ])
  el(
    "div",
    joinHtml(actions),
    mergeAttrs(@[
      ("class", classes),
      ("data-tiara", "form-actions"),
    ], attrs)
  )
