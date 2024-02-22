################################################################################
# 6 - Write a plumber function to plot the population change of a user 
# defined country.
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

#* This function returns a plot of the change in population for a `country`, as per the Gapminder dataset
#* @param country String with a country in the Gapminder dataset: https://doi.org/10.7910/DVN/GJQNEQ.
#* @serializer png
#* @get /pop_country_change
function(country) {
  pop_tbl <- gapminder::gapminder |>
    dplyr::filter(country == !!country) |>
    dplyr::select(year, pop)
  
  options(scipen = 999) # Change number format on axes
  plot(pop_tbl, xlab = "Year", ylab = "Population")
}

#* This function returns a data frame with the change in population for a `country`, as per the Gapminder dataset
#* @param country String with a country in the Gapminder dataset: https://doi.org/10.7910/DVN/GJQNEQ.
#* @get /pop_country_change_df
function(country) {
  pop_tbl <- gapminder::gapminder |>
    dplyr::filter(country == !!country) |>
    dplyr::select(year, pop)
  return(pop_tbl)
}
