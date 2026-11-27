

Geo_Cluster <- function(Tau.r, geo2){
    #Remove rows with NA
    Tau.r2 <- Tau.r
    names(Tau.r2) <- c('units', 'low','est','high','animalid','cluster')

    #looks at Tau.r, groups by animalid, asks if any are <7
    counts <- Tau.r2 %>%
        dplyr::filter(!is.na(est)) %>%
        dplyr::group_by(animalid) %>%
        dplyr::summarise(sum(est<7))

    #remove where all are 7 or NA
    counts.all7 <- counts[counts$`sum(est < 7)`==0,1] %>% as.data.frame()
    counts.all7 <- counts.all7$animalid

    #for ids with no clusters <7, set all other ests to NA
    Tau.r2[Tau.r2$animalid %in% counts.all7, 1:3] <- NA

    #for ids with clusters <7, get number of clusters
    counts <- counts[counts$`sum(est < 7)`> 0,]
    c.ids <- counts$animalid

    #get cluster counts
    Tau.r3 <- Tau.r2[Tau.r2$animalid %in% c.ids,]
    clustnums <- Tau.r3 %>%
        dplyr::group_by(animalid) %>%
        dplyr::summarise(max(cluster))

    #subset geo2 to just remaining in Tau.r without NAs
    geo.r <- geo2[geo2$animalid %in% c.ids,]

    #loop through remaining geo.r
    #re-run clustering, with number of clusters indicated by num clusters in Tau.r
    for(i in 1:length(clustnums$animalid)){
        print(paste0(i, " of ", length(clustnums$animalid)))
        id <- clustnums$animalid[i]
        nclust <- clustnums$`max(cluster)`[i]
        kmax <- nclust
        lmin <- 5
        pig <- geo.r[geo.r$animalid==id,]
        pigseg <- Do.Seg(pig,kmax,nclust,lmin)

        #only keep clusters with Tau <7 days
        ts <- Tau.r3[Tau.r3$animalid==id & Tau.r3$est < 7,]
        keep.clust <- ts$cluster
        pigseg <- pigseg[pigseg$state_ordered %in% keep.clust,]

        #rbind pigs together with segment id's
        if(i==1){
            geo.r.out <- pigseg
        } else{
            geo.r.out <- rbind(geo.r.out, pigseg)
        }
    }

    #remove indices column
    geo.r.out <- geo.r.out[,-which(colnames(geo.r.out)=="indice")]

    return(geo.r.out)
}
