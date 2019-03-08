if(!("crayon" %in% rownames(installed.packages()))) {
  install.packages('crayon')
}

if(!("tidyverse" %in% rownames(installed.packages()))) {
  install.packages('tidyverse')
}

library(crayon)
library(tidyverse)

clear <- function() cat("\014")

clear()

download.raw.data <- function() {
  if(!file.exists('household_power_consumption.txt')) {
    data.url  <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
    data.zip.path <- 'data.csv.zip'
    
    clear()
    cat(blue('Downloading the zip file\n'))
    download.file(data.url, destfile = data.zip.path)
    clear()
    
    cat(blue('Unzipping...\n'))
    unzip(data.zip.path)
    
    file.remove(data.zip.path)
    
    clear()
    cat(green('Download of raw data done\n'))
  }
  else {
    clear()
    cat(green('Raw data already present - skipping the download\n'))
  }
}

read.data <- function() {
  download.raw.data()
  
  read_delim(
    "household_power_consumption.txt",
    ";",
    col_types = list(
      col_date(format="%d/%m/%Y"),
      col_time(),
      col_double(),
      col_double(),
      col_double(),
      col_double(),
      col_double(),
      col_double(),
      col_double()
    ),
    na = c("?")
  ) %>%
    filter(Date %in% as.Date(c("2007-02-01", "2007-02-02"))) %>%
    mutate(DateTime = as.POSIXct(paste(data$Date,data$Time), format = "%Y-%m-%d %H:%M"))
}

data <- read.data()

png(width=480, height=480, filename="plot2.png")

plot(
  data$DateTime,
  data$Global_active_power,
  ylab="Global Active Power (kilowatts)",
  xlab="",
  type="n"
)

lines(
  data$DateTime,
  data$Global_active_power
)

dev.off()
