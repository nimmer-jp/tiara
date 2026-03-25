import ../builder
import ./utils
export utils

proc notificationIcon*(
  T: typedesc[Tiara],
  badge: string,
  icon = "🔔",
  label = "Notifications",
  variant = "default",
  attrs: seq[(string, string)] = @[]
): Html =
  let variantClass =
    case normalizeDomId(variant)
    of "subtle", "ghost", "solid":
      normalizeDomId(variant)
    else:
      "default"

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
        ("class", classList([
          "icon-badge",
          "notification-icon",
          "notification-icon-" & variantClass
        ])),
        ("data-tiara", "notification-icon"),
        ("aria-label", label)
      ],
      attrs
    )
  )

