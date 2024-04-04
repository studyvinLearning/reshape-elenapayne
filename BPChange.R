library(tidyverse)
library(lubridate)
library(dplyr)

## I definitely dropped the ball this week. The forloop hammer for these nails was unsuccessful. 
## Not much of the following code works.

bp <- readRDS("C:/Users/UW-User/Downloads/bloodPressure.RDS")

head(bp, 1)

#################### Fix Date ####################
regexp <- "([0-9]{4}-[a-z]{3}-[0-9]+)"

colnames <- colnames(bp)

newColnames <- colnames
for (i in seq_along(colnames)) {
  if (colnames[i] != "person") {
    newColnames[i] <- gsub(regexp, ymd(regexp[i]), colnames[i])
  }
}
head(bp, 1)

#################### Systolic/Diastolic ####################
bpFull <- c()

for (i in 1:nrow(bp)) {
  systolic <- unlist(bp[i, grepl("systolic", names(bp))])
  diastolic <- unlist(bp[i, grepl("diastolic", names(bp))])
  bpFull[i] <- paste(systolic, "/", diastolic)
}

bp$bpFull <- bpFull

head(bp, 1)

#################### Reshape ####################
people <- 1:500

## wide to long
bp2 <- reshape(data= bp,
              direction='long',
              varying=c(colnames), ## wide column names
              v.names='num', ## new col name for outcome frequency
              timevar=c("person", "date", "systolic/diastolic", "value"), ## new long col names
              times=c(people), ## outcome values in new long data
              idvar='person')