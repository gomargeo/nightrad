#' Create an Interactive Leaflet Map of Radiance Change per City
#'
#' This function visualizes the change in city-level radiance between two time periods
#' using a diverging color scale on an interactive Leaflet map. The tooltip includes
#' radiance values for both time periods and the computed difference.
#'
#' @param city_sf An `sf` object containing city polygons and numeric radiance columns.
#' @param col1 Character. Column name for the baseline radiance (e.g., `"mean_2022"`).
#' @param col2 Character. Column name for the comparison radiance (e.g., `"mean_2023"`).
#' @param city_col Character. Name of the column containing city names (default = `"NAME_2"`).
#' @param label1 Character. Label to display for the baseline radiance in the tooltip (default = `"2022 Radiance"`).
#' @param label2 Character. Label to display for the comparison radiance in the tooltip (default = `"2023 Radiance"`).
#' @param legend_title Character. Title to display above the map legend (default = `"Radiance Change per City"`).
#'
#' @return A `leaflet` map object with polygons color-coded by radiance change and interactive HTML tooltips.
#'
#' @export
#'
#' @importFrom leaflet leaflet addProviderTiles addPolygons addLegend highlightOptions colorNumeric
#' @importFrom dplyr mutate
#' @importFrom htmltools HTML
#'
#' @examples
#' \dontrun{
#' city$mean_2022 <- runif(nrow(city), 20, 60)
#' city$mean_2023 <- runif(nrow(city), 30, 80)
#' radiance_change_leaflet(
#'   city_sf = city,
#'   col1 = "mean_2022",
#'   col2 = "mean_2023",
#'   city_col = "NAME_2",
#'   label1 = "2022 Radiance",
#'   label2 = "2023 Radiance",
#'   legend_title = "Radiance Difference (2023 - 2022)"
#' )
#' }

radiance_change_leaflet <- function(city_sf,
                                    col1,
                                    col2,
                                    city_col = "NAME_2",
                                    label1 = "2022 Radiance",
                                    label2 = "2023 Radiance",
                                    legend_title = "Radiance Change per City") {

  city_sf <- city_sf |>
    mutate(
      radiance_change = .data[[col2]] - .data[[col1]],
      tooltip = paste0(
        "<b>", .data[[city_col]], "</b><br>",
        "Change in Radiance: ", round(radiance_change, 3), "<br>",
        "<i>", label2, ": ", round(.data[[col2]], 3), "</i><br>",
        "<i>", label1, ": ", round(.data[[col1]], 3), "</i>"
      )
    )

  pal <- colorNumeric(
    palette = "RdBu",
    domain = city_sf$radiance_change,
    reverse = TRUE
  )

  leaflet(city_sf) |>
    addProviderTiles("CartoDB.Positron") |>
    addPolygons(
      fillColor = ~pal(radiance_change),
      fillOpacity = 0.7,
      color = "#444",
      weight = 1,
      label = lapply(city_sf$tooltip, HTML),
      highlightOptions = highlightOptions(
        weight = 2,
        color = "#000",
        fillOpacity = 0.9,
        bringToFront = TRUE
      )
    ) |>
    addLegend(
      pal = pal,
      values = city_sf$radiance_change,
      title = legend_title,
      position = "bottomright"
    )
}
