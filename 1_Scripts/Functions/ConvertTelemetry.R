

Convert.Telemetry <- function(geolocs){
    id.n <- which(colnames(geolocs)=="animalid")
    id.t <- which(colnames(geolocs)=="datetime")
    id.lat <- which(colnames(geolocs)=="latitude")
    id.lon <- which(colnames(geolocs)=="longitude")
    tk <- geolocs[,c(id.n, id.t, id.lon, id.lat)]
    colnames(tk) <- c("ID", "timestamp", "longitude", "latitude")
    crs_str <- st_crs(5070)$proj4string
    te1 <- ctmm::as.telemetry(tk, projection=crs_str)
    return(te1)
}
