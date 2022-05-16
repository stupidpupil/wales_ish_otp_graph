prepare_r5r_network_dat <- function(){

  old_opts <- options(java.parameters = java_args())
  on.exit(options(old_opts))

  input_files <- c(
    Sys.glob(dir_output("openstreetmap/*.osm.pbf")),
    paths_to_active_gtfs()
  )

  dest_path <- dir_output("r5r/network.dat")
  dest_dir <- dirname(dest_path)

  # Remove any existing 'network.dat' file, as previous failures
  # can result in malformed examples that confuse r5r
  if(fs::file_exists(dest_path)){
    fs::file_delete(dest_path)
  }

  link_paths <- link_create_with_dir(input_files, dest_dir)

  r5r::setup_r5(data_path = dest_dir)

  stopifnot(file.exists(dest_path))

  fs::link_delete(link_paths)

  list(
    CreatedAt = now_as_iso8601(),
    CreatedWithR5rVersion = packageVersion("r5r") %>% as.character(),
    CreatedWithR5Version = formals(r5r::setup_r5)$version %>% as.character(),
    DerivedFrom = describe_file(input_files)
  ) %>% jsonlite::toJSON(pretty = TRUE) %>%
  write(dir_output("network.dat.meta.json"))

  return(dir_output("network.dat"))
}
