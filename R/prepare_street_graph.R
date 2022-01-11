prepare_street_graph <- function(){

  prepare_otp_config()

  cmd <- paste0(java_command(), " -jar ", dir_working("otp.jar"), " --buildStreet ", dir_output())

  system(cmd)

  list(
    CreatedAt = now_as_iso8601(),
    CreatedWithCommand = cmd,
    CreatedWithOpenTripPlannerVersion = otp_version(),
    DerivedFrom = I(describe_file(dir_output(paste0(output_affix(), ".osm.pbf"))))
  ) %>% jsonlite::toJSON(pretty = TRUE) %>%
  write(dir_output("streetGraph.obj.meta.json"))

}
