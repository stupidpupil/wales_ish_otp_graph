pfaedle_all_output_gtfs <- function(){
  for(fn in list.files(dir_output(), "\\.gtfs\\.zip$", full.names=TRUE)){
    pfaedle_a_gtfs_zip(fn)
  }
}

pfaedle_a_gtfs_zip <- function(path_to_gtfs_zip, path_to_osm = dir_output(paste0(output_affix(), ".osm.pbf"))){

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
  stopifnot(file.size(new_gtfs_zip_path) >= file.size(path_to_gtfs_zip)) # HACK

  file.copy(new_gtfs_zip_path, path_to_gtfs_zip, overwrite=TRUE)

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