readRaster <- function(path, proj.match=NULL, methd='near', resl=500, crs.out='EPSG:5070'){
    rastdat <- terra::rast(path)
    # breaks up input raster into tiles to read in larger datasets with terra::project
    # could use raster::projectRaster but doesn't have all the method options (e.g. 'mode' makes sense for aggregating land cover data to 0.5km resolution)
    exts <- getTileExtents(rastdat)
    pieces <- apply(exts, 1, function(x){
        tl <- terra::crop(rastdat, x)
        if (is.null(proj.match)){
            tl.proj <- terra::project(tl, crs(crs.out), method=methd, res=resl)
        } else {
            tl.proj <- terra::project(tl, proj.match, method=methd, res=resl)
        }
        return(tl.proj)
    })
    collect <- sprc(pieces)
    rastdat <- merge(collect)
    return(rastdat)
}
