prepare_r5r_network_dat <- function(){

  prepare_r5r_config()

  options(java.parameters = java_args())
  setup_r5(data_path="output")

  list(
    CreatedAt = now() %>% format_ISO8601(usetz=TRUE),
    DerivedFrom = list.files(dir_output(), "(\\.osm.pbf|\\.gtfs\\.zip)$", full.names=TRUE) %>% lapply(describe_file)
  ) %>% toJSON(pretty = TRUE) %>%
  write(dir_output("network.dat.meta.json"))

}
