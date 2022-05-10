output_affix <- function() {
  ret <- config::get()$output_affix

  if(!is.null(ret)){
    if(ret != ""){
      return(ret)      
    }
  }

  "walesish"
}