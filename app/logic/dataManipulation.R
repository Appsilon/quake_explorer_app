box::use(
  readr[read_csv],
  dplyr[distinct, mutate, rename, filter, arrange, select],
  stringr[str_to_title],
  app / logic / make_popup[make_popup],
  app / logic / display_quake[display_quake],
  utils[...],
  purrr[pmap],
  RCurl[url.exists]
)

#' @export
get_data <- function(file_path) {
  url <- "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.csv"
  temp_file_path <- "data/temp_file.csv"
  # Check if the URL is valid and returns a download
  if (url.exists(url)) {
    # Download the file from the URL
    download.file(url, temp_file_path, mode = "wb")
    # Check if the downloaded file is not empty
    if (file.info(temp_file_path)$size > 0) {
      # Check if the downloaded file is different from the existing file
      if (file.exists(file_path)) {
        if (!identical(read.csv(file_path), read.csv(temp_file_path))) {
          message("File downloaded has new data")
          #overwrite old file for new
          file.copy(file_path, temp_file_path, overwrite = TRUE)
          #delete temp file
          file.remove(temp_file_path)
          #return the latest data
          return(read.csv(file_path))
        }else {
         message("Downloaded file is the same as existing file.")
         return(read.csv(file_path))
         message(temp_file_path)
        }
      }else {
        message("No old file present in directory. New File downloaded successfully.")
        file.rename(temp_file_path, file_path)
        #return latest data
        return(read.csv(file_path))
      }
    }else {
      message("Downloaded file is empty.")
      #no overwrite needed here
      return(read.csv(file_path))
    }
  } else {
    message("URL is not valid or does not return a download.")
    #no overwrite needed here
    return(read.csv(file_path))
  }
}


#' Function for reading realtime data into a dataframe
#' and appending to it a column named popup
#'
#' @param file File to be read
#' @return table with additional popup column
#' @export
quake_data_read_realtime <- function(file) {
  get_data(file) |>
    mutate(popup = make_popup(place, time, mag, magType, depth))
}


#' Function for reading csv file into a dataframe
#' and appending to it a column named popup
#'
#' @param file File to be read
#' @return table with additional popup column
#' @export
quake_data_read <- function(file) {
  read_csv(file) |>
    mutate(popup = make_popup(place, time, mag, magType, depth))
}

#' Function for obtaining a table with
#' unique types of earthquake
#'
#' @param data data table
#' @return table with unique types of earthquakes
#' @export
quake_types_func <- function(data) {
  data |>
    distinct(type) |>
    mutate(text = str_to_title(type)) |>
    rename(key = type)
}

# 'Function for filtering data according to the
# 'type of earthquake and minimum magnitude
#'
#' @param data data table
#' @param type Earthquake type
#' @param mag Earthquake magnitude
#' @return filtered table
#' @export
quake_filter_func <- function(data, type, mag) {
  data |>
    filter(type %in% !!type, mag >= !!mag)
}

#' Function to generate a table of top n quakes
#' arranged from the one with highest magnitude
#'
#' @param data data table
#' @param n_quakes number of quakes to show
#' @param ns namespace
#' @return arranged table of top n_quakes
#' @export
top_quakes_func <- function(data, n_quakes, ns) {
  data |>
    arrange(desc(mag)) |>
    head(n_quakes) |>
    select(mag, place, time, depth, id) |>
    mutate(ns = ns(character())) |>
    pmap(display_quake)
}

#' Function to filter specific earthquake
#' based on its' quake id and obtain its'
#' location through latitude and longitude
#'
#' @param data data table
#' @param quake_id Earthquake id
#' @return list with 2 values (latitude and longitude)
#' @export
selected_quake_func <- function(data, quake_id) {
  quake_index <- which(data[["id"]] == quake_id)

  list(
    lat = data[["latitude"]][quake_index],
    lng = data[["longitude"]][quake_index]
  )
}
