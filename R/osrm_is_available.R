osrm_is_available <- function(){
  check_func <- function(){
    system("osrm-routed -v", ignore.stderr=TRUE, intern=TRUE, show.output.on.console = FALSE)
    system("osrm-extract -v", ignore.stderr=TRUE, intern=TRUE, show.output.on.console = FALSE)
    system("osrm-contract -v", ignore.stderr=TRUE, intern=TRUE, show.output.on.console = FALSE)
    return(TRUE)
  }

  wrapped_check_func <- purrr::quietly(purrr::possibly(check_func, otherwise = FALSE))

  wrapped_check_func()$result
}
