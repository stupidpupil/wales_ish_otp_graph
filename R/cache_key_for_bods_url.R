#' Get the parochial cache key for a BODS download URL
#'
#' The cache key is based on the Content-Length HTTP header (indicating the size of the zip) and the current month.
#'
#' @param bods_url A URL for a BODS gtfs zip.
#' 
cache_key_for_bods_url <- function(bods_url) {

  checkmate::assert_character(bods_url, len=1, pattern=paste0("https?://.+$"))

  bods_head <- httr::HEAD(bods_url)
  openssl::sha1(paste0(
    bods_head$headers$`content-length`,
    lubridate::today() %>% strftime("%Y-%m"), 
    bods_url
  )) %>% as.character()
}