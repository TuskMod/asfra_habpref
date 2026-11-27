

#Make function to output original area ests, cluster ests, cluster combined ests
DoClustTau <- function(pigseg){
    library(sf)
    library(ctmm)
    clusts <- unique(pigseg$state_ordered)
    outdf <- data.frame(matrix(nrow=length(clusts), ncol=6))
    colnames(outdf) <- c('units', "low", "est", "high", "animalid", "cluster")
    outdf$animalid <- pigseg$animalid[1]
    #loop through clusters
    for(c in 1:length(clusts)){
        #print(clusts[c])
        pigseg.clust <- pigseg[pigseg$state_ordered==clusts[c],]
        pigseg.clust <- pigseg.clust[order(pigseg.clust$datetime),]
        print("converting telemetry")
        te1 <- Convert.Telemetry(pigseg.clust)
        print(paste0("fitting ctmm model for cluster ", c, " of ", length(clusts)))
        GUESS1 <- ctmm.guess(te1, interactive = FALSE)
        print("did Guess")
        FIT1_pHREML <- ctmm.select(te1, GUESS1, method = 'pHREML')
        res <- summary(FIT1_pHREML)$CI
        if(nrow(res) > 1){
            Tau.c <- res[2,, drop=FALSE]
            outdf[c,1:4] <- c(rownames(Tau.c), Tau.c)
        }
        outdf[c, 6] <- clusts[c]
    }
    return(outdf)
}
