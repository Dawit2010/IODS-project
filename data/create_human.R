# Author: Dawit A. Yohannes
# Date : November 29, 2017
# Description: Human development and gender inequality data wrangling.
# Data source : From course 2218 in datacamp


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














