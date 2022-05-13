prepare_r5r_config <- function(){
  unlink(dir_output("build-config.json"))
  unlink(dir_output("router-config.json"))

  return(TRUE)
}
