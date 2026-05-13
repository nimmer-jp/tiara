import std/os
import crown/core as crown
import basolato except html
import std/asyncdispatch
import ../src/app/layout/layout as crown_layout_layout
import ../src/app/page as app_page
import ../src/app/components/page as app_components_page
import ../src/app/tiara_client/page as app_tiara_client_page
import ../src/app/docs/page as app_docs_page

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

let crownRoute1 = crownRouteRegister("get", "/components"):
    var res: crown.Response
    let req = crown.Request(context: c, params: p)
    when compiles(app_components_page.page(req, "")):
      when type(app_components_page.page(req, "")) is string:
        res = htmlResponse(app_components_page.page(req, ""))
      elif type(app_components_page.page(req, "")) is Html:
        res = htmlResponse(crown.crownTiaraHtmlToString(app_components_page.page(req, "")))
      elif type(app_components_page.page(req, "")) is Future[Html]:
        res = htmlResponse(crown.crownTiaraHtmlToString(await app_components_page.page(req, "")))
      elif type(app_components_page.page(req, "")) is crown.Response:
        res = app_components_page.page(req, "")
      else:
        res = await app_components_page.page(req, "")
    elif compiles(app_components_page.page(req)):
      when type(app_components_page.page(req)) is string:
        res = htmlResponse(app_components_page.page(req))
      elif type(app_components_page.page(req)) is Html:
        res = htmlResponse(crown.crownTiaraHtmlToString(app_components_page.page(req)))
      elif type(app_components_page.page(req)) is Future[Html]:
        res = htmlResponse(crown.crownTiaraHtmlToString(await app_components_page.page(req)))
      elif type(app_components_page.page(req)) is crown.Response:
        res = app_components_page.page(req)
      else:
        res = await app_components_page.page(req)
    else:
      # Fallback to pure Basolato signature for backwards compatibility
      when type(app_components_page.page(c, p)) is string:
        res = htmlResponse(app_components_page.page(c, p))
      elif type(app_components_page.page(c, p)) is Html:
        res = htmlResponse(crown.crownTiaraHtmlToString(app_components_page.page(c, p)))
      elif type(app_components_page.page(c, p)) is Future[Html]:
        res = htmlResponse(crown.crownTiaraHtmlToString(await app_components_page.page(c, p)))
      elif type(app_components_page.page(c, p)) is crown.Response:
        res = app_components_page.page(c, p)
      else:
        res = await app_components_page.page(c, p)
    
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

let crownRoute2 = crownRouteRegister("get", "/tiara_client"):
    var res: crown.Response
    let req = crown.Request(context: c, params: p)
    when compiles(app_tiara_client_page.page(req, "")):
      when type(app_tiara_client_page.page(req, "")) is string:
        res = htmlResponse(app_tiara_client_page.page(req, ""))
      elif type(app_tiara_client_page.page(req, "")) is Html:
        res = htmlResponse(crown.crownTiaraHtmlToString(app_tiara_client_page.page(req, "")))
      elif type(app_tiara_client_page.page(req, "")) is Future[Html]:
        res = htmlResponse(crown.crownTiaraHtmlToString(await app_tiara_client_page.page(req, "")))
      elif type(app_tiara_client_page.page(req, "")) is crown.Response:
        res = app_tiara_client_page.page(req, "")
      else:
        res = await app_tiara_client_page.page(req, "")
    elif compiles(app_tiara_client_page.page(req)):
      when type(app_tiara_client_page.page(req)) is string:
        res = htmlResponse(app_tiara_client_page.page(req))
      elif type(app_tiara_client_page.page(req)) is Html:
        res = htmlResponse(crown.crownTiaraHtmlToString(app_tiara_client_page.page(req)))
      elif type(app_tiara_client_page.page(req)) is Future[Html]:
        res = htmlResponse(crown.crownTiaraHtmlToString(await app_tiara_client_page.page(req)))
      elif type(app_tiara_client_page.page(req)) is crown.Response:
        res = app_tiara_client_page.page(req)
      else:
        res = await app_tiara_client_page.page(req)
    else:
      # Fallback to pure Basolato signature for backwards compatibility
      when type(app_tiara_client_page.page(c, p)) is string:
        res = htmlResponse(app_tiara_client_page.page(c, p))
      elif type(app_tiara_client_page.page(c, p)) is Html:
        res = htmlResponse(crown.crownTiaraHtmlToString(app_tiara_client_page.page(c, p)))
      elif type(app_tiara_client_page.page(c, p)) is Future[Html]:
        res = htmlResponse(crown.crownTiaraHtmlToString(await app_tiara_client_page.page(c, p)))
      elif type(app_tiara_client_page.page(c, p)) is crown.Response:
        res = app_tiara_client_page.page(c, p)
      else:
        res = await app_tiara_client_page.page(c, p)
    
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

