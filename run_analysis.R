## This script downloads a data set containing smartphone sensor data
## and combines all the data into one data frame, merged_data. It also
## creates another data set, tidy_data, containing the average of 
## every variable in the merged_data set broken down by subjectid
## and activityname.

## download the file into a temp file, and unzip
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
temp <- tempfile()
download.file(fileUrl, destfile = temp)
unzip(temp)

## load in all descriptive data
## activity_labels, features
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE,
                              col.names = c("activityid", "activityname"))
features <- read.table("UCI HAR Dataset/features.txt", header = FALSE,
                       col.names = c("featureid", "feature"))

## load in train data
## subject_train, y_train, x_train
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE, 
                            col.names = "subjectid")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE, 
                      col.names = "activityid")
## name the x_train column names their feature names preceded by train-
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE,
                      col.names = features$feature)

## load in test data
## subject_test, y_test, x_test
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE, 
                           col.names = "subjectid")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE, 
                     col.names = "activityid")

## name the x_test column names their feature names preceded by test-
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE,
                     col.names = features$feature)

## create the test_data set, only include the columns from x_test that are mean() and std()
## intentionally not including the frequency mean and other means because from my understanding
## of the question they are not required.
train_data <- cbind(subject_test, y_test, x_test[, grepl("\\.mean\\.|\\.std\\.", names(x_test))])

##create the train_data set, include the same columns as the test data set from x_train
test_data <- cbind(subject_train, y_train, x_train[, grepl("\\.mean\\.|\\.std\\.", names(x_train))])

##merge the two data sets
merged_data <- merge(test_data, train_data, all = TRUE, sort = FALSE)

## merge the activity_labels and the merged_data
merged_data <- merge(merged_data, activity_labels)

## remove the activityid column, as it was replaced with the activityname
merged_data$activityid <- NULL

## create a new tidy data set containing means for all variables
## broken down by subjectid and activityname
tidy_summary <- merged_data%>% 
  group_by(subjectid, activityname) %>% 
  summarize_all(mean)

# remove all data we no longer need from the global environment
rm(list = c("activity_labels", "features", "subject_train", "subject_test",
     "x_train", "x_test", "y_train", "y_test",
     "train_data","test_data"))