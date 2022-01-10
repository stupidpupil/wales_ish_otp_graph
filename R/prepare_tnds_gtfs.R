prepare_tnds_gtfs <- function(){


  tnds_files <- intersecting_regions_and_nations() %>% pull(tnds_code) %>% na.omit()

  for(r in tnds_files){
    src_path <- dir_working(paste0(r, ".bus.tnds.zip"))


    gtfs <- transxchange2gtfs(
      path_in = src_path, ncores= (parallel::detectCores()-1), 
      try_mode=TRUE, scotland=ifelse(r == "S", "yes", "no"))
    gtfs <- gtfs %>% gtfs_wales_ish_ify()
    gtfs %>% gtfs_write(folder=dir_output(), name=paste0(r,".tnds.walesish.gtfs"))

    list(
      CreatedAt = now() %>% format_ISO8601(usetz=TRUE),
      DerivedFrom = I(describe_file(src_path))
    ) %>% toJSON(pretty = TRUE, auto_unbox = TRUE) %>%
    write(dir_output(paste0(r,".tnds.walesish.gtfs.zip.meta.json")))
  }

  # NCSD TXC stuff is buried within the zip
  unlink(dir_working("NCSD.bus.tnds"), recursive=TRUE)
  unzip(dir_working("NCSD.bus.tnds.zip"), exdir=dir_working("NCSD.bus.tnds"))

  ncsd_files <- list.files(dir_working("NCSD.bus.tnds/NCSD_TXC/"), pattern="*.xml", full.names=TRUE)
  gtfs <- transxchange2gtfs(
    path_in = ncsd_files, ncores= (parallel::detectCores()-1), 
    try_mode=TRUE, scotland="no")

  gtfs <- gtfs %>% gtfs_wales_ish_ify()
  gtfs$routes$route_type = 202
  gtfs %>% gtfs_write(folder=dir_output(), name="NCSD.tnds.walesish.gtfs")
  unlink(dir_working("NCSD.bus.tnds"), recursive=TRUE)

  list(
    CreatedAt = now() %>% format_ISO8601(usetz=TRUE),
    DerivedFrom = I(describe_file(dir_working("NCSD.bus.tnds.zip")))
  ) %>% toJSON(pretty = TRUE, auto_unbox = TRUE) %>%
  write(dir_output("NCSD.tnds.walesish.gtfs.zip.meta.json"))

}
