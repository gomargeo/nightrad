#' Generate a Collapsible Table Showing Radiance Change per City
#'
#' This function ranks and displays changes in city-level radiance between two columns,
#' typically representing different time periods. It shows raw values, their difference,
#' and ranks the cities in descending order of change. The table is rendered as a collapsible
#' HTML block for use in markdown documents.
#'
#' @param city_sf An `sf` object containing city geometries and numeric columns for radiance values.
#' @param col1 Character. Name of the baseline radiance column (e.g., `"mean_2022"`).
#' @param col2 Character. Name of the comparison radiance column (e.g., `"mean_2023"`).
#' @param city_col Character. Name of the column containing city names. Default is `"NAME_2"`.
#' @param label1 Character. Display name for the baseline column in the output table (default = `"2022 Radiance"`).
#' @param label2 Character. Display name for the comparison column in the output table (default = `"2023 Radiance"`).
#' @param change_label Character. Display name for the radiance change column (default = `"Change"`).
#' @param table_caption Character. Caption to appear below the table (default = `"City-Level Radiance Change (Comparison)"`).
#'
#' @return No return value. The function prints a collapsible HTML table.
#'
#' @export
#'
#' @importFrom dplyr transmute arrange mutate select row_number
#' @importFrom sf st_drop_geometry
#' @importFrom knitr kable
radiance_change_table <- function(city_sf,
                                  col1,
                                  col2,
                                  city_col = "NAME_2",
                                  label1 = "2022 Radiance",
                                  label2 = "2023 Radiance",
                                  change_label = "Change",
                                  table_caption = "City-Level Radiance Change (Comparison)") {

  df <- sf::st_drop_geometry(city_sf) |>
    dplyr::transmute(
      City = .data[[city_col]],
      col2_val = round(.data[[col2]], 3),
      col1_val = round(.data[[col1]], 3),
      change_val = round(.data[[col2]] - .data[[col1]], 3)
    ) |>
    dplyr::arrange(dplyr::desc(change_val)) |>
    dplyr::mutate(Rank = dplyr::row_number()) |>
    dplyr::select(
      Rank,
      City,
      !!label2 := col2_val,
      !!label1 := col1_val,
      !!change_label := change_val
    )

  cat(
    "<details>
    <summary>
    <b>
    Click to expand <i>", table_caption, "</i>
    </b>
    </summary>\n\n"
  )
  print(knitr::kable(df, caption = table_caption))
  cat("\n</details>")
}
