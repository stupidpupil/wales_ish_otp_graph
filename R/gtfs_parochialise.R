gtfs_parochialise <- function(
  gtfs, 
  spatial_bounds = bounds(buffer_by_metres = 5000),
  additional_stop_ids = config::get()$additional_stop_ids,
  temporal_bounds = parochial_temporal_bounds()){

  gtfs <- gtfs %>%
    gtfs_keep_in_spatial_bounds(spatial_bounds, additional_stop_ids) %>%
    gtfs_keep_in_temporal_bounds(temporal_bounds) %>%
    gtfs_remove_one_stop_trips()

  gtfs$stops <- gtfs$stops %>%
    filter(
      stop_id %in% gtfs$stops$parent_station |
      stop_id %in% gtfs$stop_times$stop_id
    )

  gtfs <- gtfs %>% gtfs_refint_stop_id()

  str_is_empty <- function(x){is.na(x) | str_length(x) == 0}

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
    
  return(gtfs)
}