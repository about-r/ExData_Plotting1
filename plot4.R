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
df$dttm <- strptime(paste(df$dt,df$tm), "%d/%m/%Y %H:%M:%S")

#as PNG
png("plot4.png",width = 480, height = 480, units = "px")
par(mfrow=c(2,2),oma=c(1,1,1,1))
xlim <- c(df$dttm[1],df$dttm[2880])

#1
ylim <- range(df$gap)
plot(xlim, ylim, type="n", xlab="", ylab="Global Active Power")
lines(df$dttm, df$gap, type='l', lty=1, col='black', pch=0)

#2
ylim <- range(df$vt)
plot(xlim, ylim, type="n", xlab="datetime", ylab="Voltage")
lines(df$dttm, df$vt, type='l', lty=1, col='black', pch=0)

#3
ylim <- range(df[,7])
clr  <- c('black','red','blue')
lgd  <- c('Sub_metering_1','Sub_metering_2','Sub_metering_3')
plot(xlim, ylim, type="n", xlab="", ylab="Energy sub metering")
lines(df$dttm, df$sm1, type='l', lty=1, col=clr[1], pch=0)
lines(df$dttm, df$sm2, type='l', lty=1, col=clr[2], pch=0)
lines(df$dttm, df$sm3, type='l', lty=1, col=clr[3], pch=0)
legend("topright",legend=lgd,col=clr,lty=1,bty="n")

#4
ylim <- range(df$grp)
plot(xlim, ylim, type="n", xlab="datetime", ylab="Global_reactive_power")
lines(df$dttm, df$grp, type='l', lty=1, col='black', pch=0)

#finish
dev.off()

# cleanup works space
rm(list=ls())
