# Author: Dawit A. Yohannes
# Date : November 14, 2017
# Description: data wrangling and analysis for Rstudio exercise 2 in IODS2017 course
# Data source : http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-meta.txt


#### Reading in the data
l2014Data <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt",header=T, sep="\t")

str(l2014Data)
dim(l2014Data)

# There are 183 observations (rows) with 60 variables (cols) in the dataset. 
# All except Gender are integers variables.


#### select variables of interest
library(dplyr)

# The following are brought from the corresponding datacamp exercise

# scaling the attitude variabe since it is combined from 10 variables each with values from 1-5
l2014Data$attitude <- l2014Data$Attitude / 10


# questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# select the columns related to deep learning and create column 'deep' by averaging
deep_columns <- select(l2014Data, one_of(deep_questions))
l2014Data$deep <- rowMeans(deep_columns)


# select the columns related to surface learning and create column 'surf' by averaging
surface_columns <- select(l2014Data, one_of(surface_questions))
l2014Data$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning and create column 'stra' by averaging
strategic_columns <- select(l2014Data, one_of(strategic_questions))
l2014Data$stra <- rowMeans(strategic_columns)

# choose a handful of columns to keep
keep_columns <- c("gender","Age","attitude", "deep", "stra", "surf", "Points")

# select the 'keep_columns' to create a new dataset
ln2014  <- select(l2014Data, one_of(keep_columns))

# keep observations with points greater than 0
ln2014 <- filter(ln2014, Points > 0)

dim(ln2014)

# data now has 166 observations and 7 variables


#### Writing and reading analysis data

# Writing the analysis data

write.table(ln2014,file="data/learning2014.txt",sep="\t")


# reading the data
ldata <- read.table("data/learning2014.txt",header=T, sep="\t")
str(ldata)
head(ldata)












