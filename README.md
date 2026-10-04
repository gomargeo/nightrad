# nightrad

**nightrad** is an R package for analyzing and visualizing nighttime radiance over the Greater Manila Area using VIIRS-DNB satellite imagery. It includes tools for comparing radiance across years, ranking cities, and generating static and interactive maps.

## Installation

```r
# Install from local directory
devtools::install("path/to/nightrad")
```

## Example

Here's a quick example using one of the exported functions:

```r
library(nightrad)

# Plot classified radiance using Fisher breaks
plot_jenks_radiance(
  raster1 = rast("VNL_2022_greater-manila.tif"),
  raster2 = rast("VNL_2023_greater-manila.tif"),
  boundary = vect("greater-manila.shp"),
  n_classes = 6
)
```

## Vignette

See the full walkthrough in the package vignette:

```r
vignette("nightrad", package = "nightrad")
```

The vignette walks through year-on-year radiance comparison, static/interactive maps, and city-level rankings.

## Features

- Side-by-side raster visualization with classified breaks
- City-level radiance change maps and rankings
- Static (tmap) and interactive (Leaflet) map outputs
- Admin boundary maps with city labels
- Supports spatial storytelling and urban monitoring


## Data Sources

The project uses annual VIIRS-DNB nighttime-light composites produced by the Earth Observation Group (EOG). The VIIRS data included in this repository are derived from EOG products distributed under the Creative Commons Attribution 4.0 International (CC BY 4.0) license.

Administrative boundaries used in the original analysis were obtained from GADM. GADM boundary data are **not redistributed in this repository**. Users should obtain the appropriate boundary data directly from GADM and comply with its licensing terms.

The example analysis uses data clipped to the Greater Manila Area.


## Roadmap

Planned additions:

- Zonal statistics functions
- Raster preprocessing automation
- Support for monthly/multi-year VIIRS data
- Integration with population, transport, and infrastructure indicators

## Developed For

Developed as per the requirements of the 'Spatial Data Science with R' course under the Erasmus MSc in Geospatial Technologies (2025 Cohort).

## License

MIT License. See `LICENSE` file for details.
