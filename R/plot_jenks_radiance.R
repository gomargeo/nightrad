#' Plot Radiance Rasters Using Fisher Breaks (formerly Jenks)
#'
#' This function plots two SpatRaster layers side by side using Fisher natural breaks with a shared color scale.
#' Designed for comparing nighttime lights across two time periods.
#'
#' @param raster1 A SpatRaster for the earlier time period.
#' @param raster2 A SpatRaster for the later time period.
#' @param boundary A SpatVector or sf object used to mask the rasters.
#' @param n_classes Integer. Number of classes for Fisher breaks (default: 6).
#' @param color_palette Character. Name of the color palette (default: "Inferno").
#' @param title1 Title for the first map.
#' @param title2 Title for the second map.
#'
#' @return A side-by-side base R plot.
#' @export
#'
#' @import terra
#' @import classInt
#' @importFrom grDevices hcl.colors
#' @importFrom graphics par

plot_jenks_radiance <- function(raster1, raster2, boundary,
                                n_classes = 6, color_palette = "Inferno",
                                title1 = "Radiance: Time 1",
                                title2 = "Radiance: Time 2") {
  if (!requireNamespace("terra", quietly = TRUE)) stop("Package 'terra' is required.")
  if (!requireNamespace("classInt", quietly = TRUE)) stop("Package 'classInt' is required.")

  # Reproject if needed
  if (!terra::crs(raster1) == terra::crs(boundary)) {
    boundary <- terra::project(boundary, terra::crs(raster1))
  }

  # Mask and crop
  r1_clip <- terra::mask(raster1, boundary)
  r2_clip <- terra::mask(raster2, boundary)

  # Shared breaks
  values_combined <- c(terra::values(r1_clip, na.rm = TRUE),
                       terra::values(r2_clip, na.rm = TRUE))
  breaks <- classInt::classIntervals(values_combined, n = n_classes, style = "fisher")$brks
  colors <- hcl.colors(n_classes - 1, palette = color_palette)

  # Plot
  old_par <- par(mfrow = c(1, 2), mar = c(4, 4, 4, 6))
  on.exit(par(old_par))

  terra::plot(r1_clip, breaks = breaks, col = colors,
              main = title1, axes = FALSE, legend = FALSE)
  terra::plot(r2_clip, breaks = breaks, col = colors,
              main = title2, axes = FALSE, legend = TRUE)
}
