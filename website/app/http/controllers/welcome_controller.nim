import std/json
  # framework
import basolato/controller
import basolato/core/base
import tiara/client
  # view
import ../views/pages/welcome_view
import ../views/pages/docs_view
import ../views/pages/components_view


proc index*(context:Context, params:Params):Future[Response] {.async.} =
  return render(welcomeView())

proc docs*(context:Context, params:Params):Future[Response] {.async.} =
  return render(docsView())

proc components*(context:Context, params:Params):Future[Response] {.async.} =
  return render(componentsView())

proc tiaraClientJs*(context:Context, params:Params):Future[Response] {.async.} =
  let headers = newHttpHeaders(true)
  headers["Content-Type"] = "application/javascript; charset=utf-8"
  return render(TiaraClientBundle, headers)

proc indexApi*(context:Context, params:Params):Future[Response] {.async.} =
  return render(%*{"message": "Basolato " & BasolatoVersion})
