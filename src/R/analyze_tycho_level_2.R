# Make sure you put your Tycho API key (http://www.tycho.pitt.edu/apikey.php)
# in a file named .tychoapi in your home directory
tychoApiKey <- readLines(paste(Sys.getenv("HOME"), "/.tychoapi", sep=""), 1)

source("tycho.R")

diseases <- readList("diseases")
cities <- readList("cities")
states <- readList("states")

mumps <- diseases[23,1]

# Build a data frame consisting of all the states
if (file.exists("states.data.Rda"))
   load("states.data.Rda")
else {
   states.data <- data.frame()
   for (d in driseases$disease) {
      for (s in states$state) {
         print(paste("Reading data for disease", d, "state", s))
         newdf <- read.csv(query(disease=d, state=s))
         if (nrow(newdf) > 0) {
            newdf$disease <- d
            states.data <- rbind(states.data, newdf)
         }
      }
   }
   
   states.data$disease <- as.factor(states.data$disease)
   states.data$year <- as.factor(states.data$year)
   states.data$week <- as.factor(states.data$week)
}


# Subset to Wisconsin Mumps cases and plot
mumps.wi <- subset(states.data, disease==mumps & state=="WI")
p <- ggplot(mumps.wi, aes(x=as.Date(paste("1", week, year, sep="-"), format = "%w-%W-%Y"), y=number)) + geom_bar(stat="identity")

p
