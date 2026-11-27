
Combine_Tau <- function(Tau2, Tau.r, geo4){
    #Format tau, make data frame
    Tau2 <- formatTau(Tau2)

    #fix column names
    colnames(Tau2)[5] <- "animalid"

    #Remove IDs in tau.r
    Tau2 <- Tau2[!(Tau2$animalid %in% Tau.r$animalid),]

    #add cluster column
    Tau2$cluster <- 1

    #looks at Tau.r, groups by animalid, asks if any are <7
    names(Tau.r) <- c('units','low','est','high','animalid','cluster')
    counts <- Tau.r %>%
        dplyr::filter(!is.na(est)) %>%
        dplyr::group_by(animalid) %>%
        dplyr::summarise(sum(est<7))

    #remove where all are 7 or NA
    counts.all7 <- counts[counts$`sum(est < 7)`==0,1] %>% as.data.frame()
    counts.all7 <- counts.all7$animalid

    #for ids with no clusters <7, set all other ests to NA
    Tau.r[Tau.r$animalid %in% counts.all7, 1:3] <- NA

    #remove NA
    Tau.r <- Tau.r[complete.cases(Tau.r),]

    #remove clusters with >7 days
    Tau.r <- Tau.r[Tau.r$est < 7,]

    #bind Taus
    Tau.c <- rbind(Tau2, Tau.r)

    return(Tau.c)
}
