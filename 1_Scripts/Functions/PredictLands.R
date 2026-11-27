
PredictLands <- function(land.df_list, rf_model, lands_sprc, rf_steps2, lcd){

    #get land
    land <- land.df_list[[1]]

    #subset needed cols for predict
    landp <- land[, 4:ncol(land)]

    #make data frame
    landp <- as.data.frame(landp)

    if(length(which(!(colnames(rf_steps2) %in% colnames(landp)))) > 1){
        cols <- colnames(rf_steps2)[which(!(colnames(rf_steps2) %in% colnames(landp)))]
        cols <- cols[which(cols != "case_")]

        #add missing columns
        for(c in 1:length(cols)){
            landp$newcol <- 0
            colnames(landp)[ncol(landp)] <- cols[c]
        }
    }

    pred <- predict(rf_model, landp, na.action='na.omit')

    #add predictions for presence to land df
    land$predicted <- rep(0, nrow(land))
    land$predicted[complete.cases(land)] <- pred$predicted[,'1']

    #subset out x,y,season,predictions
    lq <- as.data.frame(land[,c(which(colnames(land)=="x"),
                                which(colnames(land)=="y"),
                                which(colnames(land)=="predicted"))])

    lq$predicted[is.na(lq$predicted)] <- 0
    lq <- rast(lq, type='xyz', crs='EPSG:5070')

    return(lq)

}
