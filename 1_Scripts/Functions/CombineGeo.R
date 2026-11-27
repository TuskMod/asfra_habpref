
Combine_Geo <- function(geo3, geo.r){
    #Remove IDs which have lt100 pts
    #test=geo3 %>%
    #    dplyr::group_by(animalid) %>%
    #    dplyr::summarise(n=n())
    if (nrow(geo3) > 0) {
        geo3$state_ordered <- 1
        geo4 <- rbind(geo3,geo.r)
    } else {
        geo4 <- geo.r
    }
    return(geo4)
}
