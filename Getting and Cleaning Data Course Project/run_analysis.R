#create one R script called run_analysis.R that does the following.

# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set 
#  with the average of each variable for each activity and each subject.


# 1. Get the data
library(data.table)

path <- getwd()

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, file.path(path, "dataFiles.zip"))
unzip(zipfile = "dataFiles.zip")

list.files()
list.files("./UCI HAR Dataset")

#2 list of activities
activities <- fread(file.path(path, "UCI HAR Dataset/activity_labels.txt"))
colnames(activities) <- c("activity.num", "activity.label")

#3 list of features
features <- fread(file.path(path, "UCI HAR Dataset/features.txt"))
colnames(features) <- c("feature.num", "feature.label")

features.in.num <- grep('(mean|std)\\(',features[,feature.label]) # for subsetting columns
features.in <- features[grep('(mean|std)\\(',features[,feature.label])]
features.in$feature.label <- gsub('[()]','', features.in$feature.label) # for columns names

#4 train data
list.files("./UCI HAR Dataset")
list.files("./UCI HAR Dataset/train")
train.data <- fread(file.path(path, "UCI HAR Dataset/train/X_train.txt"))[,..features.in.num]
colnames(train.data) <- features.in$feature.label

train.activities <- fread(file.path(path, "UCI HAR Dataset/train/Y_train.txt"))
colnames(train.activities) <- c("activity")

train.subjects <- fread(file.path(path, "UCI HAR Dataset/train/subject_train.txt"))
colnames(train.subjects) <- c("subject.num")

train.all <- cbind(train.subjects, train.activities, train.data)

#5 test data
list.files("./UCI HAR Dataset")
list.files("./UCI HAR Dataset/test")
test.data <- fread(file.path(path, "UCI HAR Dataset/test/X_test.txt"))[,..features.in.num]
colnames(test.data) <- features.in$feature.label

test.activities <- fread(file.path(path, "UCI HAR Dataset/test/Y_test.txt"))
colnames(test.activities) <- c("activity")

test.subjects <- fread(file.path(path, "UCI HAR Dataset/test/subject_test.txt"))
colnames(test.subjects) <- c("subject.num")

test.all <- cbind(test.subjects, test.activities, test.data)

#6 merge files
data.all <- rbind(train.all,test.all)

data.all$subject.num <- factor(data.all$subject.num)

data.all$activity <- factor(data.all$activity
                                   , levels = activities$activity.num
                                   , labels = activities$activity.label)

#7 new dataset
data.new <- aggregate(. ~ subject.num+activity, data.all, mean)

write.table(data.new, "My.Tidy.Data.txt", row.name=FALSE) 

