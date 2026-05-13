import std/os
import crown/core as crown
import basolato except html
import std/asyncdispatch
import ../src/app/page as app_page

let crownRoute0 = crownRouteRegister("get", "/"):
    var res: crown.Response
    let req = crown.Request(context: c, params: p)
    when compiles(app_page.page(req, "")):
      when type(app_page.page(req, "")) is string:
        res = htmlResponse(app_page.page(req, ""))
      elif type(app_page.page(req, "")) is Html:
        res = htmlResponse(crown.crownTiaraHtmlToString(app_page.page(req, "")))
      elif type(app_page.page(req, "")) is Future[Html]:
        res = htmlResponse(crown.crownTiaraHtmlToString(await app_page.page(req, "")))
      elif type(app_page.page(req, "")) is crown.Response:
        res = app_page.page(req, "")
      else:
        res = await app_page.page(req, "")
    elif compiles(app_page.page(req)):
      when type(app_page.page(req)) is string:
        res = htmlResponse(app_page.page(req))
      elif type(app_page.page(req)) is Html:
        res = htmlResponse(crown.crownTiaraHtmlToString(app_page.page(req)))
      elif type(app_page.page(req)) is Future[Html]:
        res = htmlResponse(crown.crownTiaraHtmlToString(await app_page.page(req)))
      elif type(app_page.page(req)) is crown.Response:
        res = app_page.page(req)
      else:
        res = await app_page.page(req)
    else:
      # Fallback to pure Basolato signature for backwards compatibility
      when type(app_page.page(c, p)) is string:
        res = htmlResponse(app_page.page(c, p))
      elif type(app_page.page(c, p)) is Html:
        res = htmlResponse(crown.crownTiaraHtmlToString(app_page.page(c, p)))
      elif type(app_page.page(c, p)) is Future[Html]:
        res = htmlResponse(crown.crownTiaraHtmlToString(await app_page.page(c, p)))
      elif type(app_page.page(c, p)) is crown.Response:
        res = app_page.page(c, p)
      else:
        res = await app_page.page(c, p)
    
    var contentType = ""
    if res.headers.hasKey("Content-Type"): contentType = $res.headers["Content-Type"]
    elif res.headers.hasKey("content-type"): contentType = $res.headers["content-type"]
    let isLayoutEnabled = true and not res.headers.hasKey("Crown-Disable-Layout")
    if contentType.contains("text/html") and isLayoutEnabled:
      var htmlContent = res.body()
      when compiles(crown_layout_layout.layout(htmlContent)):
        htmlContent = crown_layout_layout.layout(htmlContent)
      htmlContent = injectCrownSystem(htmlContent)
      res = htmlResponse(htmlContent, res.status)
    return res

when compiles(Routes.merge(@[])):
  let routes* = Routes.merge(@[crownRoute0])
else:
  let routes* = @[crownRoute0]
