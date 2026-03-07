import ../builder
import ./utils
export utils

proc modal*(
  T: typedesc[Tiara],
  id: string,
  trigger: Html,
  content: Html,
  title = "",
  closeLabel = "閉じる",
  size = "medium",
  motionMs = 220,
  attrs: seq[(string, string)] = @[]
): Html =
  let safeId =
    if id.strip().len == 0:
      "tiara-modal"
    else:
      id
  let sizeClass =
    case normalizeDomId(size)
    of "small", "large":
      normalizeDomId(size)
    else:
      "medium"
  var dialogBody: seq[Html] = @[]

  if title.len > 0:
    dialogBody.add(el("h2", textNode(title), @[("class", "modal-title")]))

  dialogBody.add(el("div", content, @[("class", "modal-content")]))

  let closeButton = Tiara.button(closeLabel, color = "secondary", size = "small", buttonType = "button", attrs = @[("data-tiara-modal-close", safeId)])
  dialogBody.add(el("div", closeButton, @[("class", "modal-actions")]))

  let triggerWrapper = el(
    "span",
    trigger,
    @[("class", "modal-trigger"), ("data-tiara-modal-open", safeId)]
  )

  let dialogElement = el(
    "dialog",
    joinHtml(dialogBody),
    mergeAttrs(
      @[
        ("id", safeId),
        ("class", classList(["modal", "modal-" & sizeClass])),
        ("data-tiara", "modal"),
        ("data-tiara-motion-ms", $max(80, motionMs))
      ],
      attrs
    )
  )

  joinHtml([triggerWrapper, dialogElement])

