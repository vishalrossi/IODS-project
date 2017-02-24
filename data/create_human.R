# Vishal Sinha
# 2017-02-15
# Exercise 4 & 5: data wrangling


# Read the ???Human development??? and ???Gender inequality??? datas into R
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# Explore the datasets: see the structure and dimensions of the data. Create summaries of the variables.
str(hd)
str(gii)
summary(hd)
summary(gii)

# Look at the meta files and rename the variables with (shorter) descriptive names.
colnames(hd) <- c("HDIrank","country","HDI","lifexp","expedu","meanedu","GNI","rank2")
colnames(gii) <- c("GIIrank","country","GII","matmor","adbi","repparl","edu2F","edu2M","labF","labM")

# Mutate the ???Gender inequality??? data and create two new variables. 
# The first one should be the ratio of Female and Male populations with secondary education in each country. (i.e. edu2F / edu2M). 
# The second new variable should be the ratio of labour force participation of females and males in each country (i.e. labF / labM)
library(dplyr)
gii <- mutate(gii, edu2FMrat = edu2F / edu2M)
gii <- mutate(gii, labFMrat = labF / labM)

# Join together the two datasets using the variable Country as the identifier. 
# Keep only the countries in both data sets (Hint: inner join). 
human <- inner_join(hd, gii, by = "country")

# Call the new joined data human and save it in your data folder.
save(human, file="/Users/vsinha/IODS-project/data/human.RData")

# Data Wrangling exercise for week 5
dim(human)
library(stringr)
str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric

keep_columns <- c("country", "edu2FMrat", "labFMrat", "expedu", "lifexp", "GNI", "matmor", "adbi", "repparl")
human <- select(human, one_of(keep_columns))

# Removing all rows with missing variables
keep <- complete.cases(human)
data.frame(human[-1], comp = keep)
human <- filter(human, complete.cases(human))
dim(human)

# Remove regions
human <- human[1:155,]
human$Country


# Defining row names
rownames(human) <- human$country
human <- human[,-1]
str(human)

# Export thr data
write.table(human, file="/Users/vsinha/IODS-project/data/human", row.names = TRUE) 
