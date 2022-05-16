delete_merged_gtfs <- function(){
  fs::delete_file(Sys.glob(dir_output("gtfs/merged.*.gtfs.zip.*")))
}