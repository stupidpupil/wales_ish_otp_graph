simplify_and_buffer_regions_and_nations <- function(){
  
  sys.setenv(OGR_GEOJSON_MAX_OBJ_SIZE=1024)

  simplify_and_buffer <- function(data){
    data %>% st_buffer(1000) %>% st_simplify(dTolerance=1000)
  }

  regions <- read_sf(dir_support("regions_and_nations/Regions_(December_2020)_EN_BFE.geojson")) %>%
    simplify_and_buffer()

  countries <- read_sf(dir_support("regions_and_nations/Countries_(December_2020)_UK_BFE.geojson")) %>%
    simplify_and_buffer()

  countries %>% rename(code = CTRY20CD, name=CTRY20NM) %>% select(code, name) %>% 
    rbind(regions %>% rename(code = RGN20CD, name=RGN20NM) %>% select(code, name)) %>% 
    st_write(dir_working("regions_and_nations.geojson")) # dir_working sort-of makes sense here
}