
seer.home <- paste(Sys.getenv("HOME"), "/data/seer/SEER_1973_2010_TEXTDATA", sep="")
incidence.dir <- paste(seer.home, "/incidence", sep="")
seer9.incidence.dir <- paste(incidence.dir, "/yr1973_2010.seer9", sep="")
sas.file <- readLines(paste(incidence.dir, "/read.seer.research.nov2012.sas", sep=""))

# Read the SAS script to get the field widths and the field names
col.widths <- c()
col.names <- c()
for (line in sas.file) {
   r <- regexpr("[$]char[0-9]+[.]", line)
   
   if (r > 0) {
      fields <- unlist(strsplit(line, " +"))
      #s <- substr(fields[5], r, r+attr(r, "match.length")-1)
      w <- gsub("[$char.]", "", fields[5])
      col.widths <- c(col.widths, as.integer(w))
      col.names <- c(col.names, tolower(fields[4]))
   }
}

library(LaF)

breast.laf <- laf_open_fwf(paste(seer9.incidence.dir, "/BREAST.TXT", sep=""),
                           column_types=rep("string", length(col.widths)),
                           column_widths=col.widths,
                           column_names=col.names)

breast.data <- breast.laf[ , ]




