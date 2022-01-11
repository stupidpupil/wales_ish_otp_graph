prepare_transport_graph <- function(){

  prepare_otp_config()

  cmd <- paste0(java_command(), " -jar ", dir_working("otp.jar"), " --loadStreet --save ", dir_output())
  
  system(cmd)

  list(
    CreatedAt = now_as_iso8601(),
    CreatedWithCommand = cmd,
    CreatedWithOpenTripPlannerVersion = otp_version(),
    DerivedFrom = list.files(dir_output(), "(streetGraph.obj|\\.gtfs\\.zip)$", full.names=TRUE) %>% sapply(describe_file, USE.NAMES=F)
  ) %>% jsonlite::toJSON(pretty = TRUE) %>%
  write(dir_output("graph.obj.meta.json"))

}
