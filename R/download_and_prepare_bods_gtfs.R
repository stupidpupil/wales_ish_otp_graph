download_and_prepare_bods_gtfs <- function(){

  bods_files <- intersecting_regions_and_nations() %>% pull(bods_itm_code) %>% na.omit()
  base_bus_url <- "https://data.bus-data.dft.gov.uk/timetable/download/gtfs-file/"

  output_paths <- c()

  for (r in bods_files) {
    message("Downloading BODS data for ", r, "...")
    bus_url <- paste0(base_bus_url, r, '/')
    work_path <- dir_working(r, ".bods.gtfs.zip")
    output_path <- dir_output("gtfs/", r, ".bods.", output_affix(),".gtfs.zip")

    output_paths <- c(output_paths, output_path)

    cache_key <- cache_key_for_bods_url(bus_url)

    if(cache_key != cache_key_for_file(work_path)){
      download.file(bus_url, work_path)

      jsonlite::toJSON(pretty = TRUE, auto_unbox = TRUE, list(
        SourceUrl = bus_url,
        SourceDownloadedAt = now_as_iso8601(),
        SourceLicence = "OGL-UK-3.0",
        SourceAttribution = "UK Department for Transport",
        ParochialCacheKey = cache_key
      )) %>% write(paste0(work_path, ".meta.json"))

    }else{
      message("Cache hit for ", work_path)
    }

    message("Preparing GTFS from \'", r, "\' BODS timetables...")
    gtfs <- gtfstools::read_gtfs(work_path)
    gtfs <- gtfs %>% gtfs_parochialise()
    gtfs %>% gtfstools::write_gtfs(output_path)

    list(
      CreatedAt = now_as_iso8601(),
      DerivedFrom = I(describe_file(work_path))
    ) %>% jsonlite::toJSON(pretty = TRUE, auto_unbox = TRUE) %>%
    write(paste0(output_path, ".meta.json"))

    delete_merged_gtfs()

  }

  return(output_paths)
}
