prepare_readme <- function(){
  rmarkdown::render(dir_support("output_readme.Rmd"), knit_root_dir="..", output_dir=dir_output(), output_format="all")
  rmarkdown::render(dir_support("release_body.Rmd"),  knit_root_dir="..", output_dir=dir_output(), output_format="all")
}
