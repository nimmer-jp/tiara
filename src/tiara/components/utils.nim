import std/[strutils, times]
export strutils, times
import ../builder
export builder

type Tiara* = object


proc mergeAttrs*(
  baseAttrs: openArray[(string, string)],
  extraAttrs: seq[(string, string)]
): seq[(string, string)] =
  result = @[]
  result.add(baseAttrs)

  for (rawName, rawValue) in extraAttrs:
    let name = rawName.strip()
    if name.len == 0:
      continue

    var updated = false
    for idx in 0 ..< result.len:
      if result[idx][0] != name:
        continue

      if name == "class":
        result[idx] = (name, classList([result[idx][1], rawValue]))
      elif name == "style":
        let baseStyle = result[idx][1].strip()
        let extraStyle = rawValue.strip()
        if baseStyle.len == 0:
          result[idx] = (name, extraStyle)
        elif extraStyle.len == 0:
          discard
        else:
          let separator = if baseStyle.endsWith(";"): " " else: "; "
          result[idx] = (name, baseStyle & separator & extraStyle)
      else:
        result[idx] = (name, rawValue)

      updated = true
      break

    if not updated:
      result.add((name, rawValue))

proc normalizeDomId*(value: string): string =
  var normalized = newStringOfCap(value.len)
  for ch in value:
    if ch in {'a'..'z', 'A'..'Z', '0'..'9'}:
      normalized.add toLowerAscii(ch)
    elif ch in {' ', '_', '-', '.', ':'}:
      normalized.add '-'

  normalized = normalized.strip(chars = {'-'})
  if normalized.len == 0:
    return "tiara-field"

  normalized

proc resolveDateToken*(value: string): string =
  let token = value.strip().toLowerAscii()
  case token
  of "":
    ""
  of "today":
    now().format("yyyy-MM-dd")
  else:
    value

proc normalizeLanguage*(value: string): string =
  value.strip().toLowerAscii()

proc appendEscapedChar*(output: var string, ch: char) =
  case ch
  of '&':
    output.add "&amp;"
  of '<':
    output.add "&lt;"
  of '>':
    output.add "&gt;"
  of '"':
    output.add "&quot;"
  of '\'':
    output.add "&#39;"
  else:
    output.add ch

proc appendEscaped*(output: var string, value: string) =
  for ch in value:
    appendEscapedChar(output, ch)

proc isIdentifierStart*(ch: char): bool =
  ch in {'a'..'z', 'A'..'Z', '_'}

proc isIdentifierChar*(ch: char): bool =
  ch in {'a'..'z', 'A'..'Z', '0'..'9', '_'}

proc isKeyword*(language: string, token: string): bool =
  let normalized = token.toLowerAscii()
  case normalizeLanguage(language)
  of "nim":
    normalized in [
      "proc", "func", "method", "iterator", "template", "macro",
      "let", "var", "const", "type", "object", "ref",
      "if", "elif", "else", "case", "of",
      "for", "while", "return", "discard",
      "import", "from", "when", "not", "and", "or"
    ]
  of "javascript", "js", "typescript", "ts":
    normalized in [
      "function", "const", "let", "var", "return",
      "if", "else", "switch", "case", "break",
      "for", "while", "class", "new", "import", "from",
      "export", "try", "catch", "finally", "await", "async"
    ]
  of "python", "py":
    normalized in [
      "def", "class", "return",
      "if", "elif", "else",
      "for", "while", "in", "not", "and", "or",
      "import", "from", "try", "except", "finally",
      "with", "as", "lambda", "yield"
    ]
  else:
    false

proc addHighlightedToken*(output: var string, token: string,
    tokenClass: string) =
  if tokenClass.len == 0:
    appendEscaped(output, token)
    return

  output.add "<span class=\"code-token " & tokenClass & "\">"
  appendEscaped(output, token)
  output.add "</span>"

proc renderHighlightedCode*(code: string, language: string): string =
  let lang = normalizeLanguage(language)
  var i = 0

  while i < code.len:
    let ch = code[i]

    if (lang in ["nim", "python", "py"]) and ch == '#':
      var j = i
      while j < code.len and code[j] != '\n':
        inc j
      addHighlightedToken(result, code[i ..< j], "code-comment")
      i = j
      continue

    if (lang in ["javascript", "js", "typescript", "ts"]) and ch == '/' and i +
        1 < code.len and code[i + 1] == '/':
      var j = i
      while j < code.len and code[j] != '\n':
        inc j
      addHighlightedToken(result, code[i ..< j], "code-comment")
      i = j
      continue

    if ch == '"' or ch == '\'':
      var j = i + 1
      while j < code.len:
        if code[j] == '\\':
          if j + 1 < code.len:
            j += 2
          else:
            inc j
          continue
        if code[j] == ch:
          inc j
          break
        if code[j] == '\n':
          break
        inc j
      addHighlightedToken(result, code[i ..< j], "code-string")
      i = j
      continue

    if ch in {'0'..'9'}:
      var j = i + 1
      while j < code.len and code[j] in {'0'..'9', '.', '_'}:
        inc j
      addHighlightedToken(result, code[i ..< j], "code-number")
      i = j
      continue

    if isIdentifierStart(ch):
      var j = i + 1
      while j < code.len and isIdentifierChar(code[j]):
        inc j
      let token = code[i ..< j]
      if isKeyword(lang, token):
        addHighlightedToken(result, token, "code-keyword")
      else:
        addHighlightedToken(result, token, "")
      i = j
      continue

    appendEscapedChar(result, ch)
    inc i

proc initialsFromName*(name: string): string =
  for part in name.strip().splitWhitespace():
    if part.len == 0:
      continue
    result.add toUpperAscii(part[0])
    if result.len == 2:
      break

  if result.len == 0:
    result = "?"

