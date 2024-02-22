################################################################################
# 5 - Write a plumber function to allow a user to find out the population of 
# any country during any year in the Gapminder dataset.
#
# IMPORTANT: This is the client code, which should be executed inside a 
# different RStudio session.
# Make sure to use the same port number as in the server file.
################################################################################

# install.packages("httr")     # Needed for request/response with API
# install.packages("jsonlite") # Needed to decode the response data from the API

# set plumber port
options("plumber.port" = 1234)

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
