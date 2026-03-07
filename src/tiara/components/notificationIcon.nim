import ../builder
import ./utils
export utils

proc notificationIcon*(
  T: typedesc[Tiara],
  badge: string,
  icon = "🔔",
  label = "Notifications",
  attrs: seq[(string, string)] = @[]
): Html =
  var segments: seq[Html] = @[
    el("span", textNode(icon), @[("class", "icon-badge-icon"), ("aria-hidden", "true")])
  ]
  if badge.strip().len > 0:
    segments.add(el("span", textNode(badge.strip()), @[("class", "icon-badge-count")]))

  el(
    "button",
    joinHtml(segments),
    mergeAttrs(
      @[
        ("type", "button"),
        ("class", "icon-badge notification-icon"),
        ("data-tiara", "notification-icon"),
        ("aria-label", label)
      ],
      attrs
    )
  )

