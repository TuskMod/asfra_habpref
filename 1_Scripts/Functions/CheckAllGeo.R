
# CheckAllGeo <- function(wb, wbr_lcd, lcd, tc, mast, geo2, rd1, rd2, rd3, rgd, prcp, tmax, tmin, crs.goal = 'EPSG:5070'){
CheckAllGeo <- function(wb, lcd, tc, mast, geo2, rd1, rd2, rd3, rgd, prcp, tmax, tmin, crs.goal = 'EPSG:5070'){

    # checks if crs is all the same
    CRS_check_list <- vector(mode="list", length=11)
    CRS_check_list[[1]] <- same.crs(crs(crs.goal), crs(wb))
    CRS_check_list[[2]] <- same.crs(crs(crs.goal), crs(tc))
#     CRS_check_list[[3]] <- same.crs(crs(crs.goal), crs(wbr_lcd))
    CRS_check_list[[3]] <- same.crs(crs(crs.goal), crs(lcd))
    CRS_check_list[[4]] <- same.crs(crs(crs.goal), crs(mast))
    CRS_check_list[[5]] <- same.crs(crs(crs.goal), crs(rd1))
    CRS_check_list[[6]] <- same.crs(crs(crs.goal), crs(rd2))
    CRS_check_list[[7]] <- same.crs(crs(crs.goal), crs(rd3))
    CRS_check_list[[8]] <- same.crs(crs(crs.goal), crs(rgd))
    CRS_check_list[[9]] <- same.crs(crs(crs.goal), crs(prcp))
    CRS_check_list[[10]] <- same.crs(crs(crs.goal), crs(tmax))
    CRS_check_list[[11]] <- same.crs(crs(crs.goal), crs(tmin))

    if(!all(CRS_check_list)){stop("non-matching CRS! double check rasters")}

    CRS_check_status <- all(CRS_check_list)
    return(CRS_check_status)
}
