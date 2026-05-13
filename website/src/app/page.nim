import crown/core
import ./views/home

proc page*(req: Request): Response =
  disableLayout(htmlResponse(home.fullHtml()))
