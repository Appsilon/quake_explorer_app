box::use(
  shiny[NS, tagList, moduleServer, uiOutput, renderUI, req, reactive],
  dplyr[filter],
  shiny.fluent[Dropdown.shinyInput]
)

box::use(
  app/logic/dataManipulation[quake_types_func]
)


#' @export
ui <- function(id) {
  ns <- NS(id)
  tagList(
    uiOutput(ns("typeSelect"))
  )
}

#' @export
server <- function(id, data, min_mag) {
  moduleServer(
    id,
    function(input, output, session) {
      ns <- session$ns
      
      filtered_types <- reactive({
        req(min_mag())
        options <- data |>
          filter(mag >= min_mag()) |>
          quake_types_func()
      })

      # Update selectInput by only allowing choices contained in the dataset
      output$typeSelect <- renderUI({
        Dropdown.shinyInput(
          ns("type"),
          value = "earthquake",
          options = filtered_types(), label = "Quake type"
        )
      })

      #return the rendered input's value
      reactive(input$type)
    }
  )
}
