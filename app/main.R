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
    get_data, quake_data_read_realtime, quake_data_read,
    quake_types_func, quake_filter_func,
    top_quakes_func, selected_quake_func
  ],
  here[here]
)

# Box import of views
box::use(
  app / view / mapQuake,
  app / view / downloadData,
  app / view / typeSelect
)




# Use breakpoints based on the Appsilon design system
appsilon_breakpoints <- breakpointSystem(
  "appsilon-breakpoints",
  breakpoint("xs", min = 320),
  breakpoint("s", min = 428),
  breakpoint("m", min = 728),
  breakpoint("l", min = 1024),
  breakpoint("xl", min = 1200)
)


# Data wrangling ----------------------------------------------------------
quakes_data <- quake_data_read_realtime("data/quakes_last30Days.csv")

# R components ------------------------------------------------------------
quake_types <- quake_types_func(quakes_data)

# ===================
# ======= UI ========
# ===================

#' @export
ui <- function(id) {
  ns <- NS(id)
  # UI components ---------------------------------------------------------

  app_header <- gridPanel(
    id = "app_header",
    class = "mobile-collapsed",
    breakpoint_system = appsilon_breakpoints,
    areas = list(
      default = c(
        "logo . info mobile_controls",
        "separator separator separator separator",
        "title title title title",
        "menu menu menu menu",
        "cta cta cta cta"
      ),
      l = "logo separator title mobile_controls . info cta"
    ),
    columns = list(
      default = "auto 1fr auto auto",
      l = "auto 1px auto auto 1fr auto auto auto"
    ),
    rows = list(
      default = "auto auto auto auto auto",
      l = "40px"
    ),
    gap = list(
      default = "0px",
      l = "16px"
    ),
    logo = img(src = "static/appsilon-logo.png", id = ns("logo")),
    separator = div(class = "app_header_vertical_separator mobile-toggled"),
    title = div("Quakes explorer", class = "app_header_title mobile-toggled"),
    div(
      class = "header__right",
      downloadData$ui(ns("download")),
      CommandBarButton.shinyInput(
        ns("zoom_out"),
        iconProps = list(iconName = "FullScreen"), text = "Zoom out"
      ),
      Toggle.shinyInput(
        inputId = ns("btn_tog"),
        FALSE,
        onText = icon("moon"),
        offText = icon("sun"),
        inlineLabel =  TRUE
        )
    ),
    info = IconButton.shinyInput(
      "cta_info",
      class = "cta-icon",
      iconProps = list(iconName = "Info"),
      href = "https://github.com/Appsilon/quake_explorer_app",
      target = "_blank"
    ),
    cta = PrimaryButton.shinyInput(
      inputId = "cta_talk",
      text = "Let's Talk",
      class = "btn-primary btn-cta mobile-toggled",
      href = "https://appsilon.com/",
      target = "_blank"
    ),
    mobile_controls = div(
      icon(
        "bars",
        class = "header_control header_expand cta-icon",
        onclick = "App.headerExpand();"
      ),
      icon(
        "times",
        class = "header_control header_collapse cta-icon",
        onclick = "App.headerCollapse();"
      )
    )
  )


  app_sidebar <- div(
    id = "sidebar",
    h5("Filter quakes", class = "separator_fields"),
    Slider.shinyInput(
      ns("mag"),
      value = 4,
      min = 1,
      max = 6,
      label = "Minimum magnitude"
    ),
    typeSelect$ui(ns("typeSelect")),
    h5("Top quakes", class = "separator_fields"),
    flexPanel(
      id = "top_quakes_inputs",
      basis = c("85%", "10%"),
      wrap = "nowrap",
      align_content = "space-between",
      SpinButton.shinyInput(
        inputId = ns("n_quakes"),
        label = "Top:",
        value = 5,
        min = 1,
        max = 15
      )
    ),
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
    Text(
      variant = "medium",
      "Built with ❤ by Appsilon",
      id = "left_footer_text"
      ),
    Text(
      variant = "medium",
      nowrap = FALSE,
      "Data source: U.S. Geological Survey", id = "center_footer_text"
      ),
    Text(
      variant = "medium",
      nowrap = FALSE,
      "All rights reserved.",
      id = "right_footer_text"
      )
  )

  gridPage(
    tags$head(
      tags$script(
        src = "https://www.googletagmanager.com/gtag/js?id=G-FQQZL5V93G",
        async = ""),
      includeScript(
        path = here("app/static/js/gtag.js")
      )
    ),
    template = "grail-left-sidebar",
    gap = "10px",
    rows = list(
      default = "auto 1fr 30px",
      md = "auto auto 1fr 30px"
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
    ns <- session$ns

    type <- typeSelect$server("typeSelect", quakes_data, reactive(input$mag))

    quakes_filtered <- reactive({
      validate(need(type(), "Select at least 1 quake type"))
      req(input$mag)

      quake_filter_func(quakes_data, type(), input$mag)
    })

    downloadData$server("download", quakes_filtered)

    selected_quake <- eventReactive(input$quake_id, {
      selected_quake_func(quakes_filtered(), input$quake_id)
    })

    output$top_quakes <- renderUI({
      req(quakes_filtered)

      top_quakes_func(quakes_filtered(), input$n_quakes, ns)
    })

    mapQuake$server("map",
      quakes_data,
      quakes_filtered,
      selected_quake,
      reactive(input$zoom_out),
      reactive(input$btn_tog)
    )
  })
}
