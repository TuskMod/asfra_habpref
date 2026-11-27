
doRanfor <- function(rf_steps2, set){
    if(set=="full"){
        df <- rf_steps2
    } else{
        df <- rf_steps2[1:set,]
    }

    tres <- tune(case_ ~ ., data = df)
    opt <- tres$optimal

    grid <- c(10,20,50,100,200,300,500,1000)
    errs <- c(0,0,0,0,0,0,0,0)
    for(g in 1:length(grid)){
        print(paste0("trying ", grid[g], " trees"))
        rfsrc_pigs <- rfsrc.fast(case_ ~ ., data = df, ntree=grid[g], importance = TRUE, nodesize=opt[[1]], mtry=opt[[2]], block.size=NULL)
        errs[g] <- rfsrc_pigs$err.rate[,1][!is.na(rfsrc_pigs$err.rate[,1])]
    }

    nt <- grid[which(errs==min(errs))]

    rfsrc_pigs <- rfsrc(case_ ~ ., data = df, ntree=nt, importance = TRUE, nodesize=opt[[1]], mtry=opt[[2]], block.size=NULL, forest=TRUE)

    return(rfsrc_pigs)
}
