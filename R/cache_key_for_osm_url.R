cache_key_for_osm_url <- function(osm_url){
  osm_head <- httr::HEAD(osm_url)
  openssl::sha1(paste0(
    osm_head$headers$ETag,
    osm_url
  )) %>% as.character()
}
