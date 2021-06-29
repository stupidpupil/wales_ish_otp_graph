pretty_wales_ish_map <- function(){

  stops <- tibble()
  stop_times <- tibble()
  trips <- tibble()
  agencies <- tibble()
  routes <- tibble()

  for(fn in dir("output", ".gtfs.zip")){
    gtfs <- better_gtfs_read(paste0("output/", fn))

    stops <- stops %>% bind_rows(
      gtfs$stops %>% select(stop_id, stop_lat, stop_lon) %>%
      mutate(filename= fn)
    )

    stop_times <- stop_times %>% bind_rows(
      gtfs$stop_times %>% select(stop_id, trip_id, stop_sequence) %>%
      mutate(filename= fn)
    )

    trips <- trips %>% bind_rows(
      gtfs$trips %>% select(trip_id, route_id) %>%
      mutate(filename= fn)
    )

    agencies <- agencies %>% bind_rows(
      gtfs$agency %>% mutate(filename = fn)
    )

    routes <- routes %>% bind_rows(
      gtfs$routes %>% mutate(filename = fn)
    )

  }

  crude_routes <- stops %>%
    left_join(stop_times) %>%
    left_join(trips) %>% 
    left_join(routes) %>% 
    left_join(agencies) %>%
    mutate(route_id = paste0(filename, "-", route_id)) %>%
    group_by(route_id, trip_id) %>% mutate(trip_n = n()) %>% ungroup() %>%
    arrange(route_id, -trip_n, trip_id, stop_sequence) %>% 
    group_by(route_id) %>% filter(trip_id == first(trip_id)) %>% ungroup()


  plot_map <- ggplot(tibble(), aes(x=stop_lon, y=stop_lat, group=route_id)) + 
    geom_path(data = crude_routes,
      colour = '#bbbbbb', size=0.2
    ) +
    geom_path(data = crude_routes %>% 
        filter(filename %>% str_detect("atoc")) %>% 
        filter(agency_name %>% str_detect("Western")),
      colour = '#3b524e', size=0.3, alpha=0.8
    ) +
    geom_path(data = crude_routes %>% 
        filter(filename %>% str_detect("atoc")) %>% 
        filter(agency_name %>% str_detect("(West Coast|Virgin Trains)")),
      colour = '#bf7660', size=0.4, alpha=0.8
    ) +
    geom_path(data = crude_routes %>% 
        filter(filename %>% str_detect("atoc")) %>% 
        filter(agency_name %>% str_detect("CrossCountry")),
      colour = '#7d5967', size=0.4, alpha=0.8
    ) +
    geom_path(data = crude_routes %>% 
        filter(filename %>% str_detect("atoc")) %>% 
        filter(agency_name %>% str_detect("Wales")),
      colour = '#9c3636', alpha=0.8
    ) +
    geom_path(data = crude_routes %>%
        filter(filename %>% str_detect("wales.bus")) %>%
        filter(route_short_name %>% str_detect("^T")),
      colour = '#58823D', size=0.6
    ) + 
    theme_minimal() + 
    theme(
      legend.position = 'none', 
      panel.grid = element_blank(), 
      axis.title=element_blank(), 
      axis.text=element_blank(), 
      axis.ticks=element_blank()
    ) + 
    coord_fixed(ratio=1.67)

  return(plot_map)
}

prepare_pretty_wales_ish_map <- function(){
  ggsave(plot=pretty_wales_ish_map(), filename="output/map.png", width=440/72, height=490/72, units="in", dpi=72)
  ggsave(plot=pretty_wales_ish_map(), filename="output/map.2x.png", width=440/72, height=490/72, units="in", dpi=144)
  ggsave(plot=pretty_wales_ish_map(), filename="output/map.4x.png", width=440/72, height=490/72, units="in", dpi=288)
}