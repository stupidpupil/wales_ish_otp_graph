prepare_otp_config <- function(){
  file.copy(dir_support("otp_config/build-config.json"), dir_output("build-config.json"), overwrite=TRUE)
  file.copy(dir_support("otp_config/router-config.json"), dir_output("router-config.json"), overwrite=TRUE)

  stopifnot(file.exists(dir_output("build-config.json")))
  stopifnot(file.exists(dir_output("router-config.json")))

  if(!dir.exists(dir_working("otp_cache"))){
    dir.create(dir_working("otp_cache"))
  }
  
  return(TRUE)
}
