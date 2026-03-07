import ../builder
import ./utils
export utils

proc iconWithBadge*(
  T: typedesc[Tiara],
  icon: Html,
  badge: string,
  label = "",
  attrs: seq[(string, string)] = @[]
): Html =
  var segments: seq[Html] = @[
    el("span", icon, @[("class", "icon-badge-icon"), ("aria-hidden", "true")])
  ]

  if badge.strip().len > 0:
    segments.add(el("span", textNode(badge.strip()), @[("class", "icon-badge-count")]))

  var baseAttrs = @[
    ("class", "icon-badge"),
    ("data-tiara", "icon-badge")
  ]
  if label.strip().len > 0:
    baseAttrs.add(("aria-label", label.strip()))

  el("span", joinHtml(segments), mergeAttrs(baseAttrs, attrs))

