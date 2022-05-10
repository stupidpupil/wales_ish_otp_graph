describe_file <- function(...){

  paths <- Sys.glob(c(...))

  if(length(paths) == 0){
    return(NULL)
  }

  if(length(paths) > 1){
    return(lapply(paths, describe_file))
  }

  path <- paths

  ret <- list(
    Filename = basename(path),
    SizeBytes = file.size(path)
  )

  meta_path <- paste0(path, ".meta.json")

  if(file.exists(meta_path)){
    ret <- ret %>% append(jsonlite::fromJSON(meta_path))
  }

  return(ret)
}