let crownRoute3 = crownRouteRegister("get", "/docs"):
    var res: crown.Response
    let req = crown.Request(context: c, params: p)
    when compiles(app_docs_page.page(req, "")):
      when type(app_docs_page.page(req, "")) is string:
        res = htmlResponse(app_docs_page.page(req, ""))
      elif type(app_docs_page.page(req, "")) is Html:
        res = htmlResponse(crown.crownTiaraHtmlToString(app_docs_page.page(req, "")))
      elif type(app_docs_page.page(req, "")) is Future[Html]:
        res = htmlResponse(crown.crownTiaraHtmlToString(await app_docs_page.page(req, "")))
      elif type(app_docs_page.page(req, "")) is crown.Response:
        res = app_docs_page.page(req, "")
      else:
        res = await app_docs_page.page(req, "")
    elif compiles(app_docs_page.page(req)):
      when type(app_docs_page.page(req)) is string:
        res = htmlResponse(app_docs_page.page(req))
      elif type(app_docs_page.page(req)) is Html:
        res = htmlResponse(crown.crownTiaraHtmlToString(app_docs_page.page(req)))
      elif type(app_docs_page.page(req)) is Future[Html]:
        res = htmlResponse(crown.crownTiaraHtmlToString(await app_docs_page.page(req)))
      elif type(app_docs_page.page(req)) is crown.Response:
        res = app_docs_page.page(req)
      else:
        res = await app_docs_page.page(req)
    else:
      # Fallback to pure Basolato signature for backwards compatibility
      when type(app_docs_page.page(c, p)) is string:
        res = htmlResponse(app_docs_page.page(c, p))
      elif type(app_docs_page.page(c, p)) is Html:
        res = htmlResponse(crown.crownTiaraHtmlToString(app_docs_page.page(c, p)))
      elif type(app_docs_page.page(c, p)) is Future[Html]:
        res = htmlResponse(crown.crownTiaraHtmlToString(await app_docs_page.page(c, p)))
      elif type(app_docs_page.page(c, p)) is crown.Response:
        res = app_docs_page.page(c, p)
      else:
        res = await app_docs_page.page(c, p)
    
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

let crownRoute4 = crownRouteRegister("get", "/routes"):
    var html = """<!DOCTYPE html><html><head><meta charset="utf-8"><title>Crown Routes</title><script src="https://cdn.tailwindcss.com"></script></head><body class="bg-gray-50 text-gray-800 p-8"><div class="max-w-4xl mx-auto"><h1 class="text-3xl font-bold mb-6">👑 Crown Registered Routes</h1><div class="bg-white shadow rounded-lg overflow-hidden"><table class="min-w-full"><thead class="bg-gray-100"><tr><th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Path</th><th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">File</th><th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Methods</th></tr></thead><tbody class="divide-y divide-gray-200">"""
    html &= """<tr class="hover:bg-gray-50"><td class="px-6 py-4 whitespace-nowrap font-mono text-sm text-blue-600"><a href="/">/</a></td><td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">src/app/page.nim</td><td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 font-mono">PAGE</td></tr>"""
    html &= """<tr class="hover:bg-gray-50"><td class="px-6 py-4 whitespace-nowrap font-mono text-sm text-blue-600"><a href="/components">/components</a></td><td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">src/app/components/page.nim</td><td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 font-mono">PAGE</td></tr>"""
    html &= """<tr class="hover:bg-gray-50"><td class="px-6 py-4 whitespace-nowrap font-mono text-sm text-blue-600"><a href="/tiara_client">/tiara_client</a></td><td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">src/app/tiara_client/page.nim</td><td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 font-mono">PAGE</td></tr>"""
    html &= """<tr class="hover:bg-gray-50"><td class="px-6 py-4 whitespace-nowrap font-mono text-sm text-blue-600"><a href="/docs">/docs</a></td><td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">src/app/docs/page.nim</td><td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 font-mono">PAGE</td></tr>"""
    html &= """</tbody></table></div></div></body></html>"""
    return htmlResponse(html)

when compiles(Routes.merge(@[])):
  let routes* = Routes.merge(@[crownRoute0, crownRoute1, crownRoute2, crownRoute3, crownRoute4])
else:
  let routes* = @[crownRoute0, crownRoute1, crownRoute2, crownRoute3, crownRoute4]
