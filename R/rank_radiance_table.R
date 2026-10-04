#' Generate a Collapsible HTML Table of City-Level Radiance Rankings
#'
#' This function compares city-level mean radiance values across two columns (typically from two time periods)
#' and generates a collapsible HTML table with ranks, values, and city names. It ranks cities in descending order
#' of radiance and displays both rankings side by side for easy comparison.
#'
#' @param city_sf An `sf` object containing city geometries and numeric columns for radiance values.
#' @param col1 Character. Name of the first radiance column (e.g., `"mean_2022"`).
#' @param col2 Character. Name of the second radiance column (e.g., `"mean_2023"`).
#' @param city_col Character. Name of the column containing city names (e.g., `"NAME_2"`).
#' @param label1 Character. Column label to display for `col1` in the table (default = `"Radiance 1"`).
#' @param label2 Character. Column label to display for `col2` in the table (default = `"Radiance 2"`).
#' @param cityname1 Character. Label for the city name column in the first ranking (default = `"City (col1)"`).
#' @param cityname2 Character. Label for the city name column in the second ranking (default = `"City (col2)"`).
#' @param table_caption Character. Caption text shown above the table (default = `"Comparison Table"`).
#'
#' @return A collapsible HTML table comparing city-level radiance values and ranks.
#'
#' @export
#'
#' @importFrom dplyr select arrange mutate row_number left_join all_of
#' @importFrom knitr kable
#' @importFrom glue glue
#'
#' @examples
#' \dontrun{
#' city$mean_2022 <- runif(nrow(city), 20, 80)
#' city$mean_2023 <- runif(nrow(city), 30, 90)
#' rank_radiance_table(
#'   city_sf = city,
#'   col1 = "mean_2022",
#'   col2 = "mean_2023",
#'   city_col = "NAME_2",
#'   label1 = "2022 Radiance",
#'   label2 = "2023 Radiance",
#'   cityname1 = "City (2022)",
#'   cityname2 = "City (2023)",
#'   table_caption = "Radiance Ranking Comparison"
#' )
#' }

rank_radiance_table <- function(city_sf, col1, col2, city_col,
                                label1 = "Radiance 1",
                                label2 = "Radiance 2",
                                cityname1 = "City 1",
                                cityname2 = "City 2",
                                table_caption = "Comparison Table") {

  df <- sf::st_drop_geometry(city_sf)

  # First ranking
  rank_1 <- df |>
    select(all_of(city_col), all_of(col1)) |>
    arrange(desc(.data[[col1]])) |>
    mutate(Rank = row_number()) |>
    select(Rank,
           !!cityname1 := all_of(city_col),
           !!label1 := all_of(col1))

  # Second ranking
  rank_2 <- df |>
    select(all_of(city_col), all_of(col2)) |>
    arrange(desc(.data[[col2]])) |>
    mutate(Rank = row_number()) |>
    select(Rank,
           !!cityname2 := all_of(city_col),
           !!label2 := all_of(col2))

  # Merge
  rank_table <- left_join(rank_1, rank_2, by = "Rank")

  # Display
  cat(glue::glue(
    "<details>
    <summary>
    <b>
    Click to expand <i>{table_caption}</i>
    </b>
    </summary>\n\n"
  ))
  print(knitr::kable(rank_table, digits = 3, caption = table_caption))
  cat("\n</details>")
}
