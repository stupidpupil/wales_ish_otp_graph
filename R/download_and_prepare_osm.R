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
  dest_path <- dir_working("great-britain-latest.osm.pbf")
 
  bounds_geojson_path <- dir_output(paste0(output_affix(), "bounds.geojson"))
  unlink(bounds_geojson_path)
  bounds() %>% sf::st_write(bounds_geojson_path)

  osmium_command = paste0(
    "osmium extract -p ",
    bounds_geojson_path,
    " -s smart ",
    dest_path,
    " -o ", 
    dir_output(paste0(output_affix(), ".osm.pbf"))
  )

  system(osmium_command)

  list(
    CreatedAt = now_as_iso8601(),
    DerivedFrom = I(describe_file(dest_path))
  ) %>% jsonlite::toJSON(pretty = TRUE, auto_unbox = TRUE) %>%
  write(dir_output(paste0(output_affix(), ".osm.pbf.meta.json")))
}

download_and_prepare_osm <- function(){
  download_osm()
  prepare_osm()
}
