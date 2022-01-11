prepare_tnds_gtfs <- function(){


  tnds_files <- intersecting_regions_and_nations() %>% pull(tnds_code) %>% na.omit()

  for(r in tnds_files){
    src_path <- dir_working(paste0(r, ".bus.tnds.zip"))


    gtfs <- UK2GTFS::transxchange2gtfs(
      path_in = src_path, ncores= (parallel::detectCores()-1), 
      try_mode=TRUE, scotland=ifelse(r == "S", "yes", "no"))
    gtfs <- gtfs %>% gtfs_wales_ish_ify()
    gtfs %>% UK2GTFS::gtfs_write(folder=dir_output(), name=paste0(r,".tnds.", output_affix(), ".gtfs"))

    list(
      CreatedAt = now_as_iso8601(),
      DerivedFrom = I(describe_file(src_path))
    ) %>% jsonlite::toJSON(pretty = TRUE, auto_unbox = TRUE) %>%
    write(dir_output(paste0(r,".tnds.", output_affix(), ".gtfs.zip.meta.json")))
  }

  # NCSD TXC stuff is buried within the zip
  unlink(dir_working("NCSD.bus.tnds"), recursive=TRUE)
  unzip(dir_working("NCSD.bus.tnds.zip"), exdir=dir_working("NCSD.bus.tnds"))

  ncsd_files <- list.files(dir_working("NCSD.bus.tnds/NCSD_TXC/"), pattern="*.xml", full.names=TRUE)
  gtfs <- UK2GTFS::transxchange2gtfs(
    path_in = ncsd_files, ncores= (parallel::detectCores()-1), 
    try_mode=TRUE, scotland="no")

  gtfs <- gtfs %>% gtfs_wales_ish_ify()

  if(gtfs$routes %>% nrow() > 0){
    gtfs$routes$route_type = 202
  }
  
  gtfs %>% UK2GTFS::gtfs_write(folder=dir_output(), name=paste0("NCSD.tnds.", output_affix(), ".gtfs"))
  unlink(dir_working("NCSD.bus.tnds"), recursive=TRUE)

  list(
    CreatedAt = now_as_iso8601(),
    DerivedFrom = I(describe_file(dir_working("NCSD.bus.tnds.zip")))
  ) %>% jsonlite::toJSON(pretty = TRUE, auto_unbox = TRUE) %>%
  write(dir_output(paste0("NCSD.tnds.", output_affix(), ".gtfs.zip.meta.json")))

}
