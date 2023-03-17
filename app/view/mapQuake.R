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
  app / logic / magnitude_palette[magnitude_palette],
  leaflet[
    renderLeaflet, leaflet, addTiles, setView,
    leafletProxy, clearControls, clearMarkers, addCircleMarkers,
    addLegend, flyTo, leafletOutput
  ]
)

#' Create a leafletOutput
#'
#' This function creates a leafletOutput with height `100%`
#'
#' @param id The module id
#' @return leafletOutput
#' @export
ui <- function(id) {
  ns <- NS(id)

  leafletOutput(ns("map"), height = "100%")
}

#' Server function for handling map actions and aesthetics
#'
#' This function adds filtered earthquakes on the map as colored markers and zooms out and in
#' according to user input.
#'
#' @param id The module id
#' @param quakes_data Raw data without any filters applied
#' @param quakes_filtered Filtered data according to user input
#' @param selected_quake List of lat and lng for the selected quake
#' @param zoom_out Reactive variable for observing whenever zoom out button is pressed
#' @return
#' @export
server <- function(id, quakes_data, quakes_filtered, selected_quake, zoom_out) {
  map_points_palette <- magnitude_palette()
  moduleServer(id, function(input, output, session) {
    output$map <- renderLeaflet({
      req(quakes_filtered()) # validate map data
      leaflet() |>
        addTiles() |>
        setView(-27.210814, 30.161823, zoom = 2)
    })

    observe({
      req(quakes_filtered())

      leafletProxy("map", data = quakes_filtered()) |>
        clearControls() |>
        clearMarkers() |>
        addCircleMarkers(
          radius = ~ 1.415 ** mag, popup = ~popup, color = ~ map_points_palette(mag),
          stroke = TRUE, lat = ~latitude, lng = ~longitude
        ) %>%
        addLegend(
          "bottomright",
          title = "Magnitude",
          pal = map_points_palette,
          values = c(1, max(quakes_data$mag))
        )
    })

    observe({
      leafletProxy("map") |>
        flyTo(lng = selected_quake()[["lng"]], lat = selected_quake()[["lat"]], zoom = 6)
    })

    observeEvent(zoom_out(), {
      leafletProxy("map") |>
        flyTo(-27.210814, 30.161823, zoom = 2)
    })
  })
}
