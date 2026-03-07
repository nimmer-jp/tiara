import std/[asynchttpserver, asyncdispatch, strutils, os]
import examples/preview
import src/tiara/client

var pageHtmlGlobal: cstring
var clientJsGlobal: cstring

when isMainModule:
  let portNumber =
    if paramCount() >= 1:
      try:
        parseInt(paramStr(1))
      except ValueError:
        8787
    else:
      8787

  pageHtmlGlobal = renderPreviewPage("/tiara_client.js").cstring
  clientJsGlobal = TiaraClientBundle.cstring

  var server = newAsyncHttpServer()
  let port = Port(portNumber)

  echo "Open http://127.0.0.1:", portNumber
  waitFor server.serve(
    port,
    proc (req: Request): Future[void] {.async, gcsafe.} =
      if req.url.path == "/" or req.url.path == "/index.html":
        await req.respond(
          Http200,
          $pageHtmlGlobal,
          newHttpHeaders([("Content-Type", "text/html; charset=utf-8")])
        )
      elif req.url.path == "/tiara_client.js":
        await req.respond(
          Http200,
          $clientJsGlobal,
          newHttpHeaders([("Content-Type", "application/javascript; charset=utf-8")])
        )
      else:
        await req.respond(Http404, "Not Found")
  )
