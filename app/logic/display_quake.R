box::use(
  shiny[...],
  glue[glue],
  stringr[str_to_title],
  app / logic / magnitude_palette[magnitude_palette]
)

palette <- magnitude_palette()

#' @export
display_quake <- function(mag, place, time, depth, id, ns) {
  div(
    style = "display: flex;",
    class = "quake-container",
    id = id,
    onclick = glue("App.sentQuakeId('{ns}',this.id)"),
    h3(mag,style = paste("color",palette(mag),sep = ":")),
    div(
      h3(str_to_title(place)),
      div(
        class = "quake-metadata",
        p(time),
        p(paste(mag, "km"))
      )
    )
  )
}
