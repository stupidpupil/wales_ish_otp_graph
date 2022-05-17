gtfstidy_merge_gtfs <- function(in_gtfs_paths, out_gtfs_path){

  checkmate::assert_file_exists(in_gtfs_paths, access="r", extension=".zip")
  checkmate::assert_character(out_gtfs_path, len=1)

  unlink(out_gtfs_path)

  gtfstidy_args = c(
    "--remove-red-agencies",
    "--remove-red-routes",
    "--remove-red-stops",
    "--remove-red-trips",
    "--remove-red-services",

    "--delete-orphans",

    "--minimize-ids-char",

    # NOTE: Setting max-headway does nothing
    # unless minimise-stoptimes is being used,
    # but better to be future-proof here. See:
    # https://github.com/ad-freiburg/pfaedle/issues/36

    "--max-headway", "65534", 

    in_gtfs_paths,
    "-o", out_gtfs_path
  )

  processx::run(gtfstidy_path(), gtfstidy_args)

  stopifnot(file.exists(out_gtfs_path))

  return(out_gtfs_path)
}
