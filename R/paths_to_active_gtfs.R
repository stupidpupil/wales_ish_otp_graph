#' Get paths to GTFS zips that parochial considers 'active'
#'
#' @details
#' This function returns filepaths to the GTFS zips that parochial considers 'active'
#' and will make use of in, for example, \code{prepare_r5r_network_dat} or \code{prepare_transport_network}.
#'
#' Usually this is the value of \code{dir_output("gtfs/*.gtfs.zip")}.
#' However, if a single GTFS zip begins with 'merged.' then this will be treated as the sole 'active' GTFS zip.
#' 
paths_to_active_gtfs <- function(){
  paths_to_all_gtfs <- Sys.glob(dir_output("gtfs/*.gtfs.zip"))

  merged_gtfs <- paths_to_all_gtfs %>%
    purrr::keep(function(x){fs::path_file(x) %>% str_detect("^merged\\..+\\.gtfs\\.zip$")})

  if(length(merged_gtfs) == 1){
    return(merged_gtfs)
  }

  return(paths_to_all_gtfs)
}