
RanforPreformatLC <- function(lands_sprc){
    land.df_list <- vector(mode="list", length=length(lands_sprc))
    for(i in 1:length(lands_sprc)){
        print(paste0("formatting ", i, " of ", length(lands_sprc)))
        land <- lands_sprc[i]

        landfl <- as.data.frame(land[[1]], cells=TRUE, xy=TRUE)
        if("mast" %in% colnames(landfl)){

            if('drt' %in% names(landfl) == FALSE) landfl$drt <- -1

            #get means for all vars except lc
            landfl$mmast <- mean(landfl$mast, na.rm=TRUE)
            landfl$mtc <- mean(landfl$tc, na.rm=TRUE)
            landfl$mrd1 <- mean(landfl$rd1, na.rm=TRUE)
            landfl$mrd2 <- mean(landfl$rd2, na.rm=TRUE)
            landfl$mrd3 <- mean(landfl$rd3, na.rm=TRUE)
            landfl$mdrt <- mean(landfl$drt, na.rm=TRUE)
            landfl$mprcp <- mean(landfl$prcp, na.rm=TRUE)
            landfl$mtmax <- mean(landfl$tmax, na.rm=TRUE)
            landfl$mtmin <- mean(landfl$tmin, na.rm=TRUE)
            landfl$mrgd <- mean(landfl$rgd, na.rm=TRUE)
            landfl$mdrt[is.na(landfl$mdrt)] <- -1

            #remove unneeded cols
            landfl <- landfl[-c(which(colnames(landfl)=="mast"),
                                which(colnames(landfl)=="rgd"),
                                which(colnames(landfl)=="drt"),
                                which(colnames(landfl)=="tc"),
                                which(colnames(landfl)=="rd1"),
                                which(colnames(landfl)=="rd2"),
                                which(colnames(landfl)=="rd3"),
                                which(colnames(landfl)=="prcp"),
                                which(colnames(landfl)=="tmax"),
                                which(colnames(landfl)=="tmin"))]

            land.df_list[[i]] <- landfl
        } else{
            land.df_list[[i]] <- NA
        }
    }

    land.df_list <- Filter(function(a) any(!is.na(a)), land.df_list)

    return(land.df_list)

}
