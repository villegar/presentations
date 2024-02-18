iss_position <- function() {
  response <- httr::GET("http://api.open-notify.org/iss-now.json")
  # the content is in binary, so convert the response to an R data object
  content <- jsonlite::fromJSON(rawToChar(response$content))
  Sys.sleep(1) # pause for 1 second
  # extract each field and convert to the appropriate data type
  tibble::tibble(
    timestamp = as.POSIXct(content$timestamp),
    longitude = as.numeric(content$iss_position$longitude),
    latitute = as.numeric(content$iss_position$latitude)
  )
}

# map over the helper function X times, here 60 = 60 seconds of positions
iss_position_tbl <- seq_len(60*15) |> # number of positions to extract
  purrr::map(\(x) iss_position()) |>
  purrr::list_rbind()

# iss_position_tbl <- iss_position_tbl |>
#   dplyr::mutate(longitude = longitude * ifelse(longitude > 0, -1, 1))
readr::write_rds(iss_position_tbl, "xxiv-simmac/data/iss_position_tbl.rds")
