prepare_atoc_gtfs <- function(src_path = dir_working("atoc.zip")){

  checkmate::assert_file_exists(src_path, access="r", extension=".zip")

  dest_path <- dir_output("gtfs/", "atoc.", output_affix(), ".gtfs.zip")

  cache_key <- openssl::sha1(paste0(
    cache_key_for_file(src_path),
    packageVersion("UK2GTFS"),
    bounds() %>% sf::st_as_text(),
    parochial_temporal_bounds_as_character(),
    "v1"
  )) %>% as.character()


  if(cache_key == cache_key_for_file(dest_path)){
    message("Cache hit for ", dest_path)
    return(dest_path)
  }

  work_path <- prepare_atoc_gtfs_unbounded(src_path)

  gtfs <- gtfstools::read_gtfs(work_path)
  gtfs <- gtfs %>% gtfs_parochialise()
  gtfs %>% gtfstools::write_gtfs(dest_path)

  list(
    CreatedAt = now_as_iso8601(),
    DerivedFrom = I(describe_file(src_path)),
    ParochialCacheKey = cache_key
  ) %>% jsonlite::toJSON(pretty = TRUE, auto_unbox = TRUE) %>%
  write(paste0(dest_path, ".meta.json"))

  delete_merged_gtfs()

  return(dest_path)
}
