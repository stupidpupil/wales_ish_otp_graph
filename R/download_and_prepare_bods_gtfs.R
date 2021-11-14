download_and_prepare_bods_gtfs <- function(){

  bods_files <- intersecting_regions_and_nations() %>% pull(bods_itm_code) %>% na.omit()
  base_bus_url <- "https://data.bus-data.dft.gov.uk/timetable/download/gtfs-file/"

  for (r in bods_files) {
    print(paste0("Downloading bus data for ", r, "…"))
    bus_url <- paste0(base_bus_url, r, '/')
    dest_path <- paste0("data-raw/", r, ".bods.gtfs.zip")
    download.file(bus_url, dest_path)

    toJSON(pretty = TRUE, auto_unbox = TRUE, list(
      SourceUrl = bus_url,
      SourceDownloadedAt = now() %>% format_ISO8601(usetz=TRUE),
      SourceLicence = "OGL-UK-3.0",
      SourceAttribution = "UK Department for Transport"
    )) %>% write(paste0(dest_path, ".meta.json"))

    print(paste0("Preparing bus data for ", r, "…"))
    gtfs <- better_gtfs_read(dest_path)
    gtfs <- gtfs %>% gtfs_wales_ish_ify()
    gtfs %>% gtfs_write(folder="output", name=paste0(r, ".bods.walesish.gtfs"))

    list(
      CreatedAt = now() %>% format_ISO8601(usetz=TRUE),
      DerivedFrom = I(describe_file(dest_path))
    ) %>% toJSON(pretty = TRUE, auto_unbox = TRUE) %>%
    write(paste0("output/", r, ".bods.walesish.gtfs.zip.meta.json"))

  }

}

