box::use(
  shiny[NS, tagList, moduleServer, uiOutput, renderUI, req, reactive, tags, checkboxGroupInput,
        tagAppendAttributes, observe, updateCheckboxGroupInput],
  dplyr[filter]
)

box::use(
  app/logic/dataManipulation[quake_types_func]
)


#' @export
ui <- function(id) {
  ns <- NS(id)
  tags$div(id = "quake-types",
      checkboxGroupInput(ns("quakeTypes"), label = "Quake Type", 
                         choices = c("Earthquake" = "earthquake", 
                                     "Explosion" = "explosion", 
                                     "Quarry Blast" = "quarry blast", 
                                     "Ice Quake" = "ice quake"),
                         selected = c("earthquake"), 
                         inline = FALSE) |>
        tagAppendAttributes(class = "quake-type-toggle")
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
        data |>
          filter(mag >= min_mag()) |>
          quake_types_func()
      })

      # Update checkboxGroup by only checking choices contained in the dataset
      observe({
        updateCheckboxGroupInput(inputId = "quakeTypes",
                                 selected = filtered_types()$key)
      })

      # return the rendered input's value
      reactive(input$quakeTypes)
    }
  )
}
