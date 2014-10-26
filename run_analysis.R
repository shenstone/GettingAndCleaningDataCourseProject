## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## 0. preamble
rm(list=ls())
if (!require("data.table")) install.packages("data.table")
if (!require("reshape2"))   install.packages("reshape2")

require("data.table")
require("reshape2")

setwd("C:/Users/js3684/Documents/My Exercises/DataScience/Getting and Cleaning Data Course Project");

## 1. Merges the training and the test sets to create one data set.
personID     = read.table('UCI HAR Dataset/train/subject_train.txt',header=FALSE); 
xTrain       = read.table('UCI HAR Dataset/train/X_train.txt',header=FALSE); 
actID        = read.table('UCI HAR Dataset/train/y_train.txt',header=FALSE); 
trainingSet  = cbind(personID, actID, xTrain);

personID     = read.table('UCI HAR Dataset/test/subject_test.txt',header=FALSE); 
xTest        = read.table('UCI HAR Dataset/test/X_test.txt',header=FALSE); 
actID        = read.table('UCI HAR Dataset/test/y_test.txt',header=FALSE);
testSet      = cbind(personID, actID, xTest);

superSet     = rbind(trainingSet, testSet);

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.

features     = read.table('UCI HAR Dataset/features.txt',header=FALSE); 
activities   = read.table('UCI HAR Dataset/activity_labels.txt',header=FALSE); 
colnames(activities) <- c('Activity', 'ActivityDec');

measurements = grep("mean|std", features[,2], ignore.case = TRUE); 
features     = features[measurements,]
measurements = c(1, 2, measurements+2);
subSet       = superSet[measurements];

## 3. Use descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.

features     = gsub('mean', 'Mean', features[,2]);
features     = gsub('std', 'Std', features);
features     = gsub('[-()]', '', features);
colnames(subSet) <- c("Subject", "Activity", features);
subSet       = merge(subSet, activities);
subSet       = subSet[c("Subject", "ActivityDec", features)];

## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

subSet2 = aggregate(subSet[,names(subSet)!=c("Subject","ActivityDec")], by=list(activity = subSet$ActivityDec, subject=subSet$Subject), mean);

write.table(subSet2, './tidyData.txt',row.names=TRUE,sep='\t');




