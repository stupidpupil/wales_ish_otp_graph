gtfs_route_types <- function(){
  readr::read_csv(dir_support("gtfs_route_types.csv"), col_types="icci")
}