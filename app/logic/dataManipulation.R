# app/logic/dataManipulation.R

box::use(
  readr[read_csv],
  dplyr[distinct, mutate, rename, filter, arrange, select],
  stringr[str_to_title],
  purrr[pmap]
)

#' @export
quake_data_read <- function(file){
  read_csv(file)|>
  mutate(popup = make_popup(place, time, mag, depth))
}



#' @export
quake_types_func <- function(data){
  data |>
  distinct(type) |>
  mutate(text = str_to_title(type)) |>
  rename(key = type)
}


#' @export
quake_filter_func <- function(data){
  data |>
    filter(type == input$type, mag >= input$mag)
}

#' @export
top_quakes_func <- function(data){
  data() |>
  arrange(desc(mag)) |>
  head(input$n_quakes) |>
  select(mag, place, time, depth, id) |>
  pmap(display_quake)
}

#' @export
selected_quake_func <- function(data){
  quake_index <- which(data()[['id']] == input$quake_id)
  
  list(
    lat = data()[['latitude']][quake_index],
    lng = data()[['longitude']][quake_index]
  )
}