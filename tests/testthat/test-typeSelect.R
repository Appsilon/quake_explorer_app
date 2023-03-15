box::use(
  shiny[...]
)

box::use(
  app / view / typeSelect,
  app / logic / dataManipulation[quake_data_read]
)

test_that("typeSelect only includes types in the dataset",{
  
  data <- quake_data_read(file = "test-data.csv")
  
  min_mags <- 0:10
  
  for (min_mag in min_mags) {
    
    filtered_types_groundtruth <- unique(data[data$mag >= min_mag, "type"])
    
    testServer(app = typeSelect$server,args = list(data = data, reactiveVal(min_mag)),expr = {
      expect_equal(sort(filtered_types()[["key"]]), sort(filtered_types_groundtruth$type))
    })
    
    
  }
  
})

test_that("typeSelect renders a dropdown input", {
  local_edition(3)
  testServer(app = typeSelect$server,args = list(data = data, reactiveVal(3)),expr = {
    expect_snapshot(output$typeSelect$html)
    })
  
  
})