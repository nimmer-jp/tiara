import ../builder
import ./utils
export utils

type
  TableColumn* = object
    id*: string
    label*: string
    align*: string = ""

  TableRowBuilder* = object
    cells*: seq[Html]
    attrs*: seq[(string, string)]

proc tableCell*(
  value: string,
  align = "",
  attrs: seq[(string, string)] = @[]
): Html =
  ## Render a table cell with an auto-escaped string value.
  var cellAttrs = attrs
  if align.len > 0:
    cellAttrs = mergeAttrs(@[("class", "data-table-cell-align-" & align)], cellAttrs)
  el("td", textNode(value), cellAttrs)

proc tableCellNode*(
  content: Html,
  align = "",
  attrs: seq[(string, string)] = @[]
): Html =
  ## Render a table cell from pre-built Html (badges, buttons, inline forms).
  var cellAttrs = attrs
  if align.len > 0:
    cellAttrs = mergeAttrs(@[("class", "data-table-cell-align-" & align)], cellAttrs)
  el("td", content, cellAttrs)

proc tableRow*(
  cells: openArray[Html],
  attrs: seq[(string, string)] = @[]
): Html =
  el("tr", joinHtml(cells), attrs)

proc tableRowBuilder*(): TableRowBuilder =
  TableRowBuilder(cells: @[], attrs: @[])

proc withCell*(
  builder: TableRowBuilder,
  value: string,
  align = "",
  attrs: seq[(string, string)] = @[]
): TableRowBuilder =
  result = builder
  result.cells.add tableCell(value, align, attrs)

proc withCellNode*(
  builder: TableRowBuilder,
  content: Html,
  align = "",
  attrs: seq[(string, string)] = @[]
): TableRowBuilder =
  result = builder
  result.cells.add tableCellNode(content, align, attrs)

proc build*(builder: TableRowBuilder): Html =
  tableRow(builder.cells, builder.attrs)

proc dataTable*(
  T: typedesc[Tiara],
  columns: seq[TableColumn],
  rows: seq[Html],
  emptyMessage = "データがありません",
  emptyState: Html = rawHtml(""),
  variant = "striped",
  attrs: seq[(string, string)] = @[]
): Html =
  ## Column-driven data table with optional empty state and striped rows.
  var headerCells: seq[Html] = @[]
  for column in columns:
    var thAttrs = @[("scope", "col")]
    if column.align.len > 0:
      thAttrs.add(("class", "data-table-cell-align-" & column.align))
    headerCells.add(el("th", textNode(column.label), thAttrs))

  let thead = el("thead", el("tr", joinHtml(headerCells), @[]), @[])
  let tbody =
    if rows.len == 0:
      let emptyContent =
        if ($emptyState).strip.len > 0:
          emptyState
        else:
          el("p", textNode(emptyMessage), @[("class", "data-table-empty-message")])
      el(
        "tbody",
        el(
          "tr",
          el(
            "td",
            emptyContent,
            @[("colspan", $max(columns.len, 1)), ("class", "data-table-empty")]
          ),
          @[]
        ),
        @[]
      )
    else:
      el("tbody", joinHtml(rows), @[])

  let classes = classList([
    "data-table",
    if variant.len > 0: "data-table-" & variant else: "",
  ])

  el(
    "div",
    el(
      "table",
      joinHtml([thead, tbody]),
      @[("class", "data-table-grid")]
    ),
    mergeAttrs(@[
      ("class", classes),
      ("data-tiara", "data-table"),
    ], attrs)
  )

proc table*(
  T: typedesc[Tiara],
  columns: seq[string],
  rows: seq[seq[string]],
  emptyMessage = "データがありません",
  variant = "striped",
  attrs: seq[(string, string)] = @[]
): Html =
  ## Convenience wrapper for string-only tables with auto-escaped cells.
  var tableColumns: seq[TableColumn] = @[]
  for label in columns:
    tableColumns.add TableColumn(id: label, label: label)

  var tableRows: seq[Html] = @[]
  for row in rows:
    var cells: seq[Html] = @[]
    for cell in row:
      cells.add tableCell(cell)
    tableRows.add tableRow(cells)

  dataTable(
    T,
    tableColumns,
    tableRows,
    emptyMessage = emptyMessage,
    variant = variant,
    attrs = attrs
  )
