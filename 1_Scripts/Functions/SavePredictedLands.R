
SavePredictedLands <- function(plands_sprc, grid, outfile='indiv_plands', namex=''){
    outdir <- file.path("4_Output", outfile)
    existing.files <- list.files(outdir)
    if (length(existing.files) > 0) unlink(paste0(outdir, '/*'))
    if(!dir.exists(outdir)){dir.create(outdir)}
    for(i in 1:length(plands_sprc)){
        land <- plands_sprc[i][[1]]
        land.id <- grid$ID[i]
        land.in <- grid$wb_inside[i]
        land.edge <- grid$wb_edge[i]
        terra::writeRaster(land, file.path(outdir, paste0("pland_", land.id, '_', land.in, '_', land.edge, ".tif")), overwrite=TRUE)
    }

    files <- list.files(outdir)
    if(length(files)==length(plands_sprc)){
        success <- TRUE
    } else{
        success <- FALSE
    }
    return(success)
}
