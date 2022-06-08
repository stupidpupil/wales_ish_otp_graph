#' Get the parochial cache key for a Terrain 50 download URL
#'
#' @details
#' The cache key is the MD5 checksum provided by the Ordnance Survey directory at
#' https://api.os.uk/downloads/v1/products/Terrain50/downloads
#' 
#' @param terrain_50_url A Terrain 50 download URL
#' 
cache_key_for_terrain_50_url <- function(terrain_50_url) {

  base_url <- "https://api.os.uk/downloads/v1/products/Terrain50/downloads"

  checkmate::assert_character(terrain_50_url, len=1, pattern=paste0("^", base_url, "\\?.+$"))

  terrain_50_directory <- httr::GET(base_url) %>%
    httr::content(type='text')  %>% jsonlite::fromJSON()

  terrain_50_directory %>%
    filter(url == terrain_50_url) %>%
    pull(md5) %>% first()
}
