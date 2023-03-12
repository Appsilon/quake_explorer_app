# Rhino / shinyApp entrypoint. Do not edit.
rhino::app()

box::use(
  app/view/mapQuake,
  app/logic/dataManipulation[quake_data_read, 
                             quake_types_func, quake_filter_func, 
                             top_quakes_func, selected_quake_func]
)

# functions -------------------------------------------------------------------
make_popup <- function(place, time, mag, depth){
  glue::glue(
    "
    <style>
      .t-title {{margin: 0; color: blue; font-size: 13px}}
      .popup-content p {{margin: 0;}}
    </style>
    <div class='popup-content'>
      <h3 class = 't-title'>{ str_to_title(place) }</h3>
      <p><b>Time: </b> { time } </p>
      <p><b>Magnitude: </b> { mag } </p>
      <p><b>Depth: </b> { depth } Km </p>
    </div>
    "
  )
}

display_quake <- function(mag, place, time, depth, id) {
  div(
    style = "display: flex;",
    class = "quake-container",
    id = id,
    onclick = "sentQuakeId(this.id)",
    h3(mag),
    div(
      h3(str_to_title(place)),
      div(
        class = "quake-metadata",
        p(time), 
        p(paste(mag, "km"))
      )
    )
  )
}

sendQuakeId <- "function sentQuakeId(element_id){Shiny.setInputValue('quake_id', element_id)}"

# Data wrangling ----------------------------------------------------------
quakes_data <- quake_data_read("data/quakes_may_2022.csv")

# R components ------------------------------------------------------------

map_points_palette <- colorNumeric(
  palette = "YlGnBu",
  domain = quakes_data$mag
)

## Header command bar
header_commandbar_list <- list(
  list(
    key = 'zoom_out', 
    text = "Zoom out", 
    iconProps = list(iconName = "FullScreen")
  ),
  list(
    key = 'download', 
    text = "Download data", 
    iconProps = list(iconName = "Download")
  )
)

quake_types <- quake_types_func(quakes_data)

# UI components ---------------------------------------------------------
app_header <- div(
  class = "header",
  div(
    class = "header__left",
    tags$a(
      href = "https://appsilon.com/",
      img(src = "appsilon-logo.png", style = "width: 150px")
    ),
    Text(variant = "xLarge", "| Quakes explorer", class="header__title")
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
  Slider.shinyInput("mag", value = 4, min = 1, max = 6, label = 'Minimun magnitude'),
  Dropdown.shinyInput(
    "type", value = "earthquake",
    options = quake_types, label = "Quake type"
  ),
  Separator("Top quakes"),
  flexPanel(
    id = "top_quakes_inputs",
    basis = c("85%", "10%"),
    wrap = "nowrap",
    align_content = "space-between",
    SpinButton.shinyInput(inputId = 'n_quakes', label = "Top:", value = 5, min = 1, max = 15),
    IconButton.shinyInput('zoom_out', iconProps = list("iconName" = "FullScreen"))
  ),
  tags$script(sendQuakeId),
  uiOutput('top_quakes')
)

app_content <- div(
  id="content",
  mapQuake$ui(ns('map'))
)

app_footer <- flexPanel(
  id = "footer",
  justify_content = 'space-between',
  gap = "20px",
  Text(variant = "medium", "Built with ❤ by Appsilon", block=TRUE),
  Text(variant = "medium", nowrap = FALSE, "Data source: U.S. Geological Survey"),
  Text(variant = "medium", nowrap = FALSE, "All rights reserved.")
)
# Application -------------------------------------------------------------
ui <- gridPage(
  tags$head(tags$link(rel="stylesheet", href = "quakes_style.css")),
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

server <- function(input, output, session) {
  
  quakes_filtered <- reactive({
    req(input$type)
    req(input$mag)
    
    quake_filter_func(quakes_data)
  })
  
  output$top_quakes <- renderUI({
    req(quakes_filtered)
    
    top_quakes_func(quakes_filtered)
  })
  
  
  selected_quake <- eventReactive(input$quake_id, {
    selected_quake_func(quakes_filtered)
  })
  
  mapQuake$server('map', data1 = quakes_filtered, data2 = selected_quake)
  
    
}

shinyApp(ui, server)

