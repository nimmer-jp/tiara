import std/[strutils, tables]

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

proc getTailwindPrefix(cls: string): string =
  var modifier = ""
  var base = cls
  let colonIdx = cls.rfind(':')
  if colonIdx != -1:
    modifier = cls[0..colonIdx]
    base = cls[colonIdx+1..^1]
  
  let prefixes = ["bg-", "text-", "font-", "border-", "ring-", "cursor-",
                  "p-", "pt-", "pr-", "pb-", "pl-", "px-", "py-",
                  "m-", "mt-", "mr-", "mb-", "ml-", "mx-", "my-",
                  "w-", "h-", "min-w-", "max-w-", "min-h-", "max-h-",
                  "flex-", "grid-", "gap-", "rounded-", "shadow-", "z-", "opacity-"]
  for prefix in prefixes:
    if base.startsWith(prefix):
      return modifier & prefix
  return cls

proc mergeClasses*(baseStr: string, overrideStr: string): string =
  var classMap = initOrderedTable[string, string]()
  for cls in baseStr.splitWhitespace():
    if cls.len > 0:
      classMap[getTailwindPrefix(cls)] = cls
  for cls in overrideStr.splitWhitespace():
    if cls.len > 0:
      classMap[getTailwindPrefix(cls)] = cls
  
  var res: seq[string] = @[]
  for val in classMap.values():
    res.add(val)
  return res.join(" ")

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
