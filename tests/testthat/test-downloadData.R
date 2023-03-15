box::use(
  shiny[testServer, reactiveVal],
  utils[head]
)
box::use(
  app / view / downloadData,
  app / logic / dataManipulation[quake_data_read]
)

df <- reactiveVal(quake_data_read("test-data.csv") |> head())

test_that("downloadData does not return additional columns", {
  testServer(app = downloadData$server, args = list(data = df), expr = {
    download_data <- read.csv(output$downloadData)
    expect_equal(
      sort(names(download_data)),
      c(
        "depth", "depthError", "dmin", "gap", "horizontalError",
        "id", "latitude", "locationSource", "longitude", "mag",
        "magError", "magNst", "magSource", "magType", "net", "nst",
        "place", "rms", "status", "time", "type", "updated"
      )
    )
  })
})
