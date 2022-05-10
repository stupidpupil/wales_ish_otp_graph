dir_support <- function(fn){

  ret <- NULL

  try({
    ret <- config::get()$dir_support
  }, silent=TRUE)

  if(is.null(ret)){
    ret <- system.file("extdata", package=package_name())
  }

  if(!missing(fn)){
    ret <- paste0(ret, "/", fn)
  }

  return(ret)
}