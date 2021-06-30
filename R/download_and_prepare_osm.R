download_and_prepare_osm <- function(){

  gb_osm_url <- "https://download.geofabrik.de/europe/great-britain-latest.osm.pbf"
  dest_path <- "data-raw/great-britain-latest.osm.pbf"

  download.file(gb_osm_url, dest_path)

  toJSON(pretty = TRUE, auto_unbox = TRUE, list(
    SourceUrl = gb_osm_url,
    SourceDownloadedAt = now() %>% format_ISO8601(usetz=TRUE),
    SourceLicence = "ODbL-1.0",
    SourceAttribution = "OpenStreetMap contributors"
  )) %>% write(paste0(dest_path, "meta.json"))

  osmium_command = paste0(
    "osmium extract -b ",
    wales_ish_bounding_box_string,
    " -s smart ",
    dest_path,
    " -o output/wales_ish.osm.pbf"
  )

  system(osmium_command)

  list(
    CreatedAt = now() %>% format_ISO8601(usetz=TRUE),
    MaxSpatialExtent = wales_ish_bounding_box_string,
    DerivedFrom = I(describe_file(dest_path))
  ) %>% toJSON(pretty = TRUE, auto_unbox = TRUE) %>%
  write(paste0("output/wales_ish.osm.pbf.meta.json"))

}

