
JoinLandEnvCovs <- function(i, grid.in, tc, mast, rd1, rd2, rd3, drt, rgd, lcd, prcp, tmax, tmin){
    library(sf)
    library(terra)
    library(raster)

    bound <- vect(grid.in[grid.in$ID == i,])
    ras <- terra::crop(lcd, bound, extend=TRUE)
    intersect.data2 <- TRUE
    if(sum(values(allNA(ras))) == 40000){
        intersect.data2 <- FALSE
    }

    #make names of rasters more informative
    names(tc)[1] <- "tc"
    names(rd1)[1] <- "rd1"
    names(rd2)[1] <- "rd2"
    names(rd3)[1] <- "rd3"
    names(mast)[1] <- 'mast'
    names(rgd)[1] <- 'rgd'
    names(drt)[1] <- 'drt'

    intersect.data <- lapply(list(lcd, mast, tc, rd1, rd2, rd3, rgd), function(d) any(relate(x=d, y=bound, relation='intersects')))
    lc_val <- terra::extract(lcd, bound)[,2]
    intersect.data3 <- any(c(!is.na(lc_val), lc_val != 11, lc_val != 12))

    if (all(c(unlist(intersect.data), intersect.data2, unlist(intersect.data3)))){

        land <- segregate(ras)

        #join lands with mast
        land_mast <- terra::crop(mast, land, extend=TRUE)
        add(land) <- land_mast
        #join lands with tc
        land_tc <- terra::crop(tc, land, extend=TRUE)
        add(land) <- land_tc
        #join lands with rd1
        land_rd1 <- terra::crop(rd1, land, extend=TRUE)
        add(land) <- land_rd1
        #join lands with rd2
        land_rd2 <- terra::crop(rd2, land, extend=TRUE)
        add(land) <- land_rd2
        #join lands with rd3
        land_rd3 <- terra::crop(rd3, land, extend=TRUE)
        add(land) <- land_rd3

#         if (any(relate(vect(drt_q1), land, 'intersects')) == TRUE){
#             #add drought layers
#             add(land) <- drt_proc(drt_q1, land, "q1")
#         }
#         if (any(relate(vect(drt_q2), land, 'intersects')) == TRUE){
#             add(land) <- drt_proc(drt_q2, land, "q2")
#         }
#         if (any(relate(vect(drt_q3), land, 'intersects')) == TRUE){
#             add(land) <- drt_proc(drt_q3, land, "q3")
#         }
#         if (any(relate(vect(drt_q4), land, 'intersects')) == TRUE){
#             add(land) <- drt_proc(drt_q4, land, "q4")
#         }
        land_drt <- terra::crop(drt, land, extend=TRUE)
        add(land) <- land_drt
        land_rgd <- terra::crop(rgd, land, extend=TRUE)
        add(land) <- land_rgd
        land_prcp <- terra::crop(prcp, land, extend=TRUE)
        add(land) <- land_prcp
        land_tmax <- terra::crop(tmax, land, extend=TRUE)
        add(land) <- land_tmax
        land_tmin <- terra::crop(tmin, land, extend=TRUE)
        add(land) <- land_tmin

        return(land)
    } else {
        return(ras)
    }
}

# drt_proc <- function(drt_q, land, q){
#     drt_ras <- stars::st_rasterize(drt_q)
#     drt_ras <- terra::rast(drt_ras)
#     drt_ras <- drt_ras$DM_DM
#     drt_land <- terra::crop(drt_ras, land, extend=TRUE)
#     drt_land <- terra::project(drt_land, st_crs(land)$proj4string)
#     terra::ext(drt_land) <- terra::ext(land)
#     x <- drt_land
#     res(drt_land) <- res(land)
#     drt_land <- resample(drt_land, land, method='near')
#     #increase drought index by 1 so it doesn't freak out model prediction when there are tons of NA values
#     drt_land <- terra::classify(drt_land, matrix(c(NA,0,1,2,3,4,5,-1,0,1,2,3,4,5), ncol=2, byrow=TRUE))
#     names(drt_land)[1] <- paste0("drt_", q)
#     return(drt_land)
# }

drt_combine <- function(q1, q2, q3, q4, lcd){
    q1 <- rasterize(q1, rast(ext(lcd), crs='EPSG:5070', vals=0, res=500), field='DM')
    q2 <- rasterize(q2, rast(ext(lcd), crs='EPSG:5070', vals=0, res=500), field='DM')
    q3 <- rasterize(q3, rast(ext(lcd), crs='EPSG:5070', vals=0, res=500), field='DM')
    q4 <- rasterize(q4, rast(ext(lcd), crs='EPSG:5070', vals=0, res=500), field='DM')
    max.drought <- app(c(q1,q2,q3,q4), 'max', na.rm=TRUE)
    return(max.drought)
}
