#' @export
magnitude_to_tnt <- function(mag) {
  energy <- 10 ** (1.5 * mag + 4.8)
  energy / ((5.25 * 10 ** 13) * 8e-05)
}
