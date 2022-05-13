atoc_user_agent <- function(){
  httr::user_agent("Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:89.0) Gecko/20100101 Firefox/89.0")
}

get_logged_in_atoc_session <- function(){
  atoc_session <- rvest::session("https://data.atoc.org/user/login", atoc_user_agent())

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

get_atoc_download_url <- function(){

  atoc_session <- get_logged_in_atoc_session()

  atoc_session <- atoc_session %>% rvest::session_jump_to("https://data.atoc.org/data-download")

  atoc_download_url <- atoc_session %>% rvest::html_node("#field_timetable_file-wrapper a") %>% rvest::html_attr("href")

  atoc_session %>% rvest::session_jump_to("https://data.atoc.org/user/logout?current=node/1")

  return(atoc_download_url)
}

download_atoc <- function(retries=3L){

  atoc_download_url <- get_atoc_download_url()
  atoc_session <- get_logged_in_atoc_session()

  #atoc_session <- atoc_session %>% rvest::session_jump_to("https://data.atoc.org/data-download")
  atoc_session <- atoc_session %>% rvest::session_jump_to(atoc_download_url, atoc_user_agent())

  actual_content_length <- atoc_session$response$content %>% length()
  claimed_content_length <- as.integer(atoc_session$response$headers$`content-length`)

  if(actual_content_length == 0L | actual_content_length < claimed_content_length){
    print("ATOC zip was empty or didn't match content-length header. Retrying in 60 seconds…")
    atoc_session %>% rvest::session_jump_to("https://data.atoc.org/user/logout?current=node/1")
    Sys.sleep(60L)
    if(retries > 0){
      return(download_atoc(retries-1L))
    }
    stop("Downloading ATOC zip failed!")
  }

  dest_path <- dir_working("atoc.zip")

  writeBin(atoc_session$response$content, dest_path)
  atoc_session %>% rvest::session_jump_to("https://data.atoc.org/user/logout?current=node/1")

  jsonlite::toJSON(pretty = TRUE, auto_unbox = TRUE, list(
    SourceUrl = atoc_download_url,
    SourceDownloadedAt = now_as_iso8601(),
    SourceLicence = "CC-BY-2.0",
    SourceAttribution = "RSP Limited (Rail Delivery Group)"
  )) %>% write(paste0(dest_path, ".meta.json"))

  return(dest_path)
}