download_atoc <- function(){

  atoc_session <- rvest::html_session("http://data.atoc.org/user/login")

  atoc_login_form <- atoc_session %>% rvest::html_node("#user-login") %>% rvest::html_form() %>%
    rvest::set_values(name=config::get()$atoc_username, pass=config::get()$atoc_password)

  atoc_session <- atoc_session %>% rvest::submit_form(atoc_login_form)

  atoc_session <- atoc_session %>% rvest::jump_to("http://data.atoc.org/data-download")

  atoc_download_url <- atoc_session %>% rvest::html_node("#field_timetable_file-wrapper a") %>% rvest::html_attr("href")

  atoc_session <- atoc_session %>% rvest::jump_to(atoc_download_url)

  writeBin(atoc_session$response$content, "data-raw/atoc.zip") 

}