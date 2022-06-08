#' Prepare Terrain 50 for parochial spatial bounds
#' 
#' @details
#' This function prepares a GeoTIFF from a Terrain 50 ASCII Grid and GML (GAGG) zip.
#' The GeoTIFF is cropped to the parochial spatial bounds (plus a buffer of 20km or so) 
#' and reprojected to EPSG:4326.
#'
#' It will create a GDAL VRT (Virtual Dataset) file for the Terrain 50 zip
#' if necessary, using \code{vrt_for_terrain50_zip}.
#' 
#' @param terr50_zip_path Path to the Terrain 50 Grid and GML (GAGG) zip
#'
#' @return The path of the prepared GeoTIFF
#' 
prepare_terrain50 <- function(terr50_zip_path = dir_working("terr50_gagg_gb.zip")){
  
  checkmate::assert_file_exists(terr50_zip_path, access="r", extension=".zip")

  vrt_filename <- dir_working("terr50_gagg_gb.vrt")

  if(cache_key_for_file(terr50_zip_path) == cache_key_for_file(vrt_filename)){
    message("Cache hit for ", vrt_filename)
    terrain50 <- terra::rast(vrt_filename)
  }else{
    terrain50 <- vrt_for_terrain50_zip(
      terr50_zip_path = terr50_zip_path, 
      vrt_filename = vrt_filename)

    list(
      CreatedAt = now_as_iso8601(),
      DerivedFrom = I(describe_file(dir_working("terr50_gagg_gb.zip"))),
      ParochialCacheKey = cache_key_for_file(terr50_zip_path)
    ) %>% jsonlite::toJSON(pretty = TRUE) %>%
    write(paste0(vrt_filename, ".meta.json"))
  }

  dest_path <- dir_output(output_affix(), ".terr50.tif")

  cache_key = openssl::sha1(paste0(
    cache_key_for_file(vrt_filename),
    bounds() %>% sf::st_as_text()
    )) %>% as.character()

  if(cache_key == cache_key_for_file(dest_path)){
    message("Cache hit for ", dest_path)
    return(dest_path)
  }

  message("Cropping and reprojecting Terrain 50...")

  terra::crop(terrain50, bounds(buffer_by_metres = 20100) %>% sf::st_transform(crs="EPSG:27700")) %>% 
    terra::project("EPSG:4326") %>%
    terra::writeRaster(dest_path, overwrite=TRUE)

  list(
    CreatedAt = now_as_iso8601(),
    DerivedFrom = I(describe_file(dir_working("terr50_gagg_gb.zip"))),
    ParochialCacheKey = cache_key
  ) %>% jsonlite::toJSON(pretty = TRUE) %>%
  write(paste0(dest_path, ".meta.json"))

  return(dest_path)
}
