#create one R script called run_analysis.R that does the following.

# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set 
#  with the average of each variable for each activity and each subject.


## 1. Merge the training and the test sets to create one data set
# 1.1 Get the data
library(data.table)

path <- getwd()

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, file.path(path, "dataFiles.zip"))
unzip(zipfile = "dataFiles.zip")

list.files()
list.files("./UCI HAR Dataset")

#1.2 train data
list.files("./UCI HAR Dataset/train")
train.data <- read.table("./UCI HAR Dataset/train/X_train.txt")
train.activities <- read.table("./UCI HAR Dataset/train/Y_train.txt")
train.subjects <- read.table("./UCI HAR Dataset/train/subject_train.txt")
train.all <- cbind(train.subjects, train.activities, train.data)

#1.3 test data
list.files("./UCI HAR Dataset/test")
test.data <- read.table("./UCI HAR Dataset/test/X_test.txt")
test.activities <- read.table("./UCI HAR Dataset/test/Y_test.txt")
test.subjects <- read.table("./UCI HAR Dataset/test/subject_test.txt")
test.all <- cbind(test.subjects, test.activities, test.data)

#1.4 merge files
data.all <- rbind(train.all,test.all)


## 2. Extract only the measurements on the mean and standard deviation for each measurement
#2.1 list of features
features <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)[,2]

#2.2 select only required columns 
features.in <- grep('(mean|std)\\(\\)',features)
data.cut <- data.all[,c(1,2, features.in+2)]
colnames(data.cut) <- c("SubjectNum", "Activity", features[features.in])  


## 3. Use descriptive activity names to name the activities in the data set
#3.1 list of activities
activities <- read.table("./UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)

#3.2 name the activities
data.cut$Activity <- factor(data.cut$Activity, levels = activities$V1, labels = activities$V2)

names(data.cut)

# 4. Appropriately label the data set with descriptive variable names
names(data.cut) <- gsub("[()]", "", names(data.cut))  
names(data.cut) <- gsub("^t", "time_", names(data.cut))  
names(data.cut) <- gsub("^f", "frequency_", names(data.cut))  
names(data.cut) <- gsub("BodyAcc", "Body_Acc", names(data.cut))  
names(data.cut) <- gsub("GravityAcc", "Gravity_Acc", names(data.cut))  
names(data.cut) <- gsub("BodyBody", "Body", names(data.cut))  
names(data.cut) <- gsub("BodyGyro", "Body_Gyro", names(data.cut))  
names(data.cut) <- gsub("GravityGyro", "Gravity_Gyro", names(data.cut))  

names(data.cut) <- gsub("-mean-X", "_X_mean", names(data.cut)) 
names(data.cut) <- gsub("-mean-Y", "_Y_mean", names(data.cut)) 
names(data.cut) <- gsub("-mean-Z", "_Z_mean", names(data.cut)) 
names(data.cut) <- gsub("-std-X", "_X_std", names(data.cut)) 
names(data.cut) <- gsub("-std-Y", "_Y_std", names(data.cut)) 
names(data.cut) <- gsub("-std-Z", "_Z_std", names(data.cut)) 
names(data.cut) <- gsub("-mean", "_mean", names(data.cut)) 
names(data.cut) <- gsub("-std", "_std", names(data.cut)) 

names(data.cut) <- gsub("Acc_X", "Accelerometer_Raw_X", names(data.cut)) 
names(data.cut) <- gsub("Acc_Y", "Accelerometer_Raw_Y", names(data.cut)) 
names(data.cut) <- gsub("Acc_Z", "Accelerometer_Raw_Z", names(data.cut)) 
names(data.cut) <- gsub("AccMag", "Accelerometer_Raw_Magnitude", names(data.cut)) 
names(data.cut) <- gsub("AccJerkMag", "Accelerometer_Jerk_Magnitude", names(data.cut)) 
names(data.cut) <- gsub("AccJerk", "Accelerometer_Jerk", names(data.cut)) 

names(data.cut) <- gsub("Gyro_X", "Gyroscope_Raw_X", names(data.cut)) 
names(data.cut) <- gsub("Gyro_Y", "Gyroscope_Raw_Y", names(data.cut)) 
names(data.cut) <- gsub("Gyro_Z", "Gyroscope_Raw_Z", names(data.cut)) 
names(data.cut) <- gsub("GyroMag", "Gyroscope_Raw_Magnitude", names(data.cut))
names(data.cut) <- gsub("GyroJerkMag", "Gyroscope_Jerk_Magnitude", names(data.cut)) 
names(data.cut) <- gsub("GyroJerk", "Gyroscope_Jerk", names(data.cut)) 
 

names(data.cut)

#5 new dataset
data.new <- aggregate(. ~ SubjectNum+Activity, data.cut, mean)
library(dplyr)
data.new <- data.new %>%
  gather(signal_sourceForce_device_signalType_dimension_measure, count, -SubjectNum, -Activity) %>%
  separate(col = signal_sourceForce_device_signalType_dimension_measure
           , into = c("signal", "sourceForce", "device", "signalType", "dimension", "measure"))  %>%
  spread(key=measure, value=count)

data.new$SubjectNum <- factor(data.new$SubjectNum)
data.new$signal <- factor(data.new$signal, levels = c("time", "frequency"))
data.new$sourceForce <- factor(data.new$sourceForce)
data.new$device <- factor(data.new$device)
data.new$signalType <- factor(data.new$signalType, levels = c("Raw", "Jerk"))
data.new$dimension <- factor(data.new$dimension, levels = c("X", "Y", "Z", "Magnitude"))
str(data.new)

write.table(data.new, "TidyData.txt", row.name=FALSE) 

