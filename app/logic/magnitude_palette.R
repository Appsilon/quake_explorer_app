#' Create a color palette for displaying quake magnitudes
#' This function returns a colorNumeric function that returns a color based on the given magnitude
#'
#' @return colorNumeric function
#'
#' @examples
#' palette <- magnitude_palette()
#' palette(5)
box::use(
  leaflet[colorNumeric],
  grDevices[colorRamp]
)

#' @export
magnitude_palette <- function() {
  colorNumeric(
    palette = colorRamp(
      c("#0049A9", "#33ADFA", "#02C9B1", "#F5B400", "#FA7C2E", "#FB4157", "#AF0000"),
      interpolate = "linear"
    ),
    domain = c(1, 10)
  )
}
