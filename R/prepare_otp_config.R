prepare_otp_config <- function(){

  fs::dir_create(dir_output("opentripplanner"), recurse=TRUE)
  file.copy(dir_support("otp_config/build-config.json"), dir_output("opentripplanner/build-config.json"), overwrite=TRUE)
  file.copy(dir_support("otp_config/router-config.json"), dir_output("opentripplanner/router-config.json"), overwrite=TRUE)

  stopifnot(file.exists(dir_output("opentripplanner/build-config.json")))
  stopifnot(file.exists(dir_output("opentripplanner/router-config.json")))

  fs::dir_create(dir_working("otp_cache"), recurse=TRUE)

  return(TRUE)
}
