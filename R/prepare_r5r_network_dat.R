prepare_r5r_network_dat <- function(){
  prepare_r5r_config()

  old_opts <- options(java.parameters = java_args())
  on.exit(options(old_opts))

  # Remove any existing 'network.dat' file, as previous failures
  # can result in malformed examples that confuse r5r
  unlink(dir_output("network.dat"))
  r5r::setup_r5(data_path="output")

  list(
    CreatedAt = now_as_iso8601(),
    DerivedFrom = list.files(dir_output(), "(\\.osm.pbf|\\.gtfs\\.zip)$", full.names=TRUE) %>% lapply(describe_file)
  ) %>% jsonlite::toJSON(pretty = TRUE) %>%
  write(dir_output("network.dat.meta.json"))
}
