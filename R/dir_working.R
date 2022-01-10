dir_working <- function(fn){
  ret <-config::get()$dir_working

  if(is.null(ret)){
    ret <- "data-raw"
  }

  if(!dir.exists(ret)){
    dir.create(ret)
  }

  if(!missing(fn)){
    ret <- paste0(ret, "/", fn)
  }

  return(ret)
}