cache_key_for_bods_url <- function(bods_url) {
  bods_head <- httr::HEAD(bods_url)
  openssl::sha1(paste0(
    bods_head$headers$`content-length`,
    lubridate::today() %>% strftime("%Y-%m"), 
    bods_url
  )) %>% as.character()
}