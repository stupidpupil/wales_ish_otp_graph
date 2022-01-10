dir_support <- function(fn){
  ret <-config::get()$dir_support

  if(is.null(ret)){
    ret <- system.file("data-raw", package=package_name())
  }

  if(!missing(fn)){
    ret <- paste0(ret, "/", fn)
  }

  return(ret)
}