prepare_street_graph <- function(){

  prepare_otp_config()

  cmd <- paste0(
    java_command(), 
    " -jar ", dir_working("otp.jar"), 
    " --cache ", dir_working("otp_cache"), 
    " --buildStreet ", dir_output()
    )

  system(cmd)

  stopifnot(file.exists(dir_output("streetGraph.obj")))

  list(
    CreatedAt = now_as_iso8601(),
    CreatedWithCommand = cmd,
    CreatedWithOpenTripPlannerVersion = otp_version(),
    DerivedFrom = describe_file(dir_output("*.osm.pbf"), dir_output("*terr50.tif"))
  ) %>% jsonlite::toJSON(pretty = TRUE) %>%
  write(dir_output("streetGraph.obj.meta.json"))

  return(dir_output("streetGraph.obj"))
}
