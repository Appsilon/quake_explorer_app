box::use(
  app / logic / magnitude_to_tnt[magnitude_to_tnt]
)

test_that("magnitude_to_tnt returns correct tnt equivalent", {
  mags <- 1:10
  equivalent <- c(0.0005, 0.0150, 0.4751, 15, 475, 15023, 475062, 15022794, 475062456, 15022793916)
  expect_equal(magnitude_to_tnt(mags), equivalent)
})

test_that("magnitude_to_tnt returns decimal when tnt equilavent < 0", {
  expect_match(as.character(magnitude_to_tnt(1)), "\\d\\.\\d")
})
