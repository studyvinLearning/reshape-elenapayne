library(tidyverse)
library(lubridate)

data(federalistPapers, package='syllogi')

#################### Bad list to DF ####################
numbers <- c()
authors <- c()
titles <- c()
journals <- c()
dates <- c()

for (i in 1:length(federalistPapers)) {
  
  numbers <- c(numbers, federalistPapers[[i]]$meta$number)
  
  authors <- c(authors, federalistPapers[[i]]$meta$author)
  
  titles <- c(titles, federalistPapers[[i]]$meta$title)
  
  journals <- c(journals, federalistPapers[[i]]$meta$journal)
  
  date <- federalistPapers[[i]]$meta$date
  date <- ifelse(!is.na(date), substr(date, 1, 10), NA)
  dates <- c(dates, date)

}

fedDF <- data.frame(paperNumber = numbers,
                    author = authors,
                    journals = journals,
                    dates = as.Date(dates))

#################### Weekday ####################
weekday <- c()

for (i in 1:nrow(fedDF)){
  
  weekday <- c(weekday, wday(fedDF$dates[i]))
  
}
  
weekday <- gsub(3, "Tuesday", weekday)
weekday <- gsub(5, "Thursday", weekday)
weekday <- gsub(6, "Friday", weekday)

fedDF$weekday <- weekday

#################### Paper Count ####################
weekdayAuthor <- data.frame(fedDF$weekday, fedDF$author)

table(weekdayAuthor)

#################### New DF ####################
date1 <- as.Date(na.omit(fedDF$dates))
unique <- unique(date1)


out <- data.frame()

for (i in 1:nrow(fedDF)){
  if(!is.na(fedDF$dates[i])){
    out <- c(out, fedDF[i,])
  }
}
out
## at this point, if I used my out variable again it would revert the dates to a weird number.
## did not have time to further troubleshoot