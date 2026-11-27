
MakeCONUSgrid <- function(lcd, wb, contus){

    #2. Get coordinates (easting, northing) sequences for grid over u.s., 100km res
    #easting sequence:
    #get minx, round down to nearest 100,000
    minx <- floor((ext(contus)[1]/100000))*100000
    #get maxx, round up to nearest 100,000
    maxx <- ceiling((ext(contus)[2]/100000))*100000
    #get miny, round down to nearest 100,000
    miny <- floor((ext(contus)[3]/100000))*100000
    #get maxy, round up to nearest 100,000
    maxy <- ceiling((ext(contus)[4]/100000))*100000

    #get sequences for starting coords
    e_seq <- seq(from=minx, to=(maxx-100000), by=100000)
    n_seq <- seq(from=miny, to=(maxy-100000), by=100000)

    #calc grid dimensions
    ncells <- length(e_seq)*length(n_seq)
    len_x <- length(e_seq)
    len_y <- length(n_seq)

    #Make grid of cells
    grid <- matrix(nrow=ncells, ncol=11)
    #cell numbers
    grid[, 1] <- 1:ncells
    #Bottom left X coordinate of each cell
    grid[, 2] <- rep(seq(from=minx, to=(maxx-100000), by=100000), times=len_y)
    #Bottom left Y coordinate of each cell
    grid[, 3] <- rep(seq(from=miny, to=(maxy-100000), by=100000), each=len_x)
    #Bottom right X coordinate of each cell
    grid[, 4] <- rep(seq(from=minx+100000, to=maxx, by=100000), times=len_y)
    #Bottom right Y coordinate of each cell
    grid[, 5] <- rep(seq(from=miny, to=(maxy-100000), by=100000), each=len_x)
    #Top left X coordinate of each cell
    grid[, 6] <- rep(seq(from=minx, to=(maxx-100000), by=100000), times=len_y)
    #Top left Y coordinate of each cell
    grid[, 7] <- rep(seq(from=(miny+100000), to=maxy, by=100000), each=len_x)
    #Top right X coordinate of each cell
    grid[, 8] <- rep(seq(from=minx+100000, to=maxx, by=100000), times=len_y)
    #Top right Y coordinate of each cell
    grid[, 9] <- rep(seq(from=(miny+100000), to=maxy, by=100000), each=len_x)
    #Center X coordinate of each cell
    grid[, 10] <- rep(seq(from=(minx+(100000/2)), to=(maxx-(100000/2)), by=100000), times=len_y)
    #Center Y coordinate of each cell
    grid[, 11] <- rep(seq(from=(miny+(100000/2)), to=(maxy-(100000/2)), by=100000), each=len_x)

#     easy.grid <- st_make_grid(st_bbox(lcd), cellsize=c(100000,100000), square=TRUE, crs=5070)
    #set colnames for grid
    colnames(grid) <- c("cell", "ll.x", "ll.y", "lr.x", "lr.y", "tl.x", "tl.y", "tr.x", "tr.y", "cx", "cy")

    library(data.table)
    # create grid for landscape tiles
    dtgrid <- data.table(grid)
    ltgrid <- melt(dtgrid, id.vars='cell', measure.vars=measure(pt, value.name, sep='.'))
    ltgridc <- melt(dtgrid, id.vars='cell', measure.vars=measure(pt, value.name, sep='c'))[,pt:='c'][,ell:=NULL]
    ltgrid <- rbind(ltgrid, ltgridc)
    # polygons of landscape tile borders based on grids
    all.box <- vect(lapply(seq(nrow(grid)), function(i) as.polygons(ext(c(grid[i,2], grid[i,4], grid[i,3], grid[i,7])))), crs='EPSG:5070')
    # set ID names
    values(all.box) <- data.frame(ID=seq(nrow(grid)))
    # intersection with pig range (wb) and contiguous US (contus)
    all.box$wb_intersect <- relate(all.box, vect(wb), 'intersects')
    all.box$contus_intersect <- relate(all.box, terra::aggregate(vect(contus)), 'intersects')

    # calculate area and proportion of coverage of each tile for pig zone and contiguous US
    wb_pts <- intersect(all.box, vect(wb))
    wb_pts$wb_area <- expanse(wb_pts)
    wb_pts$wb_prop <- pmin(1, wb_pts$wb_area/100000^2)
    contus_pts <- intersect(all.box, terra::aggregate(vect(contus)))
    contus_pts$contus_area <- expanse(contus_pts)
    contus_pts$contus_prop <- pmin(1, contus_pts$contus_area/100000^2)

    # connect up intersections, areas, proportions and fill in na values from merges
    all.wb <- merge(all.box, wb_pts, by=c('ID','wb_intersect','contus_intersect'), all=TRUE)
    all.box <- merge(all.wb[,c(1,2,5,6,7)], contus_pts, all=TRUE)
    all.box$wb_intersect[is.na(all.box$wb_intersect)] <- FALSE
    all.box$wb_area[is.na(all.box$wb_area)] <- 0
    all.box$wb_prop[is.na(all.box$wb_prop)] <- 0
    all.box$contus_intersect[is.na(all.box$contus_intersect)] <- FALSE
    all.box$contus_area[is.na(all.box$contus_area)] <- 0
    all.box$contus_prop[is.na(all.box$contus_prop)] <- 0

    # get rid of tiles that don't have contus land in them
#     all.box <- all.box[all.box$contus_intersect == TRUE]
    all.box <- all.box[all.box$contus_intersect == TRUE & all.box$wb_intersect == TRUE,]

    # filter out tiles that don't have enough pig coverage or enough land in the continental US
    all.box$wb_inside <- 0
    all.box$wb_inside[all.box$wb_prop >= 0.10 & all.box$contus_prop >= 0.95] <- 1
    all.box$wb_edge <- 0
    all.box$wb_edge[all.box$wb_prop >= 0.01 & all.box$contus_prop < 0.95] <- 1

#     return(all.box)
    # put it in a format that plays nice(r) with targets
    return(st_cast(st_as_sf(all.box), 'MULTIPOLYGON'))
}
