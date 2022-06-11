path_to_osrm_graph <- function(profile_name){
  # NOTE - the actual filename is based on the input OSM filename
  checkmate::assert_character(profile_name, len=1)
  dir_output("osrm_", profile_name, "/", output_affix(), ".osrm")
}
