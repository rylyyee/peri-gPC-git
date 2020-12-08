#################################################################################################################
#################################################################################################################
###
### Velocity profile calculations
###
#################################################################################################################


#### Parameters ####
track <- "branch"   # Options: "racetrack", "branch", "obstacles", "branchandobstacles"
n <- 165

# Parameters that should not change
output <- "Um_profile"
type_base <- "profile"
dt <- 1e-5
print_time <- 10000
sub <- 5		# Number of initial time steps to ignore
d0 <- 0.1		# Diameter of tube
Qall<-matrix(NA,n,1)  # Allocates space

# Loading parameter files
parameters <- read.table(paste("./data/parameters/allpara_", n, ".txt", sep = ""), sep = "\t")
parameter_names <- c("Wo", "CR", "Freq")
colnames(parameters) <- parameter_names

#### Main analysis ####

# Checks for and makes new directory for time series data
dir.create(file.path(paste("./results/r-csv-files/", track, "_results", sep = ""),
                     "time-series/"), showWarnings = FALSE)

for (k in 1:n){
  
  print(paste("Simulation:", k))
	# Gets file list.
	f <- list.files(path=paste("./results/visit/", track, "_runs/sim", k, "/", sep = ""),
	                pattern = output,
	                all.files=FALSE)
	ts<-length(f) # Sets number of time steps based on number of files.
	Qts<-matrix(NA, ts, 2) # allocates space for flow rates
	colnames(Qts) <- c("time", "Q")
	Qts[, 1] <- seq(0,by = dt*print_time, length.out = ts)
	
	for (i in 1:length(f)){
		data <- read.table(paste("./results/visit/", 
		                         track, "_runs/sim", k, "/", f[i], sep = "")) 	# Loads data for time step
		s2 <- dim(data)[1]			# Sets size of data file
		dr <- d0/s2					# Sets distance between data points
		q <- matrix(0, s2 - 1, 1)			# allocates space for individual time step
		for (j in 1:(s2 - 1)){
				A <- 0.5*pi*((d0 - dr*(j - 1)) - (d0 - dr*j)) # calculates concentric circle
				q[j] <- A*data[j, 2]					# calculates volume flow for each circle
		}
		Qts[i,2] <- sum(q)				# sums individual volume flows for time step
	}
	complete<-as.numeric(sum(is.na(Qts)))
	write.table(Qts, file = paste("./results/r-csv-files/", track, "_results/time-series/Qts_profile_", k,
	                                "_", Sys.Date(), ".csv", sep = ""), sep = ",", row.names = FALSE)
	Qall[k] <- mean(Qts[sub:ts])			# Calculates mean across simulation
	rm(Qts)
}

# Sets up Qall in data frame
Qall2 <- data.frame(parameters, Qall)

#### Checking and Saving Data ####
complete<-as.numeric(sum(is.na(Qall2)))
message("~.*^*~Completeness check~*^*~.~\n",
        "Number of NAs: ",complete)
if (complete==0){
  message("Set complete. Saving now!")
  write.table(Qall2, file = paste("./results/r-csv-files/", track, "_results/Qall_", n,
                                  "_", Sys.Date(), ".csv", sep = ""), sep = ",")
} else {
  message("Set not complete, did not save")
}


