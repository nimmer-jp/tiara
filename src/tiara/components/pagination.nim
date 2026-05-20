import std/strutils
import ../builder
import ./utils
export utils

proc buildPageHref*(basePath: string, pageParam: string, page: int,
    extraQuery: string): string =
  let separator =
    if basePath.contains('?'):
      "&"
    else:
      "?"
  var href = basePath & separator & pageParam & "=" & $page
  let extra = extraQuery.strip()
  if extra.len > 0:
    let extraSep = if extra.startsWith("&"): "" else: "&"
    href.add extraSep & extra
  href

proc paginationLink*(
  T: typedesc[Tiara],
  label: string,
  href: string,
  active = false,
  disabled = false,
  attrs: seq[(string, string)] = @[]
): Html =
  let classes = classList([
    "pagination-link",
    if active: "is-active" else: "",
    if disabled: "is-disabled" else: "",
  ])
  var linkAttrs = mergeAttrs(@[
    ("class", classes),
    ("href", if disabled: "#" else: href),
    ("aria-current", if active: "page" else: ""),
  ], attrs)
  if disabled:
    linkAttrs.add(("aria-disabled", "true"))

  el("a", textNode(label), linkAttrs)

proc pagination*(
  T: typedesc[Tiara],
  currentPage: int,
  totalPages: int,
  basePath: string,
  pageParam = "page",
  extraQuery = "",
  siblingCount = 1,
  prevLabel = "前へ",
  nextLabel = "次へ",
  attrs: seq[(string, string)] = @[]
): Html =
  ## Page-number pagination for admin list views.
  var pageCount = totalPages
  if pageCount < 1:
    pageCount = 1
  let page = currentPage.clamp(1, pageCount)

  var links: seq[Html] = @[]

  links.add Tiara.paginationLink(
    prevLabel,
    buildPageHref(basePath, pageParam, page - 1, extraQuery),
    disabled = page <= 1,
    attrs = @[("class", "pagination-prev"), ("rel", "prev")]
  )

  var seenEllipsisBefore = false
  var seenEllipsisAfter = false
  for pageNum in 1 .. pageCount:
    let isEdge = pageNum == 1 or pageNum == totalPages
    let isNear = abs(pageNum - page) <= siblingCount
    if not isEdge and not isNear:
      if pageNum < page and not seenEllipsisBefore:
        links.add el("span", textNode("…"), @[("class", "pagination-ellipsis"), ("aria-hidden", "true")])
        seenEllipsisBefore = true
      elif pageNum > page and not seenEllipsisAfter:
        links.add el("span", textNode("…"), @[("class", "pagination-ellipsis"), ("aria-hidden", "true")])
        seenEllipsisAfter = true
      continue

    links.add Tiara.paginationLink(
      $pageNum,
      buildPageHref(basePath, pageParam, pageNum, extraQuery),
      active = pageNum == page
    )

  links.add Tiara.paginationLink(
    nextLabel,
    buildPageHref(basePath, pageParam, page + 1, extraQuery),
    disabled = page >= pageCount,
    attrs = @[("class", "pagination-next"), ("rel", "next")]
  )

  el(
    "nav",
    el("div", joinHtml(links), @[("class", "pagination-links")]),
    mergeAttrs(@[
      ("class", "pagination"),
      ("data-tiara", "pagination"),
      ("aria-label", "Pagination"),
    ], attrs)
  )
