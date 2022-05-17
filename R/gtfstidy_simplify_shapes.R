gtfstidy_simplify_shapes <- function(path_to_gtfs_zip) {

  working_filename <- tempfile(tmpdir = dir_working(), fileext=".gtfs.zip")

  gtfstidy_args = c(
    "--min-shapes",
    "--remove-red-shapes",
    "--remeasure-shapes",
    path_to_gtfs_zip,
    "-o", working_filename
  )

  processx::run(gtfstidy_path(), gtfstidy_args)
  stopifnot(file.exists(working_filename))

  unlink(path_to_gtfs_zip)
  file.copy(working_filename, path_to_gtfs_zip)
  unlink(working_filename)

  return(path_to_gtfs_zip)
}
