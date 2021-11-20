intersecting_regions_and_nations <- function(){
  rnn <- sf::read_sf("data-raw/regions_and_nations.geojson") %>%
    left_join(read_csv("data-raw/regions_and_nations.csv", col_types="cccc"), by="code")

  rnn[lengths(rnn %>% sf::st_intersects(bounds())) > 0,] 
}