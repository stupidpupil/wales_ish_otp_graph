pretty_wales_ish_map <- function(){

  stops <- tibble()
  agencies <- tibble()
  routes <- tibble()

  for(fn in dir("output", ".gtfs.zip")){
    gtfs <- better_gtfs_read(paste0("output/", fn))

    stops <- stops %>% bind_rows(
      gtfs$stops %>% select(stop_id, stop_lat, stop_lon) %>%
      mutate(filename= fn)
    )

    agencies <- agencies %>% bind_rows(
      gtfs$agency %>% mutate(filename = fn)
    )

    routes <- routes %>% bind_rows(
      gtfs$routes %>% mutate(filename = fn)
    )

  }

  plot_map <- ggplot(stops, aes(x=stop_lon, y=stop_lat, colour=filename)) + geom_point(size=0.5, alpha=0.5) + theme_minimal() + theme(legend.position = 'none', panel.grid = element_blank(), axis.title=element_blank(), axis.text=element_blank(), axis.ticks=element_blank())

  return(plot_map)
}