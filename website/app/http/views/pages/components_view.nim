import ../../../../../examples/preview


proc componentsView*(): string =
  renderPreviewPage(
    clientScriptSrc = "/tiara-client",
    homeHref = "/",
    docsHref = "/docs",
    componentsHref = "/components"
  )
