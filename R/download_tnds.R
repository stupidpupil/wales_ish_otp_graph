download_tnds <- function(){

  tnds_files <- intersecting_regions_and_nations() %>% pull(tnds_code) %>% na.omit()
  tnds_files <- c(tnds_files, 'NCSD')

  for(r in tnds_files){
    download.file(
      paste0("ftp://",config::get()$tnds_username,":",config::get()$tnds_password,"@ftp.tnds.basemap.co.uk/", r, ".zip"),
       paste0("data-raw/", r, ".bus.tnds.zip"))

    toJSON(pretty = TRUE, auto_unbox = TRUE, list(
      SourceUrl = paste0("ftp://ftp.tnds.basemap.co.uk/",r,".zip"),
      SourceDownloadedAt = now() %>% format_ISO8601(usetz=TRUE),
      SourceLicence = "OGL-UK-3.0",
      SourceAttribution = "Traveline"
    )) %>% write(paste0("data-raw/",r,".bus.tnds.zip.meta.json"))
  }

}
