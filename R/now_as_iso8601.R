now_as_iso8601 <- function(){
  lubridate::now() %>% lubridate::format_ISO8601(usetz=TRUE)
}