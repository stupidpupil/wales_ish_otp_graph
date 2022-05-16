paths_to_active_gtfs <- function(){
  paths_to_all_gtfs <- Sys.glob(dir_output("gtfs/*.gtfs.zip"))

  merged_gtfs <- paths_to_all_gtfs %>%
    purrr::keep(function(x){fs::path_file(x) %>% str_detect("^merged\\..+\\.gtfs\\.zip$")})

  if(length(merged_gtfs) == 1){
    return(merged_gtfs)
  }

  return(paths_to_all_gtfs)
}