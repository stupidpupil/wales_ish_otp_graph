vrt_for_terrain50_zip <- function(terr50_zip_path = "terr50_gagg_gb.zip", vrt_filename = "terr50_gagg_gb.vrt"){

  checkmate::assert_file_exists(terr50_zip_path, access="r", extension=".zip")

  vrt_sources_from_paths <- function(source_paths){

    sources_tibble <- tibble()

    for (pth in source_paths) {

      temp_rast <- terra::rast(pth)

      new_row <- tibble(
        SourceFilename = pth,
        XMin = terra::ext(temp_rast)$xmin,
        XMax = terra::ext(temp_rast)$xmax,
        YMin = terra::ext(temp_rast)$ymin,
        YMax = terra::ext(temp_rast)$ymax,
        XRes = terra::res(temp_rast)[[1]],
        YRes = terra::res(temp_rast)[[2]]
      )

      sources_tibble <- bind_rows(sources_tibble, new_row)

    }

    sources_tibble <- sources_tibble %>%
      mutate(
        DstRectXOff = (XMin - min(XMin))/XRes,
        DstRectYOff = (YMin - min(YMin))/YRes,
        XSize = (XMax - XMin)/XRes,
        YSize = (YMax - YMin)/YRes,
        DstRectXMax = DstRectXOff + XSize,
        DstRectYMax = DstRectYOff + YSize
      )


    return(sources_tibble)
  }

  vrt_sources_to_vrt_xml_string <- function(sources_tibble, description){
    # Assume that all have the same resolution
    XResolution = sources_tibble$XRes[[1]]
    YResolution = sources_tibble$YRes[[1]]

    RasterXSize = sources_tibble %>% pull(DstRectXMax) %>% max()
    RasterYSize = sources_tibble %>% pull(DstRectYMax) %>% max()

    sources_tibble <- sources_tibble %>%
      mutate(DstRectYOff = RasterYSize - DstRectYOff) %>%
      arrange(DstRectXOff, DstRectYOff) %>%
      mutate(
        SimpleSourceXML = paste0(
          "<SimpleSource>\n",
          "  <SourceFilename relativeToVRT=\"0\">", SourceFilename, "</SourceFilename>\n",
          "  <SourceBand>1</SourceBand>\n",
            "  <SourceProperties RasterXSize=\"", XSize, "\" RasterYSize=\"", YSize, "\" DataType=\"Float32\" BlockXSize=\"200\" BlockYSize=\"1\" />\n",
          "  <SrcRect xOff=\"0\" yOff=\"0\" xSize=\"", XSize, "\" ySize=\"", YSize, "\" />\n",
              "  <DstRect xOff=\"", DstRectXOff ,"\" yOff=\"", DstRectYOff, "\" xSize=\"", XSize, "\" ySize=\"", YSize, "\" />\n",
          "</SimpleSource>"
        )

      )

    vrt_text <- paste0(
      "<VRTDataset rasterXSize=\"", RasterXSize ,
               "\" rasterYSize=\"", RasterYSize , "\">\n",
      "  <SRS dataAxisToSRSAxisMapping=\"1,2\">", sf::st_crs(27700)$wkt, "</SRS>\n",
        "  <GeoTransform> ", 
          sources_tibble %>% pull(XMin) %>% min(), ",  ", XResolution, ",  0.0, ", 
          sources_tibble %>% pull(YMax) %>% max() + (YResolution * sources_tibble$YSize[[1]]),",  0.0, ", -YResolution, "</GeoTransform>\n",
        "  <VRTRasterBand dataType=\"Float32\" band=\"1\">\n",
        "    <Description>", description,"</Description>\n",
        "    <UnitType>m</UnitType>\n",
             (sources_tibble %>% pull(SimpleSourceXML) %>% paste(collapse = "\n")),
        "\n  </VRTRasterBand>\n",
        "</VRTDataset>"
    )

    return(vrt_text)
  }


  input_zips <- unzip(terr50_zip_path, list=TRUE) %>%
    filter(Name %>% stringr::str_detect("\\.zip$")) %>%
    pull(Name)

  grid_refs <-  input_zips %>% 
    stringr::str_extract("/[a-z]{2}[0-9]{2}_OST50GRID") %>% 
    stringr::str_sub(2,5) %>%
    stringr::str_to_upper()

  vsizip_paths <- paste0("/vsizip//vsizip/", terr50_zip_path, "/", input_zips, "/",  grid_refs, ".asc")

  message("Found ", length(vsizip_paths), " input zips")

  sources_tibble <- vrt_sources_from_paths(vsizip_paths)

  vrt_text <- vrt_sources_to_vrt_xml_string(sources_tibble, "OS Terrain 50 DTM")

  unlink(vrt_filename)
  vrt_text %>% write(vrt_filename)

  message("VRT written")

  terra::rast(vrt_filename)
}
