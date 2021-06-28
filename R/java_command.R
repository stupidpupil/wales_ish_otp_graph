java_command = function(){
  "java --add-opens java.base/java.io=ALL-UNNAMED --add-opens java.base/java.util=ALL-UNNAMED -Xmx8g"
}

java_version = function(){
  system(paste0(java_command(), " --version"), intern=TRUE) %>% str_split("\n") %>% first()
}
