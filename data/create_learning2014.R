# Course: Introduction to Open Data Science, spring 2017
# Author: Vishal Sinha
# Date: 31 January 2107
# Exercise: Regression and model validation

###set working directory
setwd = ("/Users/vsinha/IODS-project/")

###install package
library(dplyr)

###read the data
file= read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", header = T, sep = "\t")

###structure and dimension of the data
str(file)
dim(file)
###file is a data frame of 183 rows and 63 coloums

###rescale attitude
file$attitude <- file$Attitude/10

###create analysis dataset
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D07","D14","D22","D30")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")
deep_columns <- select(file, one_of(deep_questions))
surface_columns <- select(file, one_of(surface_questions))
strategic_columns <- select(file, one_of(strategic_questions))

###scale data by taking mean
file$deep <- rowMeans(deep_columns)
file$surf <- rowMeans(surface_columns)
file$stra <- rowMeans(strategic_columns)

###select the specific columns to create analysis dataset 
keep_columns <- c("gender","Age","attitude", "deep", "stra", "surf", "Points")
data <- select(file, one_of(keep_columns))

###exclude observations where exam points equals to 0
learning2014 <- filter(data, Points>0)

###write the data in a table format
write.table(learning2014, file="/Users/vsinha/IODS-project/data/learning2014", sep = "\t")
