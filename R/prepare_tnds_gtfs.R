prepare_tnds_gtfs <- function(){


  tnds_files <- intersecting_regions_and_nations() %>% pull(tnds_code) %>% na.omit()

  for(r in tnds_files){

    gtfs <- transxchange2gtfs(
      path_in = paste0("data-raw/",r,".bus.tnds.zip"), ncores= (parallel::detectCores()-1), 
      try_mode=TRUE, scotland=ifelse(r == "S", "yes", "no"))
    gtfs <- gtfs %>% gtfs_wales_ish_ify()
    gtfs %>% gtfs_write(folder="output", name=paste0(r,".tnds.walesish.gtfs"))

    list(
      CreatedAt = now() %>% format_ISO8601(usetz=TRUE),
      DerivedFrom = I(describe_file(paste0("data-raw/",r,".bus.tnds.zip")))
    ) %>% toJSON(pretty = TRUE, auto_unbox = TRUE) %>%
    write(paste0("output/",r,".tnds.walesish.gtfs.zip.meta.json"))
  }

  # NCSD TXC stuff is buried within the zip
  unlink("data-raw/NCSD.bus.tnds", recursive=TRUE)
  unzip("data-raw/NCSD.bus.tnds.zip", exdir="data-raw/NCSD.bus.tnds")
  ncsd_files <- list.files("data-raw/ncsd.bus.tnds/NCSD_TXC/", pattern="*.xml", full.names=TRUE)
  gtfs <- transxchange2gtfs(
    path_in = ncsd_files, ncores= (parallel::detectCores()-1), 
    try_mode=TRUE, scotland="no")

  gtfs <- gtfs %>% gtfs_wales_ish_ify()
  gtfs$routes$route_type = 202
  gtfs %>% gtfs_write(folder="output", name="NCSD.tnds.walesish.gtfs")
  unlink("data-raw/NCSD.bus.tnds", recursive=TRUE)

  list(
    CreatedAt = now() %>% format_ISO8601(usetz=TRUE),
    DerivedFrom = I(describe_file("data-raw/NCSD.bus.tnds.zip"))
  ) %>% toJSON(pretty = TRUE, auto_unbox = TRUE) %>%
  write(paste0("output/NCSD.tnds.walesish.gtfs.zip.meta.json"))

}

