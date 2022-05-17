gtfstidy_is_available <- function() {
  check_func <- function(){
    system("$(go env GOPATH)/bin/gtfstidy", ignore.stderr=TRUE, intern=TRUE, show.output.on.console = FALSE)
    return(TRUE)
  }

  wrapped_check_func <- purrr::quietly(purrr::possibly(check_func, otherwise = FALSE))

  wrapped_check_func()$result
}

gtfstidy_path <- function(){
  if(!gtfstidy_is_available()){
    stop("gtfstidy is not available")
  }

  paste0(
    processx::run("go", c("env", "GOPATH"))$stdout %>% stringr::str_trim(),
    "/bin/gtfstidy"
  )
}