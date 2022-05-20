prepare_r5r_network_dat <- function(){

  old_opts <- options(java.parameters = java_args())
  on.exit(options(old_opts))

  input_files <- c(
    Sys.glob(dir_output("openstreetmap/*.osm.pbf")),
    paths_to_active_gtfs()
  )

  cache_key <- openssl::sha1(paste0(
    paste0(cache_key_for_file(input_files), collapse=""),
    packageVersion("r5r") %>% as.character()
  )) %>% as.character()


  dest_path <- dir_output("r5r/network.dat")
  dest_dir <- fs::path_dir(dest_path)

  if(cache_key == cache_key_for_file(dest_path)){
    message("Cache hit for ", dest_path)
    return(dest_path)
  }

  message("Preparing R5r network.dat...")

  # Remove any existing 'network.dat' file, as previous failures
  # can result in malformed examples that confuse r5r
  if(fs::file_exists(dest_path)){
    fs::file_delete(dest_path)
  }

  link_paths <- link_create_with_dir(input_files, dest_dir)
  on.exit({fs::link_delete(link_paths)}, add = TRUE)

  r5r::setup_r5(data_path = dest_dir) %>%
    r5r::stop_r5()

  stopifnot(file.exists(dest_path))

  list(
    CreatedAt = now_as_iso8601(),
    CreatedWithR5rVersion = packageVersion("r5r") %>% as.character(),
    CreatedWithR5Version = formals(r5r::setup_r5)$version %>% as.character(),
    DerivedFrom = describe_file(input_files),
    ParochialCacheKey = cache_key
  ) %>% jsonlite::toJSON(pretty = TRUE) %>%
  write(paste0(dest_path, ".meta.json"))

  return(dest_path)
}
