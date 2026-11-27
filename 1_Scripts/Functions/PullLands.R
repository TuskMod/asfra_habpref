
## {source('./1_Scripts/Functions/Functions.R'); Pull_Lands(tar_read(lcd), tar_read(grid))}
Pull_Lands <- function(lcd, grid){
    grid.in <- grid[!is.na(grid$inside),]
    lands_list <- vector(mode="list", length=nrow(grid.in))

    for(i in 1:nrow(grid.in)){
        print(paste0("row ", i, " of ", nrow(grid.in)))

        #crop nlcd by extent of grid row i
        #make sure col indices correct
        bound <- extent(c(grid.in[i,2], grid.in[i,4], grid.in[i,3], grid.in[i,7]))
        ras <- terra::crop(lcd,bound)

        #dummy code
        ras <- raster(ras)
        rasdum <- layerize(ras)

        #Aggregate nlcd to appropriate scale
        #500 m resolution
        x <- raster(rasdum)
        res(x) <- 500
        rasdum_agg <- raster::resample(rasdum, x, method="bilinear")
        rasdum_agg <- terra::rast(rasdum_agg)
        lands_list[[i]] <- rasdum_agg
    }
    lands <- terra::sprc(lands_list)
    names(lands) <- grid.in[,1]
    return(lands)
}
