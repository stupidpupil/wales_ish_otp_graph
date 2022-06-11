run_osrm <- function(code, port=5000, osrm_file=path_to_osrm_graph("driving")) {

  checkmate::assert_integer(port, lower = 1024L, upper=49151L, len=1L)   # TODO - find an open port
  checkmate::assert_file_exists(osrm_file, access="r")

  # OSRM-routed doesn't like its stdout being closed
  # but it also requires that its stdout is constantly drained
  # unless we DISABLE_ACCESS_LOGGING or similar
  # (An alternative might be to set verbosity to NONE and investigate SIGNAL_PARENT_WHEN_READY)

  message("Starting OSRM...")
  px <- start_program(
    "osrm-routed", 
    c(
      "--max-table-size", "20000", 
      "--port", port,
      osrm_file),
    "running and waiting for requests", timeout = 30,
    env = c(Sys.getenv(), DISABLE_ACCESS_LOGGING = "DISABLE_ACCESS_LOGGING")
    )
  options(osrm.server = paste0("http://", "localhost", ":", port, "/"))

  if(!missing(code)){

    on.exit({
      message("Killing OSRM (pid ", px$get_pid(), ")...")
      px$kill()
      })

    return(force(code))
  }

  return(px)
}