gtfs_keep_in_temporal_bounds <- function(gtfs, temporal_bounds, limit_calendar=TRUE) {

  filter_start_date <- temporal_bounds[[1]]
  filter_end_date <- temporal_bounds[[2]]

  if(all(c('start_date', 'end_date') %in% colnames(gtfs$calendar))){
    gtfs$calendar <- gtfs$calendar %>%
      filter(
      	lubridate::ymd(end_date)   >= filter_start_date, 
      	lubridate::ymd(start_date) <= filter_end_date,
      	)

    if(limit_calendar){

      # HACK - comptability with both UK2GTFS and gtfstools

      dates_as_characters <- any(inherits(gtfs$calendar$start_date, "character"))

    	gtfs$calendar <- gtfs$calendar %>%
    		mutate(
    			start_date = pmax(lubridate::ymd(start_date), filter_start_date),
    			end_date   = pmin(lubridate::ymd(end_date),   filter_end_date)
    		)

      if(dates_as_characters){
        gtfs$calendar <- gtfs$calendar %>%
          mutate(
            start_date = start_date %>% strftime("%Y%m%d"),
            end_date   = end_date   %>% strftime("%Y%m%d")
          )
      }

    }
  }

  if('date' %in% colnames(gtfs$calendar_dates)){
    gtfs$calendar_dates <- gtfs$calendar_dates %>%
      filter(
      	lubridate::ymd(date) >= filter_start_date, 
      	lubridate::ymd(date) <= filter_end_date,
      	)
  }

  gtfs <- gtfs %>% gtfs_refint_service_id()

  return(gtfs)
}