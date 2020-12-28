# Data handling functions

loadflowdata <- function(track,date){
  data <- read.csv(paste("../results/r-csv-files/", track, 
                         "_results/combined_data_",track,"_165_", date, ".csv", sep = ""), 
                   header = TRUE)
  data$delta_P <- data$vena_P_avg-data$aorta_P_avg
  data.Q <- read.csv(paste("../results/r-csv-files/", track, 
                           "_results/Qall_165_", date, ".csv", sep = ""), 
                     header = TRUE)
  data$Q <- data.Q$Qall
  return(data)
}

loadcostdata <- function(track, date){
  data <- read.csv(paste("../results/matlab-csv-files/", track, 
                         "_results/cost_of_transport_165_", date, ".csv", sep = ""),
                   header = FALSE)
  colnames(data) <- c("COT","Work")
  return(data)
}

combinedata <- function(flowdata,costdata) {
  if(is.na(costdata)){ 
    costdata <- data.frame("COT" =rep(NA,dim(flowdata)[1]), 
                           "Work" =rep(NA,dim(flowdata)[1]))}
  data <- cbind(flowdata,costdata)
}

combinetracks <- function(data, tracklist){
  numtracks <- length(tracklist)
  alldata <- data[[1]]
  nsims <- as.numeric(dim(alldata)[1])
  alldata$track <- rep(tracklist[1],nsims)
  for(i in 2:numtracks){
    temp.data <- data[[i]]
    temp.data$track <- rep(tracklist[i],nsims)
    alldata <- rbind(alldata,temp.data)
  }
  alldata$track <- factor(alldata$track, levels = tracklist)
  return(alldata)
}



plot.track <- function(track){
  race.data <- read.table(paste("../data/ibamr-files/", track,
                                "_files/heart_race_512.vertex", sep = ""),
                          skip = 1, header = FALSE)
  colnames(race.data) <- c("x", "y")
  tube.data <- read.table(paste("../data/ibamr-files/", track,
                                "_files/heart_tube_512.vertex", sep = ""),
                          skip = 1, header = FALSE)
  colnames(tube.data) <- c("x", "y")
  alldata <- list("race" = race.data, "tube" = tube.data)
  return(alldata)
}
