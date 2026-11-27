
#set directories
setwd(this.path::this.dir())
outdir<-file.path("4_Output")

#source targets file
source("_targets.R")

#Make pipeline
tar_make()












