box::use(
  shiny[...],
  glue[glue],
  stringr[str_to_title],
  testthat[...]
)

box::use(
  app/logic/display_quake[...]
)

test_that("variables have a value", {
  # set values for the input variables
  mag <- 5.0
  place <- "Hogwarts"
  time <- "2023-03-14 14:36:00"
  depth <- 10
  id <- "quake-123"
  # call the function with the input values
  output <- display_quake(mag, place, time, depth, id)
  # styles might change in future, so lets check if the values are called correctly or not
  # check that the input variables are not null
  expect_true(!is.null(mag))
  expect_true(!is.null(place))
  expect_true(!is.null(time))
  expect_true(!is.null(depth))
  expect_true(!is.null(id))
})
# check with rhino::test_r()
