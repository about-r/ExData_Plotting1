#dependencies
library(data.table)

#setup the original data: download and uzip
wdir <- "."
if(!file.exists("./hpc_dataset.zip")){
 fUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
 fZip <- "./hpc_dataset.zip"
 download.file( fUrl, fZip )
}
if(!file.exists(paste(wdir,"household_power_consumption.txt",sep="/"))){
 unzip( fZip, exdir="." )
}

#read data set, skip to Feb 2007, subset dates 2007-02-01 and 2007-02-02
fil=paste(wdir,"household_power_consumption.txt",sep="/")
df <- fread(fil, na.strings='?', skip=66637L, nrows=3000L, 
            col.names=c('dt','tm','gap','grp','vt','gi','sm1','sm2','sm3'),data.table=FALSE)
df <- subset(df, dt == "1/2/2007" | dt=="2/2/2007")

#add new column date-time in POSIXlt format
df$dttm <- strptime(paste(df$dt,df$tm), "%d/%m/%Y %H:%M:%S", tz='UTC')

# plot as PNG
png("plot1.png",width = 480, height = 480, units = "px")
hist(df$gap,xlab="Global Active Power (kilowatts)",main="Global Active Power",col='red')
dev.off()

# cleanup works space
rm(list=ls())