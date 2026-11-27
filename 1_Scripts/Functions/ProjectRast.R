
ProjectRast <- function(rastdat, methd='ngb', resl=500, crs.out='EPSG:5070'){
    if (!terra::same.crs(st_crs(rastdat), st_crs(crs.out))) {
        rastdat <- terra::rast(raster::projectRaster(raster(rastdat), res=resl, crs=crs(crs.out), method=methd))
#         rastdat <- terra::project(x=rast(rastdat), y=crs.out, res=resl, method=methd, use_gdal=FALSE)#, threads=TRUE)
    }
#     if (crs(lcd_original) != 5070) lcd_original <- terra::project(lcd_original, 'epsg:5070', method='near', threads=TRUE)
    return(rastdat)
}
