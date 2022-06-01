# Packages ----------------------------------------------------------------
library(shiny)
library(shiny.fluent)
library(imola)
library(shiny)
library(imola)
library(stringr)
library(dplyr)
library(readr)
library(leaflet)
library(glue)
library(purrr)

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
quakes_data <- read_csv("data/quakes_may_2022.csv")|>
  mutate(popup = make_popup(place, time, mag, depth))

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

quake_types <- quakes_data |>
  distinct(type) |>
  mutate(text = str_to_title(type)) |>
  rename(key = type)

# UI components ---------------------------------------------------------
app_header <- flexPanel(
  id = "header",
  align_items = "center",
  flex = c(0, 1, 0),
  img(src = "appsilon-logo.png", style = "width: 150px"),
  div(
    Text(variant = "xLarge", "| Quakes explorer", style="color: gray;"), 
    style = "margin-bottom: 10px;"),
  CommandBar(items = header_commandbar_list),
  style = "box-shadow: 0 0 10px #000;"
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
  leafletOutput('map', height = "100%")
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
    
    quakes_data |>
      filter(type == input$type, mag >= input$mag)
  })
  
  output$top_quakes <- renderUI({
    req(quakes_filtered)
    
    quakes_filtered() |>
      arrange(desc(mag)) |>
      head( input$n_quakes ) |>
      select(mag, place, time, depth, id) |>
      pmap(display_quake)
    
  })
  
  output$map <- renderLeaflet({
    leaflet() |>
      addTiles() |>
      setView(-27.210814, 30.161823, zoom = 2)
  })
  
  observe({
    req(quakes_filtered)
    
    leafletProxy("map", data = quakes_filtered()) |>
      clearControls() |>
      clearMarkers() |>
      addCircleMarkers(
        radius = input$map_zoom * 2, popup = ~popup, color = ~map_points_palette(mag),
        stroke = TRUE, lat = ~latitude, lng = ~longitude) %>%
      addLegend(
        "bottomright",
        title = "Magnitude",
        pal = map_points_palette,
        values = c(1, 3, 5, 7)
      )
  })
  
  selected_quake <- eventReactive(input$quake_id, {
    quake_index <- which(quakes_filtered()[['id']] == input$quake_id)
    
    list(
      lat = quakes_filtered()[['latitude']][quake_index],
      lng = quakes_filtered()[['longitude']][quake_index]
    )
  })
  
  observe({
    leafletProxy('map') |>
      flyTo(lng = selected_quake()[['lng']], lat = selected_quake()[['lat']], zoom = 6)
  })
  
  observeEvent(input$zoom_out, {
    leafletProxy('map') |>
      flyTo(-27.210814, 30.161823, zoom = 2)
  })
  
}

shinyApp(ui, server)

