import std/json
  # framework
import basolato/controller
import basolato/core/base
  # view
import ../views/pages/welcome_view
import ../views/pages/docs_view


proc index*(context:Context, params:Params):Future[Response] {.async.} =
  return render(welcomeView())

proc docs*(context:Context, params:Params):Future[Response] {.async.} =
  return render(docsView())

proc indexApi*(context:Context, params:Params):Future[Response] {.async.} =
  return render(%*{"message": "Basolato " & BasolatoVersion})
