
formatWB <- function(wb_path, crs.in = 'EPSG:5070'){
    wb <- st_read(wb_path)
    wb <- st_transform(wb, crs=st_crs(crs.in))
    return(wb)
}
