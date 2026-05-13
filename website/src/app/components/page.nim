import crown/core
import preview

proc page*(req: Request): Response =
  let html = renderCatalogDocument(
    "Tiara Lab — Component Playground",
    "/tiara_client",
    "/",
    "/docs",
    "/components",
  )
  disableLayout(htmlResponse(html))
