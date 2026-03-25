import ../core
import ./utils
export utils

## Renders a toast with `data-tiara-*` hooks for ``tiara_client.js``.
## Attributes are plain ``data-`` names so markup works with Crown's ``html"""`` macro
## (which does not translate ``tiara-on:`` like Tiara's ``html`` macro).

proc toast*(
  T: typedesc[Tiara],
  message: string,
  title = "",
  tone = "info",
  dismissible = true,
  autoHideMs = 0,
  position = "bottom-right",
  id = "",
  attrs: seq[(string, string)] = @[]
): Html =
  let normalizedTone =
    case normalizeDomId(tone)
    of "success", "warning", "error":
      normalizeDomId(tone)
    else:
      "info"

  let titleHtml = if title.strip().len > 0: html"""<h4 class="toast-title">{title}</h4>""" else: rawHtml("")
  let closeBtn = if dismissible:
    html"""<button type="button" class="toast-close" aria-label="Dismiss notification" data-tiara-toast-close>x</button>"""
  else:
    rawHtml("")

  let baseClassStr = "toast toast-" & normalizedTone
  var classes = baseClassStr
  for attr in attrs:
    if attr[0] == "class":
      classes = mergeClasses(baseClassStr, attr[1])

  ## id / extra / autohide must be ``rawHtml``: Tiara's ``html`` macro escapes string
  ## interpolations (Crown ``html"""`` returns plain strings and does not have this issue).
  let idAttrHtml = if id != "":
    rawHtml("id=\"" & escapeHtml(id) & "\" ")
  else:
    rawHtml("")
  var extraAttrs = ""
  for attr in attrs:
    if attr[0] != "class":
      extraAttrs &= " " & attr[0] & "=\"" & escapeHtml(attr[1]) & "\""
  let extraAttrsHtml = rawHtml(extraAttrs)
  let autoHideHtml = if autoHideMs > 0:
    rawHtml("data-tiara-toast-autohide=\"" & $autoHideMs & "\" ")
  else:
    rawHtml("")

  result = html"""
<aside class="{classes}" role="status" {idAttrHtml}{autoHideHtml} data-tiara="toast" data-tiara-toast-position="{position}"{extraAttrsHtml}>
  <div class="toast-content">
    {titleHtml}
    <p class="toast-message">{message}</p>
  </div>
  {closeBtn}
</aside>
  """
