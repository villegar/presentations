#
# This is a Plumber API. You can run the API by clicking
# the 'Run API' button above.
#
# Find out more about building APIs with Plumber here:
#
#    https://www.rplumber.io/
#

library(plumber)

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
