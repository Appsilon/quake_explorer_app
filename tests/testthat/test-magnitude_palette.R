box::use(
  app / logic / magnitude_palette[magnitude_palette]
)

test_that("magnitude_palette returns a function", {
  palette <- magnitude_palette()
  expect_true(inherits(palette,"function"))
})