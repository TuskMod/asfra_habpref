
Do.Seg <- function(pig, kmax, nclust, lmin){
    library(segclust2d)
    pig$indice <- 1:nrow(pig)
    pig2 <- pig[, c("indice", "x", "y", "datetime")]
    colnames(pig2) <- c("indice", "x", "y", "dateTime")

    mode_segclust <- try(segclust(pig2, Kmax = kmax, lmin=lmin, ncluster = nclust, seg.var = c("x","y"), scale.variable = FALSE))
    if (attr(mode_segclust, 'class') == 'try-error'){
        ## sometimes if there are too many points in the same-ish location, this gets mad, so try to estimate by taking the first of each of those points?
        library(data.table)
        pig2dt <- data.table(pig2)[,.SD[1], by=.(x,y)]
        mode_segclust <- try(segclust(pig2dt, Kmax = kmax, lmin=lmin, ncluster = nclust, seg.var = c("x","y"), scale.variable = FALSE))
    }

    pig3 <- augment(mode_segclust)
    pig3 <- pig3[,c("indice", "state_ordered")]
    library(dplyr)
    pig <- left_join(pig, pig3, by="indice")
    pig <- pig[!is.na(pig$state_ordered),]

    return(pig)
}
