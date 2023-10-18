# Download all the reference files into a local directory, and set an environment
# variable 'DATA_DIR' to point to this directory.
# Required files:
# 1. ONS-UPRN directory (August 2023): https://geoportal.statistics.gov.uk/datasets/ons-uprn-directory-august-2023
# 2. Sub-ICB boundaries (April 2023): https://geoportal.statistics.gov.uk/datasets/ons::sub-integrated-care-board-locations-april-2023-en-bfc-2/about

# Set data directory
data_dir <- Sys.getenv("DATA_DIR")

# Load ONS-UPRN directory for the North West region
ons_uprn_nw <- 
  file.path(data_dir,
            "ONS/UPRN/ONSUD_AUG_2023_NW.csv") |>
  readr::read_csv() |>
  janitor::clean_names() |>
  dplyr::mutate(
    pcds_pre = stringr::str_extract(pcds, "^[A-Z]+"), # Postcode prefix
    .before = pcds) |>
  sf::st_as_sf(coords = c("gridgb1e", "gridgb1n"),
               crs = 27700) |>
  # Convert the coordinates to longitude and latitude
  sf::st_transform(crs = 4326)

# Sub-ICB boundaries - April 2023
sub_icb_boundaries <- 
  file.path(data_dir, "NHS/Sub_ICB_Locations_April_2023_EN_BFC.gpkg") |>
  sf::read_sf() |>
  sf::st_as_sf() |>
  dplyr::mutate(sub_icb_location_code = SICBL23NM |>
                  stringr::str_extract("[0-9a-zA-Z]+$") |>
                  stringr::str_squish(),
                .before = 1) |>
  dplyr::rename(geometry = SHAPE) |>
  janitor::clean_names() |>
  dplyr::mutate(sub_icb_location_name = sicbl23nm |>
                  stringr::str_remove_all(sub_icb_location_code) |>
                  stringr::str_remove_all("-") |>
                  stringr::str_squish()) |>
  dplyr::mutate(sub_icb_location_name = 
                  dplyr::coalesce(sub_icb_location_name, sicbl23nm),
                .after = sub_icb_location_code) |>
  sf::st_transform(crs = 4326)

# Subset the Cheshire & Merseyside (C&M) ICB:
sub_icb_boundaries_cm <- sub_icb_boundaries |>
  dplyr::filter(stringr::str_detect(sicbl23nm, "Cheshire and Merseyside"))

# Save dataset with geometries for the C&M ICB
readr::write_rds(sub_icb_boundaries_cm, 
                 file = "data/sub_icb_boundaries_cm.Rds",
                 compress = "xz")

# Filter UPRNs within the C&M ICB:
ons_uprn_nw_cm_icb <- ons_uprn_nw |>
  dplyr::filter(ccg21cd %in% sub_icb_boundaries_cm$sicbl23cd) |>
  dplyr::mutate(pcds_pre = pcds_pre |> # replace NAs by 'Unknown'
                  stringr::str_replace_na("Unknown")) |>
  dplyr::group_by(pcds_pre) |>         # group by postcode prefix 
  dplyr::mutate(
    pcds_pre_n = length(pcds_pre),     # find UPRNs per postcode prefix
    pcds_pre_alpha = 
      ifelse(pcds_pre_n < 100, 1, 0.7),# create alpha based on pcds_pre_n
    pcds_pre_stroke = 
      ifelse(pcds_pre == "Unknown", 0.5, 0)
  ) |>
  dplyr::arrange(dplyr::desc(pcds_pre_n)) |>
  dplyr::ungroup() |>
  dplyr::mutate(                       # create label with full names and counts
    pcds_pre_label = pcds_pre |>
      forcats::fct_recode(
        Bath = "BA",
        Chester = "CH",
        Crewe = "CW",
        Liverpool = "L",
        Llandudno = "LL",
        Manchester = "M",
        Preston = "PR",
        Stockport = "SK",
        Shrewsbury = "SY",
        `Stoke-on-Trent` = "ST",
        Telford = "TF",
        Warrington = "WA",
        Wigan = "WN"
      ),
    pcds_pre_label = 
      stringr::str_c(pcds_pre_label, " [", pcds_pre_n, "]")
  )

# Save dataset with UPRNs for the C&M ICB
readr::write_rds(ons_uprn_nw_cm_icb, 
                 file = "data/ons_uprn_nw_cm_icb.Rds",
                 compress = "xz")
