prepare_tnds_gtfs <- function(){
  gtfs <- transxchange2gtfs(
    path_in = "data-raw/wales.bus.tnds.zip", ncores= (parallel::detectCores()-1), 
    try_mode=TRUE, scotland="no")
  gtfs <- gtfs %>% gtfs_wales_ish_ify()
  gtfs %>% gtfs_write(folder="output", name="wales.bus.walesish.gtfs")

  list(
    CreatedAt = now() %>% format_ISO8601(usetz=TRUE),
    MaxSpatialExtent = wales_ish_bounding_box_string,
    DerivedFrom = I(describe_file("data-raw/wales.bus.tnds.zip"))
  ) %>% toJSON(pretty = TRUE, auto_unbox = TRUE) %>%
  write(paste0("output/wales.bus.walesish.gtfs.zip.meta.json"))

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

  list(
    CreatedAt = now() %>% format_ISO8601(usetz=TRUE),
    MaxSpatialExtent = wales_ish_bounding_box_string,
    DerivedFrom = I(describe_file("data-raw/ncsd.bus.tnds.zip"))
  ) %>% toJSON(pretty = TRUE, auto_unbox = TRUE) %>%
  write(paste0("output/ncsd.bus.walesish.gtfs.zip.meta.json"))

}

