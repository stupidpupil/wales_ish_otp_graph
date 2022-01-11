java_args = function(){
  c(paste0("-Xmx", java_xmx()))
}

java_xmx = function(){
  if(is.null(config::get()$java_xmx)){
    return("8g")
  }

  config::get()$java_xmx
}

java_command = function(){
  paste0("java ", paste(java_args(), collapse=" "))
}

java_version = function(){
  system(paste0(java_command(), " --version"), intern=TRUE) %>% str_split("\n") %>% first()
}
