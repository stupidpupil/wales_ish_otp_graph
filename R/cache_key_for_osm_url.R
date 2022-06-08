#' Get the parochial cache key for a Geofabrik OSM extract URL
#' 
#' @details
#' The cache key is based on the ETag HTTP header and the URL itself.
#'
#' @param osm_url A URL for a Geofabrik OSM extract download.
#'
cache_key_for_osm_url <- function(osm_url){

  checkmate::assert_character(osm_url, len=1, pattern=paste0("^https://download\\.geofabrik\\.de/.+$"))

  osm_head <- httr::HEAD(osm_url)
  openssl::sha1(paste0(
    osm_head$headers$ETag,
    osm_url
  )) %>% as.character()
}
