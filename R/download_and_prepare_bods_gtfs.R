download_and_prepare_bods_gtfs <- function(){

  bods_files <- intersecting_regions_and_nations() %>% pull(bods_itm_code) %>% na.omit()
  base_bus_url <- "https://data.bus-data.dft.gov.uk/timetable/download/gtfs-file/"

  for (r in bods_files) {
    print(paste0("Downloading bus data for ", r, "…"))
    bus_url <- paste0(base_bus_url, r, '/')
    dest_path <- dir_working(paste0(r, ".bods.gtfs.zip"))
    download.file(bus_url, dest_path)

    jsonlite::toJSON(pretty = TRUE, auto_unbox = TRUE, list(
      SourceUrl = bus_url,
      SourceDownloadedAt = now_as_iso8601(),
      SourceLicence = "OGL-UK-3.0",
      SourceAttribution = "UK Department for Transport"
    )) %>% write(paste0(dest_path, ".meta.json"))

    print(paste0("Preparing bus data for ", r, "…"))
    gtfs <- better_gtfs_read(dest_path)
    gtfs <- gtfs %>% gtfs_wales_ish_ify()
    gtfs %>% UK2GTFS::gtfs_write(folder=dir_output(), name=paste0(r, ".bods.", output_affix(),".gtfs"))

    list(
      CreatedAt = now_as_iso8601(),
      DerivedFrom = I(describe_file(dest_path))
    ) %>% jsonlite::toJSON(pretty = TRUE, auto_unbox = TRUE) %>%
    write(dir_output(paste0(r, ".bods.", output_affix() ,".gtfs.zip.meta.json")))

  }

}
