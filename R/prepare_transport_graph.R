prepare_transport_graph <- function(){
  system(paste0(java_command(), " -jar data-raw/otp.jar --loadStreet --save output"))
}
