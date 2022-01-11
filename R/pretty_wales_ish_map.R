pretty_wales_ish_map <- function(){

  stops <- tibble()
  stop_times <- tibble()
  trips <- tibble()
  agencies <- tibble()
  routes <- tibble()

  for(fn in list.files(dir_output(), "\\.gtfs\\.zip$")){
    gtfs <- better_gtfs_read(dir_output(fn))

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

  plot_map <- ggplot2::ggplot(tibble(), ggplot2::aes(x=stop_lon, y=stop_lat, group=route_id)) + 
    ggplot2::geom_path(data = crude_routes %>% filter(!(route_type %in% c(4, 200:299))),
      colour = '#bbbbbb', size=0.2
    ) +
    ggplot2::geom_path(data = crude_routes %>% filter(route_type %in% c(4, 1502, 1200:1299)),
      colour = '#7ebdbc', linetype=2
    ) +
    ggplot2::geom_path(data = crude_routes %>% 
        filter(filename %>% str_detect("atoc")) %>% 
        filter(agency_name %>% str_detect("Western")),
      colour = '#3b524e', size=0.3, alpha=0.8
    ) +
    ggplot2::geom_path(data = crude_routes %>% 
        filter(filename %>% str_detect("atoc")) %>% 
        filter(agency_name %>% str_detect("(West Coast|Virgin Trains)")),
      colour = '#bf7660', size=0.4, alpha=0.8
    ) +
    ggplot2::geom_path(data = crude_routes %>% 
        filter(filename %>% str_detect("atoc")) %>% 
        filter(agency_name %>% str_detect("CrossCountry")),
      colour = '#7d5967', size=0.4, alpha=0.8
    ) +
    ggplot2::geom_path(data = crude_routes %>% 
        filter(filename %>% str_detect("atoc")) %>% 
        filter(agency_name %>% str_detect("Wales")),
      colour = '#9c3636', alpha=0.8
    ) +
    ggplot2::geom_path(data = crude_routes %>%
        filter(filename %>% str_detect("^(W|wales).(tnds|bus|bods)")) %>%
        filter(route_short_name %>% str_detect("^T")),
      colour = '#58823D', size=0.6
    ) + 
    ggplot2::theme_minimal() + 
    ggplot2::theme(
      legend.position = 'none', 
      panel.grid = ggplot2::element_blank(), 
      axis.title = ggplot2::element_blank(), 
      axis.text  = ggplot2::element_blank(), 
      axis.ticks = ggplot2::element_blank()
    ) + 
    ggplot2::coord_fixed(ratio=1.67)

  return(plot_map)
}

prepare_pretty_wales_ish_map <- function(){
  ggplot2::ggsave(plot=pretty_wales_ish_map(), filename=dir_output("map.png"),    width=440/72, height=490/72, units="in", dpi= 72)
  ggplot2::ggsave(plot=pretty_wales_ish_map(), filename=dir_output("map.2x.png"), width=440/72, height=490/72, units="in", dpi=144)
  ggplot2::ggsave(plot=pretty_wales_ish_map(), filename=dir_output("map.4x.png"), width=440/72, height=490/72, units="in", dpi=288)
}
