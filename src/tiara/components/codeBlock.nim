import ../builder
import ./utils
export utils

proc codeBlock*(
  T: typedesc[Tiara],
  code: string,
  language = "text",
  title = "",
  attrs: seq[(string, string)] = @[]
): Html =
  let normalizedLang = normalizeLanguage(language)
  let languageClass =
    if normalizedLang.len > 0 and normalizedLang != "text":
      "language-" & normalizedLang
    else:
      ""

  var segments: seq[Html] = @[]
  if title.len > 0 or (normalizedLang.len > 0 and normalizedLang != "text"):
    var headerSegments: seq[Html] = @[]

    if title.len > 0:
      headerSegments.add(el("span", textNode(title), @[("class", "code-block-title")]))

    if normalizedLang.len > 0 and normalizedLang != "text":
      headerSegments.add(
        el("span", textNode(toUpperAscii(normalizedLang)), @[("class", "code-block-language")])
      )

    segments.add(el("figcaption", joinHtml(headerSegments), @[("class", "code-block-header")]))

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
    mergeAttrs(@[("class", "code-block"), ("data-tiara", "code-block")], attrs)
  )

