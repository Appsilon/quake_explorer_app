box::use(
  shiny[...],
  glue[glue],
  stringr[...]
)

box::use(
  app / logic / magnitude_to_tnt[magnitude_to_tnt]
)

#' @export
make_popup <- function(place, time, mag, mag_type, depth) {
  time <- format(as.POSIXct(time, tz = "UTC"), tz = "America/New_York", "%Y-%m-%d %H:%M:%S")
  glue::glue(
    "
    <style>
      .t-title {{margin: 0; color: blue; font-size: 13px}}
      .popup-content p {{margin: 0;}}
    </style>
    <div class='popup-content'>
      <h3 class = 't-title'>{ str_to_title(place) }</h3>
      <p><b>Time: </b> { time } </p>
      <p><b>Magnitude: </b> { mag } { mag_type }</p>
      <p><b>Depth: </b> { depth } Km </p>
      <p><b>TNT Equivalent: </b> ~ {magnitude_to_tnt(mag)} tons</p>
    </div>
    "
  )
}
