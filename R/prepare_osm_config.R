prepare_osm_config <- function(){
  file.copy(dir_support("osm_config/build-config.json"), dir_output("build-config.json"), overwrite=TRUE)
  file.copy(dir_support("osm_config/router-config.json"), dir_output("router-config.json"), overwrite=TRUE)
}
-