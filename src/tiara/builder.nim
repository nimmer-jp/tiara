import std/strutils

type
  Html* = distinct string

proc `$`*(value: Html): string {.inline.} =
  string(value)

proc rawHtml*(value: string): Html {.inline.} =
  Html(value)

proc escapeHtml*(value: string): string =
  result = newStringOfCap(value.len)
  for ch in value:
    case ch
    of '&':
      result.add "&amp;"
    of '<':
      result.add "&lt;"
    of '>':
      result.add "&gt;"
    of '"':
      result.add "&quot;"
    of '\'':
      result.add "&#39;"
    else:
      result.add ch

proc textNode*(value: string): Html {.inline.} =
  Html(escapeHtml(value))

proc classList*(classes: openArray[string]): string =
  for item in classes:
    let cls = item.strip()
    if cls.len == 0:
      continue

    if result.len > 0:
      result.add ' '
    result.add cls

proc attrsToString*(attrs: openArray[(string, string)]): string =
  for (rawName, rawValue) in attrs:
    let name = rawName.strip()
    if name.len == 0:
      continue

    if rawValue.len == 0:
      result.add " " & name
    else:
      result.add " " & name & "=\"" & escapeHtml(rawValue) & "\""

proc el*(name: string; body: Html): Html =
  Html("<" & name & ">" & $body & "</" & name & ">")

proc el*(name: string; body: Html; attrs: openArray[(string, string)]): Html =
  Html("<" & name & attrsToString(attrs) & ">" & $body & "</" & name & ">")

proc voidEl*(name: string): Html =
  Html("<" & name & " />")

proc voidEl*(name: string; attrs: openArray[(string, string)]): Html =
  Html("<" & name & attrsToString(attrs) & " />")

proc joinHtml*(parts: openArray[Html]): Html =
  var output = newStringOfCap(256)
  for part in parts:
    output.add $part
  Html(output)
