box::use(
    shiny[...],
    glue[glue]
)

display_quake <- function(mag, place, time, depth, id) {
  div(
    style = "display: flex;",
    class = "quake-container",
    id = id,
    onclick = "sentQuakeId(this.id)",
    h3(mag),
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
