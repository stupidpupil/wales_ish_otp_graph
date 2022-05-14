prepare_street_graph <- function(){

  cache_key <- openssl::sha1(paste0(
    openssl::sha1(file(dir_support("otp_config/build-config.json"))),
    openssl::sha1(file(dir_support("otp_config/router-config.json"))),
    cache_key_for_file(Sys.glob(dir_output("*.osm.pbf"))),
    cache_key_for_file(Sys.glob(dir_output("*terr50.tif"))),
    otp_version()
    )) %>% as.character()

  dest_path <- dir_output("streetGraph.obj")

  if(cache_key == cache_key_for_file(dest_path)){
    message("Cache hit for ", dest_path)
    return(dest_path)
  }

  prepare_otp_config()

  cmd <- paste0(
    java_command(), 
    " -jar ", dir_working("otp.jar"), 
    " --cache ", dir_working("otp_cache"), 
    " --buildStreet ", dir_output()
    )

  system(cmd)

  stopifnot(file.exists(dest_path))

  list(
    CreatedAt = now_as_iso8601(),
    CreatedWithCommand = cmd,
    CreatedWithOpenTripPlannerVersion = otp_version(),
    DerivedFrom = describe_file(dir_output("*.osm.pbf"), dir_output("*terr50.tif")),
    ParochialCacheKey = cache_key
  ) %>% jsonlite::toJSON(pretty = TRUE) %>%
  write(dir_output("streetGraph.obj.meta.json"))

  return(dest_path)
}
