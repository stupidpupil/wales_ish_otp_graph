bounds <- function(){
  bounds <- config::get()$bounds %>% sf::st_as_sfc()

  if(is.na(sf::st_crs(bounds))){
    sf::st_crs(bounds) <- 4326
  }

  bounds <- sf::st_make_valid(bounds)

  return(bounds)
}

path_to_bounds_geojson <- function(){
  # Be aware that osmium will not like a polygon file called something like
  # "walesish.bound.geojson" as the two dots will confuse its file ext detection
  # resulting in the following error message:
  # "Could not autodetect file type in '(multi)polygon' object. Add a 'file_type'."

  dir_output(output_affix(), "-bounds.geojson")
}

prepare_bounds_geojson <- function(){
  unlink(path_to_bounds_geojson())
  bounds() %>% sf::st_write(path_to_bounds_geojson())
}