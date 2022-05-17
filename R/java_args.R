java_args = function(){
  c(paste0("-Xmx", java_xmx()))
}

java_xmx = function(){
  if(is.null(config::get()$java_xmx)){
    return("8g")
  }

  config::get()$java_xmx
}
