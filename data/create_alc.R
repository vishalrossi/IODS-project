# Course: Introduction to Open Data Science, spring 2017
# Author: Vishal Sinha
# Date: 31 January 2107
# Exercise: Logistic regression
# File: Student alcohol consumption

### Read the files
file1 = read.csv("/Users/vsinha/IODS-project/data/student-mat.csv", sep = ";", header = T)
file2 = read.csv("/Users/vsinha/IODS-project/data/student-por.csv", sep = ";", header = T)

### Check the structure and dimension of files
str(file1)
str(file2)
dim(file1)
dim(file2)

### Access the dplyr library
library(dplyr)

### Join the two datasets by the selected identifiers
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")
math_por <- inner_join(file1, file2, by =join_by, suffix = c(".math", ".por"))

### Keep duplicated answer data
alc <- select(math_por, one_of(join_by))

### Structure and dimension of joined and duplicated answer data
str(math_por)
dim(math_por)
str(alc)
dim(alc)

### The columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(file1)[!colnames(file1) %in% join_by]

### For every column name not used for joining...
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

### Define a new column alc_use by combining weekday and weekend alcohol use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

### Define a new logical column 'high_use'
alc <- mutate(alc, high_use = alc_use > 2)

### Glimplse at the joined and modified data by running the alc twice 
glimpse(alc)

### Export the data
write.table(alc, file="/Users/vsinha/IODS-project/data/alc", sep = "\t")
