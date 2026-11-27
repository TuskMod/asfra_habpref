

Trim_Geo <- function(geo2, Tau2, Tau.r){
    #Tau- original output, all pigs, pigs with NA are lt100
    #Tau2- all pigs remaining after remove lt100
    #Tau3- pigs with Tau > 7 days
    #Tau.r- reclustered pigs, some Tau <7 days
    #>all these in geo.r already

    #remove IDs already in geo.r
    names(Tau.r) <- c('low','est','high','animalid','cluster','units')
    TrimIDs.1 <- unique(Tau.r$animalid)

    #remove IDs present in Tau but not in Tau2 (less than 100 pts)
    allIDs <- unique(geo2$animalid)
    TrimIDs.2 <- allIDs[!(allIDs %in% Tau2[,4])]

    geo3 <- geo2[!(geo2$animalid %in% TrimIDs.1),]
    geo3 <- geo3[!(geo3$animalid %in% TrimIDs.2),]

    return(geo3)
}
