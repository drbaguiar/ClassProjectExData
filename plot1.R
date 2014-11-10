##Set working directory to data directory
setwd('C:/Users/bryan_000/Documents/GitHub/Data/')

#Check for the File. If not there, download the data and extract it
if (!file.exists("power_dataset.zip")) {
        zip.url <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
        zip.file <- 'power_dataset.zip'
        download.file(zip.url, zip.file)
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
png(filename = "plot1.png", width = 480, height = 480, units = "px", pointsize = 12, bg = "white")
with(datasub, hist(datasub$globalactivepower, col = "red",main="Global Active Power", xlab = "Global Active Power (kilowatts)"))

## Close the PNG device
dev.off()  