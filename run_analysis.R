## Jesse (Brandon) Wheeler
## Final Project - Getting and Cleaning Data
## 06/25/2020
##
##
library(data.table)
library(dplyr)

##
## Set a local data working directy | define URL where project course data lives
## download the zipped files renaming zip to "finalprojectsdata.zip"
## redefine .zip file complete location.  This was the only way the unzip function worked without errors.
## Use the unzip() function to unzip the data files into the "GCD(Getting And Cleaning Data) sub-directory
##
##
setwd("c:/users/jbwhe/documents/training/data/")
url <-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, dest="finalprojectdata.zip", mode="wb") 
myzip <- "c:/users/jbwhe/documents/training/data/finalprojectdata.zip"
unzip(myzip, exdir = "./GCD")
setwd("./GCD")
############################################################################
## Prepare the testing and training data sets for merge
##
## Get the test data
############################################################################
theXTest <- read.table("UCI HAR DATASET/Test/X_Test.txt")
theYTest <- read.table("UCI HAR DATASET/Test/y_Test.txt")
theSubjectTest <- read.table("UCI HAR DATASET/Test/subject_Test.txt")
##
##Get the training data
###########################################################################
theXTrain <- read.table("UCI HAR DATASET/Train/X_Train.txt")
theYTrain <- read.table("UCI HAR DATASET/Train/y_Train.txt")
theSubjectTrain <- read.table("UCI HAR DATASET/Train/subject_train.txt")
##
## Get the features and activity details
###########################################################################
theFeatures <- read.table("UCI HAR DATASET/features.txt")
theActivity <- read.table("UCI HAR DATASET/activity_labels.txt")
##
##
##
###############################################################################
## Step Number 1:  Merge the training and test sets to create single data sets.
###############################################################################
##
##
xData <- rbind(theXTest, theXTrain)                     ## dim(xData) = 10299 - 561
yData <- rbind(theYTest, theYTrain)                     ## dim(yData) = 10299, - 561
theSubject <- rbind(theSubjectTest, theSubjectTrain)    ## dim(theSubject = 10299 - 561)
##
##
##
##
#####################################################################################################
## Step Number 2: Extract only the measurements on the mean & Standard Deviation for each measurement
#####################################################################################################
##
##
index <- grep("mean\\(\\)|std\\(\\)", theFeatures[,2])
length(index)   ##66
x <- xData[,index]  ##getting only the variables with mean/stdev
dim(x)  ## validing the dim of the data subset  | 10299    66
##
##
##
#######################################################################################
## Step Number 3:  Ue descriptiveactivity names to name the activities in my data set
#######################################################################################
##
##

yData[,1] <- theActivity[yData[,1],2]   ## this statement replaces numeric values with descriptions from the activity dataset "theActivity".
head(yData)## investing the first few records of yData to ensure activity dataset descriptions are used. 
##
##
##############################################################################
## Step Number 4: Label the data set with descriptive variable (column names).
##############################################################################
##
##
myNames<- theFeatures[index,2] ## get the names for the variables (columns)
names(xData) <- myNames   ##updating the column names for the dataset "xData"
names(theSubject) <- "SubjectID"
names(yData) <- "Activity"
finalData <- cbind(theSubject, yData, xData)
head(finalData[,c(1:4)])   ##test the first 5 columns to ensure descriptive variable names are correct.
##
##
##
########################################################################################################################################################
## Step Numer 5: from my data in step 4, create a second, independent ticy data set with the average of each variable for each activity and each subject
########################################################################################################################################################
##
##
myFinalDataSet <- data.table(finalData)
head(myFinalDataSet)  ##do a test to ensure clone of finalData from step 4
myTidyData <- myFinalDataSet[, lapply(.SD, mean), by = 'SubjectID,Activity'] ##pulls the averages by subjectid and activity
dim(myTidyData)   ## Validates data set | 180 68
write.table(myTidyData, file = myTidyData.txt, row.names = FALSE)  ##validated data file created in my working directory.
head(myTidyData[order(SubjectID)][,c(1:4), with = FALES], 6)  ##View the first few rows for validation




