
apiUrl <- "http://www.tycho.pitt.edu/api/"
queryUrl <- paste(apiUrl, "query?", sep="")
infoUrl <- paste(apiUrl, "info?", sep="")

# Add the api key to the given url. Optionally specify the format for the returned data (xml, txt, csv)
addApiKey <- function(url, key, format="csv") {
   paste(url, "apikey=", key, ".", format, sep="")
}

# read a list of available data (like diseases, cities and states)
readList <- function (u) {
   url <- paste(apiUrl, u, "?", sep="")
   url <- addApiKey(url, tychoApiKey)
   read.csv(url, stringsAsFactors=FALSE)
}

# build the URL for a query
query <- function (apikey, disease, state, event="cases", loc_type="state", city, start, end, format="csv") {
   if (missing(apikey))
      stop("apikey must be provided!")
   if (missing(disease))
      stop("disease must be provided!")
   if (missing(state))
      stop("state must be provided!")
   if (!(loc_type %in% c("city", "state")))
      stop("loc_type must be either \"city\" or \"state\"")
   if (loc_type=="city" && missing(city))
      stop("A city must be specified when using loc_type=city")
   
   url <- paste(queryUrl, "event=", event, "&loc_type=", loc_type, "&disease=", URLencode(disease),
                "&state=", state, sep="")
   
   if (!missing(city))
      url <- paste(url, "&city=", URLencode(city), sep="")
   
   if (!missing(start))
      url <- paste(url, "&start=", URLencode(start), sep="")
   
   if (!missing(end))
      url <- paste(url, "&end=", URLencode(end), sep="")
   
   url <- paste(url, "&", sep="")
   
   addApiKey(url, apikey, format)
}

# build the URL for an info
info <- function(apikey, loc_type="state", event="cases", state, disease, loc, format="csv") {
   if (missing(apikey))
      stop("apikey must be provided!")
   if (missing(disease) && missing(loc))
      stop("must provide either disease or loc")

   url <- paste(infoUrl, "event=", event, "&loc_type=", loc_type, sep="")
   
   if (!missing(disease))
      url <- paste(url, "&disease=", URLencode(disease), sep="")
   
   if (!missing(state))
      url <- paste(url, "&state=", state, sep="")
   
   if (!missing(loc))
      url <- paste(url, "&loc", loc, sep="")
   
   url <- paste(url, "&", sep="")
   
   addApiKey(url, apikey, format)
}


