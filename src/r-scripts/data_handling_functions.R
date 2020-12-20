# Data handling functions

loadflowdata <- function(track,date){
  data <- read.csv(paste("../results/r-csv-files/", track, 
                         "_results/combined_data_branch_165_", date, ".csv", sep = ""), 
                   header = TRUE)
  data.Q <- read.csv(paste("../results/r-csv-files/", track, 
                           "_results/Qall_165_", date, ".csv", sep = ""), 
                     header = TRUE)
  data$Q <- data.Q$Qall
  return(data)
}