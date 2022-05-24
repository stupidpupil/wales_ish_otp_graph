run_osrm <- function(port=0, code) {

  px <- start_program(
    "osrm-routed", 
    c("--max-table-size", "20000", dir_output("osrm/", output_affix(), ".osrm")),
    "running and waiting for requests", 30
    )

  close(px$get_output_connection())

  options(osrm.server = paste0("http://", "localhost", ":", port))

  if(!missing(code)){
    force(code)
    on.exit({px$kill()})
  }

  return(px)
}