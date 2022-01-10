describe_file <- function(path){
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