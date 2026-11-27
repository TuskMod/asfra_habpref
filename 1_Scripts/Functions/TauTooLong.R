
#Get Tau > 7 days
Tau_toolong <- function(Tau2){
    Tau2 <- formatTau(Tau2)
    Tau_out <- Tau2[Tau2[,3]>7,]
    return(Tau_out[,5])
}
