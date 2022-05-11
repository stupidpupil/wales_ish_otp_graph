download_otp <- function(){

  
  otp_url <- "https://github.com/opentripplanner/OpenTripPlanner/releases/download/v2.1.0/otp-2.1.0-shaded.jar"
  dest_path <- dir_working("otp.jar")
  download.file(otp_url, dest_path)

  jsonlite::toJSON(pretty = TRUE, auto_unbox = TRUE, list(
    SourceUrl = otp_url,
    SourceDownloadedAt = now_as_iso8601(),
    SourceLicence = "LGPL-3.0-or-later",
    SourceAttribution = "OpenTripPlanner"
  )) %>% write(paste0(dest_path, ".meta.json"))

}

otp_version <- function(){
  system(paste0(java_command(), " -jar ", dir_working("otp.jar")," --version"), intern=TRUE) %>% str_replace("^OpenTripPlanner version: ", "")
}