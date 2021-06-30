wales_ish_bounding_box = list(
  c(51.3431,-5.4672),
  c(53.4761,-2.1742)
  )

wales_ish_bounding_box_string = paste0(wales_ish_bounding_box %>% rev() %>% unlist() %>% rev(), collapse=",")
