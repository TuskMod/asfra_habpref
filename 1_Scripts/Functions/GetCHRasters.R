
getCHrasters <- function(ch_list, lcd){

    lcd_30m <- terra::rast(lcd)

    ids <- names(ch_list)
    ch_rasts <- vector(mode="list",length=length(ids))
    names(ch_rasts) <- ids

    for(i in 1:length(ids)){
        print(paste0("making raster for id ", i, " of ", length(ids)))
        ch <- ch_list[[i]]
        ch <- st_transform(ch, crs=st_crs(lcd_30m))
        #crop by home range polygon
        lc <- raster::crop(lcd_30m, ch)
        # recode land classes to match what will be used in the simulations
        lc <- RecodeLandClass(lc)
        # keep as 30m raster for more detailed analysis of gps movement data
        lc <- raster::raster(project(lc, y='EPSG:5070', method='near'))
        #make dummy coded version
        lc_dummy <- layerize(lc)
        lcbl <- terra::rast(lc_dummy)
        ch_rasts[[i]] <- lcbl
    }
    ch_rasts_sprc <- terra::sprc(ch_rasts)
    return(ch_rasts_sprc)
}
