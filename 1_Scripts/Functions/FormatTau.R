formatTau <- function(tau2){
    #takes tau as data frame with low, est, high, animalid cols
    tau2 <- as.data.frame(tau2)
    if (ncol(tau2) == 6){
        names(tau2) <- c('units','low','est','high','ids', 'cluster')
    } else {
        names(tau2) <- c('units','low','est','high','ids')
    }
    #pull tau units
#     tau2$units <- rownames(tau2)
    tau2$units[grep("minutes", tau2$units)] <- "minutes"
    tau2$units[grep("hour", tau2$units)] <- "hours"
    tau2$units[grep("day", tau2$units)] <- "days"
    tau2$units[grep("month", tau2$units)] <- "month"

    #convert all vals to numeric
    tau2$low <- as.numeric(tau2$low)
    tau2$est <- as.numeric(tau2$est)
    tau2$high <- as.numeric(tau2$high)

    # clear out NA rows
    tau2 <- tau2[complete.cases(tau2),]

    #convert all estimates to days
    tau2[tau2$units=="minutes", 2:4] <- tau2[tau2$units=="minutes", 2:4]/60/24
    tau2[tau2$units=="hours", 2:4] <- tau2[tau2$units=="hours", 2:4]/24
    tau2[tau2$units=="month", 2:4] <- tau2[tau2$units=="month", 2:4]*30
    tau2$units <- "days"

    return(tau2)
}
