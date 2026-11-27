
TrimTooLongGeo <- function(geo4, Tau.c){
    #verify that all ids match between tau.c and geo
    geo.ids <- unique(geo4$animalid)
    tau.ids <- unique(Tau.c$animalid)

    if(!(all(geo.ids %in% tau.ids))){
        toolong.ids <- geo.ids[which(!(geo.ids %in% tau.ids))]
        geo4 <- geo4[!(geo4$animalid %in% toolong.ids),]
    } else{
        geo4 <- geo4
    }

    #get matching IDs
    Tau.c$ID <- paste(Tau.c$animalid, Tau.c$cluster, sep="_")
    geo4$ID <- paste(geo4$animalid, geo4$state_ordered, sep="_")

    #Make new id, match, remove no matching
    #verify that all matching, stop if not
    if(!(all(Tau.c$ID %in% geo4$ID))){
        rem.geo.ids <- unique(geo4$ID)[which(!(unique(geo4$ID) %in% unique(Tau.c$ID)))]
        geo5 <- geo4[!(geo4$ID %in% rem.geo.ids),]
    } else {
        geo5 <- geo4
    }
    return(geo5)
}
