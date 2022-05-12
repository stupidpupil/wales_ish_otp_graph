pfaedle_all_output_gtfs <- function(){
  for(fn in list.files(dir_output(), "\\.gtfs\\.zip$", full.names=TRUE)){
    pfaedle_a_gtfs_zip(fn)
  }
}

pfaedle_a_gtfs_zip <- function(path_to_gtfs_zip, path_to_osm = dir_output(output_affix(), ".osm.pbf")){

  # Unzip gtfs zip to a temporary folder in dir working

  temp_dir_path <- tempfile(tmpdir = dir_working())
    unzip(path_to_gtfs_zip, exdir=temp_dir_path)

  # pfaedle

  prepare_osm_for_pfaedle(path_to_osm, paste0(temp_dir_path, "/temp.osm"))


  pfaedle_command = paste0(
    "pfaedle -D",
    " -c ", dir_support("pfaedle.cfg"),
    " -x ", paste0(temp_dir_path, "/temp.osm"), " ",
    temp_dir_path,
    " -o ", paste0(temp_dir_path, "/gtfs-out")
  )

  system(pfaedle_command)

  # Rezip gtfs zip, and do some checks that we've not corrupted it

  new_gtfs_zip_path <- paste0(temp_dir_path, "/", basename(path_to_gtfs_zip))

  utils::zip(
    zipfile = new_gtfs_zip_path, 
    files = dir(paste0(temp_dir_path, "/gtfs-out"), pattern="\\.txt$", full.names=TRUE),
    flags = "-rj9X"
    )

  stopifnot(file.exists(new_gtfs_zip_path))
  #stopifnot(file.size(new_gtfs_zip_path) >= file.size(path_to_gtfs_zip)) # HACK

  new_gtfs <- gtfstools::read_gtfs(new_gtfs_zip_path)
  trip_speeds <- gtfstools::get_trip_speed(new_gtfs) %>%
    left_join(new_gtfs$trips, by='trip_id') %>%
    left_join(new_gtfs$routes, by='route_id') %>%
    left_join(gtfs_route_types()) %>%
    select(trip_id, speed, max_speed_kmh)

  # Speed is in km/h and these are quite generous...
  trips_to_strip_shape_id <- trip_speeds %>%
    filter(speed > max_speed_kmh)

  message("Dropping ", nrow(trips_to_strip_shape_id), " shapes as too fast")

  new_gtfs$trips <- new_gtfs$trips %>%
    mutate(shape_id = if_else(trip_id %in% trips_to_strip_shape_id$trip_id, "", shape_id))

  new_gtfs$shapes <- new_gtfs$shapes %>%
    filter(shape_id %in% new_gtfs$trips$shape_id)

  unlink(path_to_gtfs_zip)
  new_gtfs %>% gtfstools::write_gtfs(path_to_gtfs_zip)

  unlink(temp_dir_path, recursive = TRUE)
}

prepare_osm_for_pfaedle <- function(in_osm_path, out_osm_path) {

  osmium_command = paste0(
    "osmium tags-filter ",
    "--expressions ", dir_support("pfaedle_osm_tags.txt"),
    " ", in_osm_path,
    " -o ", out_osm_path,
    " -f osm,add_metadata=false --overwrite"
  )

  system(osmium_command)
  stopifnot(file.exists(out_osm_path))
}