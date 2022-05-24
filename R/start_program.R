start_program <- function(command, args, message, timeout = 5, ...) {
  timeout <- as.difftime(timeout, units = "secs")

  if(missing(message)){
    print('here')
    px <- processx::process$new(command, args, ..., echo=TRUE)
    Sys.sleep(timeout)
    return(px)
  }

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