#Check for the File. If not there, download the data and extract it
if (!file.exists("dataset.zip")) {
        zip.url <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
        zip.file <- 'dataset.zip'
        download.file(zip.url, destfile = zip.file)
        unzip(zip.file)
}

#Check to see if the data has been processed
if (!exists("datasub")){
        # Read text file
        datafull <-read.table("household_power_consumption.txt", header = TRUE, sep =";")
        
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
png(filename = "plot2.png", width = 480, height = 480, units = "px", pointsize = 12, bg = "white")

## write output to .png file
with (datasub, plot(datasub$globalactivepower~datasub$datetime, type="l", ylab="Global Active Power (kilowatts)", xlab=""))

# Close the PNG device
dev.off()  