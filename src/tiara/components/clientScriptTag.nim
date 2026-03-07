import ../builder
import ./utils
export utils

proc clientScriptTag*(
  T: typedesc[Tiara],
  src = "/assets/tiara_client.js"
): Html =
  el("script", rawHtml(""), @[("src", src), ("defer", "")])

