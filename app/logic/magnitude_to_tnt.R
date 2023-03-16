#' @export
magnitude_to_tnt <- function(mag) {
  energy <- 10 ** (1.5 * mag + 4.8)
  tnt <- energy / ((5.25 * 10 ** 13) * 8e-05)
  round(tnt, ifelse(tnt<1,4,0))
}
