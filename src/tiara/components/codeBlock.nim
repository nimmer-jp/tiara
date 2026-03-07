import ../builder
import ./utils
export utils

proc codeBlock*(
  T: typedesc[Tiara],
  code: string,
  language = "text",
  title = "",
  chrome = "default",
  attrs: seq[(string, string)] = @[]
): Html =
  let normalizedLang = normalizeLanguage(language)
  let normalizedChrome = chrome.strip().toLowerAscii()
  let languageClass =
    if normalizedLang.len > 0 and normalizedLang != "text":
      "language-" & normalizedLang
    else:
      ""

  var segments: seq[Html] = @[]
  let shouldShowHeader =
    normalizedChrome == "terminal" or (
      normalizedChrome != "minimal" and (
        title.len > 0 or (normalizedLang.len > 0 and normalizedLang != "text")
      )
    )

  if shouldShowHeader:
    var headerMainSegments: seq[Html] = @[]
    if normalizedChrome == "terminal":
      headerMainSegments.add(
        el(
          "span",
          joinHtml([
            el("span", rawHtml(""), @[("class", "code-block-dot code-block-dot-red")]),
            el("span", rawHtml(""), @[("class", "code-block-dot code-block-dot-yellow")]),
            el("span", rawHtml(""), @[("class", "code-block-dot code-block-dot-green")])
          ]),
          @[("class", "code-block-traffic"), ("aria-hidden", "true")]
        )
      )

    if title.len > 0:
      headerMainSegments.add(
        el("span", textNode(title), @[("class", "code-block-title")])
      )

    var headerSegments: seq[Html] = @[]
    if headerMainSegments.len > 0:
      headerSegments.add(
        el("div", joinHtml(headerMainSegments), @[("class", "code-block-header-main")])
      )

    if normalizedLang.len > 0 and normalizedLang != "text":
      headerSegments.add(
        el("span", textNode(toUpperAscii(normalizedLang)), @[("class", "code-block-language")])
      )

    segments.add(
      el(
        "figcaption",
        joinHtml(headerSegments),
        @[("class", classList([
          "code-block-header",
          if normalizedChrome == "terminal": "code-block-header-terminal" else: ""
        ]))]
      )
    )

  let highlighted = rawHtml(renderHighlightedCode(code, normalizedLang))
  let codeNode = el(
    "code",
    highlighted,
    @[("class", classList(["code-block-code", languageClass]))]
  )
  segments.add(el("pre", codeNode, @[("class", "code-block-pre")]))

  el(
    "figure",
    joinHtml(segments),
    mergeAttrs(@[
      ("class", classList([
        "code-block",
        if normalizedChrome == "terminal": "code-block-terminal" else: ""
      ])),
      ("data-tiara", "code-block")
    ], attrs)
  )
