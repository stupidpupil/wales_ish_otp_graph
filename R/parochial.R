parochial <- function(){
  check_config_and_environment()

  download_atoc()
  prepare_atoc_gtfs()
  download_tnds()
  prepare_tnds_gtfs()
  download_and_prepare_bods_gtfs()
  download_and_prepare_osm()

  # If you want to include elevation data (e.g. for walking, cycling)
  download_terrain50()
  prepare_terrain50()

  # If you've got gtfstidy and pfaedle installed
  if(gtfstidy_is_available() & pfaedle_is_available()){
    prepare_merged_gtfs()
  }

  if(osrm_is_available()){
    prepare_osrm_graph()
  }

  # OpenTripPlanner
  # (Requires JDK 17)
  download_otp()
  prepare_street_graph()
  prepare_transport_graph()
  # output/opentripplanner/ should now contain graph.obj

  # r5r
  # (Requires JDK 11)
  prepare_r5r_network_dat()
}