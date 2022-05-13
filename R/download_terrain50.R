download_terrain50 <- function(){
  
  terrain_50_url <- "https://api.os.uk/downloads/v1/products/Terrain50/downloads?area=GB&format=ASCII+Grid+and+GML+%28Grid%29&redirect"
  dest_path <- dir_working("terr50_gagg_gb.zip")
  download.file(terrain_50_url, dest_path)

  jsonlite::toJSON(pretty = TRUE, auto_unbox = TRUE, list(
    SourceUrl = terrain_50_url,
    SourceDownloadedAt = now_as_iso8601(),
    SourceLicence = "OGL-UK-3.0",
    SourceAttribution = "Contains OS data © Crown copyright and database right 2022"
  )) %>% write(paste0(dest_path, ".meta.json"))

  return(dest_path)
}
