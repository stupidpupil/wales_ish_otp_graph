gtfstidy_merge_all_output_gtfs <- function(){

  merged_filename <- paste0("merged.", output_affix(), ".gtfs.zip")

  unlink(dir_working(merged_filename))

  gtfstidy_command = paste0(
    "$(go env GOPATH)/bin/gtfstidy",
    " --remove-red-agencies",
    " --remove-red-routes",
    " --remove-red-stops",
    " --remove-red-trips",
    " --remove-red-services",

    " --delete-orphans",

    " --minimize-ids-char",

    # NOTE: Setting max-headway does nothing
    # unless minimise-stoptimes is being used,
    # but better to be future-proof here. See:
    # https://github.com/ad-freiburg/pfaedle/issues/36

    " --max-headway 65534", 
    " ", dir_output("*.gtfs.zip"),
    " -o ", dir_working(merged_filename)
  )

  system(gtfstidy_command)

  stopifnot(file.exists(dir_working(merged_filename)))

  meta <- list(
    CreatedAt = now_as_iso8601(),
    DerivedFrom = describe_file(dir_output("*.gtfs.zip"))
  ) 

  unlink(dir_output("*.gtfs.zip"))
  unlink(dir_output("*.gtfs.zip.meta.json"))

  file.copy(dir_working(merged_filename), dir_output(merged_filename))
  unlink(dir_working(merged_filename))

  meta %>% jsonlite::toJSON(pretty = TRUE) %>%
    write(dir_output(merged_filename, ".meta.json"))

  return(dir_output(merged_filename))  
}
