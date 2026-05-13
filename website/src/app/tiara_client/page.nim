import crown/core except Response
import basolato/core/response
import tiara/client

proc page*(req: Request): Response =
  var headers = newHttpHeaders()
  headers["Content-Type"] = "application/javascript; charset=utf-8"
  disableLayout(render(Http200, TiaraClientBundle, headers))
