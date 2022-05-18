parochial_temporal_bounds <- function() {
  start_date <- lubridate::today() %>% 
    lubridate::floor_date("week", week_start=1)

  end_date <- start_date + lubridate::days(29)

  return(c(start_date, end_date))
}

parochial_temporal_bounds_as_character <- function(){
  paste0(
    parochial_temporal_bounds()[[1]] %>% strftime("%Y-%m-%d"),
    " - ",
    parochial_temporal_bounds()[[2]] %>% strftime("%Y-%m-%d")
  )
}