box::use(
  shiny[NS, tagList, moduleServer, conditionalPanel, downloadButton, observeEvent, downloadHandler],
  shinyjs[useShinyjs, runjs],
  shiny.fluent[CommandBarButton.shinyInput],
  utils[write.csv],
  dplyr[select, any_of]
)

#' Create an ui for a CommandBarButton.shinyInput that triggers an invisible downloadButton
#'
#' This function creates two buttons, CommandBarButton.shinyInput and downloadButton. However only
#' CommandBarButton.shinyInput is displayed to the user.
#'
#' @param id The module id
#' @return tagList
#'
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

#' Server function for triggering download from CommandBarButton.shinyInput
#'
#' This function handles triggering downloadButton when CommandBarButton.shinyInput button pressed.
#' Normally CommandBarButton.shinyInput does not have any download functionality, to achieve it
#' we click the invisible downloadButton using `shinyjs::runjs`
#'
#' @param id The module id
#' @param data Data that will be downloaded when the button pressed
#' @return
#'
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
