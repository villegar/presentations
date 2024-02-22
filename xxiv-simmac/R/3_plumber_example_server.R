################################################################################
# 3 - Connect to plumber example.
# IMPORTANT: This is the server code, which should be running inside a 
# different RStudio session. Deploy by clicking on 'Run API'
################################################################################

# install.packages("httr")     # Needed for request/response with API
# install.packages("jsonlite") # Needed to decode the response data from the API
# install.packages("png")      # Needed to read PNG objects

# This is a Plumber API. You can run the API by clicking
# the 'Run API' button above.
#
# Find out more about building APIs with Plumber here:
#
#    https://www.rplumber.io/

# set plumber port
options("plumber.port" = 1234)

#* @apiTitle XXIV SIMMAC tutorial
#* @apiDescription XXIV SIMMAC tutorial: API development with R by Roberto Villegas-Diaz
#* @apiContact r.villegas-diaz@liverpool.ac.uk
#* @apiVersion 0.0.1.9000
NULL

#* This function returns a message
#* @get /hello_world
function() {
  return("Hello XXIV SIMMAC!")
}

#* This function calculates the square of `a`
#* @param a Numeric value.
#* @get /square 
function(a) {
  return(as.numeric(a) ^ 2)
}

#* Plot a histogram
#* @serializer png
#* @get /plot
function() {
  rand <- rnorm(100)
  hist(rand)
}