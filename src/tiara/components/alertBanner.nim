import ../builder
import ./utils
export utils

proc alertBanner*(
  T: typedesc[Tiara],
  message: string,
  title = "",
  tone = "info",
  attrs: seq[(string, string)] = @[]
): Html =
  let toneNorm = strip(tone).toLowerAscii()
  let toneClass =
    case toneNorm
    of "warning":
      "alert-banner-warning"
    of "error", "danger":
      "alert-banner-error"
    of "success":
      "alert-banner-success"
    else:
      "alert-banner-info"

  var segments: seq[Html] = @[]
  if title.len > 0:
    segments.add(el("div", textNode(title), @[("class", "alert-banner-title")]))
  segments.add(el("div", textNode(message), @[("class", "alert-banner-message")]))

  let classes = classList(["alert-banner", toneClass])
  el(
    "div",
    joinHtml(segments),
    mergeAttrs(@[("class", classes), ("data-tiara", "alert-banner"), ("role", "status")], attrs)
  )
