run_opentripplanner <- function(code, opentripplanner_dir = dir_output("opentripplanner")){
  px <- start_program(
    "java", c(java_args(), "-jar", dir_working("otp.jar"), "--load", opentripplanner_dir), 
    "Started listener bound to \\[0.0.0.0:8080\\]", timeout=240)

  close(px$get_output_connection())

  if(!missing(code)){

    on.exit({
      message("Killing OpenTripPlanner (pid ", px$get_pid(), ")...")
      px$kill()
      })

    return(force(code))
  }

  return(px)
}
