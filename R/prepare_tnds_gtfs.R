prepare_tnds_gtfs <- function(){

  tnds_files <- intersecting_regions_and_nations() %>% pull(tnds_code) %>% na.omit()

  dest_paths <- c()

  for(r in tnds_files){
    src_path <- dir_working(r, ".bus.tnds.zip")

    checkmate::assert_file_exists(src_path, access="r", extension=".zip")

    cache_key <- openssl::sha1(paste0(
      cache_key_for_file(src_path),
      packageVersion("UK2GTFS"),
      bounds() %>% sf::st_as_text(),
      temporal_bounds_as_character(),
      "v1"
    )) %>% as.character()

    class(cache_key) <- "character"

    dest_path <- dir_output(r,".tnds.", output_affix(), ".gtfs.zip")
    dest_paths <- c(dest_paths, dest_path)

    if(cache_key == cache_key_for_file(dest_path)){
      message("Cache hit for ", dest_path)
      next
    }

    gtfs <- UK2GTFS::transxchange2gtfs(
      path_in = src_path, ncores= (parallel::detectCores()-1), 
      try_mode=TRUE, scotland=ifelse(r == "S", "yes", "no"), force_merge = TRUE)
    gtfs <- gtfs %>% gtfs_wales_ish_ify()

    gtfs %>% UK2GTFS::gtfs_write(folder=dir_output(), name=paste0(r,".tnds.", output_affix(), ".gtfs"))

    list(
      CreatedAt = now_as_iso8601(),
      DerivedFrom = I(describe_file(src_path)),
      ParochialCacheKey = cache_key
    ) %>% jsonlite::toJSON(pretty = TRUE, auto_unbox = TRUE) %>%
    write(paste0(dest_path, ".meta.json"))

  }

  # NCSD TXC stuff is buried within the zip
  checkmate::assert_file_exists(dir_working("NCSD.bus.tnds.zip"), access="r", extension=".zip")

  dest_path <- dir_output("NCSD.tnds.", output_affix(), ".gtfs.zip")
  dest_paths <- c(dest_paths, dest_path)

  cache_key <- openssl::sha1(paste0(
    cache_key_for_file(dir_working("NCSD.bus.tnds.zip")),
    packageVersion("UK2GTFS"),
    bounds() %>% sf::st_as_text(),
    temporal_bounds_as_character(),
    "v1"
  )) %>% as.character()

  if(cache_key == cache_key_for_file(dest_path)){
    message("Cache hit for ", dest_path)
  }else{
    unlink(dir_working("NCSD.bus.tnds"), recursive=TRUE)
    unzip(dir_working("NCSD.bus.tnds.zip"), exdir=dir_working("NCSD.bus.tnds"))

    ncsd_files <- list.files(dir_working("NCSD.bus.tnds/NCSD_TXC/"), pattern="*.xml", full.names=TRUE)
    gtfs <- UK2GTFS::transxchange2gtfs(
      path_in = ncsd_files, ncores= (parallel::detectCores()-1), 
      try_mode=TRUE, scotland="no", force_merge = TRUE)

    gtfs <- gtfs %>% gtfs_wales_ish_ify()

    if(gtfs$routes %>% nrow() > 0){
      gtfs$routes$route_type <- 202 
      # "National Coach Service" per https://developers.google.com/transit/gtfs/reference/extended-route-types
    }

    gtfs %>% UK2GTFS::gtfs_write(folder=dir_output(), name=paste0("NCSD.tnds.", output_affix(), ".gtfs"))

    unlink(dir_working("NCSD.bus.tnds"), recursive=TRUE)

    list(
      CreatedAt = now_as_iso8601(),
      DerivedFrom = I(describe_file(dir_working("NCSD.bus.tnds.zip"))),
      ParochialCacheKey = cache_key
    ) %>% jsonlite::toJSON(pretty = TRUE, auto_unbox = TRUE) %>%
    write(dir_output("NCSD.tnds.", output_affix(), ".gtfs.zip.meta.json"))
  }

  return(dest_paths)
}
