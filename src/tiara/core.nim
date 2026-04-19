import std/[macros, strutils]
import ./builder
export builder

proc toHtmlStr*(x: string): string = escapeHtml(x)
proc toHtmlStr*(x: Html): string = $x
proc toHtmlStr*(x: int): string = $x
proc toHtmlStr*(x: float): string = $x
proc toHtmlStr*(x: bool): string = $x

proc expandInterpolatedHtml(pi: string): NimNode =
  ## Shared implementation for ``html`` / ``tiaraHtml`` macros.
  var parts: seq[NimNode] = @[]

  var buf = ""
  var i = 0
  while i < pi.len:
    if pi[i] == '{' and (i == 0 or pi[i - 1] != '\\'):
      if buf.len > 0:
        parts.add(newLit(buf))
        buf = ""
      inc i
      var varName = ""
      while i < pi.len and pi[i] != '}':
        varName.add(pi[i])
        inc i
      if i < pi.len and pi[i] == '}':
        inc i

      let nodeStr = varName.strip()
      if nodeStr.len > 0:
        let node = parseExpr(nodeStr)
        let call = newCall(bindSym("toHtmlStr"), node)
        parts.add(call)
    elif pi[i] == '\\' and i + 1 < pi.len and (pi[i + 1] == '{' or pi[i + 1] == '}'):
      buf.add(pi[i + 1])
      i += 2
    else:
      buf.add(pi[i])
      inc i

  if buf.len > 0:
    parts.add(newLit(buf))

  if parts.len == 0:
    return newCall(ident("rawHtml"), newLit(""))

  var concatStr = parts[0]
  for idx in 1 ..< parts.len:
    concatStr = newCall(ident("&"), concatStr, parts[idx])

  result = newCall(ident("rawHtml"), concatStr)

macro html*(body: static[string]): untyped =
  ## Parses HTML string, injects variables using interpolation `{var}`,
  ## and translates `tiara-on:event` to `data-tiara-on-event`.
  ##
  ## When used alongside Crown's ``html`` macro, prefer ``import tiara/core except html``
  ## and use ``tiaraHtml``, or import only ``tiara/builder`` + ``tiara/components``.
  let pi = body.replace("tiara-on:", "data-tiara-on-")
  result = expandInterpolatedHtml(pi)

macro tiaraHtml*(body: static[string]): untyped =
  ## Same as ``html``. Use this symbol when Crown (or another package) also exports
  ## a macro named ``html`` — combine with ``import crown/core`` and ``import tiara/core except html``.
  let pi = body.replace("tiara-on:", "data-tiara-on-")
  result = expandInterpolatedHtml(pi)


macro client*(prc: untyped): untyped =
  ## Marks a proc to be compiled and included in the client-side JS bundle.
  ## Also exports it to the global scope so the hydration script can find it.
  prc.expectKind(nnkProcDef)
  let procName = prc.name.strVal
  let exportName = newLit("TiaraApp_" & procName)
  prc.addPragma(nnkExprColonExpr.newTree(ident("exportc"), exportName))
  result = prc
