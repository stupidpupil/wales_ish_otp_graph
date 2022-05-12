gtfstidy_simplify_shapes <- function(path_to_gtfs_zip) {

  working_filename <- tempfile(tmpdir = dir_working(), fileext=".gtfs.zip")

  gtfstidy_command = paste0(
    "$(go env GOPATH)/bin/gtfstidy",
    " --min-shapes",
    " --remove-red-shapes",
    " --remeasure-shapes",
    " ", path_to_gtfs_zip,
    " -o ", working_filename
  )

  stopifnot(file.exists(working_filename))

  unlink(path_to_gtfs_zip)
  file.copy(working_filename, path_to_gtfs_zip)
  unlink(working_filename)
}
