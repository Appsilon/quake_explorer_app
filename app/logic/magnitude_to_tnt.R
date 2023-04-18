#' Function for converting earthquake magnitude to tons of TNT
#'
#' This function calculates tons of TNT equivalent of earthquake magnitudes using the formula:
#' https://en.wikipedia.org/wiki/Moment_magnitude_scale#Comparison_with_TNT_equivalents
#' Result is rounded when its bigger than 1 for better display
#'
#' @param mag Earthquake magnitude
#' @return tons of TNT
#' @export
magnitude_to_tnt <- function(mag) {
  energy <- 10 ** (1.5 * mag + 4.8)
  tnt <- energy / ((5.25 * 10 ** 13) * 8e-05)
  round(tnt, ifelse(tnt < 1, 4, 0))
}
