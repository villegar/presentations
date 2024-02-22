################################################################################
# 2 API - What is the current position of the International Space 
# Station? Can you create a plot? [ANSWER]
################################################################################

# install.packages("httr")     # Needed for request/response with API
# install.packages("jsonlite") # Needed to decode the response data from the API
# install.packages("tidyverse") # Needed for data wrangling
# install.packages("leaflet")   # Needed to create interactive map

# call the API and save the response
response <- httr::GET("http://api.open-notify.org/iss-now.json")

# the content is in binary, so convert the response to an R data object
content <- jsonlite::fromJSON(rawToChar(response$content))

# get timestamp
as.POSIXct(content$timestamp)

# get position coordinates
content$iss_position

################################################################################
# Bonus: retrieve multiple points
################################################################################
iss_position <- function() {
  response <- httr::GET("http://api.open-notify.org/iss-now.json")
  # the content is in binary, so convert the response to an R data object
  content <- jsonlite::fromJSON(rawToChar(response$content))
  Sys.sleep(1) # pause for 1 second
  # extract each field and convert to the appropriate data type
  tibble::tibble(
    timestamp = as.POSIXct(content$timestamp),
    longitude = as.numeric(content$iss_position$longitude),
    latitude = as.numeric(content$iss_position$latitude)
  )
}

# map over the helper function X times, here 10 = 10 seconds of data
iss_position_tbl <- seq_len(10) |> # number of positions to extract
  purrr::map(\(x) iss_position()) |>
  purrr::list_rbind()

################################################################################
# Bonus: create interactive map with the positions
################################################################################

# create icon from online image
iss_icon <- leaflet::makeIcon(
  iconUrl = "https://cdn-icons-png.flaticon.com/512/81/81959.png", 
  iconWidth = 15, 
  iconHeight = 15
)

# create plot of the positions
iss_position_tbl |>
  leaflet::leaflet() |>
  leaflet::addTiles() |>
  leaflet::addMarkers(
    lng = ~longitude, 
    lat = ~latitude, 
    label = ~timestamp,
    icon = iss_icon
  )