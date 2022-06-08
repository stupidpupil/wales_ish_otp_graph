#' Get info about a file, including metadata, as a list
#'
#' @details
#' Given a single filepath, this will return a list describing the file at that path.
#' At a minimum, if the file exists, this will return a list with the
#' the file's base name (as 'Filename') and size in bytes (as 'SizeBytes') 
#'
#' If a .meta.json file exists for the specified path, then the metadata
#' included in that file is read and added to the returned list.
#'
#' The function also accepts multiple filepaths, and will perform wildcard expansion
#' ('globbing') using \code{Sys.glob} on the the paths supplied. If multiple files are identified by the
#' (globbed) file paths, then this returns a list of lists.
#' 
#' @param ... One or more filepaths.
#'
#' @return A list describing a single file, or a list of lists describing multiple files.
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