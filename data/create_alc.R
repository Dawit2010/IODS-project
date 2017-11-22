# Author: Dawit A. Yohannes
# Date : November 21, 2017
# Description: Logistic regression...data wrangling and analysis for Rstudio exercise 3 in IODS2017 course
# Data source : https://archive.ics.uci.edu/ml/datasets/Student+Performance


#### Reading in student data performance datasets
library(dplyr)


math <- read.table("data/student-mat.csv", sep = ";" , header=TRUE)
por <- read.table("data/student-por.csv", sep = ";" , header=TRUE)

# explore datasets: 395 observations and 33 variables. Variables are of type int and factor
str(math)
dim(math)

#  649 observations and 33 variables in por dataset
str(por)
dim(por)


# Joining the two datasets based on the following columns

join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")

# join the two datasets by the selected identifiers
math_por <- inner_join(math, por, by = join_by,suffix=c(".math",".por"))

str(math_por) # 382 observations found after inner join.
dim(math_por)



# combine duplicated answers, copied from datacamp exercise

# create a new data frame with only the joined columns
alc <- select(math_por, one_of(join_by))

# the columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(math)[!colnames(math) %in% join_by]


# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(math_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}


# create and add alc_use and high_use variables 


# define a new column alc_use by combining weekday and weekend alcohol use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

# define a new logical column 'high_use'
alc <- mutate(alc, high_use = alc_use > 2)


# take a glimpse of the data. We have 382 observations and 35 variables.
glimpse(alc)


#### Writing and reading analysis data

# Writing the analysis data

write.table(alc,file="data/alcData.txt",sep="\t")


# reading the data
alcData <- read.table("data/alcData.txt",header=T, sep="\t")
str(alcData)
head(alcData)












