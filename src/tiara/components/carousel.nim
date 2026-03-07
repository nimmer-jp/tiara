import ../builder
import ./utils
export utils

proc carousel*(
  T: typedesc[Tiara],
  id: string,
  items: openArray[Html],
  showIndicators = true,
  attrs: seq[(string, string)] = @[]
): Html =
  let safeId =
    if id.strip().len == 0:
      "tiara-carousel"
    else:
      normalizeDomId(id)

  var slides: seq[Html] = @[]
  for idx, item in items:
    slides.add(
      el(
        "article",
        item,
        @[
          ("class", "carousel-slide"),
          ("data-tiara-carousel-slide", $idx),
          ("aria-hidden", if idx == 0: "false" else: "true")
        ]
      )
    )

  if slides.len == 0:
    slides.add(
      el(
        "article",
        Tiara.text("No items"),
        @[
          ("class", "carousel-slide"),
          ("data-tiara-carousel-slide", "0"),
          ("aria-hidden", "false")
        ]
      )
    )

  let size = slides.len
  let track = el(
    "div",
    joinHtml(slides),
    @[
      ("class", "carousel-track"),
      ("data-tiara-carousel-track", ""),
      ("style", "transform: translateX(0%);")
    ]
  )

  var bodySegments: seq[Html] = @[track]

  if size > 1:
    bodySegments.add(
      el(
        "button",
        textNode("‹"),
        @[
          ("type", "button"),
          ("class", "carousel-nav carousel-nav-prev"),
          ("aria-label", "Previous slide"),
          ("data-tiara-carousel-action", "prev"),
          ("data-tiara-carousel-target", safeId)
        ]
      )
    )

    bodySegments.add(
      el(
        "button",
        textNode("›"),
        @[
          ("type", "button"),
          ("class", "carousel-nav carousel-nav-next"),
          ("aria-label", "Next slide"),
          ("data-tiara-carousel-action", "next"),
          ("data-tiara-carousel-target", safeId)
        ]
      )
    )

    if showIndicators:
      var indicatorNodes: seq[Html] = @[]
      for idx in 0 ..< size:
        indicatorNodes.add(
          el(
            "button",
            rawHtml(""),
            @[
              ("type", "button"),
              ("class", classList(["carousel-indicator", if idx == 0: "is-active" else: ""])),
              ("data-tiara-carousel-action", "go"),
              ("data-tiara-carousel-target", safeId),
              ("data-tiara-carousel-go", $idx),
              ("data-tiara-carousel-indicator", $idx),
              ("aria-label", "Go to slide " & $(idx + 1)),
              ("aria-current", if idx == 0: "true" else: "false")
            ]
          )
        )

      bodySegments.add(el("div", joinHtml(indicatorNodes), @[("class", "carousel-indicators")]))

  el(
    "section",
    joinHtml(bodySegments),
    mergeAttrs(
      @[
        ("id", safeId),
        ("class", "carousel"),
        ("data-tiara", "carousel"),
        ("data-tiara-carousel-index", "0"),
        ("data-tiara-carousel-size", $size)
      ],
      attrs
    )
  )

