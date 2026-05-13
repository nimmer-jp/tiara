import crown/core
import ../views/docs_page

proc page*(req: Request): Response =
  disableLayout(htmlResponse(docs_page.fullHtml()))
