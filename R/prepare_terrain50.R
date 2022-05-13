prepare_terrain50 <- function(terr50_zip_path = dir_working("terr50_gagg_gb.zip")){
	
  checkmate::assert_file_exists(terr50_zip_path, access="r", extension=".zip")

	terrain50 <- vrt_for_terrain50_zip(
		terr50_zip_path = terr50_zip_path, 
		vrt_filename = dir_working("terr50_gagg_gb.vrt"))

	dest_path <- dir_output(output_affix(), ".terr50.tif")

	terra::crop(terrain50, bounds(buffer_by_metres = 20100) %>% sf::st_transform(27700)) %>% 
		terra::project("epsg:4326") %>%
		terra::writeRaster(dest_path, overwrite=TRUE)

  list(
    CreatedAt = now_as_iso8601(),
    DerivedFrom = I(describe_file(dir_working("terr50_gagg_gb.zip")))
  ) %>% jsonlite::toJSON(pretty = TRUE) %>%
  write(paste0(dest_path, ".meta.json"))

  return(dest_path)
}