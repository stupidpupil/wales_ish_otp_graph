#' User-agent used for accessing ATOC
atoc_user_agent <- function(){
  httr::user_agent("Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:89.0) Gecko/20100101 Firefox/89.0")
}


#' Get a logged-in ATOC session
#'
#' @details
#' Uses the username and password provided in config.yml to attempt to
#' to obtain a logged-in \code{rvest::session}.
#' 
#' @return An \code{rvest::session} if succesful.
#'
get_logged_in_atoc_session <- function(){
  atoc_session <- rvest::session("https://data.atoc.org/user/login", atoc_user_agent())

  message("Logging into ATOC/RDG data portal...")

  atoc_login_form <- atoc_session %>% rvest::html_node("#user-login") %>% rvest::html_form() %>%
    rvest::html_form_set(name=config::get()$atoc_username, pass=config::get()$atoc_password)

  atoc_session <- atoc_session %>% rvest::session_submit(atoc_login_form)

  error_message_el <- atoc_session %>% rvest::html_node(".error")

  if(!inherits(error_message_el, "xml_missing")){
    error_message <- error_message_el %>% rvest::html_text()
    stop("ATOC login failed with the following error: ", error_message)
  }

  return(atoc_session)
}


#' Logout a logged-in ATOC session
#'
#' @param atoc_session A logged-in ATOC session.
#'
#' @return TRUE
#' 
logout_atoc_session <- function(atoc_session){
  atoc_session %>% rvest::session_jump_to("https://data.atoc.org/user/logout?current=node/1")
  return(TRUE)
}


#' Get the latest ATOC CIF download url
#'
#' @param atoc_session A logged-in ATOC session. If this is missing, then the function will attempt
#' to obtain its own session, using \code{get_logged_in_atoc_session}
#' 
#' @return An \code{rvest::session} if succesful.
#' 
get_atoc_download_url <- function(atoc_session){

  if(missing(atoc_session)){
    atoc_session <- get_logged_in_atoc_session()
    on.exit(logout_atoc_session(atoc_session))
  }

  atoc_session <- atoc_session %>% rvest::session_jump_to("https://data.atoc.org/data-download")

  atoc_download_url <- atoc_session %>% rvest::html_node("#field_timetable_file-wrapper a") %>% rvest::html_attr("href")

  message("Got URL for ATOC data:\n", atoc_download_url)

  atoc_download_url %>% checkmate::assert_character(pattern="^https?://.+$")

  return(atoc_download_url)
}


#' Download the latest ATOC CIF zip
#
#' @details
#' This uses \code{get_atoc_download_url} to find the latest ATOC CIF download url,
#' checks if this is different to any existing download ATOC CIF zip (using \code{cache_key_for_atoc_url}),
#' and downloads it if necessary.
#'
#' It checks that the actual size of the downloaded zip matches the HTTP Content-Length header, 
#' and will reattempt the download if this fails.
#'
#' @return The path of the downloaded ATOC CIF zip
#'
download_atoc <- function(retries=3L){

  retries %>% checkmate::assert_count()

  atoc_session <- get_logged_in_atoc_session()
  on.exit(logout_atoc_session(atoc_session))

  atoc_download_url <- get_atoc_download_url(atoc_session)

  cache_key <- cache_key_for_atoc_url(atoc_download_url)

  dest_path <- dir_working("atoc.zip")

  if(cache_key == cache_key_for_file(dest_path)){
    message("Cache hit for ", dest_path)
    return(dest_path)
  }

  atoc_session <- atoc_session %>% rvest::session_jump_to(atoc_download_url, atoc_user_agent())

  actual_content_length <- atoc_session$response$content %>% length()
  claimed_content_length <- as.integer(atoc_session$response$headers$`content-length`)

  if(actual_content_length == 0L | actual_content_length < claimed_content_length){
    warning("ATOC zip was empty or didn't match content-length header. Retrying in 60 seconds...")
    atoc_session %>% rvest::session_jump_to("https://data.atoc.org/user/logout?current=node/1")
    Sys.sleep(60L)
    if(retries > 0){
      return(Recall(retries-1L))
    }
    stop("Downloading ATOC zip failed!")
  }

  writeBin(atoc_session$response$content, dest_path)

  jsonlite::toJSON(pretty = TRUE, auto_unbox = TRUE, list(
    SourceUrl = atoc_download_url,
    SourceDownloadedAt = now_as_iso8601(),
    SourceLicence = "CC-BY-2.0",
    SourceAttribution = "RSP Limited (Rail Delivery Group)",
    ParochialCacheKey = cache_key
  )) %>% write(paste0(dest_path, ".meta.json"))

  return(dest_path)
}
