# Getting and Cleaning Data Project John Hopkins Coursera
#Week 4 Assignment

#The data for the project:
#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  

#TASK: create one R script called run_analysis.R that does the following. 

#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for each measurement. 
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names. 
#5. From the data set in step 4, creates a second, independent tidy data set with 
#   the average of each variable for each activity and each subject.



library(dplyr) 

# 1.  Merge training and test sets ----------------------------------------

#Load packages and get the data
path <- getwd()
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, file.path(path, "dataFiles.zip"))
unzip(zipfile = "dataFiles.zip")


#Read training data
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

#Read testing data
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

#Read features 
features <- read.table("./UCI HAR Dataset/features.txt")

#Read activity labels 
activity_labels = read.table("./UCI HAR Dataset/activity_labels.txt")


#Assigning variable names to columns
colnames(x_train) <- features[,2]
colnames(y_train) <- "activityID"
colnames(subject_train) <- "subjectID"

colnames(x_test) <- features[,2]
colnames(y_test) <- "activityID"
colnames(subject_test) <- "subjectID"

colnames(activity_labels) <- c("activityID", "activityType")


#Merging datasets
train_all <- cbind(y_train, subject_train, x_train)
test_all <- cbind(y_test, subject_test, x_test)

dataset_merged <- rbind(train_all, test_all)
#View(dataset_merged)


# 2. Extracting measurements on the mean and SD --------------------------

#Keep columns based on column name for mean & SD
keep <- grepl("subject|activity|mean|std", colnames(dataset_merged))

#Extracting data & reshaping file
dataset_meanSD <- dataset_merged[, keep]
View(dataset_meanSD)


# 3. Descriptive activity names -------------------------------------------

#Replace activity values with named factor levels
#Turn activities and subjects into factors
dataset_meanSD$activity <- factor(dataset_meanSD$activityID, 
                                 levels = activity_labels[, 1], labels = activity_labels [, 2])

dataset_meanSD$subject  <- as.factor(dataset_meanSD$subjectID)


# 4.  Labeling dataset ---------------------------------------------------
#done under previous steps


# 5. Create second, independent tidy data set -----------------------------
# with the average of each variable for each activity and each subject. 

#Create second set
dataset_tidy <- aggregate(. ~subjectID + activityID, dataset_meanSD, mean)
dataset_tidy <- dataset_tidy[order(dataset_meanSD$subjectID, dataset_meanSD$activityID), ]

#Write table
write.table(dataset_tidy, "tidy_dataset.txt", row.names = FALSE)

