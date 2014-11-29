##Use my standard openning including call function
source('C:/Users/bryan_000/Documents/GitHub/MyWork/StdOpen.R')
##Set destination file for dowload 
datafile <-paste(datadir,"household_power_consumption.txt",sep = "")
zip.file <-paste(datadir,"power_dataset.zip",sep = "")

#Check for the File. If not there, download the data and extract it
if (!file.exists(datafile)) {
        zip.url <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
        download.file(zip.url, destfile = zip.file)
        unzip(zip.file)
}

#Check to see if the data has been processed
if (!exists("datasub")){
        # Read text file
        datafull <-read.table(datafile, header = TRUE, sep =";")
        
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
plot.file <-paste(datadir,"plot2.png",sep = "")
png(filename = plot.file, width = 480, height = 480, units = "px", pointsize = 12, bg = "white")

## write output to .png file
with (datasub, plot(datasub$globalactivepower~datasub$datetime, type="l", ylab="Global Active Power (kilowatts)", xlab=""))

# Close the PNG device
dev.off()  
