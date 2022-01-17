gtfs_wales_ish_ify <- function(gtfs){

  gtfs$stops <- gtfs$stops %>% 
    mutate(
      stop_lat = as.numeric(stop_lat),
      stop_lon = as.numeric(stop_lon)
    ) %>%
    filter(!is.na(stop_lon), !is.na(stop_lat)) %>%
    sf::st_as_sf(coords = c('stop_lon', 'stop_lat'), crs=4326, remove=FALSE) %>%
    filter(sf::st_within(geometry, bounds(), sparse=FALSE)) %>%
    sf::st_drop_geometry()

  filter_start_date <- lubridate::today() - lubridate::days(1)
  filter_end_date <- filter_start_date + lubridate::days(29)
  filter_services_ids <- c()

  if(all(c('start_date', 'end_date') %in% colnames(gtfs$calendar))){
    gtfs$calendar <- gtfs$calendar %>%
      filter(lubridate::ymd(end_date) >= filter_start_date, lubridate::ymd(start_date) <= filter_end_date)

    filter_services_ids <- c(filter_services_ids, gtfs$calendar$service_id %>% unique())
  }

  if('date' %in% colnames(gtfs$calendar_dates)){
    gtfs$calendar_dates <- gtfs$calendar_dates %>%
      filter(lubridate::ymd(date) >= filter_start_date, lubridate::ymd(date) <= filter_end_date)

    filter_services_ids <- c(filter_services_ids, gtfs$calendar_dates$service_id %>% unique())
  }

  gtfs$trips <- gtfs$trips %>% 
    filter(
      service_id %in% filter_services_ids
      )

  gtfs$stop_times <- gtfs$stop_times %>% filter(
    stop_id %in% gtfs$stops$stop_id,
    trip_id %in% gtfs$trips$trip_id
    )

  gtfs$stop_times <- gtfs$stop_times %>% 
    group_by(trip_id) %>% filter(dplyr::n_distinct(stop_id) > 1) %>%
    ungroup()

  str_is_empty <- function(x){is.na(x) | str_length(x) == 0}

  gtfs$trips <- gtfs$trips %>% 
    filter(trip_id %in% gtfs$stop_time$trip_id)

  gtfs$stops <- gtfs$stops %>% 
    filter(stop_id %in% gtfs$stop_time$stop_id )

   if(!is.null(gtfs$transfers)){
      gtfs$transfers <- gtfs$transfers %>% filter((from_stop_id %in% gtfs$stops$stop_id & to_stop_id %in% gtfs$stops$stop_id))
    }

  gtfs$routes <- gtfs$routes %>% 
    filter(route_id %in% gtfs$trips$route_id) %>% 
    mutate(agency_id = ifelse(str_is_empty(agency_id), paste0("Unknown", route_id), agency_id))

  gtfs$agency <- gtfs$agency %>% filter(!is.na(agency_id), agency_id %in% gtfs$routes$agency_id)

  # Create new agencies if we have to
  gtfs$agency <- gtfs$agency %>% bind_rows(tibble(
    agency_id = setdiff(gtfs$routes$agency_id, gtfs$agency$agency_id) %>% as.character()
  ))

  # We don't need to risk any optional agency fields
  # But make sure the required ones are completed
  gtfs$agency <- gtfs$agency %>%
    select(agency_id, agency_name, agency_url, agency_timezone) %>%
    mutate(
      agency_name = ifelse(str_is_empty(agency_name), agency_id, agency_name),
      agency_url = ifelse(str_is_empty(agency_url), paste0("https://", agency_id, ".example"), agency_url),
      agency_timezone = ifelse(str_is_empty(agency_timezone), "Europe/London", agency_timezone),
    )

  # UK2GTFS doesn't support saving shapes
  gtfs$trips$shape_id <- NULL
  gtfs$stop_times$shape_dist_traveled <- NULL
  gtfs$routes$continuous_pickup <- NULL
  gtfs$routes$continuous_drop_off <- NULL
  gtfs$trips$block_id <- NULL

  stopifnot(all(gtfs$routes$agency_id %in% gtfs$agency$agency_id))

  return(gtfs)
}