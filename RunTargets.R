
#set directories
setwd(this.path::this.dir())
outdir<-file.path("4_Output")

#source targets file
source("_targets.R")

#Get pipeline
# tar_manifest()

#Make pipeline
tar_make()
# tar_make_clustermq(workers=8, reporter='verbose', log_worker=TRUE)
# tar_make(callr_function = NULL, use_crew=FALSE, as_job=FALSE) # for troubleshooting


#Save needed objects to outputs

#Final predicted landscapes, separated tiles as sprc
#plands_sprc<-tar_read(plands_sprc)
#saveRDS(plands_sprc,file.path(outdir,"predlands_sprc.rds"))

#Stitched predicted landscapes, for sharing/visualization






#check that it worked
#predlands=readRDS(file.path(outdir,"predlands_sprc.rds"))










