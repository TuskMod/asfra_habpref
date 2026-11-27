
readSHP <- function(shp_path){
    #remotes::install_github("hrbrmstr/mactheknife")
    shp <- sf::st_read(shp_path)
    shp <- st_transform(shp, crs=st_crs(5070))
    return(shp)
}
