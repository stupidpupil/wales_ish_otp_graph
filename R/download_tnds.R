download_tnds <- function(){
  download.file(
    paste0("ftp://",config::get()$tnds_username,":",config::get()$tnds_password,"@ftp.tnds.basemap.co.uk/W.zip"),
     "data-raw/wales.bus.tnds.zip")

  toJSON(pretty = TRUE, auto_unbox = TRUE, list(
    SourceUrl = "ftp://ftp.tnds.basemap.co.uk/W.zip",
    SourceDownloadedAt = now() %>% format_ISO8601(usetz=TRUE),
    SourceLicence = "OGL-UK-3.0",
    SourceAttribution = "Traveline"
  )) %>% write("data-raw/wales.bus.tnds.zip.meta.json")

  download.file(
    paste0("ftp://",config::get()$tnds_username,":",config::get()$tnds_password,"@ftp.tnds.basemap.co.uk/NCSD.zip"),
     "data-raw/ncsd.bus.tnds.zip")

  toJSON(pretty = TRUE, auto_unbox = TRUE, list(
    SourceUrl = "ftp://ftp.tnds.basemap.co.uk/NCSD.zip",
    SourceDownloadedAt = now() %>% format_ISO8601(usetz=TRUE),
    SourceLicence = "OGL-UK-3.0",
    SourceAttribution = "Traveline"
  )) %>% write("data-raw/ncsd.bus.tnds.zip.meta.json")

}
