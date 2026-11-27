

doTauSeg <- function(geo, ids){
        goodclust <- FALSE
        clustnum <- 1
        while(goodclust==FALSE){
            pig <- geo[geo$animalid==ids,]
            clustnum <- clustnum + 1

            #segclust with 2 clusters
            lmin <- 5
            kmax <- clustnum
            pig <- Do.Seg(pig, kmax, clustnum, lmin)
            tau.pig <- DoClustTau(pig)
            tau.pig <- formatTau(tau.pig)

            #if any tau >7 days
            if(any(tau.pig$est > 7) & clustnum < 3){
                goodclust <- FALSE
            } else {
                goodclust <- TRUE
            }
        } #while loop close
#     } #for pig in chop close
    return(tau.pig)
}
