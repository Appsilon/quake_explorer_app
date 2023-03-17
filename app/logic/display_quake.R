box::use(
  shiny[...],
  glue[glue],
  stringr[str_to_title]
)

#' @export
display_quake <- function(mag, place, time, depth, id, ns) {
  div(
    style = "display: flex;",
    class = "quake-container",
    id = id,
    onclick = glue("App.sentQuakeId('{ns}',this.id)"),
    h3(mag),
    div(
      h3(str_to_title(place)),
      div(
        class = "quake-metadata",
        p(format(as.POSIXct(time, tz = "UTC"), tz = "America/New_York", "%Y-%m-%d %H:%M:%S")),
        p(paste(mag, "km"))
      )
    )
  )
}
