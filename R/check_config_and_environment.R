check_config_and_environment <- function(){

	all_results_true <- TRUE

	check <- function(prev_result = TRUE, title, check_func, advice_on_failure){

		if(!prev_result){
			return(FALSE)
		}

		result <- purrr::quietly(purrr::possibly(check_func, otherwise = FALSE))()$result

		if(is.na(result)){
			result <- FALSE
		}

		message(title %>% stringr::str_pad(45, side = 'right', pad="."), appendLF=FALSE)

		all_results_true <- all_results_true & result

		if(result){
			message("[ \u2713 ] ")
		}else{
			message("[ x ]")
		}

		return(result)
	}


	check(
		title = "bounds are a valid WKT polygon", 
		check_func = function(){bounds(); return(TRUE)},
		advice_on_failure	= "Ensure that bounds is a valid WKT Polygon!"
		) %>%
	check(
		title = "bounds include at least one region/nation", 
		check_func = function(){(intersecting_regions_and_nations() %>% nrow()) > 0}
		)

	check(
		title = "ATOC username and password set", 
		check_func = function(){!is.null(config::get()$atoc_username) & !is.null(config::get()$atoc_password)}
		) %>%
	check(
		title = "can log into ATOC", 
		check_func = function(){get_atoc_download_url() %>% stringr::str_detect("atoc.org")}
		)

	check(
		title = "TNDS username and password set", 
		check_func = function(){!is.null(config::get()$tnds_username) & !is.null(config::get()$tnds_password)}
		) %>%
	check(
		title = "can log into TNDS", 
		check_func = function(){
			readr::read_lines(paste0("ftp://",config::get()$tnds_username,":",config::get()$tnds_password,"@ftp.tnds.basemap.co.uk/"))
			return(TRUE)
			}
		)

	check(
		title = "osmium is installed", 
		check_func = function(){system("osmium --version", intern=TRUE); return(TRUE)},
		advice_on_failure = "Install osmium!"
		)

	message()
}