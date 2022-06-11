run_osrm <- function(code, port=5000, osrm_file=path_to_osrm_graph("driving")) {

  # OSRM-routed doesn't like its stdout being closed
  # but it also requires that its stdout is constantly drained
  # unless we DISABLE_ACCESS_LOGGING or similar
  # (An alternative might be to set verbosity to NONE and investigate SIGNAL_PARENT_WHEN_READY)

  # TODO - find an open port

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