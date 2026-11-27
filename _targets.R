# _targets.R

## SSF stands for step selection function

# Targets setup --------------------
setwd(this.path::this.dir())

#load libraries for targets script
library(targets)
library(tarchetypes)
library(geotargets)
library(clustermq)
library(callr)
library(data.table)

# Set the _targets store so that scripts in subdirectories can access targets
# without using withr::with_dir() (see https://github.com/ropensci/targets/discussions/885)
#
# This hardcodes the absolute path in _targets.yaml,  so to make this more
# portable,  we rewrite it every time this pipeline is run (and we don't track
# _targets.yaml with git)
tar_config_set(
  store = here::here("_targets"),
  script = here::here("_targets.R")
)

# here::here() returns an absolute path, which then gets stored in tar_meta and
# becomes computer-specific (i.e. /Users/andrew/Research/blah/thing.Rmd).
# There's no way to get a relative path directly out of here::here(),  but
# fs::path_rel() works fine with it (see
# https://github.com/r-lib/here/issues/36#issuecomment-530894167)
here_rel <- function(...) {fs::path_rel(here::here(...))}

#Source functions in pipeline
lapply(list.files(file.path("1_Scripts", "Functions"),  full.names = TRUE,  recursive = TRUE),  source)




#Load packages
tar_option_set(packages = c("sf",
                            "udpipe",
                            "dplyr",
                            "lubridate",
                            "tidyr",
                            "tidyverse",
                            "survival",
                            "purrr",
                            "ctmm",
                            "terra",
                            "amt",
                            "raster",
                            "randomForestSRC"),
               ,deployment='worker'
               ,error='stop'
#                ,error='null'
               )

# Pipeline ---------------------------------------------------------

