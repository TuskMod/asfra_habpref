## Kept here after splitting into separate files to preserve structure between functions
# Format_Geo <- function(geo){
#     geo <- read.csv(geo)
#     geosf <- st_as_sf(geo, coords=c("longitude", "latitude"), crs=st_crs(4326))
#     geosf <- st_transform(geosf, crs=st_crs(5070)) #9822 or 5070?
#     geo$x <- st_coordinates(geosf)[,1]
#     geo$y <- st_coordinates(geosf)[,2]
#     geo$datetime <- as.POSIXct(geo$datetime, "%Y-%m-%d %H:%M:%S", tz="UTC")
#     return(geo)
# }
#
# formatWB <- function(wb_path, mast){
#     #remotes::install_github("hrbrmstr/mactheknife")
#     wb <- st_read(wb_path)
#     wb <- st_transform(wb, crs=st_crs(mast))
#     return(wb)
# }
#
# readRaster <- function(lcd_alias){
#     #remotes::install_github("hrbrmstr/mactheknife")
#     lcd <- raster::raster(lcd_alias)
#     lcd <- terra::rast(lcd)
#     return(lcd)
# }
#
# readSHP <- function(shp_path){
#     #remotes::install_github("hrbrmstr/mactheknife")
#     shp <- sf::st_read(shp_path)
#     shp <- st_transform(shp, crs=st_crs(5070))
#     return(shp)
# }
#
# ProjectLCD <- function(lcd_original){
#     if (crs(lcd_original) != 5070) lcd_original <- rast(raster::projectRaster(raster(lcd_original), res=500, crs='epsg:5070', method='ngb'))
# #     if (crs(lcd_original) != 5070) lcd_original <- terra::project(lcd_original, 'epsg:5070', method='near', threads=TRUE)
#     return(lcd_original)
# }
#
# RecodeLandClass <- function(lcd_original){
#     ## some of these classes are only for Alaska, and are defunct?
#     ## should classify to 52 because that is what is used.
#     rcl <- matrix(nrow=20, ncol=2)
#     rcl[, 1] <- c(11, 12,          # open water, perennial ice/snow
#                 21, 22, 23, 24,    # developed open (single family housing, golf courses, etc.), low, medium and high intensity
#                 31,                # barren rock, sand, clay
#                 41, 42, 43,        # deciduous, evergreen, and mixed forest
#                 51, 52,            # shrub (52), what is 51?? ### If you reclass to 51, it would be a blank land cover type?? maybe dwarf scrub but that's alaska only...???
#                 71, 72, 73, 74,    # grassland (71), but 72:74?? 72: sedge/herbaceous (alaska only); 73: lichens (alaska only); 74: moss (alaska only)
#                 81, 82,            # pasture, crops
#                 90, 95)            # woody wetlands, emergent herbaceous wetlands
#     rcl[, 2] <- c(11, 11,          # -> water
#                 21, 21, 21, 21,    # -> developed
#                 31,                # -> barren
#                 41, 41, 41,        # -> forest
# #                 51, 51,            # -> alaska dwarf scrub
#                 52, 52,            # -> shrub/scrub
#                 71, 71, 71, 71,    # -> grassland
#                 81, 81,            # -> pasture/cultivated
#                 90, 95)            # no change
#     lcd <- terra::classify(lcd_original, rcl)
#     return(lcd)
# }
#
# CheckAllGeo <- function(wb, wbr_lcd, lcd, tc, mast, geo2, rd1, rd2, rd3){
#
#     CRS_check_list <- vector(mode="list", length=16)
#     browser()
#     CRS_check_list[[1]] <- compareCRS(st_crs(5070), st_crs(wb))
#     CRS_check_list[[2]] <- compareCRS(st_crs(5070), st_crs(tc))
#     CRS_check_list[[3]] <- compareCRS(st_crs(5070), st_crs(wbr_lcd))
#     CRS_check_list[[4]] <- compareCRS(st_crs(5070), st_crs(lcd))
#     CRS_check_list[[5]] <- compareCRS(st_crs(5070), st_crs(mast))
#     CRS_check_list[[6]] <- compareCRS(st_crs(5070), st_crs(rd1))
#     CRS_check_list[[7]] <- compareCRS(st_crs(5070), st_crs(rd2))
#     CRS_check_list[[8]] <- compareCRS(st_crs(5070), st_crs(rd3))
#
#     #Not all true
#     CRS_check_list[[9]]  <- compareCRS(st_crs(5070)$proj4string, st_crs(wb)$proj4string)
#     CRS_check_list[[10]] <- compareCRS(st_crs(5070)$proj4string, st_crs(tc)$proj4string)
#     CRS_check_list[[11]] <- compareCRS(st_crs(5070)$proj4string, st_crs(wbr_lcd)$proj4string)
#     CRS_check_list[[12]] <- compareCRS(st_crs(5070)$proj4string, st_crs(lcd)$proj4string)
#     CRS_check_list[[13]] <- compareCRS(st_crs(5070)$proj4string, st_crs(mast)$proj4string)
#     CRS_check_list[[14]] <- compareCRS(st_crs(5070)$proj4string, st_crs(rd1)$proj4string)
#     CRS_check_list[[15]] <- compareCRS(st_crs(5070)$proj4string, st_crs(rd2)$proj4string)
#     CRS_check_list[[16]] <- compareCRS(st_crs(5070)$proj4string, st_crs(rd3)$proj4string)
#
#     if(!all(CRS_check_list)){stop("non-matching CRS! double check rasters")}
#
#     CRS_check_status <- all(CRS_check_list)
#     return(CRS_check_status)
# }
#
# ## {source('./1_Scripts/Functions/Functions.R'); MakeCONUSgrid(tar_read(lcd), tar_read(wbr_lcd2))}
# MakeCONUSgrid <- function(lcd, wb){
#
#     #2. Get coordinates (easting, northing) sequences for grid over u.s., 100km res
#     #easting sequence:
#     #get minx, round down to nearest 100,000
#     minx <- floor((ext(wb)[1]/100000))*100000
#     #get maxx, round up to nearest 100,000
#     maxx <- ceiling((ext(wb)[2]/100000))*100000
#     #get miny, round down to nearest 100,000
#     miny <- floor((ext(wb)[3]/100000))*100000
#     #get maxy, round up to nearest 100,000
#     maxy <- ceiling((ext(wb)[4]/100000))*100000
#
#     #get sequences for starting coords
#     e_seq <- seq(from=minx, to=(maxx-100000), by=100000)
#     n_seq <- seq(from=miny, to=(maxy-100000), by=100000)
#
#     #calc grid dimensions
#     ncells <- length(e_seq)*length(n_seq)
#     len_x <- length(e_seq)
#     len_y <- length(n_seq)
#
#     #Make grid of cells
#     grid <- matrix(nrow=ncells, ncol=11)
#     #cell numbers
#     grid[, 1] <- 1:ncells
#     #Bottom left X coordinate of each cell
#     grid[, 2] <- rep(seq(from=minx, to=(maxx-100000), by=100000), times=len_y)
#     #Bottom left Y coordinate of each cell
#     grid[, 3] <- rep(seq(from=miny, to=(maxy-100000), by=100000), each=len_x)
#     #Bottom right X coordinate of each cell
#     grid[, 4] <- rep(seq(from=minx+100000, to=maxx, by=100000), times=len_y)
#     #Bottom right Y coordinate of each cell
#     grid[, 5] <- rep(seq(from=miny, to=(maxy-100000), by=100000), each=len_x)
#     #Top left X coordinate of each cell
#     grid[, 6] <- rep(seq(from=minx, to=(maxx-100000), by=100000), times=len_y)
#     #Top left Y coordinate of each cell
#     grid[, 7] <- rep(seq(from=(miny+100000), to=maxy, by=100000), each=len_x)
#     #Top right X coordinate of each cell
#     grid[, 8] <- rep(seq(from=minx+100000, to=maxx, by=100000), times=len_y)
#     #Top right Y coordinate of each cell
#     grid[, 9] <- rep(seq(from=(miny+100000), to=maxy, by=100000), each=len_x)
#     #Center X coordinate of each cell
#     grid[, 10] <- rep(seq(from=(minx+(100000/2)), to=(maxx-(100000/2)), by=100000), times=len_y)
#     #Center Y coordinate of each cell
#     grid[, 11] <- rep(seq(from=(miny+(100000/2)), to=(maxy-(100000/2)), by=100000), each=len_x)
#
# #     easy.grid <- st_make_grid(st_bbox(lcd), cellsize=c(100000,100000), square=TRUE, crs=5070)
#     #set colnames for grid
#     colnames(grid) <- c("cell", "ll.x", "ll.y", "lr.x", "lr.y", "tl.x", "tl.y", "tr.x", "tr.y", "cx", "cy")
#
#     ## now it only has to check cells that have corners/centers that intersect with the land cover dataset
#     library(data.table)
#     dtgrid <- data.table(grid)
#     ltgrid <- melt(dtgrid, id.vars='cell', measure.vars=measure(pt, value.name, sep='.'))[,ext.val:=NULL]
#     ltgridc <- melt(dtgrid, id.vars='cell', measure.vars=measure(pt, value.name, sep='c'))[,pt:='c'][,ell:=NULL]
#     ltgrid <- rbind(ltgrid, ltgridc)
#     all.pts <- st_as_sf(ltgrid, coords=c('x','y'))
#     all.box <- lapply(seq(nrow(grid)), function(i) extent(c(grid[i,2], grid[i,4], grid[i,3], grid[i,7])))
#
#     # assuming those with all 4 corners in pig territory have enough to keep them in
#     intersect.cells <- ltgrid[,ext.val := raster::extract(raster(wb), all.pts)][!is.na(ext.val),]
#     intersect.cells.congus <- ltgrid[,ext.val := raster::extract(raster(lcd), all.pts)][!is.na(ext.val),]
#     grid.in <- grid[grid[,1] %in% unique(intersect.cells[, .N, by=cell][N == 5, cell]),]
#     # if not all 4 corners are in pig zones, test them like before
#     questionable.cells <- intersect.cells[,.N, by=cell][N < 5, cell]
#     grid.test <- grid[grid[,1] %in% unique(questionable.cells),]
#
# #     untested.wb <- lapply(all.box[-c(intersect.cells[,cell], questionable.cells)], function(x) mask(wb, ext(x)))
# #     lapply(all.box[-intersect.cells[,cell]], function(i) relate(i, , 'intersects'))
#     doubtful.cells <- seq(all.box)[seq(all.box) %in% intersect.cells.congus[,cell] & (seq(all.box) %in% c(intersect.cells[,cell], questionable.cells) == FALSE)]
# #     doubtful.cells.tf <- lapply(all.box[doubtful.cells], function(x) intersect(wb, x))
#     doubtful.cells.tf <- unlist(lapply(all.box[doubtful.cells], function(x) any(!is.na(extract(wb, ext(x))))))
#     doubtful.test <- doubtful.cells[which(doubtful.cells.tf == TRUE)]
#     grid.doubt <- grid[grid[,1] %in% doubtful.test,]
#
#     print("Made CONUS grid template")
#
#     #Loop through all cells
#     #Find cells that overlap completely with wp distribution
#
#     #needs overlap 95% with continent at all (i.e., not hanging half off coastline)
#     #minimum 10% overlap with wp distribution
# #     lckeep <- data.frame(id = seq(nrow(grid)), inside = NA, edge = NA)#, out = NA)
#     # build the output df with answers included, but will be updated for <=3 corner intersects
#     lckeep <- data.frame(id=grid.in[,1], inside = 1, edge=NA)
#     lckeep <- rbind(lckeep, data.frame(id=c(grid.test[,1], grid.doubt[,1]), inside=NA, edge=1))
#
#     for(i in 1:nrow(grid.test)){
#         print(paste0("checking ", i, " of ", nrow(grid.test)))
#
#         #get extent/bbox from grid cell coords
#         bound <- extent(c(grid.test[i,2], grid.test[i,4], grid.test[i,3], grid.test[i,7]))
#
#         #crop nlcd by that extent
# #         cell_lc_cropped <- crop(wb, bound)
#         # faster way to check on raster values
#         # by default, cellsFromExtent doesn't include NA cells
#         wb.cells <- wb[cellsFromExtent(wb, bound)]
#         count.in.bound.wb <- length(unlist(wb.cells)[!is.na(unlist(wb.cells))])#/(100000^2)
#         contus.cells <- lcd[cellsFromExtent(lcd, bound)]
#         count.in.bound.contus <- length(unlist(contus.cells)[!is.na(unlist(contus.cells))])#/(100000^2)
# #         browser()
#
#         #convert 0's to NA
# #         cell_lc_full[cell_lc_full==0] <- NA
#
#         #get proportion of overlap with full lc
# #         conus_isNA <- length(which(is.na(values(cell_lc_full))))
# #         conus_overlap <- length(which(!is.na(values(cell_lc_full))))
# #         conus_propNA <- conus_isNA/(conus_isNA + conus_overlap)
#
#         #get proportion of overlap with wb distrib
# #         wpd_isNA <- length(which(is.na(values(cell_lc_cropped))))
# #         wpd_overlap <- length(which(!is.na(values(cell_lc_cropped))))
# #         wpd_propNA <- wpd_isNA/(wpd_isNA + wpd_overlap)
# #         wpd_propNA <- sum(is.nan(as.matrix(cell_lc_cropped)[,1]))/length(as.matrix(cell_lc_cropped)[,1])
#         # looking for proportion of pig territory in the available land
# #         wpd_propNA <- count.in.bound.wb/count.in.bound.contus
#         wpd_propNA <- count.in.bound.wb/(100000^2)
#         print(wpd_propNA)
#
#         #if conus overlap is at least 95% (conus_propNA < 0.05)
#         #if wp distrib is at least 10% overlap (wpd_propNA < 0.9)
# #         if(conus_propNA <= 0.05 & wpd_propNA <= 0.90){
#         # first check if wild pigs are at least 99% covering the available land
#         if(wpd_propNA >= 0.01){
# #         if(wpd_propNA <= 0.99){
# #             count.in.bound.conus <- length(cellsFromExtent(wb, bound))
# #             cell_lc_full <- crop(lcd, bound)
# #             conus_propNA <- sum(is.nan(as.matrix(cell_lc_full)[,1]))/length(as.matrix(cell_lc_full)[,1])
#             conus_propNA <- count.in.bound.contus/(100000^2)
#             # if the available land is covering at least 95% of the cell, can be used for simulations
#             if (conus_propNA >= 0.95 & wpd_propNA >= 0.10){
#                 lckeep.i <- 1
#     #             lckeep.i <- grid[i, 1]
#                 lcedge.i <- NA
# #             lcout.i <- NA
#             } else {
#                 # otherwise, just keep for later modeling for the national map
#                 lckeep.i <- NA
#                 lcedge.i <- 1
#             }
# #         } else if (wpd_propNA <= 0.99){
# #         } else if (conus_propNA <= 0.99 & wpd_propNA <= 0.99){
# #             lckeep.i <- NA
# #             lcedge.i <- grid[i, 1]
# #             lcedge.i <- 1
# #             lcout.i <- NA
#         } else {
#             lckeep.i <- NA
#             lcedge.i <- NA
# #             lcout.i <- grid[i, 1]
#         }
#         #add to vector sequentially
#         lckeep$inside[lckeep$id == grid.test[i,1]] <- lckeep.i
#         lckeep$edge[lckeep$id == grid.test[i,1]] <- lcedge.i
# #         lckeep$out[lckeep$id == i] <- lcout.i
# #         if(i==1){
# #             lckeep <- pmin(lckeep.i, lcout.i)
# #         } else {
# #             lckeep <- c(lckeep, lckeep.i)
# #         }
#     }
#     #remove cells that do not overlap at all with wb distrib
# #     browser()
#     lckeep_containswb <- lckeep[!is.na(rowSums(lckeep[,2:3], na.rm=TRUE)),1]
# #     lckeep_containswb <- lckeep[!is.na(lckeep)]
#     #reduce grid to only cells fully overlapping wild pig distribution
#     grid2 <- grid[grid[,1] %in% lckeep_containswb,]
#     grid2 <- grid2[order(grid2[,1]),]
#     lckeep <- lckeep[order(lckeep[,1]),]
#     grid2 <- cbind(grid2, lckeep[,2:3])
#     nrow(grid2)
#
#     return(grid2)
# }
#
#
# ## {source('./1_Scripts/Functions/Functions.R'); Pull_Lands(tar_read(lcd), tar_read(grid))}
# Pull_Lands <- function(lcd, grid){
#     grid.in <- grid[!is.na(grid$inside),]
#     lands_list <- vector(mode="list", length=nrow(grid.in))
#
#     for(i in 1:nrow(grid.in)){
#         print(paste0("row ", i, " of ", nrow(grid.in)))
#
#         #crop nlcd by extent of grid row i
#         #make sure col indices correct
#         bound <- extent(c(grid.in[i,2], grid.in[i,4], grid.in[i,3], grid.in[i,7]))
#         ras <- terra::crop(lcd,bound)
#
#         #dummy code
#         ras <- raster(ras)
#         rasdum <- layerize(ras)
#
#         #Aggregate nlcd to appropriate scale
#         #500 m resolution
#         x <- raster(rasdum)
#         res(x) <- 500
#         rasdum_agg <- raster::resample(rasdum, x, method="bilinear")
#         rasdum_agg <- terra::rast(rasdum_agg)
#         lands_list[[i]] <- rasdum_agg
#     }
#     lands <- terra::sprc(lands_list)
#     names(lands) <- grid.in[,1]
#     return(lands)
# }
#
# Pull_Lands_edge <- function(lcd, grid){
#     grid.in <- grid[!is.na(grid$edge),]
#     lands_list <- vector(mode="list", length=nrow(grid.in))
#
#     for(i in 1:nrow(grid.in)){
#         print(paste0("row ", i, " of ", nrow(grid.in)))
#
#         #crop nlcd by extent of grid row i
#         #make sure col indices correct
#         bound <- extent(c(grid.in[i,2], grid.in[i,4], grid.in[i,3], grid.in[i,7]))
#         ras <- terra::crop(lcd, bound)
#
#         #dummy code
#         ras <- raster(ras)
#         rasdum <- layerize(ras)
#
#         #Aggregate nlcd to appropriate scale
#         #500 m resolution
#         x <- raster(rasdum)
#         res(x) <- 500
#         rasdum_agg <- raster::resample(rasdum, x, method="bilinear")
#         rasdum_agg <- terra::rast(rasdum_agg)
#         lands_list[[i]] <- rasdum_agg
#     }
#     lands <- terra::sprc(lands_list)
#     names(lands) <- grid.in[,1]
#     return(lands)
# }
#
# drt_proc <- function(drt_q, land, q){
#     ext(land)[1][[1]]
#     drt_ras <- stars::st_rasterize(drt_q)
#     drt_ras <- terra::rast(drt_ras)
#     drt_ras <- drt_ras$DM_DM
#     drt_land <- terra::crop(drt_ras, land)
#     drt_land <- terra::project(drt_land, st_crs(land)$proj4string)
#     terra::ext(drt_land) <- terra::ext(land)
# #     x <- drt_land
# #     res(drt_land) <- res(land)
#     drt_land <- resample(drt_land, land, method='near')
#     #increase drought index by 1 so it doesn't freak out model prediction when there are tons of NA values
#     drt_land <- terra::classify(drt_land, matrix(c(NA,0,1,2,3,4,5,-1,0,1,2,3,4,5), ncol=2, byrow=TRUE))
#     names(drt_land)[1] <- paste0("drt_", q)
#     return(drt_land)
# }
#
# ## {source('./1_Scripts/Functions/Functions.R'); JoinLandEnvCovs(tar_read(lands_sprc_template),tar_read(tc),tar_read(mast),tar_read(rd1),tar_read(rd2),tar_read(rd3),tar_read(drt_q1),tar_read(drt_q2),tar_read(drt_q3),tar_read(drt_q4), tar_read(rgd), tar_read(lcd))}
# ## {source('./1_Scripts/Functions/Functions.R'); JoinLandEnvCovs(tar_read(lands_sprc_template_edge),tar_read(tc),tar_read(mast),tar_read(rd1),tar_read(rd2),tar_read(rd3),tar_read(drt_q1),tar_read(drt_q2),tar_read(drt_q3),tar_read(drt_q4), tar_read(rgd), tar_read(lcd))}
# JoinLandEnvCovs <- function(lands_sprc_template, tc, mast, rd1, rd2, rd3, drt_q1, drt_q2, drt_q3, drt_q4, rgd, lcd){
#     lands <- lands_sprc_template
#
#     #make empty list to repopulate
#     lands_list <- vector(mode="list", length=length(lands))
#     lcd_wgs <- project(lcd, st_crs(4326)$proj4string)
#     #243 and 322 outside daymet coverage,  remove it
#     for(i in 1:length(lands)){
# #         if(i != 243 & i != 322){
#         print(paste0(i, " of ", length(lands)))
#
#         land <- lands[i]
#
#         #make names of rasters more informative
#         names(tc)[1] <- "tc"
#         names(rd1)[1] <- "rd1"
#         names(rd2)[1] <- "rd2"
#         names(rd3)[1] <- "rd3"
#
# #         intersect.data <- lapply(list(mast, tc, rd1, rd2, rd3, vect(drt_q1), vect(drt_q2), vect(drt_q3), vect(drt_q4), rgd), function(d) any(relate(x=d, y=land, relation='intersects')))
#         intersect.data <- lapply(list(mast, tc, rd1, rd2, rd3, rgd), function(d) any(relate(x=d, y=land, relation='intersects')))
#         land_wgs <- project(land, st_crs(4326)$proj4string)
#         xmin <- ext(land_wgs)[1][[1]]
#         xmax <- ext(land_wgs)[2][[1]]
#         ymin <- ext(land_wgs)[3][[1]]
#         ymax <- ext(land_wgs)[4][[1]]
#
#         xmid <- xmin+((xmax-xmin)/2)
#         ymid <- ymin+((ymax-ymin)/2)
#
#         intersect.data2 <- relate(vect(st_union(tile_outlines)), vect(st_point(c(xmid, ymid))), 'contains') # if dayment contains the centerpoint of the tile
#         lc_val <- extract(lcd_wgs, vect(st_point(c(xmid, ymid))))[,2]
#         intersect.data3 <- all(c(!is.na(lc_val), lc_val != 11, lc_val != 12))
#
#         if (all(c(unlist(intersect.data), unlist(intersect.data2), unlist(intersect.data3)))){
#
#             #join lands with mast
#             land_mast <- terra::crop(mast, land)
#             land_mast <- terra::project(land_mast, st_crs(land)$proj4string)
#             terra::ext(land_mast) <- terra::ext(land)
#             x <- land_mast
#             res(x) <- res(land)
#             land_mast <- terra::resample(land_mast, x, method="bilinear")
#             add(land) <- land_mast
#
#             #join lands with tc
#             land_tc <- terra::crop(tc, land)
#             land_tc <- terra::project(land_tc, st_crs(land)$proj4string)
#             terra::ext(land_tc) <- terra::ext(land)
#             x <- land_tc
#             res(x) <- res(land)
#             land_tc <- terra::resample(land_tc, x, method="bilinear")
#             add(land) <- land_tc
#
#             #join lands with rd1
# #             if (relate(rd1, land, 'intersects')[1] == TRUE){
#             land_rd1 <- terra::crop(rd1, land)
#             land_rd1 <- terra::project(land_rd1, st_crs(land)$proj4string)
#             terra::ext(land_rd1) <- terra::ext(land)
#             x <- land_rd1
#             res(x) <- res(land)
#             land_rd1 <- terra::resample(land_rd1, x, method="bilinear")
#             add(land) <- land_rd1
# #             } else {
# #                 add(land) <- rast(extent = ext(land), warn=FALSE)
# #             }
#
#             #join lands with rd2
# #             if (relate(rd2, land, 'intersects')[1] == TRUE){
#             land_rd2 <- terra::crop(rd2, land)
#             land_rd2 <- terra::project(land_rd2, st_crs(land)$proj4string)
#             terra::ext(land_rd2) <- terra::ext(land)
#             x <- land_rd2
#             res(x) <- res(land)
#             land_rd2 <- terra::resample(land_rd2, x, method="bilinear")
#             add(land) <- land_rd2
# #             }
#
#             #join lands with rd3
# #             if (relate(rd3, land, 'intersects')[1] == TRUE){
#             land_rd3 <- terra::crop(rd3, land)
#             land_rd3 <- terra::project(land_rd3, st_crs(land)$proj4string)
#             terra::ext(land_rd3) <- terra::ext(land)
#             x <- land_rd3
#             res(x) <- res(land)
#             land_rd3 <- terra::resample(land_rd3, x, method="bilinear")
#             add(land) <- land_rd3
# #             }
#
#             if (any(relate(vect(drt_q1), land, 'intersects')) == TRUE){
#                 #add drought layers
#                 add(land) <- drt_proc(drt_q1, land, "q1")
#             }
#             if (any(relate(vect(drt_q2), land, 'intersects')) == TRUE){
#                 add(land) <- drt_proc(drt_q2, land, "q2")
#             }
#             if (any(relate(vect(drt_q3), land, 'intersects')) == TRUE){
#                 add(land) <- drt_proc(drt_q3, land, "q3")
#             }
#             if (any(relate(vect(drt_q4), land, 'intersects')) == TRUE){
#                 add(land) <- drt_proc(drt_q4, land, "q4")
#             }
#
#             #join lands with rgd
# #             if (relate(rgd, land, 'intersects')[1] == TRUE){
#             land_rgd <- terra::crop(rgd, land)
#             land_rgd <- terra::project(land_rgd, st_crs(land)$proj4string)
#             terra::ext(land_rgd) <- terra::ext(land)
#             x <- land_rgd
#             res(x) <- res(land)
#             land_rgd <- terra::resample(land_rgd, x, method="bilinear")
#             add(land) <- land_rgd
# #             }
#
#             #get daymetr vals for different quarters
#             #pull all daymetr vals for most recent year
#             #get median tmax,  tmin,  dayl,  prcp for each quarter
#             #add as class attribute to rasters
# #             land_wgs <- project(land, st_crs(4326)$proj4string)
# #             if(any(relate(land_wgs, vect(tile_outlines), 'contains'))){ # tile_outlines comes in the daymet downloader package, it's the extent of the data
#
#             dmdat <- download_daymet(site="land", lat=ymid, lon=xmid, start=2022, end=2022)
#             dat <- dmdat$data
#             or <- as.Date(0, origin = "2022-01-01")
#             dat$dates <- as.Date(dat$yday, origin = "2022-01-01")
#             dat$month <- lubridate::month(dat$dates)
#             dat$season <- NA
#             dat$season[dat$month==1 | dat$month==2 | dat$month==3] <- "q1"
#             dat$season[dat$month==4 | dat$month==5 | dat$month==6] <- "q2"
#             dat$season[dat$month==7 | dat$month==8 | dat$month==9] <- "q3"
#             dat$season[dat$month==10 | dat$month==11 | dat$month==12] <- "q4"
#
#             datmn <- dat %>% dplyr::group_by(season) %>%
#                 dplyr::summarise(dayl=mean(dayl..s.),
#                                 prcp=mean(prcp..mm.day.),
#                                 tmax=mean(tmax..deg.c.),
#                                 tmin=mean(tmin..deg.c.))
#
#             datw <- tidyr::pivot_wider(datmn, names_from=season, values_from=c(2:5))
#
#             for(c in 1:ncol(datw)){
#                 x <- land$mast_5070
#                 values(x) <- datw[, c][[1]]
#                 names(x) <- colnames(datw)[c]
#                 add(land) <- x
# #                 }
#             }
#         }
#
#             lands_list[[i]] <- land
# #         } else{
# #             lands_list[[i]] <- lands[i]
# #         } #if/eslse not 243
#         #add land back to land list
#         #lands_list[[i]]
#     } #for i in lands list
#
#     lands_sprc <- terra::sprc(lands_list)
#     return(lands_sprc)
# }
#
# Convert.Telemetry <- function(geolocs){
#     id.n <- which(colnames(geolocs)=="animalid")
#     id.t <- which(colnames(geolocs)=="datetime")
#     id.lat <- which(colnames(geolocs)=="latitude")
#     id.lon <- which(colnames(geolocs)=="longitude")
#     tk <- geolocs[,c(id.n, id.t, id.lon, id.lat)]
#     colnames(tk) <- c("ID", "timestamp", "longitude", "latitude")
#     crs_str <- st_crs(5070)$proj4string
#     te1 <- ctmm::as.telemetry(tk, projection=crs_str)
#     return(te1)
# }
#
#
# formatTau <- function(tau2){
#     #takes tau as data frame with low, est, high, animalid cols
#     tau2 <- as.data.frame(tau2)
#     #pull tau units
#     tau2$units <- rownames(tau2)
#     tau2$units[grep("minutes", tau2$units)] <- "minutes"
#     tau2$units[grep("hour", tau2$units)] <- "hours"
#     tau2$units[grep("day", tau2$units)] <- "days"
#     tau2$units[grep("month", tau2$units)] <- "month"
#
#     #convert all vals to numeric
#     tau2$low <- as.numeric(tau2$low)
#     tau2$est <- as.numeric(tau2$est)
#     tau2$high <- as.numeric(tau2$high)
#
#     #convert all estimates to days
#     tau2[tau2$units=="minutes", 1:3] <- tau2[tau2$units=="minutes", 1:3]/60/24
#     tau2[tau2$units=="hours", 1:3] <- tau2[tau2$units=="hours", 1:3]/24
#     tau2[tau2$units=="month", 1:3] <- tau2[tau2$units=="month", 1:3]*30
#     tau2$units <- "days"
#
#     return(tau2)
# }
#
#
#
# Determine_Tau <- function(geo){
#     print("entering func")
#     proj.string <- sf::st_crs(5070)$proj4string
#     print("made proj string")
#
#     ids <- unique(geo$animalid)
#     print("entering loop")
#     #96 issues
#     for(p in 1:length(ids)){
#         print(p)
#         pig <- geo[geo$animalid==ids[p],]
#         pig <- pig[order(pig$datetime),]
#         if(nrow(pig) > 100){
#             te1 <- Convert.Telemetry(pig)
#             #SVF <- variogram(te1,fast=TRUE) #do this in separate loop
#             GUESS1 <- ctmm.guess(te1, interactive = FALSE)
#             FIT1_pHREML <- ctmm.select(te1, GUESS1, method = 'pHREML')
#             res <- summary(FIT1_pHREML)$CI
#             if(nrow(res)>1){
#                 Tau.p <- res[2,,drop=FALSE]
#                 Tau.p <- cbind(Tau.p, ids[p])
#             } else {
#                 Tau.p <- matrix(NA, nrow=1, ncol=4)
#             }
#             if(p==1){
#                 Tau <- Tau.p
#             } else {
#                 Tau <- rbind(Tau, Tau.p)
#             }
#         } else {
#             if(p==1){
#                 Tau <- matrix(NA, nrow=1, ncol=4)
#             } else {
#                 Tau.p <- matrix(NA, nrow=1, ncol=4)
#                 Tau <- rbind(Tau, Tau.p)
#             }
#         }
#     }
#     return(Tau)
# } #function closer
#
# #Remove Tau with NA, and save readout
# Removelt100 <- function(Tau){
#     Tau_out <- Tau[complete.cases(Tau),]
#     return(Tau_out)
# }
#
# #Get Tau > 7 days
# Tau_toolong <- function(Tau2){
#     Tau2 <- formatTau(Tau2)
#     Tau_out <- Tau2[Tau2[,2]>7,]
#     return(Tau_out)
# }
#
# Do.Seg <- function(pig, kmax, nclust, lmin){
#     pig$indice <- 1:nrow(pig)
#     pig2 <- pig[, c("indice", "x", "y", "datetime")]
#     colnames(pig2) <- c("indice", "x", "y", "dateTime")
#
#     mode_segclust <- segclust(pig2,
#                             Kmax = kmax, lmin=lmin,
#                             ncluster = nclust,
#                             seg.var = c("x","y"),
#                             scale.variable = FALSE)
#
#     pig3 <- augment(mode_segclust)
#     pig3 <- pig3[,c("indice", "state_ordered")]
#     pig <- left_join(pig, pig3, by="indice")
#
#     return(pig)
# }
#
#
#
# #Make function to output original area ests, cluster ests, cluster combined ests
# DoClustTau <- function(pigseg){
#     clusts <- unique(pigseg$state_ordered)
#     outdf <- data.frame(matrix(nrow=length(clusts), ncol=5))
#     colnames(outdf) <- c("low", "est", "high", "animalid", "cluster")
#
#     outdf$animalid <- pigseg$animalid[1]
#
#     #loop through clusters
#     for(c in 1:length(clusts)){
#         #print(clusts[c])
#         pigseg.clust <- pigseg[pigseg$state_ordered==clusts[c],]
#         pigseg.clust <- pigseg.clust[order(pigseg.clust$datetime),]
#         print("converting telemetry")
#         te1 <- Convert.Telemetry(pigseg.clust)
#
#         print(paste0("fitting ctmm model for cluster ", c, " of ", length(clusts)))
#         GUESS1 <- ctmm.guess(te1, interactive = FALSE)
#         print("did Guess")
#         FIT1_pHREML <- ctmm.select(te1, GUESS1, method = 'pHREML')
#         res <- summary(FIT1_pHREML)$CI
#         if(nrow(res) > 1){
#             Tau.c <- res[2,, drop=FALSE]
#             outdf[c,1:3] <- Tau.c
#         }
#         outdf[c, 5] <- clusts[c]
#     }
#     return(outdf)
# }
#
# doTauSeg <- function(geo, Tau){
#     ids <- Tau[,4]
#     #loop through animalids
#     for(i in 1:length(ids)){
#         print(paste0("pig ", i, " of ", length(ids)))
#         goodclust <- FALSE
#         clustnum <- 1
#         while(goodclust==FALSE){
#             pig <- geo[geo$animalid==ids[i],]
#             clustnum <- clustnum + 1
#             print(paste0("trying ", clustnum, " clusters"))
#
#             #segclust with 2 clusters
#             lmin <- 5
#             kmax <- clustnum
#             pig <- Do.Seg(pig, kmax, clustnum, lmin)
#             tau.pig <- DoClustTau(pig)
#             tau.pig <- formatTau(tau.pig)
#             print(paste0("tau vals in days: ", tau.pig$est))
#
#             #if any tau >7 days
#             if(any(tau.pig$est > 7) & clustnum < 3){
#                 goodclust <- FALSE
#             } else {
#                 goodclust <- TRUE
#                 if(i==1){
#                     tau_rerun <- tau.pig
#                 } else {
#                     tau_rerun <- rbind(tau_rerun, tau.pig)
#                 }
#             }
#         } #while loop close
#     } #for pig in chop close
#     return(tau_rerun)
# }
#
# Geo_Cluster <- function(Tau.r, geo2){
#     #Remove rows with NA
#     Tau.r2 <- Tau.r
#
#     #looks at Tau.r, groups by animalid, asks if any are <7
#     counts <- Tau.r2 %>%
#         dplyr::filter(!is.na(est)) %>%
#         dplyr::group_by(animalid) %>%
#         dplyr::summarise(sum(est<7))
#
#     #remove where all are 7 or NA
#     counts.all7 <- counts[counts$`sum(est < 7)`==0,1] %>% as.data.frame()
#     counts.all7 <- counts.all7$animalid
#
#     #for ids with no clusters <7, set all other ests to NA
#     Tau.r2[Tau.r2$animalid %in% counts.all7, 1:3] <- NA
#
#     #for ids with clusters <7, get number of clusters
#     counts <- counts[counts$`sum(est < 7)`> 0,]
#     c.ids <- counts$animalid
#
#     #get cluster counts
#     Tau.r3 <- Tau.r2[Tau.r2$animalid %in% c.ids,]
#     clustnums <- Tau.r3 %>%
#         dplyr::group_by(animalid) %>%
#         dplyr::summarise(max(cluster))
#
#     #subset geo2 to just remaining in Tau.r without NAs
#     geo.r <- geo2[geo2$animalid %in% c.ids,]
#
#     #loop through remaining geo.r
#     #re-run clustering, with number of clusters indicated by num clusters in Tau.r
#     for(i in 1:length(clustnums$animalid)){
#         print(paste0(i, " of ", length(clustnums$animalid)))
#         id <- clustnums$animalid[i]
#         nclust <- clustnums$`max(cluster)`[i]
#         kmax <- nclust
#         lmin <- 5
#         pig <- geo.r[geo.r$animalid==id,]
#         pigseg <- Do.Seg(pig,kmax,nclust,lmin)
#
#         #only keep clusters with Tau <7 days
#         ts <- Tau.r3[Tau.r3$animalid==id & Tau.r3$est < 7,]
#         keep.clust <- ts$cluster
#         pigseg <- pigseg[pigseg$state_ordered %in% keep.clust,]
#
#         #rbind pigs together with segment id's
#         if(i==1){
#             geo.r.out <- pigseg
#         } else{
#             geo.r.out <- rbind(geo.r.out, pigseg)
#         }
#     }
#
#     #remove indices column
#     geo.r.out <- geo.r.out[,-which(colnames(geo.r.out)=="indice")]
#
#     return(geo.r.out)
# }
#
#
# Trim_Geo <- function(geo2, Tau2, Tau.r){
#     #Tau- original output, all pigs, pigs with NA are lt100
#     #Tau2- all pigs remaining after remove lt100
#     #Tau3- pigs with Tau > 7 days
#     #Tau.r- reclustered pigs, some Tau <7 days
#     #>all these in geo.r already
#
#     #remove IDs already in geo.r
#     TrimIDs.1 <- unique(Tau.r$animalid)
#
#     #remove IDs present in Tau but not in Tau2 (less than 100 pts)
#     allIDs <- unique(geo2$animalid)
#     TrimIDs.2 <- allIDs[!(allIDs %in% Tau2[,4])]
#
#     geo3 <- geo2[!(geo2$animalid %in% TrimIDs.1),]
#     geo3 <- geo2[!(geo2$animalid %in% TrimIDs.2),]
#
#     return(geo3)
# }
#
# Combine_Geo <- function(geo3, geo.r){
#     #Remove IDs which have lt100 pts
#     #test=geo3 %>%
#     #    dplyr::group_by(animalid) %>%
#     #    dplyr::summarise(n=n())
#     geo3$state_ordered <- 1
#     geo4 <- rbind(geo3,geo.r)
#     return(geo4)
# }
#
# Combine_Tau <- function(Tau2, Tau.r, geo4){
#     #Format tau, make data frame
#     Tau2 <- formatTau(Tau2)
#
#     #fix column names
#     colnames(Tau2)[4] <- "animalid"
#
#     #Remove IDs in tau.r
#     Tau2 <- Tau2[!(Tau2$animalid %in% Tau.r$animalid),]
#
#     #add cluster column
#     Tau2$cluster <- 1
#
#     #fix col order to match tau.r
#     Tau2 <- Tau2[,c(1,2,3,4,6,5)]
#
#
#     #looks at Tau.r, groups by animalid, asks if any are <7
#     counts <- Tau.r %>%
#         dplyr::filter(!is.na(est)) %>%
#         dplyr::group_by(animalid) %>%
#         dplyr::summarise(sum(est<7))
#
#     #remove where all are 7 or NA
#     counts.all7 <- counts[counts$`sum(est < 7)`==0,1] %>% as.data.frame()
#     counts.all7 <- counts.all7$animalid
#
#     #for ids with no clusters <7, set all other ests to NA
#     Tau.r[Tau.r$animalid %in% counts.all7, 1:3] <- NA
#
#     #remove NA
#     Tau.r <- Tau.r[complete.cases(Tau.r),]
#
#     #remove clusters with >7 days
#     Tau.r <- Tau.r[Tau.r$est < 7,]
#
#     #bind Taus
#     Tau.c <- rbind(Tau2, Tau.r)
#
#     #verify that all ids match between tau.c and geo
#     #geo.ids=unique(geo4$animalid)
#     #tau.ids=unique(Tau.c$animalid)
#
#     #if(!(all(geo.ids%in%tau.ids))){stop("IDs in geo not in Tau.c")}
#     #if(!(all(tau.ids%in%geo.ids))){stop("IDs in Tau.c not in geo")}
#     #IDs not in tau, in geo means they were removed bc no clusters < 7 days
#     #geo.ids[which(!(geo.ids%in%tau.ids))]
#
#     #only 4 rows.. means that lt100 not trimmed from geo...
#     #nrow(geo4[geo4$animalid=="TXTyW1_95",])
#
#     return(Tau.c)
# }
#
#
# TrimTooLongGeo <- function(geo4, Tau.c){
#     #verify that all ids match between tau.c and geo
#     geo.ids <- unique(geo4$animalid)
#     tau.ids <- unique(Tau.c$animalid)
#
#     if(!(all(geo.ids %in% tau.ids))){
#         toolong.ids <- geo.ids[which(!(geo.ids %in% tau.ids))]
#         geo4 <- geo4[!(geo4$animalid %in% toolong.ids),]
#     } else{
#         geo4 <- geo4
#     }
#
#     #get matching IDs
#     Tau.c$ID <- paste(Tau.c$animalid, Tau.c$cluster, sep="_")
#     geo4$ID <- paste(geo4$animalid, geo4$state_ordered, sep="_")
#
#     #Make new id, match, remove no matching
#     #verify that all matching, stop if not
#     if(!(all(Tau.c$ID %in% geo4$ID))){
#         rem.geo.ids <- unique(geo4$ID)[which(!(unique(geo4$ID) %in% unique(Tau.c$ID)))]
#         geo5 <- geo4[!(geo4$ID %in% rem.geo.ids),]
#     } else {
#         geo5 <- geo4
#     }
#     return(geo5)
# }
#
#
# Resample_Tau <- function(Tau.c, geo5){
#     #Set up data set for steps
#     steps <- geo5
#
#     #convert to dataframe
#     tau <- Tau.c
#
#     #get matching IDs
#     tau$ID <- paste(tau$animalid, tau$cluster, sep="_")
#     steps$ID <- paste(steps$animalid, steps$state_ordered, sep="_")
#
#     #verify that all matching
#     all(tau$ID %in% steps$ID)
#
#     #get all unique IDs
#     IDs <- unique(tau$ID)
#
#     #Loop through unique IDs
#     for(i in 1:length(IDs)) {
#
#         #get subset of geolocs for pig i
#         dat_1 <- subset(steps, ID==IDs[[i]][1])
#
#         #convert to amt track format
#         tr1 <- amt::make_track(dat_1, x, y, datetime, id=ID, all_cols=TRUE)
#
#         #pull Tau to determine resampling interval needed
#         tau.i <- tau$est[tau$ID==IDs[i]]
#
#         #convert to hours from current day units
#         tau.i <- ceiling(tau.i * 24)
#
#         #set minimum lower boundary to ensure points are IID
#         tau.i <- max(tau.i, 24)
#
#         #get tolerance, based on tau.i
#         tol <- ceiling(tau.i/6) #using this because original set was 6 hrs with 1 hour tolerance, therefore 1/6
#
#         #resample to tau.i intervals to match all tracks to same sampling rate
#         tr1 <- tr1 %>% track_resample(rate = hours(tau.i), tolerance = hours(tol))
#
#         if(i==1){
#             full <- tr1
#         } else{
#             full <- rbind(full,tr1)
#         }
#
#     } #end for loop through animalids
#
#     #Use this to remove those with less than 10 steps after resampling
#     rs.summary <- full %>% #was AllFull
#         dplyr::group_by(ID) %>%
#         dplyr::summarise(n=n()) %>%
#         as.data.frame()
#
#     #remove animalids with less than 10 resampled locations
#     idslt10 <- rs.summary[rs.summary$n<10,]$ID
#
#     #remove ids with <10 steps
#     steps_resampled <- full[!(full$ID %in% idslt10),]
#
#     return(steps_resampled)
# }
#
# MakeQuarterly <- function(steps_resampled){
#     qdf <- data.frame(matrix(nrow=4,ncol=3))
#     qdf[1,] <- c(1, 2, 3)
#     qdf[2,] <- c(4, 5, 6)
#     qdf[3,] <- c(7, 8, 9)
#     qdf[4,] <- c(10, 11, 12)
#
#     months <- lubridate::month(steps_resampled$t_)
#     q_vec <- vector(mode="character", length=nrow(steps_resampled))
#
#     q_vec[which(months%in%qdf[1,])] <- "q1"
#     q_vec[which(months%in%qdf[2,])] <- "q2"
#     q_vec[which(months%in%qdf[3,])] <- "q3"
#     q_vec[which(months%in%qdf[4,])] <- "q4"
#
#     steps_resampled$season <- q_vec
#
#     return(steps_resampled)
# }
#
# getConvexHulls <- function(steps_resampled){
#     ids <- unique(steps_resampled$ID)
#     ch_list <- vector(mode="list", length=length(ids))
#     names(ch_list) <- ids
#
#     for(i in 1:length(ids)){
#         pig <- steps_resampled[steps_resampled$ID==ids[i],]
#         pig <- st_as_sf(pig, coords=c("x_", "y_"), crs=st_crs(5070))
#
#         #get convex hull polygon
#         ch <- st_convex_hull(st_union(pig))
#         ch <- ch %>%
#             st_sf %>%
#             st_cast
#         #add buffer, make sure all points inside, none on edge
#         ch <- st_buffer(ch, dist=1000)
#         ch_list[[i]] <- ch
#         #for raster piece, make separate func
#         #may need to use geo targets for this as well
#         #raster::intersect(lcd, poly)
#
#         #if above doesn't work
#         #shapefile_polygons <- as.sf(akde_object, level.UD=0.95, level=0.95)
#         #middle_polygon <- shapefile_polygons[2,]    #selects the second row which is the 95% est middle polygon
#     }
#     return(ch_list)
# }
#
# getCHrasters <- function(ch_list, lcd){
#     ids <- names(ch_list)
#     ch_rasts <- vector(mode="list",length=length(ids))
#     names(ch_rasts) <- ids
#
#     for(i in 1:length(ids)){
#         print(paste0("making raster for id ", i, " of ", length(ids)))
#         ch <- ch_list[[i]]
#         ch <- st_transform(ch, crs=st_crs(lcd))
#         #crop by home range 95% polygon
#         lc <- raster::crop(lcd, ch)
#         lc <- raster::raster(lc)
#         #make dummy coded version
#         lc_dummy <- layerize(lc)
#
#         #do binilear interpolation on lc
#         lc_dummy <- terra::rast(lc_dummy)
#         x <- terra::rast(lc_dummy)
#         res(x) <- 500
#         lcbl <- terra::resample(lc_dummy, x, method="bilinear")
#
#         ch_rasts[[i]] <- lcbl
#     }
#     ch_rasts_sprc <- terra::sprc(ch_rasts)
#     return(ch_rasts_sprc)
# }
#
# GenerateFalseSteps <- function(steps_resampled2, ch_rasts){
#     ids <- unique(steps_resampled2$ID)
#
#     ##FIX
#     PigInfo <- unique(steps_resampled2[,c("study", "animalid", "sex", "age", "state", "ID")])
#
#     for(i in 1:length(ids)){
#         print(paste0("generating false steps for id ", i, " of ", length(ids)))
#
#         #pull raster
#         lcbl <- ch_rasts[i]
#         lcbl <- project(lcbl, st_crs(5070)$proj4string)
#
#         #get ID
#         trp <- steps_resampled2[steps_resampled2$ID==ids[i],]
#         trp <- trp[order(trp$t_),]
#         trp <- amt::mk_track(trp, .x="x_", .y="y_", .t="t_", all_cols=TRUE)
#
#         #get false steps from core MCP, 50%, to be conservative
#         fp <- amt::random_points(trp, n=nrow(trp), level=0.50)
#
#         #remove true
#         fp <- fp[!fp$case_, ]
#
#         #randomly assign random points to different quarters
#         #will make analysis easier later
#         fp$season <- trp$season
#
#         #bind animalid and info to false steps
#         fp$ID <- ids[i]
#
#         #get info back
#         fp <- dplyr::left_join(fp, PigInfo, by="ID")
#
#         #bind with true steps
#         trp_rf <- dplyr::bind_rows(trp, fp)
#
#         #make case TRUE for true steps
#         trp_rf$case_[is.na(trp_rf$case_)] <- TRUE
#
#         trp_rf <- trp_rf %>% amt::extract_covariates(lcbl)
#
#         if(i==1){
#             rf_steps <- trp_rf
#         } else{
#             rf_steps <- dplyr::bind_rows(rf_steps, trp_rf)
#         }
#     }
#     return(rf_steps)
# }#function closing bracket
#
# ## {source('./1_Scripts/Functions/Functions.R'); RanforPreformat(tar_read(rf_steps))}
# RanforPreformat <- function(rf_steps){
#     #rf_steps2<-as.data.frame(rf_steps2)
#     #rf_steps2$case_<-as.factor(rf_steps2$case_)
#     #rf_steps2=rf_steps2[,c(3,5,9:29)]
#     #FIX: rf_steps is supposed to have season going into model
#     #FIX: for rf_steps preformat, remove study and sex
#     rf_steps <- as.data.frame(rf_steps)
#     #lc vals for false steps if NA need be zero
#     rf_steps[,34:42][is.na(rf_steps[,34:42])] <- 0
#
#     #change case to 1/0
#     rf_steps$case_[rf_steps$case_] <- 1
#     rf_steps$case_[!(rf_steps$case_)] <- 0
#
#     #remove cols not needed
#     rf_steps <-
#         rf_steps[,-c(which(colnames(rf_steps)=="study"),
#                     which(colnames(rf_steps)=="sex"),
#                     which(colnames(rf_steps)=="animalid"),
#                     which(colnames(rf_steps)=="state"),
#                     which(colnames(rf_steps)=="burst_"),
#                     which(colnames(rf_steps)=="rd4"),
#                     which(colnames(rf_steps)=="rd5"),
#                     which(colnames(rf_steps)=="lc"),
#                     which(colnames(rf_steps)=="age"),
#                     which(colnames(rf_steps)=="fixType"),
#                     which(colnames(rf_steps)=="DOP"),
#                     which(colnames(rf_steps)=="latitude"),
#                     which(colnames(rf_steps)=="longitude"),
#                     which(colnames(rf_steps)=="tz"),
#                     which(colnames(rf_steps)=="X"),
#                     which(colnames(rf_steps)=="t_"))]
#
#     #Format drought to numeric
#     rf_steps$drt[rf_steps$drt=="D0"] <- "0"
#     rf_steps$drt[rf_steps$drt=="D1"] <- "1"
#     rf_steps$drt[rf_steps$drt=="D2"] <- "2"
#     rf_steps$drt[rf_steps$drt=="D3"] <- "3"
#     rf_steps$drt[rf_steps$drt=="D4"] <- "4"
#     rf_steps$drt[rf_steps$drt=="D5"] <- "5"
#     rf_steps$drt[rf_steps$drt=="None"] <- '-1'
#     rf_steps$drt <- as.numeric(rf_steps$drt)
#
#     #get means of temp vals for each pig
#     rf_steps <- rf_steps %>%
#         dplyr::group_by(ID, season) %>%
#         dplyr::mutate(mtc=mean(tc, na.rm=TRUE),
#                     mprcp=mean(prcp, na.rm=TRUE),
#                     mdrt=mean(drt, na.rm=TRUE),
#                     mtmin=mean(tmin, na.rm=TRUE),
#                     mtmax=mean(tmax, na.rm=TRUE),
#                     mdayl=mean(dayl, na.rm=TRUE),
#                     mmast=mean(mast, na.rm=TRUE),
#                     mrgd=mean(rgd, na.rm=TRUE),
#                     mrd1=mean(rd1, na.rm=TRUE),
#                     mrd2=mean(rd2, na.rm=TRUE),
#                     mrd3=mean(rd3, na.rm=TRUE),)
#
#     #sep cols needed for random forest
#     rf_steps2 <- rf_steps[,c(which(colnames(rf_steps)=="season"):
#                             which(colnames(rf_steps)=="mrd3"))]
#
#     #check that no NAs remaining
#     any(!(complete.cases(rf_steps2)))
#
#     rf_steps2 <- as.data.frame(rf_steps2)
#
#     #set factors
#     factor_cols <- c(which(colnames(rf_steps2)=="season"),
#                     which(colnames(rf_steps2)=="case_"))
#
#     rf_steps2[,factor_cols] <- lapply(rf_steps2[,factor_cols], as.factor)
#
#     return(rf_steps2)
# }
#
# ## {source('./1_Scripts/Functions/Functions.R'); RanforPreformatLC(tar_read(lands_sprc))}
# ## {source('./1_Scripts/Functions/Functions.R'); RanforPreformatLC(tar_read(lands_sprc_edge))}
# RanforPreformatLC <- function(lands_sprc){
#     land.df_list <- vector(mode="list", length=length(lands_sprc))
#     for(i in 1:length(lands_sprc)){
#         print(paste0("formatting ", i, " of ", length(lands_sprc)))
#         land <- lands_sprc[i]
#
#         landf <- as.data.frame(land, cells=TRUE, xy=TRUE)
#         if("mast_5070" %in% colnames(landf)){
#             #reformat colnames
#             if (length(colnames(landf)[grep("_q", colnames(landf))]) > 0){
#                 colnames(landf)[grep("_q", colnames(landf))] <- paste0(stringr::str_sub(colnames(landf)[grep("_q", colnames(landf))], -2), "_", colnames(landf)[grep("_q", colnames(landf))])
#                 stringr::str_sub(colnames(landf)[grep("_q", colnames(landf))], -3) <- ""
#                 #convert to long format
#                 landfl <- landf %>%
#                     tidyr::pivot_longer(
#                         cols=contains("q"),
#                         names_to=c("Var", ".value"),
#                         names_sep="_")
#                 if('drt' %in% names(landfl) == FALSE) landfl$drt <- -1
#                 if(any(is.na(landfl$drt))){
#                     landfl$drt[is.na(landfl$drt)] <- (-1)
#                 }
#             } else {
#                 landfl <- landf
#                 if('drt' %in% names(landfl) == FALSE) landfl$drt <- -1
#             }
# #             landfl$drt[is.na(landfl$drt)] <- (-1)
#             if('drt' %in% names(landfl) == FALSE) landfl$drt <- -1
#
#             #get means for all vars except lc
#             landfl$mmast <- mean(landfl$mast_5070, na.rm=TRUE)
#             landfl$mtc <- mean(landfl$tc, na.rm=TRUE)
#             landfl$mrd1 <- mean(landfl$rd1, na.rm=TRUE)
#             landfl$mrd2 <- mean(landfl$rd2, na.rm=TRUE)
#             landfl$mrd3 <- mean(landfl$rd3, na.rm=TRUE)
#             landfl$mdrt <- mean(landfl$drt, na.rm=TRUE)
#             landfl$mdayl <- mean(landfl$dayl, na.rm=TRUE)
#             landfl$mprcp <- mean(landfl$prcp, na.rm=TRUE)
#             landfl$mtmax <- mean(landfl$tmax, na.rm=TRUE)
#             landfl$mtmin <- mean(landfl$tmin, na.rm=TRUE)
#             landfl$mrgd <- mean(landfl$rgd_5070, na.rm=TRUE)
# #             if ((is.na(landfl$mdrt))) browser()
#             landfl$mdrt[is.na(landfl$mdrt)] <- -1
#
#             #remove unneeded cols
#             landfl <- landfl[-c(which(colnames(landfl)=="mast_5070"),
#                                 which(colnames(landfl)=="rgd_5070"),
#                                 which(colnames(landfl)=="drt"),
#                                 which(colnames(landfl)=="tc"),
#                                 which(colnames(landfl)=="rd1"),
#                                 which(colnames(landfl)=="rd2"),
#                                 which(colnames(landfl)=="rd3"),
#                                 which(colnames(landfl)=="dayl"),
#                                 which(colnames(landfl)=="prcp"),
#                                 which(colnames(landfl)=="tmax"),
#                                 which(colnames(landfl)=="tmin"))]
#
#             land.df_list[[i]] <- landfl
#         } else{
#             land.df_list[[i]] <- NA
#         }
#     }
#
#     land.df_list <- Filter(function(a) any(!is.na(a)), land.df_list)
#
#     return(land.df_list)
#
# }
#
#
# doRanfor <- function(rf_steps2, set){
#     if(set=="full"){
#         df <- rf_steps2
#     } else{
#         df <- rf_steps2[1:set,]
#     }
#
#     tres <- tune(case_ ~ ., data = df)
#     opt <- tres$optimal
#
#     grid <- c(10,20,50,100,200,300,500,1000)
#     errs <- c(0,0,0,0,0,0,0,0)
#     for(g in 1:length(grid)){
#         print(paste0("trying ", grid[g], " trees"))
#         rfsrc_pigs <- rfsrc.fast(case_ ~ ., data = df, ntree=grid[g], importance = TRUE, nodesize=opt[[1]], mtry=opt[[2]], block.size=NULL)
#         errs[g] <- rfsrc_pigs$err.rate[,1][!is.na(rfsrc_pigs$err.rate[,1])]
#     }
#
#     nt <- grid[which(errs==min(errs))]
#
#     rfsrc_pigs <- rfsrc.fast(case_ ~ ., data = df, ntree=nt, importance = TRUE, nodesize=opt[[1]], mtry=opt[[2]], block.size=NULL, forest=TRUE)
#
#     return(rfsrc_pigs)
# }
#
# # PredictLands<-function(land.df_list,rf_model,lands_sprc2){
# #   #land.df_list<-tar_read(land.df_list)
# #   #rf_model<-tar_read(rf_model)
# #   #rf_steps2<-tar_read(rf_steps2)
# #
# #   #colnames(rf_steps2)
# #   #colnames(land)
# #
# #   plands=vector(mode="list",length=length(land.df_list))
# #
# #   for(i in 1:length(land.df_list)){
# #
# #     #get land i
# #     land<-land.df_list[[i]]
# #
# #     #subset needed cols for predict
# #     landp=land[,c(4:22)]
# #
# #     #change colname of season to match rf_steps
# #     colnames(landp)[10]<-"season"
# #
# #     #make data frame
# #     landp<-as.data.frame(landp)
# #
# #     pred=predict(rf_model,land)
# #
# #     #get land for output, to combine with predictions
# #     land<-land.df_list[[i]]
# #     colnames(land)[10]<-"season"
# #
# #     #add predictions for presence to land df
# #     land$predicted=pred$predicted[,1]
# #
# #     #subset out x,y,season,predictions
# #     lq=as.data.frame(lq1[,c(2,3,"q",20)])
# #
# #     #make raster
# #     lq_r=rast(lq,type="xyz")
# #     crs(lq_r)<-crs(lands_sprc2[1])
# #
# #     plands[[i]]=lq_r
# #
# #
# #   }
# #
# #   plands_sprc<-terra::sprc(plands)
# #
# #   return(plands_sprc)
# #
# # }
#
# ## { source('./1_Scripts/Functions/Functions.R'); PredictLands(tar_read(land.df_list), tar_read(rf_model), tar_read(lands_sprc), tar_read(rf_steps2))}
# ## { source('./1_Scripts/Functions/Functions.R'); PredictLands(tar_read(land.df_list_edge), tar_read(rf_model), tar_read(lands_sprc_edge), tar_read(rf_steps2))}
# PredictLands <- function(land.df_list, rf_model, lands_sprc, rf_steps2){
#     #land.df_list<-tar_read(land.df_list)
#     #rf_model<-tar_read(rf_model)
#     #rf_steps2<-tar_read(rf_steps2)
#     #lands_sprc<-tar_read(lands_sprc)
#
#     #colnames(rf_steps2)
#     #colnames(land)
#
#     plands <- vector(mode="list", length=length(land.df_list))
#
#     #i=64
# #     for(i in 1:length(land.df_list)){
#     for(i in 265:266){
#
#         print(paste0("predicting landscape ", i, " of ", length(land.df_list)))
#
#         #get land i
#         landp <- land.df_list[[i]]
#
#         #change colname of season to match rf_steps
#         colnames(landp)[which(colnames(landp)=="Var")] <- "season"
#
#         #subset needed cols for predict
#         landp <- landp[, 4:ncol(landp)]
#
#         #make data frame
#         landp <- as.data.frame(landp)
#         landp$season <- as.factor(landp$season)
#
#         if(length(which(!(colnames(rf_steps2) %in% colnames(landp)))) > 1){
#             cols <- colnames(rf_steps2)[which(!(colnames(rf_steps2) %in% colnames(landp)))]
#             cols <- cols[which(cols != "case_")]
#
#             #add columns missing
#             for(c in 1:length(cols)){
#                 landp$newcol <- 0
#                 colnames(landp)[ncol(landp)] <- cols[c]
#             }
#         }
#
#         browser()
#         pred <- predict(rf_model, landp)
#
#         #get land for output, to combine with predictions
#         land <- land.df_list[[i]]
#         colnames(land)[which(colnames(land)=="Var")] <- "season"
#
#         #add predictions for presence to land df
#         land$predicted <- pred$predicted[,1]
#
#         #subset out x,y,season,predictions
#         lq <- as.data.frame(land[,c(which(colnames(land)=="x"),
#                                     which(colnames(land)=="y"),
#                                     which(colnames(land)=="season"),
#                                     which(colnames(land)=="predicted"))])
#
#         #subset seasons out
#         lq1 <- lq[lq$season=="q1", c(1,2,4)]
#         lq2 <- lq[lq$season=="q2", c(1,2,4)]
#         lq3 <- lq[lq$season=="q3", c(1,2,4)]
#         lq4 <- lq[lq$season=="q4", c(1,2,4)]
#
#         #change colnames
#         colnames(lq1)[3] <- "predq1"
#         colnames(lq2)[3] <- "predq2"
#         colnames(lq3)[3] <- "predq3"
#         colnames(lq4)[3] <- "predq4"
#
#         #make rasters
#         lq1_r <- rast(lq1, type="xyz")
#         crs(lq1_r) <- crs(lands_sprc[1])
#
#         lq2_r <- rast(lq2, type="xyz")
#         crs(lq2_r) <- crs(lands_sprc[1])
#
#         lq3_r <- rast(lq3, type="xyz")
#         crs(lq3_r) <- crs(lands_sprc[1])
#
#         lq4_r <- rast(lq4, type="xyz")
#         crs(lq4_r) <- crs(lands_sprc[1])
#
#         #add other seasons as layers
#         add(lq1_r) <- lq2_r
#         add(lq1_r) <- lq3_r
#         add(lq1_r) <- lq4_r
#
#         plands[[i]] <- lq1_r
#
#     }
#
#     plands_sprc<-terra::sprc(plands)
#
#     return(plands_sprc)
#
# }
#
# SavePredictedLands <- function(plands_sprc, outfile='indiv_plands', namex=''){
#     outdir <- file.path("4_Output", outfile)
#     if(!dir.exists(outdir)){dir.create(outdir)}
#     for(i in 1:length(plands_sprc)){
#         land <- plands_sprc[i]
#         terra::writeRaster(land, file.path(outdir, paste0("pland_", i, namex, ".tif")), overwrite=TRUE)
#     }
#
#     files <- list.files(outdir)
#     if(length(files)==length(plands_sprc)){
#         success <- TRUE
#     } else{
#         success <- FALSE
#     }
#     return(success)
# }
#
