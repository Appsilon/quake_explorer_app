box::use(
  readr[read_csv],
  dplyr[distinct, mutate, rename, filter, arrange, select],
  stringr[str_to_title],
  app / logic / make_popup[make_popup],
  app / logic / display_quake[display_quake],
  utils[...],
  purrr[pmap]
)

#' @export
quake_data_read <- function(file) {
  read_csv(file) |>
    mutate(popup = make_popup(place, time, mag, depth))
}

#' @export
quake_types_func <- function(data) {
  data |>
    distinct(type) |>
    mutate(text = str_to_title(type)) |>
    rename(key = type)
}

#' @export
quake_filter_func <- function(data, type, mag) {
  data |>
    filter(type == !!type, mag >= !!mag)
}

#' @export
top_quakes_func <- function(data, n_quakes) {
  data |>
    arrange(desc(mag)) |>
    head(n_quakes) |>
    select(mag, place, time, depth, id) |>
    mutate(ns = ns(character())) |>
    pmap(display_quake)
}

#' @export
selected_quake_func <- function(data, quake_id) {
  quake_index <- which(data[["id"]] == quake_id)

  list(
    lat = data[["latitude"]][quake_index],
    lng = data[["longitude"]][quake_index]
  )
}
