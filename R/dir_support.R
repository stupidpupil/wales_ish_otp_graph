dir_support <- function(...){

  ret <- NULL

  try({
    ret <- config::get()$dir_support
  }, silent=TRUE)

  if(is.null(ret)){
    ret <- system.file("extdata", package=package_name())
  }

  if(length(list(...)) > 0){
    ret <- paste0(ret, "/", paste0(...))
  }

  return(ret)
}