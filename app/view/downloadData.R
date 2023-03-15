box::use(
  shiny[NS, tagList, moduleServer, conditionalPanel, downloadButton, observeEvent, downloadHandler],
  shinyjs[useShinyjs, runjs],
  shiny.fluent[CommandBarButton.shinyInput],
  utils[write.csv],
  dplyr[select]
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
      #click the *actual* download button when the CommandBarButton is clicked
      observeEvent(input$download, {runjs(paste0("$('#",ns("downloadData"),"')[0].click();"))})
      
      output$downloadData <- downloadHandler(
        filename = function() {
          paste("quake_data-", Sys.Date(), ".csv", sep="")
        },
        content = function(file) {
          data() |>
            write.csv(file, row.names = FALSE)
        }
      )
    }
  )
}