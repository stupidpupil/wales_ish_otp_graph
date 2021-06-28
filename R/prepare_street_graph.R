prepare_street_graph <- function(){
  system(paste0(java_command(), " -jar data-raw/otp.jar --buildStreet output"))
}
