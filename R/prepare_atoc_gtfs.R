prepare_atoc_gtfs <- function(){
  gtfs <- UK2GTFS::atoc2gtfs(
    path_in = dir_working("atoc.zip"),
    ncores = (parallel::detectCores()-1))
  gtfs <- gtfs %>% gtfs_wales_ish_ify()
  gtfs %>% gtfstools::write_gtfs(dir_output(paste0("atoc.", output_affix(), ".gtfs.zip")))

  list(
    CreatedAt = now_as_iso8601(),
    DerivedFrom = I(describe_file(dir_working("atoc.zip")))
  ) %>% jsonlite::toJSON(pretty = TRUE, auto_unbox = TRUE) %>%
  write(dir_output(paste0("atoc.", output_affix(), ".gtfs.zip.meta.json")))
}
