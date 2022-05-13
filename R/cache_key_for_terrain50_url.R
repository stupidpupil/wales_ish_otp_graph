cache_key_for_terrain_50_url <- function(terrain_50_url) {
  terrain_50_directory <- httr::GET("https://api.os.uk/downloads/v1/products/Terrain50/downloads") %>%
    httr::content(type='text')  %>% jsonlite::fromJSON()

  terrain_50_directory %>%
    filter(url == terrain_50_url) %>%
    pull(md5) %>% first()
}
