dir_output <- function(fn){
  ret <-config::get()$dir_output

  if(is.null(ret)){
    ret <- "output"
  }

  if(!dir.exists(ret)){
    dir.create(ret)
  }

  if(!missing(fn)){
    ret <- paste0(ret, "/", fn)
  }

  return(ret)
}