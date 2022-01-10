java_args = function(){
  c("-Xmx8g")
}

java_command = function(){
  paste0("java ", paste(java_args(), collapse=" "))
}

java_version = function(){
  system(paste0(java_command(), " --version"), intern=TRUE) %>% str_split("\n") %>% first()
}
