################################################################################
# 4 - Write a plumber function to use the Gapminder dataset to find the 
# population of Costa Rica in 1982.
#
# IMPORTANT: This is the server code, which should be running inside a 
# different RStudio session. Deploy by clicking on 'Run API'
################################################################################

# install.packages("plumber")   # Needed to deploy API
# install.packages("gapminder") # Needed to access the Gapminder dataset
# install.packages("tidyverse") # Needed for data wrangling

# set plumber port
port_number <- 1234

#* @apiTitle XXIV SIMMAC tutorial
#* @apiDescription XXIV SIMMAC tutorial: API development with R by Roberto Villegas-Diaz
#* @apiContact r.villegas-diaz@liverpool.ac.uk
#* @apiVersion 0.0.1.9000
NULL

#* This function returns the population of Costa Rica in 1982
#* @get /pop_cr_1982 
function() {
  pop_tbl <- gapminder::gapminder |>
    dplyr::filter(country == "Costa Rica") |>
    dplyr::filter(year == 1982)
  return(pop_tbl$pop)
}
