download_tnds <- function(){
  download.file(
    paste0("ftp://",config::get()$tnds_username,":",config::get()$tnds_password,"@ftp.tnds.basemap.co.uk/W.zip"),
     "data-raw/wales.bus.tnds.zip")

  download.file(
    paste0("ftp://",config::get()$tnds_username,":",config::get()$tnds_password,"@ftp.tnds.basemap.co.uk/NCSD.zip"),
     "data-raw/ncsd.bus.tnds.zip")
}