list(

    ## Input raw data files -----
    # gps points
    tar_target(geo,          here_rel("2_Data", "Input", "geolocsnatl.csv"), format="file"),
    # national land cover dataset
    tar_target(lcd_alias,    here_rel('..', 'NND_Lands', 'input', 'Annual_NLCD_LndCov_2021_CU_C1V1', 'Annual_NLCD_LndCov_2021_CU_C1V1.tif'), format="file"),
    # national land cover dataset cropped to feral pig range
#     tar_target(wb_lcd_path,  here_rel("2_Data", "Input", "nlcd_crop_wbdist_c02010_2021.tif"), format="file"),
    # feral pig range vector
    tar_target(wb_path,      here_rel("2_Data", "Input", "merged_conus.shp"), format="file"),
    # tree cover data
    tar_target(tc_path,      here_rel("2_Data", "Input", "tc_5070.tif"), format="file"),
    # masting species data
    tar_target(mast_path,    here_rel("2_Data", "Input", "mast_5070.tif"), format="file"),
    # roads
    tar_target(rd1_path,     here_rel("2_Data", "Input", "final_roads1.tif"), format="file"),
    tar_target(rd2_path,     here_rel("2_Data", "Input", "final_roads2.tif"), format="file"),
    tar_target(rd3_path,     here_rel("2_Data", "Input", "final_roads3.tif"), format="file"),
    # drought
    tar_target(drt_q1_path,  here_rel("2_Data", "Input", "USDM_q1", "USDM_20220104.shp"), format="file"),
    tar_target(drt_q2_path,  here_rel("2_Data", "Input", "USDM_q2", "USDM_20220405.shp"), format="file"),
    tar_target(drt_q3_path,  here_rel("2_Data", "Input", "USDM_q3", "USDM_20220705.shp"), format="file"),
    tar_target(drt_q4_path,  here_rel("2_Data", "Input", "USDM_q4", "USDM_20221004.shp"), format="file"),
    # ruggedness
    tar_target(rgd_path,     here_rel("2_Data", "Input", "rgd_5070.tif"), format="file"),
    # contiguous US borders
    tar_target(contus_path,  here_rel('..','..','Input', 'contus_shp','usmapplot_best.shp'), format='file'),
    # daymet data -- precip, max temp, min temp
    tar_target(dm_prcp_path, here_rel('2_Data', 'Input', 'daymet','daymet_v4_prcp_monttl_na_2022.nc'), format='file'),
    tar_target(dm_tmax_path, here_rel('2_Data', 'Input', 'daymet','daymet_v4_tmax_monavg_na_2022.nc'), format='file'),
    tar_target(dm_tmin_path, here_rel('2_Data', 'Input', 'daymet','daymet_v4_tmin_monavg_na_2022.nc'), format='file'),


  ## Process data -----

    ### Formatting geolocations ------
    #make sf format, format date classes etc.
    tar_target(geo2, Format_Geo(geo)),

    ### Read shapefiles-----
    tar_target(drt_q1, readSHP(drt_q1_path)),
    tar_target(drt_q2, readSHP(drt_q2_path)),
    tar_target(drt_q3, readSHP(drt_q3_path)),
    tar_target(drt_q4, readSHP(drt_q4_path)),
    tar_target(contus, readSHP(contus_path)),

    ### Read and format rasters ------
    tar_terra_rast(lcd_original, readRaster(lcd_alias, methd='mode')),
    tar_terra_rast(lcd,          crop(RecodeLandClass(lcd_original), contus, mask=TRUE)),
#     tar_terra_rast(wbr_lcd,      readRaster(wb_lcd_path, proj.match=lcd)),
    tar_terra_rast(mast,         crop(readRaster(mast_path, proj.match=lcd), contus, mask=TRUE)),
    tar_terra_rast(tc,           crop(readRaster(tc_path, proj.match=lcd), contus, mask=TRUE)),
    tar_terra_rast(rd1,          crop(readRaster(rd1_path, proj.match=lcd, methd='bilinear'), contus, mask=TRUE)),
    tar_terra_rast(rd2,          crop(readRaster(rd2_path, proj.match=lcd, methd='bilinear'), contus, mask=TRUE)),
    tar_terra_rast(rd3,          crop(readRaster(rd3_path, proj.match=lcd, methd='bilinear'), contus, mask=TRUE)),
    tar_terra_rast(rgd,          crop(readRaster(rgd_path, proj.match=lcd, methd='bilinear'), contus, mask=TRUE)),
    tar_terra_rast(dm_prcp,      readRaster(dm_prcp_path, proj.match=lcd, methd='bilinear')),
    tar_terra_rast(prcp,         Daymet_Proc(dm_prcp, contus, 'prcp')),
    tar_terra_rast(dm_tmax,      readRaster(dm_tmax_path, proj.match=lcd, methd='bilinear')),
    tar_terra_rast(tmax,         Daymet_Proc(dm_tmax, contus, 'tmax')),
    tar_terra_rast(dm_tmin,      readRaster(dm_tmin_path, proj.match=lcd, methd='bilinear')),
    tar_terra_rast(tmin,         Daymet_Proc(dm_tmin, contus, 'tmin')),

    ### change seasonal drought data into annual maximum drought
    tar_terra_rast(drt, drt_combine(drt_q1, drt_q2, drt_q3, drt_q4, lcd)),

    ### Formatting WB ------
    ## wb is a vector of pig range
    tar_target(wb, formatWB(wb_path, mast)),

    ### Spatial transform check ------
    tar_target(CRS_check_status, CheckAllGeo(wb, lcd, tc, mast, geo2, rd1, rd2, rd3, rgd, prcp, tmax, tmin)),
    tar_target(write_lcd, writeRaster(lcd, 'lcd_contus_5070_500m.tif', overwrite=TRUE)),
  
    ### Formatting US_Grid ------
    tar_target(grid, MakeCONUSgrid(lcd, wb, contus)),
    tar_target(grid.output, writeVector(vect(grid), 'tile_grid.shp', overwrite=TRUE)),
    tar_target(grid.id, grid$ID),

    ### Connect grids to landscape data
    tar_terra_rast(lands_sprc, JoinLandEnvCovs(grid.id, grid, tc, mast, rd1, rd2, rd3, drt, rgd, lcd, prcp, tmax, tmin),
                   pattern = map(grid.id)),


    ### Tau processing ------
    tar_target(unq.ids, Geo_animalid(geo2)),
    #Determine Tau vals for all pigs.
    #Tau= time for an individual to cross its home range
    #If tau < 7days, can reasonably assume any point in home range is available
    #for sampling false steps to model resource preference
    tar_target(Tau, Determine_Tau(unq.ids, geo2)
               , pattern=map(unq.ids)
               , iteration='list'
               , cue = tar_cue(depend=FALSE, iteration = FALSE, command=FALSE)
               ),

    #remove pigs with fewer than 100 points from Tau df
    #pigs with lt 100 points will be removed from analysis
    tar_target(Tau2, Removelt100(Tau)),

    #Subset tau to pigs that need to be clustered
    #This just removes NAs,  NAs coded in Tau when Tau est <7days
    tar_target(Tau3, Tau_toolong(Tau2)),

    #subset tau to reclustered pigs
    #process tries up to three clusters with segclust2d,  stops at three or when all clusters have Tau<7days
    #remove individuals that do not have at least one cluster where Tau is <7days
    tar_target(Tau.r, doTauSeg(geo2, Tau3),
               pattern=map(Tau3),
               iteration='vector'
#                , cue = tar_cue(depend=FALSE, iteration = FALSE, command=FALSE)
#                , error = 'null'
    ),

    #Uses above process, clusters geolocations and saves/rbinds/outputs
    tar_target(geo.r, Geo_Cluster(Tau.r, geo2)), # recluster pigs with Tau >7 and trim clusters with >7 days

    #Trim IDs with Tau < 7
    tar_target(geo3, Trim_Geo(geo2, Tau2, Tau.r)),

    #combine clustered pigs, with those that didn't need clustering
    tar_target(geo4, Combine_Geo(geo3, geo.r)),

    #combine tau ests for pigs that didn't need to be clustered with those that did
    tar_target(Tau.c, Combine_Tau(Tau2, Tau.r, geo4)),

    #remove IDs which didn't have any clusters <7 days
    tar_target(geo5, TrimTooLongGeo(geo4, Tau.c)),

    ### Resampling -----
    tar_target(steps_resampled, Resample_Tau(Tau.c, geo5)),
    tar_target(steps_resampled2, MakeQuarterly(steps_resampled)),

    ### False steps -----
    tar_target(ch_list, getConvexHulls(steps_resampled2)),
    tar_terra_sprc(ch_rasts, getCHrasters(ch_list, lcd_alias)),
    tar_target(rf_steps, GenerateFalseSteps(steps_resampled2, ch_rasts, ch_list)),

    ## Final preformatting -----
    tar_target(rf_steps2, RanforPreformat(rf_steps)),
    tar_target(land.df_list, RanforPreformatLC(lands_sprc)),

    ## Run analysis -----
    tar_target(rf_model, doRanfor(rf_steps2, "full")),
    tar_target(save_rf_model, saveRDS(rf_model, 'rf_model.rds')),

    ## Predict movement preferences -----
    tar_terra_rast(plands_sprc, PredictLands(land.df_list, rf_model, lands_sprc, rf_steps2, lcd),
                   pattern=map(land.df_list)),

    ## Write rasters in output individually...
    tar_target(success, SavePredictedLands(plands_sprc, grid), cue=tar_cue(mode='always'))
    
)
