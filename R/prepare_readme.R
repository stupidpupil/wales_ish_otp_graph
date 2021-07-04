prepare_readme <- function(){
  rmarkdown::render("data-raw/output_readme.Rmd", knit_root_dir="..", output_dir="output", output_format="all")
  rmarkdown::render("data-raw/release_body.Rmd", knit_root_dir="..", output_dir="output", output_format="all")
}
