
Resample_Tau <- function(Tau.c, geo5){
    #Set up data set for steps
    steps <- geo5

    #convert to dataframe
    tau <- Tau.c

    #get matching IDs
    tau$ID <- paste(tau$animalid, tau$cluster, sep="_")
    steps$ID <- paste(steps$animalid, steps$state_ordered, sep="_")

    #verify that all matching
    all(tau$ID %in% steps$ID)

    #get all unique IDs
    IDs <- unique(tau$ID)
    IDs <- IDs[IDs %in% steps$ID]

    #Loop through unique IDs
    for(i in 1:length(IDs)) {

        #get subset of geolocs for pig i
        dat_1 <- subset(steps, ID==IDs[[i]][1])

        #convert to amt track format
        tr1 <- amt::make_track(dat_1, x, y, datetime, id=ID, all_cols=TRUE)

        #pull Tau to determine resampling interval needed
        tau.i <- tau$est[tau$ID==IDs[i]]

        #convert to hours from current day units
        tau.i <- ceiling(tau.i * 24)

        #set minimum lower boundary to ensure points are IID
        tau.i <- max(tau.i, 24)

        #get tolerance, based on tau.i
        tol <- ceiling(tau.i/6) #using this because original set was 6 hrs with 1 hour tolerance, therefore 1/6

        #resample to tau.i intervals to match all tracks to same sampling rate
        library(amt)
        tr1 <- tr1 %>% track_resample(rate = hours(tau.i), tolerance = hours(tol))

        if(i==1){
            full <- tr1
        } else{
            full <- rbind(full,tr1)
        }

    } #end for loop through animalids

    #Use this to remove those with less than 10 steps after resampling
    rs.summary <- full %>% #was AllFull
        dplyr::group_by(ID) %>%
        dplyr::summarise(n=n()) %>%
        as.data.frame()

    #remove animalids with less than 10 resampled locations
    idslt10 <- rs.summary[rs.summary$n<10,]$ID

    #remove ids with <10 steps
    steps_resampled <- full[!(full$ID %in% idslt10),]

    return(steps_resampled)
}
