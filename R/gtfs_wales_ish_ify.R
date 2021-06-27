gtfs_wales_ish_ify <- function(gtfs){

  gtfs$stops <- gtfs$stops %>% filter(
    !is.na(stop_lon), !is.na(stop_lat),
    stop_lat >= wales_ish_bounding_box[[1]][[1]], stop_lat <= wales_ish_bounding_box[[2]][[1]],
    stop_lon >= wales_ish_bounding_box[[1]][[2]], stop_lon <= wales_ish_bounding_box[[2]][[2]]
    )

  if(!is.null(gtfs$transfers)){
    gtfs$transfers <- gtfs$transfers %>% filter((from_stop_id %in% gtfs$stops$stop_id & to_stop_id %in% gtfs$stops$stop_id))
  }

  gtfs$stop_times <- gtfs$stop_times %>% filter(
    stop_id %in% gtfs$stops$stop_id,
    trip_id %in% gtfs$trips$trip_id
    )

  gtfs$trips <- gtfs$trips %>% filter(trip_id %in% gtfs$stop_time$trip_id)
  gtfs$routes <- gtfs$routes %>% filter(route_id %in% gtfs$trips$route_id)
  gtfs$agency <- gtfs$agency %>% filter(agency_id %in% gtfs$routes$agency_id)

  # Create new agencies if we have to
  gtfs$agency <- gtfs$agency %>% bind_rows(tibble(
    agency_id = setdiff(gtfs$routes$agency_id, gtfs$agency$agency_id),
  ) %>% mutate(
    agency_name = agency_id,
    agency_url = paste0("https://", agency_id, ".example"),
    agency_timezone = "Europe/London"
  ))


  # UK2GTFS doesn't support saving shapes
  gtfs$trips$shape_id <- NULL
  gtfs$stop_times$shape_dist_traveled <- NULL
  gtfs$routes$continuous_pickup <- NULL
  gtfs$routes$continuous_drop_off <- NULL
  gtfs$trips$block_id <- NULL

  stopifnot(all(gtfs$routes$agency_id %in% gtfs$agency$agency_id))

  return(gtfs)
}