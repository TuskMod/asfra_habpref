
Daymet_Proc <- function(daymetdat, contus, nms){
    outdat <- mean(crop(daymetdat, contus, mask=TRUE))
    names(outdat) <- nms
    return(outdat)
}
