prepare_transport_graph <- function(){

  # TODO: Tolerate missing streetGraph.obj
  checkmate::assert_file_exists(dir_output("streetGraph.obj"), access="r")


  cache_key <- openssl::sha1(paste0(
    openssl::sha1(file(dir_support("otp_config/build-config.json"))),
    openssl::sha1(file(dir_support("otp_config/router-config.json"))),
    cache_key_for_file(dir_output("streetGraph.obj")),
    paste0(cache_key_for_file(Sys.glob(dir_output("*.gtfs.zip"))), collapse=""),
    otp_version()
    )) %>% as.character()

  dest_path <- dir_output("graph.obj")

  if(cache_key == cache_key_for_file(dest_path)){
    message("Cache hit for ", dest_path)
    return(dest_path)
  }

  prepare_otp_config()

  cmd <- paste0(
    java_command(), 
    " -jar ", dir_working("otp.jar"), 
    " --cache ", dir_working("otp_cache"),
    " --loadStreet --save ", dir_output())
  
  system(cmd)

  stopifnot(file.exists(dest_path))

  list(
    CreatedAt = now_as_iso8601(),
    CreatedWithCommand = cmd,
    CreatedWithOpenTripPlannerVersion = otp_version(),
    DerivedFrom = describe_file(dir_output("streetGraph.obj"), dir_output("*.gtfs.zip")),
    ParochialCacheKey = cache_key
  ) %>% jsonlite::toJSON(pretty = TRUE) %>%
  write(dir_output("graph.obj.meta.json"))


  return(dir_output(dest_path))
}
