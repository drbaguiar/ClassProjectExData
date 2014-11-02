#Check for the File. If not there, download the data and extract it
if (!file.exists("C:/Users/bryan_000/Documents/GitHub/Data/power_dataset.zip")) {
        zip.url <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
        zip.file <- 'C:/Users/bryan_000/Documents/GitHub/Data/power_dataset.zip'
        download.file(zip.url, destfile = zip.file)
        unzip(zip.file)
}

#Check to see if the data has been processed
if (!exists("datasub")){
        # Read text file
        datafull <-read.table("C:/Users/bryan_000/Documents/GitHub/Data/household_power_consumption.txt", header = TRUE, sep =";")
        
        #clean the file
        names(datafull) <-tolower(names(datafull))
        names(datafull) <- gsub("_","",names(datafull))
        
        #Convert Global_active_power to numeric and date to date
        datafull$globalactivepower <- as.numeric(datafull$globalactivepower)
        datafull$date = as.Date(datafull$date, format = "%d/%m/%Y" )
        
        #Get the relevant records
        datasub <- datafull[(datafull$date == "2007-02-01" | datafull$date == "2007-02-02") , ]
        
        #Create new field containing date and time combined
        datetime <- paste(datasub$date, datasub$time)
        datasub$datetime <- as.POSIXct(datetime)
        
        #Remove the full file 
        rm(datafull)
}

## write output to .png file
png(filename = "C:/Users/bryan_000/Documents/GitHub/Data/plot4.png", width = 480, height = 480, units = "px", pointsize = 12, bg = "white")

## write output to .png file
par(mfrow = c(2, 2))

## Top-left
plot(datasub$datetime, datasub$globalactivepower, 

     type = "l",
     xlab = "", ylab = "Global Active Power")

## Top-right
plot(datasub$datetime, datasub$voltage, type = "l", xlab = "datetime", ylab = "Voltage")

## Bottom-left
plot(datasub$datetime, datasub$submetering1, type = "l", col = "black", xlab = "", ylab = "Energy sub metering")
lines(datasub$datetime, datasub$submetering2, col = "red")
lines(datasub$datetime, datasub$submetering3, col = "blue")

# Remove the border of legend here.
legend("topright",bty = "n", col = c("black", "red", "blue"),c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lwd = 1)

## Bottom-right
plot(datasub$datetime, datasub$globalreactivepower, type = "l", col = "black", xlab = "datetime", ylab = colnames(datasub)[4])

# Close the PNG device
dev.off()  