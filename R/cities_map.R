#' Plot Administrative Boundaries with Labels (tmap v3 compatible)
#'
#' This function reads a shapefile, dissolves polygons by a grouping column,
#' and plots labeled city boundaries using the tmap package.
#'
#' @param shp_path Path to the shapefile (can be a .shp file or zipped shapefile).
#' @param group_col Character. Column name in the shapefile used for grouping/dissolving (e.g., "NAME_2").
#' @param label_col Character. Column name used for labeling city names (e.g., "NAME_2").
#' @param map_title Character. Title to display on the map.
#'
#' @return A static tmap object showing city boundaries with labels.
#'
#' @importFrom terra vect
#' @importFrom sf st_as_sf
#' @importFrom dplyr group_by summarise
#' @importFrom tmap tmap_mode tm_shape tm_borders tm_text tm_layout
#'
#' @export
#'
#' @examples
#' \dontrun{
#' cities_map(
#'   shp_path = system.file("extdata", "manila_admin.shp", package = "nightradPH"),
#'   group_col = "NAME_2",
#'   label_col = "NAME_2",
#'   map_title = "Greater Manila Administrative Boundaries"
#' )
#' }

cities_map <- function(shp_path, group_col, label_col, map_title) {
  shp <- terra::vect(shp_path)
  shp_sf <- sf::st_as_sf(shp)

  city <- shp_sf |>
    dplyr::group_by(.data[[group_col]]) |>
    dplyr::summarise()

  tmap::tm_shape(city) +
    tmap::tm_borders(col = "gray", lwd = 1) +
    tmap::tm_text(
      text = label_col,
      size = 0.25,
      options = tmap::opt_tm_text(point.label = TRUE),
      fontface = "bold"
    ) +
    tmap::tm_title(map_title) +
    tmap::tm_layout(legend.show = FALSE)
}
