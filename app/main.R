# Box import of external libraries
box::use(
  shiny[...],
  shiny.fluent[...],
  stringr[str_to_title],
  imola[...],
  dplyr[...],
  readr[read_csv],
  logger[log_info, log_debug, log_error],
  bslib[bs_theme, font_google],
  leaflet[...],
  app / logic / dataManipulation[
    quake_data_read,
    quake_types_func, quake_filter_func,
    top_quakes_func, selected_quake_func
  ],
)

# Box import of views
box::use(
  app / view / mapQuake
)

# preprocessing and elements to be used inside UI and Server
send_quake_id <- "function sentQuakeId(element_id){Shiny.setInputValue('quake_id', element_id)}"

# Data wrangling ----------------------------------------------------------
quakes_data <- quake_data_read("data/quakes_may_2022.csv")

# R components ------------------------------------------------------------

## Header command bar
header_commandbar_list <- list(
  list(
    key = "zoom_out",
    text = "Zoom out",
    iconProps = list(iconName = "FullScreen")
  ),
  list(
    key = "download",
    text = "Download data",
    iconProps = list(iconName = "Download")
  )
)

quake_types <- quake_types_func(quakes_data)

# ===================
# ======= UI ========
# ===================

#' @export
ui <- function(id) {
  ns <- NS(id)

  # UI components ---------------------------------------------------------
  app_header <- div(
    class = "header",
    div(
      class = "header__left",
      tags$a(
        href = "https://appsilon.com/",
        img(src = "static/appsilon-logo.png", style = "width: 150px")
      ),
      Text(variant = "xLarge", "| Quakes explorer", class = "header__title")
    ),
    div(
      class = "header__right",
      CommandBar(items = header_commandbar_list),
      tags$a(href = "https://appsilon.com/#contact", "Let's Talk", class = "header__link")
    )
  )

  app_sidebar <- div(
    id = "sidebar",
    Separator("Filter quakes"),
    Slider.shinyInput(ns("mag"), value = 4, min = 1, max = 6, label = "Minimun magnitude"),
    Dropdown.shinyInput(
      ns("type"),
      value = "earthquake",
      options = quake_types, label = "Quake type"
    ),
    Separator("Top quakes"),
    flexPanel(
      id = "top_quakes_inputs",
      basis = c("85%", "10%"),
      wrap = "nowrap",
      align_content = "space-between",
      SpinButton.shinyInput(inputId = ns("n_quakes"), label = "Top:", value = 5, min = 1, max = 15),
      IconButton.shinyInput(ns("zoom_out"), iconProps = list("iconName" = "FullScreen"))
    ),
    tags$script(send_quake_id),
    uiOutput(ns("top_quakes"))
  )

  app_content <- div(
    id = "content",
    mapQuake$ui(ns("map"))
  )

  app_footer <- flexPanel(
    id = "footer",
    justify_content = "space-between",
    gap = "20px",
    Text(variant = "medium", "Built with ❤ by Appsilon", block = TRUE),
    Text(variant = "medium", nowrap = FALSE, "Data source: U.S. Geological Survey"),
    Text(variant = "medium", nowrap = FALSE, "All rights reserved.")
  )

  gridPage(
    tags$head(tags$link(rel = "stylesheet", href = "quakes_style.css")),
    template = "grail-left-sidebar",
    gap = "10px",
    rows = list(
      default = "70px 1fr 30px"
    ),
    header = app_header,
    sidebar = app_sidebar,
    content = app_content,
    footer = app_footer
  )
}

# ===================
# === SERVER ========
# ===================

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    quakes_filtered <- reactive({
      req(input$type)
      req(input$mag)

      quake_filter_func(quakes_data, input$type, input$mag)
    })

    selected_quake <- eventReactive(input$quake_id, {
      selected_quake_func(quakes_filtered, input$quake_id)
    })

    output$top_quakes <- renderUI({
      req(quakes_filtered)

      top_quakes_func(quakes_filtered, input$n_quakes)
    })

    mapQuake$server("map", quakes_filtered, selected_quake)
  })
}
