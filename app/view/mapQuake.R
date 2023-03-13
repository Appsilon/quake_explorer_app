# /app/view/mapQuake.R

box::use(
  dplyr[...],
  readr[read_csv],
  shiny[moduleServer, NS, observe, req, observeEvent],
  app / logic / dataManipulation[
    quake_data_read,
    quake_types_func, quake_filter_func,
    top_quakes_func, selected_quake_func
  ],
  leaflet[
    renderLeaflet, leaflet, addTiles, setView,
    leafletProxy, clearControls, clearMarkers, addCircleMarkers,
    addLegend, flyTo, colorNumeric, leafletOutput
  ]
)

#' @export
ui <- function(id) {
  ns <- NS(id)

  leafletOutput(ns("map"), height = "100%")
}

#' @export
server <- function(id, quakes_filtered, selected_quake) {
  moduleServer(id, function(input, output, session) {
    # Data wrangling ----------------------------------------------------------
    quakes_data <- quake_data_read("data/quakes_may_2022.csv")

    map_points_palette <- colorNumeric(
      palette = "YlGnBu",
      domain = quakes_data$mag
    )

    output$map <- renderLeaflet({
      leaflet() |>
        addTiles() |>
        setView(-27.210814, 30.161823, zoom = 2)
    })

    observe({
      req(data1)

      leafletProxy("map", data = data1()) |>
        req(quakes_filtered)

      leafletProxy("map", data = quakes_filtered()) |>
        clearControls() |>
        clearMarkers() |>
        addCircleMarkers(
          radius = input$map_zoom * 2, popup = ~popup, color = ~ map_points_palette(mag),
          stroke = TRUE, lat = ~latitude, lng = ~longitude
        ) %>%
        addLegend(
          "bottomright",
          title = "Magnitude",
          pal = map_points_palette,
          values = c(1, 3, 5, 7)
        )
    })

    observe({
      leafletProxy("map") |>
        flyTo(lng = data2()[["lng"]], lat = data2()[["lat"]], zoom = 6)
      leafletProxy("map") |>
        flyTo(lng = selected_quake()[["lng"]], lat = selected_quake()[["lat"]], zoom = 6)
    })

    observeEvent(input$zoom_out, {
      leafletProxy("map") |>
        flyTo(-27.210814, 30.161823, zoom = 2)
    })
  })
}
