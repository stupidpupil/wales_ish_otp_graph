gtfs_refint_stop_id <- function(gtfs){
  gtfs$stop_times <- gtfs$stop_times %>%
    filter(stop_id %in% gtfs$stops$stop_id)

  if(all(c('from_stop_id', 'to_stop_id') %in% colnames(gtfs$transfers))){
    gtfs$transfers <- gtfs$transfers %>%
      filter(
        from_stop_id %in% gtfs$stops$stop_id,
        to_stop_id %in% gtfs$stops$stop_id
      )
  }

  if(all(c('from_stop_id', 'to_stop_id') %in% colnames(gtfs$pathways))){
    gtfs$pathways <- gtfs$pathways %>%
      filter(
        from_stop_id %in% gtfs$stops$stop_id,
        to_stop_id %in% gtfs$stops$stop_id
      )
  }

  return(gtfs)
}
