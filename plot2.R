#Check for the File. If not there, download the data and extract it
if (!file.exists("dataset.zip")) {
        zip.url <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
        zip.file <- 'dataset.zip'
        download.file(zip.url, destfile = zip.file)
        unzip(zip.file)
}
# Read text file
datafull <-read.table("household_power_consumption.txt", header = TRUE, sep =";")

#Convert Global_active_power to numeric and date to date
datafull$Global_active_power <- as.numeric(datafull$Global_active_power)
datafull$Date = as.Date(datafull$Date, format = "%d/%m/%Y" )

#Get the relevant records
data <- datafull[(datafull$Date == "2007-02-01" | datafull$Date == "2007-02-02") , ]

#Remove the full file 
rm(datafull)

#Convert date and time
datetime <- paste(data$Date, data$Time)
data$Datetime <- as.POSIXct(datetime)

## write output to .png file
png(filename = "plot2.png", width = 480, height = 480, units = "px", pointsize = 12, bg = "white")

## write output to .png file
with (data, plot(data$Global_active_power~data$Datetime, type="l", ylab="Global Active Power (kilowatts)", xlab=""))

# Close the PNG device
dev.off()  