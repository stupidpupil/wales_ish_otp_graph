parochial_temporal_bounds <- function() {
  start_date <- lubridate::today() %>% 
    lubridate::floor_date("week", week_start=1)

  end_date <- start_date + lubridate::days(29)

  return(c(start_date, end_date))
}

parochial_temporal_bounds_as_character <- function(){
  tb <- parochial_temporal_bounds()

  paste0(
    tb[[1]] %>% strftime("%Y-%m-%d"),
    " - ",
    tb[[2]] %>% strftime("%Y-%m-%d")
  )
}

parochial_temporal_bounds_as_list <- function() {
  tb <- parochial_temporal_bounds()

  tbal <- list(
    start = tb[[1]] %>% strftime("%Y-%m-%d"),
    end = tb[[2]] %>% strftime("%Y-%m-%d")
  )

  return(tbal)
}