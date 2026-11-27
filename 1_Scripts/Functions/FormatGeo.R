
Format_Geo <- function(geo){
    geo <- read.csv(geo)
    geosf <- st_as_sf(geo, coords=c("longitude", "latitude"), crs=st_crs(4326))
    geosf <- st_transform(geosf, crs=st_crs(5070)) #9822 or 5070?
    geo$x <- st_coordinates(geosf)[,1]
    geo$y <- st_coordinates(geosf)[,2]
    geo$datetime <- as.POSIXct(geo$datetime, "%Y-%m-%d %H:%M:%S", tz="UTC")
    return(geo)
}
