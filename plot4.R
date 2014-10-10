#Check for the File. If not there, download the data and extract it
if (!file.exists("dataset.zip")) {
        zip.url <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
        zip.file <- 'dataset.zip'
        download.file(zip.url, destfile = zip.file)
        unzip(zip.file)
}

if (!exists("data")){
        # Read text file
        datafull <-read.table("household_power_consumption.txt", header = TRUE, sep =";")
        
        #clean the file
        names(datafull) <-tolower(names(datafull))
        
        #Convert Global_active_power to numeric and date to date
        datafull$global_active_power <- as.numeric(datafull$global_active_power)
        datafull$date = as.Date(datafull$date, format = "%d/%m/%Y" )
        
        #Get the relevant records
        data <- datafull[(datafull$date == "2007-02-01" | datafull$date == "2007-02-02") , ]
        
        #Create new field containing date and time combined
        datetime <- paste(data$date, data$time)
        data$datetime <- as.POSIXct(datetime)
        
        #Remove the full file 
        rm(datafull)
}

## write output to .png file
png(filename = "plot4.png", width = 480, height = 480, units = "px", pointsize = 12, bg = "white")

## write output to .png file
par(mfrow = c(2, 2))

## Top-left
plot(data$datetime, data$global_active_power, 

     type = "l",
     xlab = "", ylab = "Global Active Power")

## Top-right
plot(data$datetime, data$voltage,
     type = "l",
     xlab = "datetime", ylab = "Voltage")

## Bottom-left
plot(data$datetime, data$sub_metering_1, 
     type = "l",
     col = "black",
     xlab = "", ylab = "Energy sub metering")
lines(data$datetime, data$sub_metering_2, col = "red")
lines(data$datetime, data$sub_metering_3, col = "blue")

# Remove the border of legend here.
legend("topright", 
       bty = "n",
       col = c("black", "red", "blue"),
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       lwd = 1)

## Bottom-right
plot(data$datetime, data$global_reactive_power, 
     type = "l",
     col = "black",
     xlab = "datetime", ylab = colnames(data)[4])

# Close the PNG device
dev.off()  