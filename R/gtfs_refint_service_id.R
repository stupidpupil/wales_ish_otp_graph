gtfs_refint_service_id <- function(gtfs){

  filter_services_ids <- c()

  if('service_id' %in% colnames(gtfs$calendar)){
    gtfs$calendar <- gtfs$calendar %>%
      filter(service_id %in% gtfs$trips$service_id)

    filter_services_ids <- c(filter_services_ids, gtfs$calendar$service_id %>% unique())
  }

  if('service_id' %in% colnames(gtfs$calendar_dates)){
    gtfs$calendar_dates <- gtfs$calendar_dates %>%
      filter(service_id %in% gtfs$trips$service_id)

    filter_services_ids <- c(filter_services_ids, gtfs$calendar_dates$service_id %>% unique())
  }

  gtfs$trips <- gtfs$trips %>% 
    filter(service_id %in% filter_services_ids)

  gtfs <- gtfs %>% gtfs_refint_trip_id()

  return(gtfs)
}
