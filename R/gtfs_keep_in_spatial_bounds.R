gtfs_keep_in_spatial_bounds <- function(gtfs, spatial_bounds, additional_stop_ids=NULL) {

  gtfs$stops <- gtfs$stops %>% 
    dplyr::union_all(tibble(parent_station=character())) %>%
    mutate(
      stop_lat = as.numeric(stop_lat),
      stop_lon = as.numeric(stop_lon),
      parent_station = if_else(parent_station == "", NA_character_, parent_station)
    ) %>%
    filter((!is.na(stop_lon) & !is.na(stop_lat)) | !is.na(parent_station))

  gtfs$stops <- gtfs$stops %>%
    sf::st_as_sf(coords = c('stop_lon', 'stop_lat'), crs="EPSG:4326", remove=FALSE)

  gtfs$stops <- gtfs$stops %>%
    filter(
      sf::st_within(geometry, spatial_bounds, sparse=FALSE) |
      stop_id %in% additional_stop_ids
      )

  gtfs$stops <- gtfs$stops %>%
    sf::st_drop_geometry()

  while(any(!(na.omit(gtfs$stops$parent_station) %in% gtfs$stops$stop_id))){
    gtfs$stops <- gtfs$stops %>%
      filter(is.na(parent_station) | parent_station %in% gtfs$stops$stop_id)
  }

  gtfs$stops <- gtfs$stops %>%
    tidyr::replace_na(list(parent_station = ""))

  gtfs <- gtfs %>% gtfs_refint_stop_id()

  return(gtfs)
}