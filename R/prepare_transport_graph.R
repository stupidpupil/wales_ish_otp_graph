prepare_transport_graph <- function(){

  cmd <- paste0(java_command(), " -jar data-raw/otp.jar --loadStreet --save output")
  
  system(cmd)

  list(
    CreatedAt = now() %>% format_ISO8601(usetz=TRUE),
    CreatedWithCommand = cmd,
    CreatedWithOpenTripPlannerVersion = otp_version(),
    MaxSpatialExtent = wales_ish_bounding_box_string,
    DerivedFrom = list.files("output/", "(streetGraph.obj|\\.gtfs\\.zip)$", full.names=TRUE) %>% sapply(describe_file, USE.NAMES=F)
  ) %>% toJSON(pretty = TRUE) %>%
  write("output/graph.obj.meta.json")

}
