#downloading file
temp <- tempfile()
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url,temp)
#unzipping file
unzip(temp, "household_power_consumption.txt")
install.packages("sqldf")
library(sqldf)
#ureading only 1/2/2007 and 2/2/2007
df <- read.csv.sql("household_power_consumption.txt",
                   "select * from file where Date = '1/2/2007' or Date = '2/2/2007' ",
                   sep=";")
df$Date <- as.Date(df$Date, format="%d/%m/%Y")
datetime <- paste(as.Date(df$Date), df$Time)
df$Datetime <- as.POSIXct(datetime)
#plotting histogram
png("plot3.png", width = 480, height = 480)
with(df, {
     plot(Sub_metering_1~Datetime, type="l", 
          ylab="Energy sub metering", xlab="")
     lines(Sub_metering_2~Datetime, col = "red")
     lines(Sub_metering_3~Datetime, col = "blue")
})

legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2, 
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.off()
