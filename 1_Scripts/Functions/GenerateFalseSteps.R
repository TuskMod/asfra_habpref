
GenerateFalseSteps <- function(steps_resampled2, ch_rasts, ch_list){
    ids <- unique(steps_resampled2$ID)

    PigInfo <- unique(steps_resampled2[,c("study", "animalid", "sex", "age", "state", "ID")])

    for(i in 1:length(ids)){
        print(paste0("generating false steps for id ", i, " of ", length(ids)))

        #pull raster
        lcbl <- ch_rasts[i]
        lcbl <- project(lcbl, st_crs(5070)$proj4string)

        #get ID
        trp <- steps_resampled2[steps_resampled2$ID==ids[i],]
        trp <- trp[order(trp$t_),]

        #get false steps from core MCP, 50%, to be conservative
        trp <- amt::mk_track(trp, .x="x_", .y="y_", .t="t_", all_cols=TRUE)
#         fp <- amt::random_points(trp, n=nrow(trp), level=0.50)
#         fp <- amt::random_points(trp, n=nrow(trp), level=1.00)

        ## random within the raster of the buffered observed points
#         xrange <- range(crds(lcbl)[,1])
#         yrange <- range(crds(lcbl)[,2])
#         fp <- data.table(case_=FALSE, x_=runif(nrow(trp), xrange[1], xrange[2]), y_=runif(nrow(trp), yrange[1], yrange[2]))
#         tp <- data.table(case_=TRUE, trp[,'x_'], trp[,'y_'])
#         fp <- rbind(fp, tp)

        ## Random steps from each origin point, based on gamma model of movement distances
#         trp <- amt::steps_by_burst(trp, keep_cols='start')
#         fp <- amt::random_steps(trp, n_control=1)

        ## random points within the buffered home range vector
        fp <- amt::random_points(ch_list[[i]], n=nrow(trp))

        #remove true
        fp <- fp[!fp$case_, ]

        #randomly assign random points to different quarters
        #will make analysis easier later
        fp$season <- trp$season

        #bind animalid and info to false steps
        fp$ID <- ids[i]

        #get info back
        fp <- dplyr::left_join(fp, PigInfo, by="ID")
#         fp <- dplyr::left_join(fp, PigInfo, by=NULL)

        #bind with true steps
        trp_rf <- dplyr::bind_rows(trp, fp)

        #make case TRUE for true steps
        trp_rf$case_[is.na(trp_rf$case_)] <- TRUE

        trp_rf <- trp_rf %>% amt::extract_covariates(lcbl)
        # x_ y_ t_ X study, animalid, tz, longitude latitude DOP fixType sex age state tc lc mast rgd rd1 rd2 rd3 rd4 rd5 drt dayl prcp tmax tmin state_ordered ID burst_ season case_ X11 X21 X31 X41 X52 X71 X81 X90 X95?

        if(i==1){
            rf_steps <- trp_rf
        } else{
            rf_steps <- dplyr::bind_rows(rf_steps, trp_rf)
        }
    }
    return(rf_steps)
}#function closing bracket



