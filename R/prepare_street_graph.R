prepare_street_graph <- function(){

  prepare_osm_config()

  cmd <- paste0(java_command(), " -jar ", dir_working("otp.jar"), " --buildStreet ", dir_output())

  system(cmd)

  list(
    CreatedAt = now() %>% format_ISO8601(usetz=TRUE),
    CreatedWithCommand = cmd,
    CreatedWithOpenTripPlannerVersion = otp_version(),
    DerivedFrom = I(describe_file(dir_output("wales_ish.osm.pbf")))
  ) %>% toJSON(pretty = TRUE) %>%
  write(dir_output("streetGraph.obj.meta.json"))

}
