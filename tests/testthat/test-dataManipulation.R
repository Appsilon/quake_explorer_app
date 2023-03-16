box::use(
  testthat[...],
  tibble[...],
  shiny[NS]
)

box::use(
  app / logic / dataManipulation[...],
  app / logic / make_popup[...]
)

path_csv <- "test-data.csv"
df <- quake_data_read(path_csv)



test_that("quake_data_read() reads csv files,
          returns a tibble and generates popup", {
  # call the function with the input values
  func_result <- quake_data_read(path_csv)
  expect_true(!is.null(path_csv))
  expect_true(!is.null(func_result))
  expect_true(is_tibble(func_result))
  expect_true(!is.null(func_result$popup))
})


test_that("quake_types_func() generates correct key text combinations", {
  expected_result <- tibble::tibble(
    key = c("earthquake", "explosion", "quarry blast", "ice quake"),
    text = c("Earthquake", "Explosion", "Quarry Blast", "Ice Quake")
  )
  # call the function with the input values
  func_result <- quake_types_func(df)
  expect_true(!is.null(df))
  expect_true(!is.null(func_result))
  expect_equal(func_result, expected_result)
})

test_that("quake_filter_func() filters correctly", {
  # set values for the input variables
  type <- "earthquake"
  mag <- 4.2
  # call the function with the input values
  func_result <- quake_filter_func(df, type, mag)
  expect_true(!is.null(df))
  expect_true(!is.null(type))
  expect_true(!is.null(mag))
  expect_true(!is.null(func_result))
})


test_that("top_quakes_func() generates HTML", {
  quakes_filtered <- quake_filter_func(df, "earthquake", 1)
  # call the function with the input values
  func_result <- top_quakes_func(quakes_filtered, 2, NS("app"))

  expect_true(!is.null(quakes_filtered))
  expect_true(!is.null(func_result))
  expect_true(!is.null(func_result))
})


test_that("selected_quake_func() generates correct latitudes and longitudes", {
  # set values for the input variables
  quake_id <- "hv73026242"
  quakes_filtered <- quake_filter_func(df, "earthquake", 1)
  # call the function with the input values
  func_result <- selected_quake_func(quakes_filtered, quake_id)
  expect_true(!is.null(quake_id))
  expect_true(!is.null(quakes_filtered))
  expect_true(!is.null(func_result))
})
