# Getting and Cleaning Data

# Final Project Code Book

This code book contains descriptions of all associated variables, the data used, and all transformations necessary to 
create the tidy data sets as outlined by final project requirements.

# Design Notes:

* The data come from the accelerometers on a Samsung Galaxy S II smartphone. It recorded various accelerometer measurements for 30 subjects during different prescribed activities. More information on the experiment can be found at: https://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

* The data for the project is downloaded from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
* The zipped file has been saved in the working directory by the run_Analysis.R script (analysis script) as FinalProjectData.zip
* The unzipped files are stored in my data working directory and creates the subdirectory 'UCI HAR Dataset' which contains all the raw data and a README.txt which describes the dataset.
* The raw data is separated into test and training datasets stored here: /UCI HAR Dataset/test & /UCI HAR Dataset/train. Within each of the test and training datasets the data are separated into files for measurement data, the activity labels, and the test subject labels.

# Code Book Steps:

## Step Number 1: Merges the training and test data sets to create 1 final combined data set.

* theXTest <- read.table("UCI HAR DATASET/Test/X_Test.txt")
* theYTest <- read.table("UCI HAR DATASET/Test/y_Test.txt")
* theSubjectTest <- read.table("UCI HAR DATASET/Test/subject_Test.txt")
* theXTrain <- read.table("UCI HAR DATASET/Train/X_Train.txt")
* theYTrain <- read.table("UCI HAR DATASET/Train/y_Train.txt")
* theSubjectTrain <- read.table("UCI HAR DATASET/Train/subject_train.txt")
* theFeatures <- read.table("UCI HAR DATASET/features.txt")
* theActivity <- read.table("UCI HAR DATASET/activity_labels.txt")

### The Merge using rbind() function:
* xData <- rbind(theXTest, theXTrain)                     **dim(xData) = 10299 - 561**
* yData <- rbind(theYTest, theYTrain)                     **dim(yData) = 10299, - 561**
* theSubject <- rbind(theSubjectTest, theSubjectTrain)    **dim(theSubject = 10299 - 561)**

## Step Number 2: Extract only the measurements on the mean & Standard Deviation for each measurement


* index <- grep("mean\\(\\)|std\\(\\)", theFeatures[,2])
* length(index)   **66**
* x <- xData[,index]  **getting only the variables with mean/stdev**
* dim(x)  **validing the dim of the data subset  | 10299    66**

## Step Number 3:  Use descriptive activity names to name the activities in my data set


* yData[,1] <- theActivity[yData[,1],2]   **this statement replaces numeric values with descriptions from the activity dataset "theActivity".**
* head(yData)    **investigating the first few records of yData to ensure activity dataset descriptions are used.**

## Step Number 4: Label the data set with descriptive variable (column names).

* myNames<- theFeatures[index,2]   **get the names for the variables (columns)**
* names(xData) <- myNames   **updating the column names for the dataset "xData"**
* names(theSubject) <- "SubjectID"
* names(yData) <- "Activity"
* finalData <- cbind(theSubject, yData, xData)
* head(finalData[,c(1:4)])   **test the first 5 columns to ensure descriptive variable names are correct.**


## Step Numer 5: from my data in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject

* myFinalDataSet <- data.table(finalData)
* head(myFinalDataSet)  **do a test to ensure clone of finalData from step 4**
* myTidyData <- myFinalDataSet[, lapply(.SD, mean), by = 'SubjectID,Activity'] **pulls the averages by subjectid and activity**
* dim(myTidyData)   **Validates data set | 180 68**
* write.table(myTidyData, file = myTidyData.txt, row.names = FALSE)  **validated data file created in my working directory**
* head(myTidyData[order(SubjectID)][,c(1:4), with = FALES], 6)  **View the first few rows for validation**




