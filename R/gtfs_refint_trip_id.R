gtfs_refint_trip_id <- function(gtfs){

  if('trip_id' %in% colnames(gtfs$frequencies)){
    gtfs$frequencies <- gtfs$frequencies %>%
      filter(trip_id %in% gtfs$trips$trip_id)
  }
  if('trip_id' %in% colnames(gtfs$stop_times)){
    gtfs$stop_times <- gtfs$stop_times %>% filter(trip_id %in% gtfs$trips$trip_id)
  }

  # Also remove unreferenced shapes
  if('shape_id' %in% colnames(gtfs$shapes)){
    gtfs$shapes <- gtfs$shapes %>% filter(shape_id %in% gtfs$trips$shape_id)
  }

  return(gtfs)
}
