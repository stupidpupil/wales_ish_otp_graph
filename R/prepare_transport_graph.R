prepare_transport_graph <- function(){

  prepare_otp_config()

  cmd <- paste0(java_command(), " -jar ", dir_working("otp.jar"), " --loadStreet --save ", dir_output())
  
  system(cmd)

  stopifnot(file.exists(dir_output("graph.obj")))

  list(
    CreatedAt = now_as_iso8601(),
    CreatedWithCommand = cmd,
    CreatedWithOpenTripPlannerVersion = otp_version(),
    DerivedFrom = describe_file(dir_output("streetGraph.obj"), dir_output("*.gtfs.zip"))
  ) %>% jsonlite::toJSON(pretty = TRUE) %>%
  write(dir_output("graph.obj.meta.json"))


  return(dir_output("graph.obj"))
}
