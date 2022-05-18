gtfs_remove_one_stop_trips <- function(gtfs) {

  gtfs$stop_times <- gtfs$stop_times %>% 
    group_by(trip_id) %>% filter(dplyr::n_distinct(stop_id) > 1) %>%
    ungroup()

  gtfs$trips <- gtfs$trips %>% 
    filter(trip_id %in% gtfs$stop_times$trip_id)

  gtfs <- gtfs %>% 
    gtfs_refint_trip_id() %>%
    gtfs_refint_service_id()

  return(gtfs)
}