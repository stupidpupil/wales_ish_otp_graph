download_and_prepare_osm <- function(){

  gb_osm_url <- "https://download.geofabrik.de/europe/great-britain-latest.osm.pbf"
  dest_path <- dir_working("great-britain-latest.osm.pbf")

  download.file(gb_osm_url, dest_path)

  toJSON(pretty = TRUE, auto_unbox = TRUE, list(
    SourceUrl = gb_osm_url,
    SourceDownloadedAt = now() %>% format_ISO8601(usetz=TRUE),
    SourceLicence = "ODbL-1.0",
    SourceAttribution = "OpenStreetMap contributors"
  )) %>% write(paste0(dest_path, ".meta.json"))


  bounds_geojson_path <- dir_output("bounds.geojson")
  unlink(bounds_geojson_path)
  bounds() %>% sf::st_write(bounds_geojson_path)

  osmium_command = paste0(
    "osmium extract -p ",
    bounds_geojson_path,
    " -s smart ",
    dest_path,
    " -o ", 
    dir_output("wales_ish.osm.pbf")
  )

  system(osmium_command)

  list(
    CreatedAt = now() %>% format_ISO8601(usetz=TRUE),
    DerivedFrom = I(describe_file(dest_path))
  ) %>% toJSON(pretty = TRUE, auto_unbox = TRUE) %>%
  write(dir_output("wales_ish.osm.pbf.meta.json"))

}

