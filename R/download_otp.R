download_otp <- function(){

  otp_url <- "https://github.com/stupidpupil/OpenTripPlanner/releases/download/v2022-05-11/otp-2.2.0-20220511.140318-1-shaded.jar"
  cache_key <- openssl::sha1(otp_url) %>% as.character()

  dest_path <- dir_working("otp.jar")

  if(cache_key == cache_key_for_file(dest_path)){
    message("Cache hit for ", dest_path)
    return(dest_path)
  }
  
  download.file(otp_url, dest_path)

  jsonlite::toJSON(pretty = TRUE, auto_unbox = TRUE, list(
    SourceUrl = otp_url,
    SourceDownloadedAt = now_as_iso8601(),
    SourceLicence = "LGPL-3.0-or-later",
    SourceAttribution = "OpenTripPlanner",
    ParochialCacheKey = cache_key
  )) %>% write(paste0(dest_path, ".meta.json"))

  return(dest_path)
}

otp_version <- function(){
  processx::run("java", c(java_args(), "-jar", dir_working("otp.jar"), "--version"))$stdout %>%
    stringr::str_trim() %>%
    stringr::str_replace("^OpenTripPlanner version: ", "")
}