prepare_r5r_network_dat <- function(){
  options(java.parameters = java_args())
  setup_r5(data_path="output")

  list(
    CreatedAt = now() %>% format_ISO8601(usetz=TRUE),
    MaxSpatialExtent = wales_ish_bounding_box_string,
    DerivedFrom = list.files("output/", "(\\.osm.pbf|\\.gtfs\\.zip)$", full.names=TRUE) %>% lapply(describe_file)
  ) %>% toJSON(pretty = TRUE) %>%
  write("output/network.dat.meta.json")

}