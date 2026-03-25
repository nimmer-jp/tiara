import ../builder
import ./utils
export utils

proc profileIcon*(
  T: typedesc[Tiara],
  name: string,
  imageUrl = "",
  size = "medium",
  status = "",
  variant = "neutral",
  attrs: seq[(string, string)] = @[]
): Html =
  let initials = initialsFromName(name)
  let sizeClass =
    if size.strip().len == 0:
      "medium"
    else:
      normalizeDomId(size)
  let variantClass =
    case normalizeDomId(variant)
    of "brand", "dark":
      normalizeDomId(variant)
    else:
      "neutral"

  var segments: seq[Html] = @[]
  if imageUrl.strip().len > 0:
    segments.add(
      voidEl(
        "img",
        @[
          ("src", imageUrl.strip()),
          ("alt", name),
          ("class", "profile-icon-image")
        ]
      )
    )
  else:
    segments.add(el("span", textNode(initials), @[("class", "profile-icon-initials")]))

  if status.strip().len > 0:
    segments.add(
      el(
        "span",
        rawHtml(""),
        @[
          ("class", classList(["profile-icon-status", "profile-icon-status-" & normalizeDomId(status)])),
          ("title", status)
        ]
      )
    )

  el(
    "span",
    joinHtml(segments),
    mergeAttrs(
      @[
        ("class", classList([
          "profile-icon",
          "profile-icon-" & sizeClass,
          "profile-icon-" & variantClass
        ])),
        ("data-tiara", "profile-icon"),
        ("title", name)
      ],
      attrs
    )
  )

