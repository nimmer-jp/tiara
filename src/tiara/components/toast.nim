import ../builder
import ./utils
export utils

proc toast*(
  T: typedesc[Tiara],
  message: string,
  title = "",
  tone = "info",
  dismissible = true,
  autoHideMs = 0,
  attrs: seq[(string, string)] = @[]
): Html =
  let normalizedTone =
    case normalizeDomId(tone)
    of "success", "warning", "error":
      normalizeDomId(tone)
    else:
      "info"

  var bodySegments: seq[Html] = @[]
  if title.strip().len > 0:
    bodySegments.add(el("strong", textNode(title), @[("class", "toast-title")]))
  bodySegments.add(el("span", textNode(message), @[("class", "toast-message")]))

  var outerSegments: seq[Html] = @[
    el("div", joinHtml(bodySegments), @[("class", "toast-content")])
  ]
  if dismissible:
    outerSegments.add(
      el(
        "button",
        textNode("x"),
        @[
          ("type", "button"),
          ("class", "toast-close"),
          ("aria-label", "Dismiss notification"),
          ("data-tiara-toast-close", "")
        ]
      )
    )

  var baseAttrs = @[
    ("class", classList(["toast", "toast-" & normalizedTone])),
    ("role", "status"),
    ("data-tiara", "toast")
  ]
  if autoHideMs > 0:
    baseAttrs.add(("data-tiara-toast-autohide", $autoHideMs))

  el("aside", joinHtml(outerSegments), mergeAttrs(baseAttrs, attrs))

