

Determine_Tau <- function(ids, geo){

        pig <- geo[geo$animalid==ids,]
        pig <- pig[order(pig$datetime),]
        if(nrow(pig) > 100){
            te1 <- Convert.Telemetry(pig)
            GUESS1 <- ctmm.guess(te1, interactive = FALSE)
            FIT1_pHREML <- ctmm.select(te1, GUESS1, method = 'pHREML', cores=0)
            res <- summary(FIT1_pHREML)$CI
            if(nrow(res)>1){
                Tau <- res[2,,drop=FALSE]
                Tau <- cbind(Tau, ids)
            } else {
                Tau <- matrix(NA, nrow=1, ncol=4)
            }
        } else {
                Tau <- matrix(NA, nrow=1, ncol=4)
        }
    return(Tau)
} #function closer
