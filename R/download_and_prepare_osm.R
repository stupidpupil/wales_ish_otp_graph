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

  bbox_string <- paste0(wales_ish_bounding_box %>% rev() %>% unlist() %>% rev(), collapse=",")

  osmium_command = paste0(
    "osmium extract -b ",
    bbox_string,
    " -s smart ",
    dest_path,
    " -o output/wales_ish.osm.pbf"
  )

  system(osmium_command)

}

