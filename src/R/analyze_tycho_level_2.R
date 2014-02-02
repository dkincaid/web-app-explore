# Make sure you put your Tycho API key (http://www.tycho.pitt.edu/apikey.php)
# in a file named .tychoapi in your home directory
tychoApiKey <- readLines(paste(Sys.getenv("HOME"), "/.tychoapi", sep=""), 1)

source("tycho.R")

diseases <- readList(tychoApiKey, "diseases")
cities <- readList(tychoApiKey, "cities")
states <- readList(tychoApiKey, "states")

mumps <- diseases[23,1]

# Build a data frame consisting of all the states
if (file.exists("states_cases.Rda")) {
   load("states_cases.Rda")
} else {
   states_cases <- data.frame()
   for (d in diseases$disease) {
      for (s in states$state) {
         print(paste("Reading data for disease", d, "state", s))
         newdf <- read.csv(query(tychoApiKey, disease=d, state=s))
         if (nrow(newdf) > 0) {
            newdf$disease <- d
            states_cases <- rbind(states_cases, newdf)
         }
      }
   }
   
   states_cases$loc <- NULL
   states_cases$loc_type <- NULL
   states_cases$country <- NULL
   states_cases$disease <- as.factor(states_data$disease)
   #states_cases$year <- as.factor(states_data$year)
   #states_cases$week <- as.factor(states_data$week)
   save(states_cases, file="states_cases.Rda")

}

library(ggplot2)

# Subset to Wisconsin Mumps cases and plot
#mumps.wi <- subset(states_cases, disease==mumps & state=="WI")
#p <- ggplot(mumps.wi, aes(x=as.Date(paste("1", week, year, sep="-"), format = "%w-%W-%Y"), y=number)) +
#   geom_bar(stat="identity", width=7) +
#   scale_y_continuous("Cases") +
#   scale_x_date("Week")

#p

di <- c("DIPHTHERIA","WHOOPING COUGH [PERTUSSIS]")

dip <- subset(states_cases, disease %in% di & state %in% c("NY","CA","TX","IL"))

p <- ggplot(dip, aes(x=as.Date(paste("1", week, year, sep="-"), format = "%w-%W-%Y"), y=number)) +
    geom_bar(stat="identity", width=7) +
    scale_y_continuous("Cases", limits=c(0,1500)) +
    scale_x_date("Week") +
    facet_grid(disease ~ state)

p

# Create a matrix of year by state for mumps
library(reshape2)
pertussis.year.by.state <- acast(subset(states_cases, disease=="INFLUENZA"), state ~ year, value.var='number', fun.aggregate=sum)
m <- melt(pertussis.year.by.state)

p <- ggplot(m, aes(x=Var2, y=Var1, fill=value)) +
    geom_tile() +
    scale_colour_brewer()

# Playing with GoogleVis
suppressPackageStartupMessages(library(googleVis))
library(dplyr)

flu.frame <- subset(states_cases, disease=="INFLUENZA")
flu.yearly <- flu.frame %.% group_by(year, state) %.% summarise(cases=sum(number))

flu.1944 <- subset(flu.yearly, year==1944)

flu.chart <- gvisGeoChart(flu.1944, locationvar="state", colorvar="cases", options=list(region="US", displayMode="regions", resolution="provinces"))

plot(flu.chart)
