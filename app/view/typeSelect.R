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

      # Update selectInput by only allowing choices contained in the dataset
      output$typeSelect <- renderUI({
        req(min_mag())
        contained_choices <- data |>
          filter(mag >= min_mag()) |>
          quake_types_func()
        Dropdown.shinyInput(
          ns("type"),
          value = "earthquake",
          options = contained_choices, label = "Quake type"
        )
      })

      reactive(input$type)
    }
  )
}
