prepare_street_graph <- function(){
  system("java -Xmx24G -jar data-raw/otp.jar --buildStreet output")
}