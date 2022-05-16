prepare_merged_gtfs <- function(should_pfaedle = pfaedle_is_available()){

  stopifnot(gtfstidy_is_available())

  input_gtfs <- Sys.glob(dir_output("gtfs/*.gtfs.zip")) %>%
    purrr::discard(function(x){fs::path_file(x) %>% str_detect("^merged\\..+\\.gtfs\\.zip$")})

  input_osm <- dir_output("openstreetmap/", output_affix(), ".osm.pbf")

  input_files <- c(input_gtfs, input_osm)

  dest_path <- dir_output("gtfs/merged.", output_affix(), ".gtfs.zip")


  cache_key <- openssl::sha1(paste0(
    paste0(cache_key_for_file(input_files), collapse=""),
    should_pfaedle %>% as.character()
  )) %>% as.character()

  if(cache_key == cache_key_for_file(dest_path)){
    message("Cache hit for ", dest_path)
    return(dest_path)
  }

  gtfstidy_merge_gtfs(input_gtfs, dest_path)
  pfaedle_a_gtfs_zip(dest_path, input_osm)

  list(
    CreatedAt = now_as_iso8601(),
    DerivedFrom = describe_file(input_files),
    ParochialCacheKey = cache_key
  ) %>% jsonlite::toJSON(pretty = TRUE) %>%
    write(paste0(dest_path, ".meta.json"))

  return(dest_path)
}
