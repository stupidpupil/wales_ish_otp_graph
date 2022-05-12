gtfstidy_is_available <- function() {
  check_func <- function(){
    system("$(go env GOPATH)/bin/gtfstidy", ignore.stderr=TRUE, intern=TRUE, show.output.on.console = FALSE)
    return(TRUE)
  }

  wrapped_check_func <- purrr::quietly(purrr::possibly(check_func, otherwise = FALSE))

  wrapped_check_func()$result
}
