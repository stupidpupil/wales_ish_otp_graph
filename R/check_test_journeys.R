check_test_journeys <- function(){

  tests <- tibble(Description = character(0), Passed = logical(0))

  test_journeys <- read_csv("output/test_journeys.csv")

  next_test <- tibble(
    Description = "Cardiff to Sheffield can't be routed",
    Passed = TRUE
  )

  if(!(test_journeys %>% filter(Description == "Cardiff to Sheffield") %>% pull(durationSeconds) %>% is.na() %>% all())){
    next_test$Passed = FALSE
  }

  tests <- tests %>% bind_rows(next_test)

  next_test <- tibble(
    Description = "All journeys within Walesish can be routed",
    Passed = TRUE
  )

  if(test_journeys %>% filter(Description != "Cardiff to Sheffield") %>% pull(durationSeconds) %>% is.na() %>% any()){
    next_test$Passed = FALSE

    cat("Couldn't route:\n")
    cat(test_journeys %>% 
      filter(Description != "Cardiff to Sheffield", is.na(durationSeconds)) %>% 
      mutate(BigDesc = paste0(Description, " - ", ifelse(public, "Public", "Driving"))) %>%
      pull(BigDesc) %>% paste0(collapse="\n"))
    cat("\n\n")
  }

  tests <- tests %>% bind_rows(next_test)

  next_test <- tibble(
    Description = "Cardiff to Bala and its reverse take roughly the same amount of time to drive",
    Passed = TRUE
  )

  ctob_duration <- test_journeys %>% filter(Description == "Cardiff to Bala", !public) %>% pull(durationSeconds)
  btoc_duration <- test_journeys %>% filter(Description == "Bala to Cardiff", !public) %>% pull(durationSeconds)

  if(ctob_duration > 1.05*btoc_duration | btoc_duration > 1.05*ctob_duration){
    next_test$Passed = FALSE
  }

  tests <- tests %>% bind_rows(next_test)

  if(any(!tests$Passed)){
    cat("Failed tests:\n")
    cat(tests %>% filter(!Passed) %>% pull(Description) %>% paste0(collapse="\n"))
    cat("\n")
    stop("Some checks on test journeys failed!")
  }

  print("All checks on test journeys passed!")

}