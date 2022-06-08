#' Get the parochial cache key for a TNDS download URL
#'
#' The cache key is based on the FTP directory entry for the file
#' specified by the URL.
#' 
#' @param tnds_url A TNDS download FTP URL
#' 
cache_key_for_tnds_url <- function(tnds_url){

  checkmate::assert_character(tnds_url, len=1, pattern="^ftp://(.+)/(.+)$")

  tnds_url_components <- tnds_url %>%
    stringr::str_match("^(.+/)([^/]*)$")

  tnds_dir_listing <- RCurl::getURL(tnds_url_components[[2]])

  dir_entry <- tnds_dir_listing %>%
    stringr::str_split("\n") %>% first() %>%
    purrr::keep(function(x){
      x %>% stringr::str_detect(paste0(" ", tnds_url_components[[3]], "$"))
      }) %>% first()

  checkmate::assert_character(dir_entry, len=1)

  openssl::sha1(dir_entry) %>% as.character()
}
