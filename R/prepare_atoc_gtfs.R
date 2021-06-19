

prepare_atoc_gtfs <- function(){
  gtfs <- UK2GTFS::atoc2gtfs(path_in = "data-raw/atoc.zip", ncores = (parallel::detectCores()-1))
  gtfs <- gtfs %>% gtfs_wales_ish_ify()
  stopifnot(all(c('CDF', 'NWP', 'WRX', 'HHD', 'CMN') %in% gtfs$stops$stop_code))
  gtfs %>% gtfs_write(folder="output", name="atoc.walesish.gtfs")
}