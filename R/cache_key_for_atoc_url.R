cache_key_for_atoc_url <- function(atoc_url) {
  # ATOC URL changes when the data is updated

  openssl::sha1(paste0(
    lubridate::today() %>% strftime("%Y-%m"), 
    atoc_url
  )) %>% as.character()
}