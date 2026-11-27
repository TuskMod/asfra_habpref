
MakeQuarterly <- function(steps_resampled){
#     qdf <- data.frame(matrix(nrow=4,ncol=3))
#     qdf[1,] <- c(1, 2, 3)
#     qdf[2,] <- c(4, 5, 6)
#     qdf[3,] <- c(7, 8, 9)
#     qdf[4,] <- c(10, 11, 12)
#
#     months <- lubridate::month(steps_resampled$t_)
#     q_vec <- vector(mode="character", length=nrow(steps_resampled))
#     browser()
#
#     q_vec[which(months%in%qdf[1,])] <- "q1"
#     q_vec[which(months%in%qdf[2,])] <- "q2"
#     q_vec[which(months%in%qdf[3,])] <- "q3"
#     q_vec[which(months%in%qdf[4,])] <- "q4"

#     steps_resampled$season <- q_vec
    steps_resampled$season <- 'none'

    return(steps_resampled)
}
