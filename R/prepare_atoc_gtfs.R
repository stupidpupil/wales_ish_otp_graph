prepare_atoc_gtfs <- function(src_path = dir_working("atoc.zip")){

  checkmate::assert_file_exists(src_path, access="r", extension=".zip")

  gtfs <- UK2GTFS::atoc2gtfs(
    path_in = src_path,
    ncores = (parallel::detectCores()-1))
  gtfs <- gtfs %>% gtfs_wales_ish_ify()
  gtfs %>% UK2GTFS::gtfs_write(folder=dir_output(), name=paste0("atoc.", output_affix(), ".gtfs"))

  list(
    CreatedAt = now_as_iso8601(),
    DerivedFrom = I(describe_file(src_path))
  ) %>% jsonlite::toJSON(pretty = TRUE, auto_unbox = TRUE) %>%
  write(dir_output("atoc.", output_affix(), ".gtfs.zip.meta.json"))

  return(dir_output("atoc.", output_affix(), ".gtfs.zip"))
}
