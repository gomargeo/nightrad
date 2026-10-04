#' Plot City-Level Mean Radiance for Two Rasters
#'
#' This function calculates and visualizes the mean radiance at the city level
#' for two different raster layers. The results are shown side-by-side using
#' consistent color scaling and shared breakpoints, making it easy to compare
#' radiance changes across cities between two time periods.
#'
#' @param raster1 A `terra::SpatRaster` object representing the earlier time period.
#' @param raster2 A `terra::SpatRaster` object representing the later time period.
#' @param shapefile A `terra::SpatVector` or `sf` object with city boundaries and a column named `NAME_2`.
#' @param title1 Character. Title for the first map (default: "City Radiance - Raster 1").
#' @param title2 Character. Title for the second map (default: "City Radiance - Raster 2").
#' @param legend1 Character. Legend title for the first map (default: "Mean Radiance 1").
#' @param legend2 Character. Legend title for the second map (default: "Mean Radiance 2").
#'
#' @return A side-by-side static map (`tmap` object) comparing city-level mean radiance.
#'
#' @export
#'
#' @importFrom terra extract vect
#' @importFrom sf st_as_sf
#' @importFrom dplyr group_by summarise
#' @importFrom tmap tmap_mode tm_shape tm_fill tm_borders tm_layout tmap_arrange
#'
#' @examples
#' \dontrun{
#' rad_2022 <- terra::rast(system.file("extdata/VNL_2022_greater-manila.tif", package = "nightradPH"))
#' rad_2023 <- terra::rast(system.file("extdata/VNL_2023_greater-manila.tif", package = "nightradPH"))
#' cities <- terra::vect(system.file("extdata/greater-manila.shp", package = "nightradPH"))
#'
#' plot_mean_radiance(
#'   raster1 = rad_2022,
#'   raster2 = rad_2023,
#'   shapefile = cities,
#'   title1 = "2022",
#'   title2 = "2023"
#' )
#' }

plot_mean_radiance <- function(raster1, raster2, shapefile,
                               title1 = "City Radiance - Raster 1",
                               title2 = "City Radiance - Raster 2",
                               legend1 = "Mean Radiance 1",
                               legend2 = "Mean Radiance 2") {
  city_sf <- shapefile |>
    sf::st_as_sf() |>
    dplyr::group_by(NAME_2) |>
    dplyr::summarise()

  city_vect <- terra::vect(city_sf)

  mean1 <- terra::extract(raster1, city_vect, fun = mean, na.rm = TRUE)
  mean2 <- terra::extract(raster2, city_vect, fun = mean, na.rm = TRUE)

  city_sf$mean1 <- mean1[[2]]
  city_sf$mean2 <- mean2[[2]]

  all_vals <- range(c(city_sf$mean1, city_sf$mean2), na.rm = TRUE)

  tmap::tmap_mode("plot")

  tm1 <- tmap::tm_shape(city_sf) +
    tmap::tm_fill("mean1",
                  palette = "inferno",
                  limits = all_vals,
                  title = legend1,
                  legend.format = list(digits = 1),
                  legend.orientation = "horizontal") +
    tmap::tm_borders() +
    tmap::tm_title(title1)

  tm2 <- tmap::tm_shape(city_sf) +
    tmap::tm_fill("mean2",
                  palette = "inferno",
                  limits = all_vals,
                  title = legend2,
                  legend.format = list(digits = 1),
                  legend.orientation = "horizontal") +
    tmap::tm_borders() +
    tmap::tm_title(title2)

  tmap::tmap_arrange(tm1, tm2, ncol = 2)
}
