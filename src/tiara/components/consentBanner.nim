import ../builder
import ./utils
export utils

proc consentBanner*(
  T: typedesc[Tiara],
  message: Html,
  actions: Html,
  id = "tiara-consent-banner",
  attrs: seq[(string, string)] = @[]
): Html =
  ## Fixed consent / cookie strip (Midnote `mn-cookie` pattern).
  let inner = el(
    "div",
    joinHtml(@[
      el("div", message, @[("class", "consent-banner-message")]),
      el("div", actions, @[("class", "consent-banner-actions")]),
    ]),
    @[("class", "consent-banner-inner")],
  )

  el(
    "aside",
    inner,
    mergeAttrs(@[
      ("id", id),
      ("class", "consent-banner"),
      ("role", "dialog"),
      ("aria-live", "polite"),
      ("data-tiara", "consent-banner"),
    ], attrs)
  )
