prepare_street_graph <- function(){

  cmd <- paste0(java_command(), " -jar data-raw/otp.jar --buildStreet output")

  system(cmd)

  list(
    CreatedAt = now() %>% format_ISO8601(usetz=TRUE),
    CreatedWithCommand = cmd,
    CreatedWithOpenTripPlannerVersion = otp_version(),
    DerivedFrom = I(describe_file("output/wales_ish.osm.pbf"))
  ) %>% toJSON(pretty = TRUE) %>%
  write("output/streetGraph.obj.meta.json")

}
