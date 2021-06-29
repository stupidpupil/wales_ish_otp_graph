download_atoc <- function(){

  atoc_session <- rvest::session("http://data.atoc.org/user/login")

  atoc_login_form <- atoc_session %>% rvest::html_node("#user-login") %>% rvest::html_form() %>%
    rvest::html_form_set(name=config::get()$atoc_username, pass=config::get()$atoc_password)

  atoc_session <- atoc_session %>% rvest::session_submit(atoc_login_form)

  atoc_session <- atoc_session %>% rvest::session_jump_to("http://data.atoc.org/data-download")

  atoc_download_url <- atoc_session %>% rvest::html_node("#field_timetable_file-wrapper a") %>% rvest::html_attr("href")

  atoc_session <- atoc_session %>% rvest::session_jump_to(atoc_download_url)

  writeBin(atoc_session$response$content, "data-raw/atoc.zip")

  toJSON(pretty = TRUE, auto_unbox = TRUE, list(
    SourceUrl = atoc_download_url,
    SourceDownloadedAt = now() %>% format_ISO8601(usetz=TRUE),
    SourceLicence = "CC-BY-2.0",
    SourceAttribution = "RSP Limited (Rail Delivery Group)"
  )) %>% write("data-raw/atoc.zip.meta.json")

}