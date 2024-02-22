################################################################################
# 5 - Write a plumber function to allow a user to find out the population of 
# any country during any year in the Gapminder dataset.
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

#* This function returns the population for a `country` in a particular `year`
#* @param country String with a country in the Gapminder dataset: https://doi.org/10.7910/DVN/GJQNEQ.
#* @param year A numeric value with a year of data available in Gapminder dataset (1952 - 2007 in steps of 5 years).
#* @get /pop_country
function(country, year) {
  pop_tbl <- gapminder::gapminder |>
    dplyr::filter(country == !!country) |>
    dplyr::filter(year == as.numeric(!!year))
  return(pop_tbl$pop)
}

#* This filter checks for valid countries in the Gapminder dataset
#* @filter validate_year
function(req, res) {
  # check if the calling endpoint has a year parameter
  if ("year" %in% names(req$args)) {
    # check if the given year is in the Gapminder dataset
    year <- as.numeric(req$args$year)
    gapminder_years <- unique(gapminder::gapminder$year)
    # do check
    status <- any(year %in% gapminder_years)
    if (!status) {
      msg <- paste0("The given year, ", year, 
                    ", it's not part of the Gapminder dataset. ",
                    "Please, try one of the following: ",
                    paste0(gapminder_years, collapse = ", ")) 
      res$status <- 400 # Bad request
      return(list(
        error = jsonlite::unbox(msg),
        valid_years = gapminder_years
      )
      )
    }
  }
  plumber::forward()
}
