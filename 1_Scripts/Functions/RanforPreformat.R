
## {source('./1_Scripts/Functions/Functions.R'); RanforPreformat(tar_read(rf_steps))}
RanforPreformat <- function(rf_steps){
    #rf_steps2<-as.data.frame(rf_steps2)
    #rf_steps2$case_<-as.factor(rf_steps2$case_)
    #rf_steps2=rf_steps2[,c(3,5,9:29)]
    #FIX: rf_steps is supposed to have season going into model
    #FIX: for rf_steps preformat, remove study and sex
    rf_steps <- as.data.frame(rf_steps)
    #lc vals for false steps if NA need be zero
    rf_steps[,34:42][is.na(rf_steps[,34:42])] <- 0
#     rf_steps[,42:50][is.na(rf_steps[,42:50])] <- 0

    #change case to 1/0
    rf_steps$case_[rf_steps$case_] <- 1
    rf_steps$case_[!(rf_steps$case_)] <- 0

    #remove cols not needed
    rf_steps <-
        rf_steps[,-c(which(colnames(rf_steps)=="study"),
                    which(colnames(rf_steps)=="sex"),
                    which(colnames(rf_steps)=="animalid"),
                    which(colnames(rf_steps)=="state"),
                    which(colnames(rf_steps)=="burst_"),
                    which(colnames(rf_steps)=="rd4"),
                    which(colnames(rf_steps)=="rd5"),
                    which(colnames(rf_steps)=="lc"),
                    which(colnames(rf_steps)=="age"),
                    which(colnames(rf_steps)=="fixType"),
                    which(colnames(rf_steps)=="DOP"),
                    which(colnames(rf_steps)=="latitude"),
                    which(colnames(rf_steps)=="longitude"),
                    which(colnames(rf_steps)=="tz"),
                    which(colnames(rf_steps)=="X"),
                    which(colnames(rf_steps)=="t_"))]

    #Format drought to numeric
    rf_steps$drt[rf_steps$drt=="D0"] <- "0"
    rf_steps$drt[rf_steps$drt=="D1"] <- "1"
    rf_steps$drt[rf_steps$drt=="D2"] <- "2"
    rf_steps$drt[rf_steps$drt=="D3"] <- "3"
    rf_steps$drt[rf_steps$drt=="D4"] <- "4"
    rf_steps$drt[rf_steps$drt=="D5"] <- "5"
    rf_steps$drt[rf_steps$drt=="None"] <- '-1'
    rf_steps$drt <- as.numeric(rf_steps$drt)

    #get means of temp vals for each pig
    rf_steps <- rf_steps %>%
        dplyr::group_by(ID, season) %>%
        dplyr::mutate(mtc=mean(tc, na.rm=TRUE),
                    mprcp=mean(prcp, na.rm=TRUE),
                    mdrt=mean(drt, na.rm=TRUE),
                    mtmin=mean(tmin, na.rm=TRUE),
                    mtmax=mean(tmax, na.rm=TRUE),
#                     mdayl=mean(dayl, na.rm=TRUE),
                    mmast=mean(mast, na.rm=TRUE),
                    mrgd=mean(rgd, na.rm=TRUE),
                    mrd1=mean(rd1, na.rm=TRUE),
                    mrd2=mean(rd2, na.rm=TRUE),
                    mrd3=mean(rd3, na.rm=TRUE),)

    #sep cols needed for random forest
    rf_steps2 <- rf_steps[,c(which(colnames(rf_steps)=="season"):
                            which(colnames(rf_steps)=="mrd3"))]

    #check that no NAs remaining
    any(!(complete.cases(rf_steps2)))

    rf_steps2 <- as.data.frame(rf_steps2)
    setnames(rf_steps2, paste0('X', c(11,21,31,41,52,71,81,90,95)), as.character(c(11,21,31,41,52,71,81,90,95)))

    #set factors
    factor_cols <- c(which(colnames(rf_steps2)=="season"),
                    which(colnames(rf_steps2)=="case_"))

    rf_steps2[,factor_cols] <- lapply(rf_steps2[,factor_cols], as.factor)

    return(rf_steps2)
}
