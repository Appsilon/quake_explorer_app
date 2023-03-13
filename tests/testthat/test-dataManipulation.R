box::use(
  shiny[testServer],
  testthat[...],
  glue[glue]
)

box::use(
  app / logic / dataManipulation[...],
  app / logic / make_popup[...]
)


df <- quake_data_read("data/quakes_may_2022.csv")

test_that("quake_data_read() read csv files and generates correct popup", {
  # Create sample data
  df <- tibble::tibble(place = "New York", time = "2023-03-10 12:10 PM", mag = 2, depth = 3)
  path_csv <- tempfile()
  write.csv(df, path_csv, row.names = FALSE)
  
  func_result <- quake_data_read(path_csv)$popup
  expected_result <- glue::glue(
    "
    <style>
      .t-title {{margin: 0; color: blue; font-size: 13px}}
      .popup-content p {{margin: 0;}}
    </style>
    <div class='popup-content'>
      <h3 class = 't-title'>New York</h3>
      <p><b>Time: </b> 2023-03-10 12:10 PM </p>
      <p><b>Magnitude: </b> 2 </p>
      <p><b>Depth: </b> 3 Km </p>
    </div>
    "
  ) 
  
  expect_equal(func_result, expected_result)
  
})


test_that("quake_types_func() generates correct key text combinations",{
  
  expected_df <- tibble::tibble(key = c("earthquake", "explosion", "quarry blast", "ice quake"),
                                text = c("Earthquake", "Explosion", "Quarry Blast", "Ice Quake"))
  
  func_result <- quake_types_func(df) 
  
  expect_equal(func_result, expected_df)
  
  
})

test_that("quake_filter_func() filters correctly",{
  subset_columns = c("type", "mag", "magType")
  df <- df[1, subset_columns]
  expected_result <- tibble::tibble(type = "earthquake", mag = 4.2, magType = "mb")
  func_result<- quake_filter_func(df, "earthquake", 4.2)[1, subset_columns]
  expect_equal(func_result, expected_result)
  
})

# 
# test_that("top_quakes_func() generates correct HTML", {
#   df <- quake_data_read("data/quakes_may_2022.csv")
#   quakes_filtered <- quake_filter_func(df, "earthquake", 1)
#   expected_result <- list(
#     glue::glue(
# '<div style="display: flex;" class="quake-container" id="us7000hcmn" onclick="sentQuakeId(this.id)">
#   <h3>7.2</h3>
#   <div>
#     <h3>13 Km Wnw Of Azángaro, Peru</h3>
#     <div class="quake-metadata">
#       <p>2022-05-26 12:02:20</p>
#       <p>7.2 km</p>
#     </div>
#   </div>
# </div>'),
# glue::glue(
# '<div style="display: flex;" class="quake-container" id="us6000hm9j" onclick="sentQuakeId(this.id)">
#   <h3>6.9</h3>
#   <div>
#     <h3>Macquarie Island Region</h3>
#     <div class="quake-metadata">
#       <p>2022-05-19 10:13:31</p>
#       <p>6.9 km</p>
#     </div>
#   </div>
# </div>')
# )
#   
#   func_result <- top_quakes_func(quakes_filtered, 2)
#   
#   
#   expect_equal(func_result, expected_result)
#   
# })


test_that("selected_quake_func() generates correct latitudes and longitudes", {
  
  expected_result = list(lat = 19.151, lng = -155.452)
  quakes_filtered <- quake_filter_func(df, "earthquake", 1)
  func_result <- lapply(selected_quake_func(quakes_filtered, "hv73026242"), round, 3)
  expect_equal(func_result, expected_result)
  
})


