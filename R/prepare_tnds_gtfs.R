prepare_tnds_gtfs <- function(){
  gtfs <- transxchange2gtfs(
    path_in = "data-raw/wales.bus.tnds.zip", ncores= (parallel::detectCores()-1), 
    try_mode=TRUE, scotland="no")
  gtfs <- gtfs %>% gtfs_wales_ish_ify()
  gtfs %>% gtfs_write(folder="output", name="wales.bus.walesish.gtfs")

  # NCSD TXC stuff is buried within the zip
  unlink("data-raw/ncsd.bus.tnds", recursive=TRUE)
  unzip("data-raw/ncsd.bus.tnds.zip", exdir="data-raw/ncsd.bus.tnds")
  ncsd_files <- list.files("data-raw/ncsd.bus.tnds/NCSD_TXC/", pattern="*.xml", full.names=TRUE)
  gtfs <- transxchange2gtfs(
    path_in = ncsd_files, ncores= (parallel::detectCores()-1), 
    try_mode=TRUE, scotland="no")

  gtfs <- gtfs %>% gtfs_wales_ish_ify()
  gtfs$routes$route_type = 202
  gtfs %>% gtfs_write(folder="output", name="ncsd.bus.walesish.gtfs")
  unlink("data-raw/ncsd.bus.tnds", recursive=TRUE)
}

