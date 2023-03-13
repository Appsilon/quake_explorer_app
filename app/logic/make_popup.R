box::use(
    shiny[...],
    glue[glue],
    stringr[...]
)

#' @export
make_popup <- function(place, time, mag, depth) {
  glue::glue(
    "
    <style>
      .t-title {{margin: 0; color: blue; font-size: 13px}}
      .popup-content p {{margin: 0;}}
    </style>
    <div class='popup-content'>
      <h3 class = 't-title'>{ str_to_title(place) }</h3>
      <p><b>Time: </b> { time } </p>
      <p><b>Magnitude: </b> { mag } </p>
      <p><b>Depth: </b> { depth } Km </p>
    </div>
    "
  )
}