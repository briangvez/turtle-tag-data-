library(psych)
library(pastecs)
library(lubridate)
library(plyr)
library(tidyverse)
library(ggplot2)
library(corrplot)
library(GGally)
library(ggpubr)
library(writexl)


##Import mid_atlantic_night_dive_data.csv with readR and convert diveEnd and diveStart columns to datetime format 

##rename dataframe 

night_dive <- mid_atlantic_night_dive_data

head(night_dive)

##convert UTC to EST for start and end dive times 

attr(night_dive$diveStartdate, "tzone") <- "America/New_York"

attr(night_dive$diveEnddate, "tzone") <- "America/New_York"

##separate dateTime column into date column and time column (used on diveStartdate AND diveEnddate)

night_dive <- tidyr::separate(night_dive, diveStartdate, c("diveStartdate", "diveStarttime"), sep = " ")

night_dive <- tidyr::separate(night_dive, diveEnddate, c("diveEnddate", "diveEndtime"), sep = " ")

##separating datetime column into two columns makes the date and time columns 
##character strings rather than true date and time formats

##convert character string of diveStartdate and diveEnddate to date class

night_dive$diveStartdate <- as.Date(night_dive$diveStartdate)

night_dive$diveEnddate <- as.Date(night_dive$diveEnddate)

##create a dataframe that only includes night data 

##R didn't like going from 20 to 06, so had to go from 20 to 23:59, and then 00:00 to 06:00 in 2 
##dataframes, then merge the 2 dataframes with r-bind 

night <- night_dive %>%  
  filter(diveStarttime >= ('20:00:00'),
         diveStarttime <= ('23:59:59'))

night1 <- night_dive %>%
  filter(diveStarttime >= ('00:00:00'),
         diveStarttime <= ('06:00:00'))


##bind 2 dataframes

full_night <- rbind(night, night1)



##remove night dives shallower than 100ft contour (33m)

NDA33 <- full_night %>%
  filter(maxDepth > 33)

NDA33$dive_dur <- NDA33$dive_dur / 3600 

NDA33$surf_dur <- NDA33$surf_dur / 3600 


##export xlsx file to import in to ArcGIS Pro

write_xlsx(NDA33,"C:\\Users\\brian.galvez\\Documents\\Fisheries\\Monkfish Gillnet Study\\Manuscript Data - 2017 & 2021\\tag dive data analysis\\NDA33.xlsx")



##remove night dives shallower than 22m maxDepth (shallowest depth of turtle takes in monkfish fishery from 2010-present))


NDA22 <- full_night %>%
  filter(maxDepth > 22)


##convert dive and surface durations from seconds to hours

NDA22$dive_dur <- NDA22$dive_dur / 3600 

NDA22$surf_dur <- NDA22$surf_dur / 3600 

head(NDA22)

##export xlsx file to import in to ArcGIS Pro

write_xlsx(NDA22,"C:\\Users\\brian.galvez\\Documents\\Fisheries\\Monkfish Gillnet Study\\Manuscript Data - 2017 & 2021\\Mid Atlantic tag dive data analysis\\NDA22_2022.xlsx")






