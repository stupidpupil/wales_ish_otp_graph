prepare_atoc_gtfs <- function(src_path = dir_working("atoc.zip")){

  checkmate::assert_file_exists(src_path, access="r", extension=".zip")

  cache_key <- openssl::sha1(paste0(
    cache_key_for_file(src_path),
    packageVersion("UK2GTFS"),
    bounds() %>% sf::st_as_text(),
    temporal_bounds_as_character(),
    "v1"
  )) %>% as.character()

  class(cache_key) <- "character"

  dest_path <- dir_output("gtfs/", "atoc.", output_affix(), ".gtfs.zip")

  if(cache_key == cache_key_for_file(dest_path)){
    message("Cache hit for ", dest_path)
    return(dest_path)
  }

  gtfs <- UK2GTFS::atoc2gtfs(
    path_in = src_path,
    ncores = (parallel::detectCores()-1))
  gtfs <- gtfs %>% gtfs_wales_ish_ify()

  gtfs %>% UK2GTFS::gtfs_write(
    folder = fs::path_dir(dest_path), 
    name = fs::path_ext_remove(fs::path_file(dest_path)))

  list(
    CreatedAt = now_as_iso8601(),
    DerivedFrom = I(describe_file(src_path)),
    ParochialCacheKey = cache_key
  ) %>% jsonlite::toJSON(pretty = TRUE, auto_unbox = TRUE) %>%
  write(paste0(dest_path, ".meta.json"))

  return(dest_path)
}
