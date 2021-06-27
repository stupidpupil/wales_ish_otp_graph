download_otp <- function(){
  otp_url <- "https://github.com/stupidpupil/wales_ish_otp_graph/releases/download/v2021-06-27/otp-2.1.0-20210623.170744-1-shaded.jar"
  dest_path <- "data-raw/otp.jar"
  download.file(otp_url, dest_path)
}
