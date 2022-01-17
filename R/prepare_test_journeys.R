prepare_test_journeys <- function(){

  launch_otp <- function(){

    start_program <- function(command, args, message, timeout = 5, ...) {
      timeout <- as.difftime(timeout, units = "secs")
      deadline <- Sys.time() + timeout
      px <- processx::process$new(command, args, stdout = "|", ...)
      all_lines <- c()

      while (px$is_alive() && (now <- Sys.time()) < deadline) {
        poll_time <- as.double(deadline - now, units = "secs") * 1000
        px$poll_io(as.integer(poll_time))
        lines <- px$read_output_lines()
        all_lines <- c(all_lines, lines)
        if (any(grepl(message, lines))) return(px)
      }

      print(args)
      print(all_lines)
      stop("Cannot start ", command)
    }

    px <- start_program(
      "java", c(java_args(), "-jar", dir_working("otp.jar"), "--load", dir_output()), 
      "Started listener bound to \\[0.0.0.0:8080\\]", timeout=240)

    close(px$get_output_connection())

    return(px)
  }

  otp_route_request_url <- function(fromLat, fromLon, toLat, toLon, when, public){

    mode <- ifelse(public, "TRANSIT%2CWALK", "CAR")

    paste0("http://localhost:8080/otp/routers/default/plan?",
      "fromPlace=", fromLat, "%2C", fromLon,
      "&toPlace=", toLat, "%2C", toLon,
      "&time=", when %>% strftime("%H%%3A%M%%3A%S"),
      "&date=",when %>% strftime("%Y-%m-%d"),
      "&mode=", mode, 
      "&maxWalkDistance=", 5000.0, 
      "&arriveBy=false&wheelchair=false&debugItineraryFilter=false&locale=en&maxItineraries=2")
  }


  initialise_test_journeys_tibble <- function(){

    # Tuesday, next week
    when = lubridate::now() %>% (function(x){x + lubridate::days(9 - lubridate::wday(x, week_start = 1))}) %>% update(hour=11, minute=0, second = 0)

    # FIXME - Really test journeys need to be extracted from the package
    readr::read_csv(dir_working("test_journeys.csv")) %>%
      crossing(expand_grid(when=when, public=c(T,F))) %>%
      mutate(requestUrl = otp_route_request_url(fromLat, fromLon, toLat, toLon, when, public))
  }

  px <- launch_otp()

  journeys <- initialise_test_journeys_tibble()
  journeys <- journeys %>% rowwise() %>% mutate(otpResponse = readr::read_file(requestUrl)) %>% ungroup()
  px$kill()

  try_to_get_duration <- function(otp_response_json){
    tryCatch({
      itineraries_i <- 1

      itineraries <- otp_response_json$plan$itineraries

      if(nrow(itineraries) > 1){ # Workaround for OTP issue #3289
        if(itineraries[[2, 'duration']] < itineraries[[1, 'duration']]){
          itineraries_i <- 2
        }
      }

      return(itineraries[[itineraries_i, 'duration']])
    }, error=function(err){})
    return(NA_integer_)
  }

  journeys <- journeys %>% rowwise() %>% 
    mutate(
      otpResponseJson = list(jsonlite::fromJSON(otpResponse)), 
      durationSeconds = try_to_get_duration(otpResponseJson),
      otpResponseJson = NULL) %>% ungroup()

  journeys %>% readr::write_csv(dir_output("test_journeys.csv"))
}
