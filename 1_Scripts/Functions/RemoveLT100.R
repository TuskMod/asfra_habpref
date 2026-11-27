
#Remove Tau with NA, and save readout
Removelt100 <- function(Tau){
    library(data.table)
    Tau.unit <- lapply(Tau, rownames, do.NULL=FALSE)
    Tau <- as.data.table(matrix(unlist(Tau), ncol=4, byrow=TRUE))
    Tau <- cbind(unlist(Tau.unit), Tau)
    setnames(Tau, c('units','low','est','high','ids'))
    Tau_out <- Tau[complete.cases(Tau),]
    return(Tau_out)
}
