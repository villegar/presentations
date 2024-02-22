################################################################################
# 4 - Write a plumber function to use the Gapminder dataset to find the 
# population of Costa Rica in 1982.
#
# IMPORTANT: This is the client code, which should be executed inside a 
# different RStudio session.
# Make sure to use the same port number as in the server file.
################################################################################

# install.packages("httr")     # Needed for request/response with API
# install.packages("jsonlite") # Needed to decode the response data from the API

# set plumber port
options("plumber.port" = 1234)

response <- httr::GET("http://127.0.0.1:1234/pop_cr_1982")
response

# the content is in binary, so convert the response to an R data object
content <- jsonlite::fromJSON(rawToChar(response$content))
content
