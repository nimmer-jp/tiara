import std/strformat

proc siteShell*(title: string; mainInner: string): string =
  result = fmt"""<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>{title}</title>
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&amp;family=Outfit:wght@400;700&amp;display=swap" rel="stylesheet" />
  <link rel="stylesheet" href="/css/styles.css" />
</head>
<body>
{mainInner}
<script src="/js/script.js" defer></script>
</body>
</html>"""
