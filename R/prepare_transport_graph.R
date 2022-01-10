prepare_transport_graph <- function(){

  prepare_osm_config()

  cmd <- paste0(java_command(), " -jar ", dir_working("otp.jar"), " --loadStreet --save ", dir_output())
  
  system(cmd)

  list(
    CreatedAt = now() %>% format_ISO8601(usetz=TRUE),
    CreatedWithCommand = cmd,
    CreatedWithOpenTripPlannerVersion = otp_version(),
    DerivedFrom = list.files(dir_output(), "(streetGraph.obj|\\.gtfs\\.zip)$", full.names=TRUE) %>% sapply(describe_file, USE.NAMES=F)
  ) %>% toJSON(pretty = TRUE) %>%
  write(dir_output("graph.obj.meta.json"))

}
