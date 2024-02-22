################################################################################
# 3 - Connect to plumber example.
# Connect to the plumber API running in the other RStudio instance.
# Note the IP address and ports used below - you will have to update them to
# match where your plumber is running
################################################################################

# install.packages("httr")     # Needed for request/response with API
# install.packages("jsonlite") # Needed to decode the response data from the API
# install.packages("png")      # Needed to read PNG objects

# set plumber port
port_number <- 1234

################################################################################
# hello_world endpoint
################################################################################
hello_response <- 
  httr::GET(paste0("http://127.0.0.1:", port_number, "/hello_world"))

# Look at the response.
hello_response

# We want the content
hello_response$content

# But the content is in binary, so convert the response to R data object
hello_data <- jsonlite::fromJSON(rawToChar(hello_response$content))
hello_data


################################################################################
# square endpoint
################################################################################
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

################################################################################
# plot endpoint
################################################################################
plot_response <- httr::GET(paste0("http://127.0.0.1:", port_number, "/plot"))

# Look at the response.
plot_response

# We want the content
plot_response$content

# Our content is a png image
plot_img <- png::readPNG(plot_response$content)
grid::grid.raster(plot_img)
