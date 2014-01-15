# Make sure you put your Tycho API key (http://www.tycho.pitt.edu/apikey.php)
# in a file named .tychoapi in your home directory
tychoApiKey <- readLines(paste(Sys.getenv("HOME"), "/.tychoapi", sep=""), 1)

source("tycho.R")

diseases <- readList(tychoApiKey, "diseases")
cities <- readList(tychoApiKey, "cities")
states <- readList(tychoApiKey, "states")

mumps <- diseases[23,1]

# Build a data frame consisting of all the states
if (file.exists("states_data.Rda")) {
   load("states_data.Rda")
} else {
   states_data <- data.frame()
   for (d in diseases$disease) {
      for (s in states$state) {
         print(paste("Reading data for disease", d, "state", s))
         newdf <- read.csv(query(tychoApiKey, disease=d, state=s))
         if (nrow(newdf) > 0) {
            newdf$disease <- d
            states_data <- rbind(states_data, newdf)
         }
      }
   }
   
   states_data$loc <- NULL
   states_data$loc_type <- NULL
   states_data$country <- NULL
   states_data$disease <- as.factor(states_data$disease)
   states_data$year <- as.factor(states_data$year)
   states_data$week <- as.factor(states_data$week)
   save(states_data, file="states_data.Rda")
}

library(ggplot2)

# Subset to Wisconsin Mumps cases and plot
mumps.wi <- subset(states_data, disease==mumps & state=="WI")
p <- ggplot(mumps.wi, aes(x=as.Date(paste("1", week, year, sep="-"), format = "%w-%W-%Y"), y=number)) +
   geom_bar(stat="identity", width=7) +
   scale_y_continuous("Cases") +
   scale_x_date("Week")

p
