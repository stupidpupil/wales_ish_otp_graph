#' Download the latest Terrain 50 Grid and GML (GAGG) zip
#'
#' @details
#'
#' This downloads the latest Terrain 50 Grid and GML (GAGG) zip, 
#' checking first if this is different to any existing zip using
#' \code{cache_key_for_terrain_50_url}
#
#' @return The path to the downloaded Terrain 50 GAGG zip
#'
download_terrain50 <- function(){
  
  terrain_50_url <- "https://api.os.uk/downloads/v1/products/Terrain50/downloads?area=GB&format=ASCII+Grid+and+GML+%28Grid%29&redirect"
  cache_key <- cache_key_for_terrain_50_url(terrain_50_url)

  dest_path <- dir_working("terr50_gagg_gb.zip")

  if(cache_key == cache_key_for_file(dest_path)){
    message("Cache hit for ", dest_path)
    return(dest_path)
  }

  download.file(terrain_50_url, dest_path)

  jsonlite::toJSON(pretty = TRUE, auto_unbox = TRUE, list(
    SourceUrl = terrain_50_url,
    SourceDownloadedAt = now_as_iso8601(),
    SourceLicence = "OGL-UK-3.0",
    SourceAttribution = "Contains OS data © Crown copyright and database right 2022",
    ParochialCacheKey = cache_key
  )) %>% write(paste0(dest_path, ".meta.json"))

  return(dest_path)
}
