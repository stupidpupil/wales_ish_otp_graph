gtfs_wales_ish_ify <- function(gtfs){

  gtfs$stops <- gtfs$stops %>% 
    dplyr::union_all(tibble(parent_station=character())) %>%
    mutate(
      stop_lat = as.numeric(stop_lat),
      stop_lon = as.numeric(stop_lon),
      parent_station = if_else(parent_station == "", NA_character_, parent_station)
    ) %>%
    filter((!is.na(stop_lon) & !is.na(stop_lat)) | !is.na(parent_station)) %>%
    sf::st_as_sf(coords = c('stop_lon', 'stop_lat'), crs="EPSG:4326", remove=FALSE) %>%
    filter(
      sf::st_within(geometry, bounds(), sparse=FALSE) |
      stop_id %in% config::get()$additional_stop_ids
      ) %>%
    sf::st_drop_geometry()

  gtfs$stops <- gtfs$stops %>%
    filter(is.na(parent_station) | parent_station %in% gtfs$stops$stop_id) %>%
    filter(is.na(parent_station) | parent_station %in% gtfs$stops$stop_id) %>%
    filter(is.na(parent_station) | parent_station %in% gtfs$stops$stop_id) %>%
    tidyr::replace_na(list(parent_station = ""))

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
    filter(stop_id %in% gtfs$stop_time$stop_id | stop_id %in% gtfs$stops$parent_station)

  if(!is.null(gtfs$transfers)){
    gtfs$transfers <- gtfs$transfers %>% filter((from_stop_id %in% gtfs$stops$stop_id & to_stop_id %in% gtfs$stops$stop_id))
  }

  if(!is.null(gtfs$shapes)){
    gtfs$shapes <- gtfs$shapes %>% filter(shape_id %in% gtfs$trips$shape_id)
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

  stopifnot(all(gtfs$routes$agency_id %in% gtfs$agency$agency_id))



  return(gtfs)
}