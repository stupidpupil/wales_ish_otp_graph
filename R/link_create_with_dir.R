#' Create links in a destination directory to a set of target paths 
#' @return The paths to the created links
link_create_with_dir <- function(target_paths, dest_dir){

  checkmate::assert_file_exists(target_paths)
  checkmate::assert_character(dest_dir, len = 1)
  checkmate::assert_directory_exists(dest_dir)

  link_targets <- target_paths %>% fs::path_rel(dest_dir)

  link_paths <- target_paths %>% purrr::map_chr(
    function(pth){paste0(dest_dir,"/", fs::path_file(pth))})

  link_paths %>% 
    purrr::keep(~ fs::link_exists(.x)) %>%
    fs::link_delete()

  fs::link_create(link_targets, link_paths)
}
