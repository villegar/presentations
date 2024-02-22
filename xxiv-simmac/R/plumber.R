#
# This is a Plumber API. You can run the API by clicking
# the 'Run API' button above.
#
# Find out more about building APIs with Plumber here:
#
#    https://www.rplumber.io/

# set plumber port
options("plumber.port" = 1234)

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

#* This function returns the population of Costa Rica in 1982
#* @get /pop_cr_1982 
function() {
  pop_tbl <- gapminder::gapminder |>
    dplyr::filter(country == "Costa Rica") |>
    dplyr::filter(year == 1982)
  return(pop_tbl$pop)
}

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

#* This function returns a plot of the change in population for a `country`, as per the Gapminder dataset
#* @param country String with a country in the Gapminder dataset: https://doi.org/10.7910/DVN/GJQNEQ.
#* @serializer png
#* @get /pop_country_change
function(country) {
  pop_tbl <- gapminder::gapminder |>
    dplyr::filter(country == !!country) |>
    dplyr::select(year, pop)
  
  options(scipen=999) # Change number format on axes
  plot(pop_tbl, xlab = "Year", ylab = "Population")
}
