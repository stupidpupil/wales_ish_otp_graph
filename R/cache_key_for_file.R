cache_key_for_file <- function(path) {
  if(!file.exists(path)){
    return(FALSE)
  }

  meta_path <- paste0(path, ".meta.json")

  if(file.exists(meta_path)){
    meta <- jsonlite::fromJSON(meta_path)
    if(!is.null(meta$ParochialCacheKey)){
      return(meta$ParochialCacheKey)
    }
  }

  openssl::sha1(file(path)) %>% as.character()
}
