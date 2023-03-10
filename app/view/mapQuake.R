# /app/view/mapQuake.R

box::use(
  shiny[moduleServer, NS, observe, req, observeEvent],
  leaflet[
    renderLeaflet, leaflet, addTiles, setView,
    leafletProxy, clearControls, clearMarkers, addCircleMarkers,
    addLegend, flyTo
  ]
)

#' @export
ui <- function(id) {
  ns <- NS(id)

  leafletOutput(ns("map"), height = "100%")
}

#' @export
server <- function(id, data1, data2) {
  moduleServer(id, function(input, output, session) {
    output$map <- renderLeaflet({
      leaflet() |>
        addTiles() |>
        setView(-27.210814, 30.161823, zoom = 2)
    })

    observe({
      req(data1)

      leafletProxy("map", data = data1()) |>
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
    })

    observeEvent(input$zoom_out, {
      leafletProxy("map") |>
        flyTo(-27.210814, 30.161823, zoom = 2)
    })
  })
}
