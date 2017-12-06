# Author: Dawit A. Yohannes
# Date : November 29, 2017
# Description: Human development and gender inequality data wrangling.
# Data source : http://hdr.undp.org/en/content/human-development-index-hdi


# Reading in the data
library(dplyr)


hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")


# Explore the datasets
str(hd)
dim(hd)


str(gii)
dim(gii)

# Both hd and gii datasets have 195 obs, and 8 and 10 vars respectively.


# Summary of the datasets
summary(hd) 
summary(gii)


# Renaming variable names to shorter meaningful names
colnames(hd) <- c("HDIRank","Country","HDI","LifeExpectancy","ExpEduInYears","MeanEduInYears","GNIperCapita","GNIPCminusHDIRank")
colnames(gii) <- c("GIIRank","Country","GII","MaternalMortalityRatio","AdolescentBirthRate","percentInParliament","SecondaryEducFemale","SecondaryEducMale","LFPRFemale","LFPRMale")


# Create two new variables in gii
gii <- mutate(gii, SecondaryEducFtoM = SecondaryEducFemale / SecondaryEducMale)
gii <- mutate(gii, LFPRFtoM = LFPRFemale / LFPRMale)


# Inner join of the datasets on the variable country
human <- inner_join(hd, gii, by = "Country", suffix=c(".hd",".gii"))
str(human)
head(human)

# human data has 195 observations and 19 variables.

# Writing the human data
write.table(human,file="data/human.txt",sep="\t")


# Rstudio exercise 5

# Read human data to make new changes from Rstudio exercise 5
humanData <- read.table("data/human.txt",header=T, sep="\t")
str(humanData)

# remove the commas from GNI and transform it to a numeric data

library(stringr);
humanData$GNIperCapita <- str_replace(humanData$GNIperCapita, pattern=",", replace ="") %>% as.numeric


# Select some columns only

selectedVars <- c("Country", "SecondaryEducFtoM", "LFPRFtoM", "ExpEduInYears", "LifeExpectancy", "GNIperCapita", "MaternalMortalityRatio", "AdolescentBirthRate", "percentInParliament")

humanData_selected <- dplyr::select(humanData,one_of(selectedVars))

# Remove rows with NA
humanData_selectedNoNA <- filter(humanData_selected, complete.cases(humanData_selected))

# Remove observations relating to regions instead of countries

tail(humanData_selectedNoNA,10) # the last 7 observations are for regions.

last <- nrow(humanData_selectedNoNA) - 7

humanData_selectedNoNACountryOnly <- humanData_selectedNoNA[1:last, ]


# Making rownames country names & removing the country column

rownames(humanData_selectedNoNACountryOnly) <- humanData_selectedNoNACountryOnly$Country

humanData_selectedNoNACountryOnly <- dplyr::select(humanData_selectedNoNACountryOnly, -Country)

# 155 obs. with 8 variables
str(humanData_selectedNoNACountryOnly)
head(humanData_selectedNoNACountryOnly)

# Writing the human data
write.table(humanData_selectedNoNACountryOnly,file="data/human.txt",sep="\t")




