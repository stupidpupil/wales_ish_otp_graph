prepare_atoc_gtfs <- function(){
  gtfs <- UK2GTFS::atoc2gtfs(path_in = dir_working("atoc.zip"), ncores = (parallel::detectCores()-1))
  gtfs <- gtfs %>% gtfs_wales_ish_ify()
  gtfs %>% gtfs_write(folder=dir_output(), name="atoc.walesish.gtfs")

  list(
    CreatedAt = now() %>% format_ISO8601(usetz=TRUE),
    DerivedFrom = I(describe_file(dir_working("atoc.zip")))
  ) %>% toJSON(pretty = TRUE, auto_unbox = TRUE) %>%
  write(dir_output("atoc.walesish.gtfs.zip.meta.json"))
}
