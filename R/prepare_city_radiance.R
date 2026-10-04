#' Prepare City-Level Mean Radiance Data from Two Raster Layers
#'
#' This function extracts mean radiance values for each city polygon from two SpatRaster layers
#' and returns an `sf` object with the results. It is useful for summarizing and comparing
#' per-city radiance from two different time periods or raster datasets.
#'
#' @param raster1 A `terra::SpatRaster` object representing the baseline radiance (e.g., 2022).
#' @param raster2 A `terra::SpatRaster` object representing the comparison radiance (e.g., 2023).
#' @param shapefile A `terra::SpatVector` or `sf` object containing city polygons.
#' @param city_col Character. Optional. Name of the column containing city names. Default is `"NAME_2"`.
#'
#' @return An `sf` object containing the original city geometries with two new columns: `mean_2022` and `mean_2023`.
#'
#' @export
#'
#' @importFrom terra extract crs project
#' @importFrom sf st_as_sf
#'
#' @examples
#' \dontrun{
#' rad_2022 <- terra::rast(system.file("extdata/VNL_2022_greater-manila.tif", package = "nightradPH"))
#' rad_2023 <- terra::rast(system.file("extdata/VNL_2023_greater-manila.tif", package = "nightradPH"))
#' shp <- terra::vect(system.file("extdata/greater-manila.shp", package = "nightradPH"))
#'
#' city_data <- prepare_city_radiance(rad_2022, rad_2023, shp)
#' head(city_data)
#' }

prepare_city_radiance <- function(raster1, raster2, shapefile, city_col = "NAME_2") {
  if (!terra::crs(raster1) == terra::crs(shapefile)) {
    shapefile <- terra::project(shapefile, terra::crs(raster1))
  }

  # Extract means
  mean1 <- terra::extract(raster1, shapefile, fun = mean, na.rm = TRUE)[[2]]
  mean2 <- terra::extract(raster2, shapefile, fun = mean, na.rm = TRUE)[[2]]

  city <- sf::st_as_sf(shapefile)
  city$mean_2022 <- mean1
  city$mean_2023 <- mean2

  city
}
