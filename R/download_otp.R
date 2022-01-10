download_otp <- function(){

  
  otp_url <- "https://github.com/stupidpupil/OpenTripPlanner/releases/download/v2021-08-06/otp-2.1.0-20210806.150542-3-shaded.jar"
  dest_path <- dir_working("otp.jar")
  download.file(otp_url, dest_path)

  toJSON(pretty = TRUE, auto_unbox = TRUE, list(
    SourceUrl = otp_url,
    SourceDownloadedAt = now() %>% format_ISO8601(usetz=TRUE),
    SourceLicence = "LGPL-3.0-or-later",
    SourceAttribution = "OpenTripPlanner"
  )) %>% write(paste0(dest_path, "meta.json"))

}

otp_version <- function(){
  system(paste0(java_command(), " -jar ", dir_working("otp.jar")," --version"), intern=TRUE) %>% str_replace("^OpenTripPlanner version: ", "")
}