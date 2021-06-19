download_otp <- function(){
  otp_url <- "https://repo1.maven.org/maven2/org/opentripplanner/otp/2.0.0-rc1/otp-2.0.0-rc1-shaded.jar"
  dest_path <- "data-raw/otp.jar"
  download.file(otp_url, dest_path)
}