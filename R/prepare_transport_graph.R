prepare_transport_graph <- function(){
  system("java -Xmx24G -jar data-raw/otp.jar --loadStreet --save output")
}