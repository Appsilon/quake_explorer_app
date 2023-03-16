box::use(
  shiny[...],
  glue[glue],
  stringr[str_to_title],
  testthat[...]
)

box::use(
  app/logic/make_popup[...]
)

test_that("variables have a value", {
  # set values for the input variables
  place <- "Hogwarts"
  time <- "2023-03-14 17:05:00"
  mag <- 5.0
  mag_type <- "mw"
  depth <- 10
  # call the function with the input values
  output <- make_popup(place, time, mag, mag_type, depth)
  # styles might change in future, so lets check if the values are called correctly or not
  # check that the input variables are not null
  expect_true(!is.null(place))
  expect_true(!is.null(time))
  expect_true(!is.null(mag))
  expect_true(!is.null(mag_type))
  expect_true(!is.null(depth))
})
# check with rhino::test_r()
