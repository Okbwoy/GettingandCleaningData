## R script run_analysis.R

## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


## Install required packages
if (!require("data.table")) {install.packages("data.table")}
require("data.table")

if (!require("reshape2")) {install.packages("reshape2")}
require("reshape2")

##
## All files have been downloaded to working directory 
## Let's load all these files and standardize names - no uppercase
##

## Load activity_labels.txt
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

## Load features.txt
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

## Load X_test.txt
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")

## Load y_test.txt
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")

## Load subject_test.txt
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

## Load X_train.txt
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")

## Load y_train.txt
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

## Load subject_test.txt
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")


## Rename variables of x_test and x_train datasets
names(x_test) = features
names(x_train) = features


## Extract only the measurements on the mean and standard deviation for each measurement.
MeanAndSd <- grepl("mean|std", features)
x_test = x_test[,MeanAndSd]
x_train = x_train[,MeanAndSd]


## Uses descriptive activity names to name the activities in the data set
y_test[,2] = activity_labels[y_test[,1]]
y_train[,2] = activity_labels[y_train[,1]]

names(y_test) = c("ActivityID", "ActivityName")
names(y_train) = c("ActivityID", "ActivityName")

names(subject_test) = "SubjectNumber"
names(subject_train) = "SubjectNumber"


## Merges the training and the test sets to create one data set.
AllTestData <- cbind(as.data.table(subject_test), y_test, x_test)
AllTrainData <- cbind(as.data.table(subject_train), y_train, x_train)
AllData <- rbind(AllTestData, AllTrainData)


## Appropriately labels the data set with descriptive variable names. 
AppropriateLabels = c("SubjectNumber", "ActivityID", "ActivityName")
MeasureLabels = setdiff(colnames(AllData), AppropriateLabels)
AllDataMelt = melt(AllData, id = AppropriateLabels, measure.vars = MeasureLabels)


## From the data set in step 4, creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject
TidyData = dcast(AllDataMelt, SubjectNumber + ActivityName ~ variable, mean)


## Please upload your data set as a txt file created with write.table() using row.name=FALSE
write.table(TidyData, file = "./TidyData.txt", row.name=FALSE)







