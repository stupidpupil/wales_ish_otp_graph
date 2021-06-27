download_otp <- function(){
  otp_url <- "https://github-registry-files.githubusercontent.com/379649389/90acae80-d445-11eb-9c55-b773f7941f5e?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20210627%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20210627T154437Z&X-Amz-Expires=300&X-Amz-Signature=8170ad52cfc8607ca2a8343956a96d32e0abe3fb24e199ed04a46e2f533f8d48&X-Amz-SignedHeaders=host&actor_id=0&key_id=0&repo_id=379649389&response-content-disposition=filename%3Dotp-2.1.0-20210623.170744-1-shaded.jar&response-content-type=application%2Foctet-stream"
  dest_path <- "data-raw/otp.jar"
  download.file(otp_url, dest_path)
}