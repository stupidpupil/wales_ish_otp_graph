delete_merged_gtfs <- function(){
  merged_gtfs <- Sys.glob(dir_output("gtfs/merged.*.gtfs.zip.*"))

  if(length(merged_gtfs) > 0){
    return(fs::file_delete(merged_gtfs))
  }

  return(character(0))
}