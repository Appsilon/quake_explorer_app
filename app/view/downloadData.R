box::use(
  shiny[NS, tagList, moduleServer, conditionalPanel, downloadButton, observeEvent, downloadHandler],
  shinyjs[useShinyjs, runjs],
  shiny.fluent[CommandBarButton.shinyInput],
  utils[write.csv],
  dplyr[select, any_of]
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  tagList(
    useShinyjs(),
    CommandBarButton.shinyInput(
      ns("download"),
      iconProps = list(iconName = "Download"), text = "Download"
    ),
    conditionalPanel(
      "false", # create an invisible download button
      downloadButton(ns("downloadData"))
    )
  )
}

#' @export
server <- function(id, data) {
  moduleServer(
    id,
    function(input, output, session) {
      ns <- session$ns
      # click the *actual* download button when the CommandBarButton is clicked
      observeEvent(input$download, {
        runjs(paste0("$('#", ns("downloadData"), "')[0].click();"))
      })

      output$downloadData <- downloadHandler(
        filename = function() {
          "quake_explorer_data.csv"
        },
        content = function(file) {
          data() |>
            select(-any_of("popup")) |>
            write.csv(file, row.names = FALSE)
        }
      )
    }
  )
}