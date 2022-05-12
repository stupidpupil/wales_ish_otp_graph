download_osm <- function(){
  old_opts <- options(timeout=max(options()$timeout,600))
  on.exit(options(old_opts))

  gb_osm_url <- "https://download.geofabrik.de/europe/great-britain-latest.osm.pbf"
  dest_path <- dir_working("great-britain-latest.osm.pbf")

  download.file(gb_osm_url, dest_path)

  jsonlite::toJSON(pretty = TRUE, auto_unbox = TRUE, list(
    SourceUrl = gb_osm_url,
    SourceDownloadedAt = now_as_iso8601(),
    SourceLicence = "ODbL-1.0",
    SourceAttribution = "OpenStreetMap contributors"
  )) %>% write(paste0(dest_path, ".meta.json"))
}

prepare_osm <- function(){
  src_path <- dir_working("great-britain-latest.osm.pbf")
  dest_path <- dir_output(output_affix(), ".osm.pbf")

  unlink(dest_path)
 
  prepare_bounds_geojson()

  bounded_temp_path <- tempfile(tmpdir = dir_working(), fileext=".osm.pbf")

  bounded_osmium_command <- paste0(
    "osmium extract -p ",
    path_to_bounds_geojson(),
    " -s smart ",
    src_path,
    " -o ", bounded_temp_path
  )

  system(bounded_osmium_command)
  stopifnot(file.exists(bounded_temp_path))

  rail_temp_path <- tempfile(tmpdir = dir_working(), fileext=".osm.pbf")

  rail_osmium_command <- paste0(
    "osmium tags-filter ",
    "--expressions ", dir_support("rail_osm_tags.txt"),
    " ", src_path,
    " -o ", rail_temp_path
  )

  system(rail_osmium_command)
  stopifnot(file.exists(rail_temp_path))


  merge_osmium_command <- paste0(
    "osmium merge",
    " ", bounded_temp_path,
    " ", rail_temp_path,
    " -o ", dest_path
  )

  system(merge_osmium_command)

  stopifnot(file.exists(dest_path))

  unlink(bounded_temp_path)
  unlink(rail_temp_path)

  list(
    CreatedAt = now_as_iso8601(),
    DerivedFrom = I(describe_file(src_path))
  ) %>% jsonlite::toJSON(pretty = TRUE, auto_unbox = TRUE) %>%
  write(paste0(dest_path, ".meta.json"))
}

download_and_prepare_osm <- function(){
  download_osm()
  prepare_osm()
}
