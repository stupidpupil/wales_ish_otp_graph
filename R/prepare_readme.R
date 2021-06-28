prepare_readme <- function(){
  rmarkdown::render("data-raw/output_readme.Rmd", knit_root_dir="..", output_dir="output")
}
