bounds <- function(){
  bounds <- config::get()$bounds %>% sf::st_as_sfc()

  if(is.na(sf::st_crs(bounds))){
    sf::st_crs(bounds) <- 4326
  }

  return(bounds)
}