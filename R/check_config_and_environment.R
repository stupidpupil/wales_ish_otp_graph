check_config_and_environment <- function(){

	all_results_true <- TRUE

	check <- function(prev_result = TRUE, title, check_func, advice_on_failure = NULL){

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

			if(!is.null(advice_on_failure)){
				message("   ", advice_on_failure)
			}

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

	osmium_install_advice <- function(){
		if(Sys.info()["sysname"] == "Linux"){
			if(file.exists("/etc/os-release")){ 

				id_like_str <-  Filter(function(x){stringr::str_detect(x, "^ID_LIKE=")}, readr::read_lines("/etc/os-release"))[[1]]
				id_str <-  Filter(function(x){stringr::str_detect(x, "^ID=")}, readr::read_lines("/etc/os-release"))[[1]]

				# Debian/Ubuntu-sh
				if(id_like_str %>% stringr::str_detect("\\bdebian\\b")){
					return("Try: sudo apt install osmium-tool")
				}

				if(id_like_str %>% stringr::str_detect("\\b(rhel|fedora)\\b")){
					return("Try: sudo dnf install osmium-tool")
				}
			}

			return("Install the osmium-tool package for your distribution.")
		}

		if(Sys.info()["sysname"] == "Darwin"){
			if(file.exists("/opt/local/bin/port")){
				return("Try: sudo port install osmium-tool")
			}

			if(file.exists("/usr/local/bin/brew")){
				return("Try: brew install osmium-tool")
			}

			return("Install osmium-tool using MacPorts ( https://www.macports.org/ ) or Homebrew ( https://brew.sh/ )")
		}

		if(Sys.info()["sysname"] == "Windows"){
			return("Osmium Tool is not well-supported under Windows.\nConsider using Windows Subsystem for Linux (WSL): https://docs.microsoft.com/en-us/windows/wsl/install")
		}

		return("See https://osmcode.org/osmium-tool/")
	}

	check(
		title = "osmium is installed", 
		check_func = function(){system("osmium --version", ignore.stderr=TRUE, intern=TRUE, show.output.on.console = FALSE); return(TRUE)},
		advice_on_failure = osmium_install_advice()
		)

	message()
}