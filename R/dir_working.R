dir_working <- function(...){

  ret <- NULL

  try({
    ret <- config::get()$dir_working
  }, silent=TRUE)

  if(is.null(ret)){
    ret <- "data-raw"
  }

  if(!dir.exists(ret)){
    dir.create(ret)
  }

  if(length(list(...)) > 0){
    ret <- paste0(ret, "/", paste0(...))
  }

  return(ret)
}