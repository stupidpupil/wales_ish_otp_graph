dir_output <- function(...){
  ret <- NULL

  try({
    ret <-config::get()$dir_output
  }, silent=TRUE)

  if(is.null(ret)){
    ret <- "output"
  }

  if(!dir.exists(ret)){
    dir.create(ret)
  }

  if(length(list(...)) > 0){
    ret <- paste0(ret, "/", paste0(...))
  }

  return(ret)
}