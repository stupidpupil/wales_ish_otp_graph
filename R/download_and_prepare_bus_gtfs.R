download_and_prepare_bus_gtfs <- function(){

  wales_and_regions <- c('wales', 'west_midlands', 'north_west', 'south_west')
  base_bus_url <- "https://data.bus-data.dft.gov.uk/timetable/download/gtfs-file/"

  for (r in wales_and_regions) {
    print(paste0("Downloading bus data for ", r, "…"))
    bus_url <- paste0(base_bus_url, r, '/')
    dest_path <- paste0("data-raw/", r, ".bus.gtfs.zip")
    download.file(bus_url, dest_path)

    print(paste0("Preparing bus data for ", r, "…"))
    gtfs <- better_gtfs_read(dest_path)
    gtfs <- gtfs %>% gtfs_wales_ish_ify()
    gtfs %>% gtfs_write(folder="output", name=paste0(r, ".bus.walesish.gtfs"))
  }

}

