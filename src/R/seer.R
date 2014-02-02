library(LaF)

seer.home <- paste(Sys.getenv("HOME"), "/data/seer/SEER_1973_2010_TEXTDATA", sep="")
incidence.dir <- paste(seer.home, "/incidence", sep="")
seer9.incidence.dir <- paste(incidence.dir, "/yr1973_2010.seer9", sep="")
sas.file <- readLines(paste(incidence.dir, "/read.seer.research.nov2012.sas", sep=""))

# Read the SAS script to get the field widths and the field names
read_sas_script <- function(sas_file) {
    col.widths <- c()
    col.names <- c()
    for (line in sas.file) {
        r <- regexpr("[$]char[0-9]+[.]", line)
   
        if (r > 0) {
            fields <- unlist(strsplit(line, " +"))
            w <- gsub("[$char.]", "", fields[5])
            col.widths <- c(col.widths, as.integer(w))
            col.names <- c(col.names, tolower(fields[4]))
        }
    }
    list(widths=col.widths, names=col.names)
}

read_seer_file <- function(cancer_type) {
    cancer_type <- toupper(cancer_type)
    format_info <- read_sas_script(sas.file)
    col.widths <- format_info$widths
    col.names <- format_info$names
    seer.laf <- laf_open_fwf(paste(seer9.incidence.dir, "/", cancer_type, ".TXT", sep=""),
                             column_types=rep("string", length(col.widths)),
                             column_widths=col.widths,
                             column_names=col.names)
    seer.data <- seer.laf[ , ]
    seer.data
}
