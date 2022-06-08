#' Get the parochial cache key for a ATOC download URL
#'
#' The cache key is based on the URL itself and the current month.
#' (The download URL for the ATOC CIF zip is expected to change whenever the file changes.)
#'
#' @param atoc_url A URL for a ATOC CIF zip.
#'
cache_key_for_atoc_url <- function(atoc_url) {

  checkmate::assert_character(atoc_url, len=1, pattern=paste0("https?://data\\.atoc\\.org/.+$"))

  openssl::sha1(paste0(
    lubridate::today() %>% strftime("%Y-%m"), 
    atoc_url
  )) %>% as.character()
}