
getConvexHulls <- function(steps_resampled){
    ids <- unique(steps_resampled$ID)
    ch_list <- vector(mode="list", length=length(ids))
    names(ch_list) <- ids

    for(i in 1:length(ids)){
        pig <- steps_resampled[steps_resampled$ID==ids[i],]
        pig <- st_as_sf(pig, coords=c("x_", "y_"), crs=st_crs(5070))

        #get convex hull polygon
        # buffer the points, not the hull, so that all the points end up in the zone
        # buffering the convex hull leaves some points on the edge of the buffer
        # changed so that null points (case_ = FALSE) for resource selection model is within this buffered polygon
        ch <- st_convex_hull(st_buffer(st_union(pig), dist=1000))
        ch <- ch %>%
            st_sf %>%
            st_cast
        #add buffer, make sure all points inside, none on edge
#         ch <- st_buffer(ch, dist=1000)
        ch_list[[i]] <- ch
        #for raster piece, make separate func
        #may need to use geo targets for this as well
        #raster::intersect(lcd, poly)

        #if above doesn't work
        #shapefile_polygons <- as.sf(akde_object, level.UD=0.95, level=0.95)
        #middle_polygon <- shapefile_polygons[2,]    #selects the second row which is the 95% est middle polygon
    }
    return(ch_list)
}
