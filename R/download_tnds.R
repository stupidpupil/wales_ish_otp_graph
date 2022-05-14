download_tnds <- function(){
  old_opts <- options(timeout=max(options()$timeout,300))
  on.exit(options(old_opts))

  tnds_files <- intersecting_regions_and_nations() %>% pull(tnds_code) %>% na.omit()
  tnds_files <- c(tnds_files, 'NCSD')

  dest_paths <- c()

  for(r in tnds_files){
    dest_path <- dir_working(r, ".bus.tnds.zip")
    dest_paths <- c(dest_paths, dest_path)

    src_url = paste0("ftp://",config::get()$tnds_username,":",config::get()$tnds_password,"@ftp.tnds.basemap.co.uk/", r, ".zip")

    cache_key <- cache_key_for_tnds_url(src_url)

    if(cache_key == cache_key_for_file(dest_path)){
      message("Cache hit for ", dest_path)
      next
    }
    download.file(src_url, dest_path)

    jsonlite::toJSON(pretty = TRUE, auto_unbox = TRUE, list(
      SourceUrl = paste0("ftp://ftp.tnds.basemap.co.uk/",r,".zip"),
      SourceDownloadedAt = now_as_iso8601(),
      SourceLicence = "OGL-UK-3.0",
      SourceAttribution = "Traveline",
      ParochialCacheKey = cache_key
    )) %>% write(paste0(dest_path, ".meta.json"))
  }

  return(dest_paths)
}
