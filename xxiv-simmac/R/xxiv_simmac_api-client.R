################################################################################
# IMPORTANT: This is the client code, which should be executed inside a 
# different RStudio session.
# Make sure to use the same port number as in the server file.
################################################################################

# install.packages("httr")     # Needed for request/response with API
# install.packages("jsonlite") # Needed to decode the response data from the API
# install.packages("tidyverse") # Needed for data wrangling
# install.packages("png")      # Needed to read PNG objects

# set plumber port
port_number <- 1234

################################################################################
# 3 - Connect to plumber example.
################################################################################
# hello_world endpoint

hello_response <- 
  httr::GET(paste0("http://127.0.0.1:", port_number, "/hello_world"))

# Look at the response.
hello_response

# We want the content
hello_response$content

# But the content is in binary, so convert the response to R data object
hello_data <- jsonlite::fromJSON(rawToChar(hello_response$content))
hello_data

# square endpoint
# Note how we are passing a parameter to it
square_response <- 
  httr::GET(paste0("http://127.0.0.1:", port_number, "/square?a=5"))

# Look at the response.
square_response

# We want the content
square_response$content

# But the content is in binary, so convert the response to R data object
square_data <- jsonlite::fromJSON(rawToChar(square_response$content))
square_data

# plot endpoint
plot_response <- httr::GET(paste0("http://127.0.0.1:", port_number, "/plot"))

# Look at the response.
plot_response

# We want the content
plot_response$content

# Our content is a png image
plot_img <- png::readPNG(plot_response$content)
grid::grid.raster(plot_img)


################################################################################
# 4 - Write a plumber function to use the Gapminder dataset to find the 
# population of Costa Rica in 1982.
################################################################################
response <- httr::GET("http://127.0.0.1:1234/pop_cr_1982")
response

# the content is in binary, so convert the response to an R data object
content <- jsonlite::fromJSON(rawToChar(response$content))
content


################################################################################
# 5 - Write a plumber function to allow a user to find out the population of 
# any country during any year in the Gapminder dataset.
################################################################################
# encode URL / replace spaces, etc.
url <- URLencode(
  "http://127.0.0.1:1234/pop_country?country=United Kingdom&year=1982"
)
response <- httr::GET(url)
response

# the content is in binary, so convert the response to an R data object
content <- jsonlite::fromJSON(rawToChar(response$content))
content

################################################################################
# Test filter to validate the year
################################################################################
# encode URL / replace spaces, etc.
url <- URLencode(
  "http://127.0.0.1:1234/pop_country?country=United Kingdom&year=2024"
)
response <- httr::GET(url)
response

# the content is in binary, so convert the response to an R data object
content <- jsonlite::fromJSON(rawToChar(response$content))
content


################################################################################
# 6 - Write a plumber function to plot the population change of a user 
# defined country.
################################################################################
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