import ../builder
import ./utils
export utils

proc fieldValidation*(
  T: typedesc[Tiara],
  message: string,
  kind = "error",
  attrs: seq[(string, string)] = @[]
): Html =
  let k = strip(kind).toLowerAscii()
  let kindClass =
    case k
    of "hint", "help":
      "field-validation-hint"
    of "success", "ok":
      "field-validation-success"
    of "warning":
      "field-validation-warning"
    else:
      "field-validation-error"

  let role =
    if kindClass == "field-validation-error" or kindClass == "field-validation-warning":
      "alert"
    else:
      "note"

  let classes = classList(["field-validation", kindClass])
  el(
    "p",
    textNode(message),
    mergeAttrs(
      @[
        ("class", classes),
        ("data-tiara", "field-validation"),
        ("data-validation-kind", k),
        ("role", role)
      ],
      attrs
    )
  )
