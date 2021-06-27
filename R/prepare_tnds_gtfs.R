prepare_tnds_gtfs <- function(){
  gtfs <- transxchange2gtfs(path_in = "data-raw/wales.bus.tnds.zip", ncores= (parallel::detectCores()-1), try_mode=TRUE)
  gtfs <- gtfs %>% gtfs_wales_ish_ify()
  gtfs %>% gtfs_write(folder="output", name="wales.bus.walesish.gtfs")
}

