#' Visualize City-Level Radiance Rankings on an Interactive Leaflet Map
#'
#' This function generates an interactive map showing city-level radiance values for two time periods.
#' It ranks the values in descending order (higher radiance = higher rank) and displays them in
#' HTML tooltips on mouse hover. The map uses `leaflet` for interactivity and `htmltools` for formatted tooltips.
#'
#' @param city_sf An `sf` object representing city boundaries. Must contain two numeric columns for radiance values.
#' @param col1 Character. The name of the column containing radiance values for the first time period.
#' @param col2 Character. The name of the column containing radiance values for the second time period.
#' @param label1 Character. Label for `col1` in the HTML tooltip (e.g., "2022 Radiance").
#' @param label2 Character. Label for `col2` in the HTML tooltip (e.g., "2023 Radiance").
#' @param city_col Character. The name of the column containing the city name. Default is `"NAME_2"`.
#'
#' @return A `leaflet` interactive map with color-coded city polygons and HTML tooltips displaying radiance values and ranks.
#'
#' @export
#'
#' @importFrom dplyr mutate
#' @importFrom leaflet leaflet addProviderTiles addPolygons highlightOptions
#' @importFrom htmltools HTML
#'
#' @examples
#' \dontrun{
#' cities <- sf::st_read(system.file("extdata/greater-manila.geojson", package = "nightradPH"))
#' cities$rad_2022 <- runif(nrow(cities), 10, 50)
#' cities$rad_2023 <- runif(nrow(cities), 15, 60)
#'
#' rank_radiance_map(
#'   city_sf = cities,
#'   col1 = "rad_2022",
#'   col2 = "rad_2023",
#'   label1 = "2022 Radiance",
#'   label2 = "2023 Radiance",
#'   city_col = "NAME_2"
#' )
#' }

rank_radiance_map <- function(city_sf, col1, col2, label1, label2, city_col = "NAME_2") {
  # Ensure required packages
  if (!requireNamespace("leaflet", quietly = TRUE)) stop("Package 'leaflet' is required.")
  if (!requireNamespace("htmltools", quietly = TRUE)) stop("Package 'htmltools' is required.")
  if (!requireNamespace("dplyr", quietly = TRUE)) stop("Package 'dplyr' is required.")

  # Rank values (higher radiance = lower rank)
  city_sf <- dplyr::mutate(
    city_sf,
    rank1 = rank(-.data[[col1]]),
    rank2 = rank(-.data[[col2]])
  )

  # Add HTML tooltip content
  city_sf$label <- paste0(
    "<b>", city_sf[[city_col]], "</b><br>",
    label1, ": ", round(city_sf[[col1]], 3), " (Rank ", city_sf$rank1, ")<br>",
    label2, ": ", round(city_sf[[col2]], 3), " (Rank ", city_sf$rank2, ")"
  )

  # Create Leaflet map
  leaflet::leaflet(city_sf) |>
    leaflet::addProviderTiles("CartoDB.Positron") |>
    leaflet::addPolygons(
      fillColor = "gray",
      weight = 1,
      color = "#222",
      label = lapply(city_sf$label, htmltools::HTML),
      highlightOptions = leaflet::highlightOptions(
        weight = 2,
        color = "#000",
        fillOpacity = 0.7,
        bringToFront = TRUE
      )
    )
}
