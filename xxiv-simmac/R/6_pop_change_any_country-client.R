################################################################################
# 6 - Write a plumber function to plot the population change of a user 
# defined country.
#
# IMPORTANT: This is the client code, which should be executed inside a 
# different RStudio session.
# Make sure to use the same port number as in the server file.
################################################################################

# install.packages("httr")     # Needed for request/response with API
# install.packages("jsonlite") # Needed to decode the response data from the API
# install.packages("tidyverse") # Needed for data wrangling

# set plumber port
options("plumber.port" = 1234)

# encode URL / replace spaces, etc.
url <- URLencode("http://127.0.0.1:1234/pop_country_change?country=Costa Rica")
response <- httr::GET(url)
response

# the content is in binary, so convert the response to an R data object
content <- jsonlite::fromJSON(rawToChar(response$content))
content

################################################################################
# Alternative, return data frame
################################################################################

# encode URL / replace spaces, etc.
url <- URLencode(
  "http://127.0.0.1:1234/pop_country_change_df?country=Costa Rica"
)
response <- httr::GET(url)
response

# the content is in binary, so convert the response to an R data object
content <- jsonlite::fromJSON(rawToChar(response$content))
content

# convert into tibble
tibble::as_tibble(content)

# create alternative plot
jsonlite::fromJSON(rawToChar(response$content)) |>
  tibble::as_tibble() |>
  ggplot2::ggplot() +
  ggplot2::geom_point(ggplot2::aes(x = year, y = pop / 1E6)) +
  ggplot2::labs(x = "Year", y = "Population [millions]", 
                title = "Population change of Costa Rica") +
  ggplot2::theme_bw()
