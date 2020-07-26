title: "Codebook"  
author: "nlypyavka"  
date: "July 26, 2020"  

# Getting and Cleaning Data Project codebook
Below are the descriptions of data inputs, performed transformations, and resulting datasets.

## Input Dataset
The [data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) used in this project comes from the accelerometers on a Samsung Galaxy S smartphone from [Human Activity Recognition Using Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)   


The data is spread out across a few different files:   

- Train data is given in three files to be merged:  
    i. "x_train.txt" – train data measurements  
    ii. "y_train.txt" – activities corresponding to train data  
    iii. "subject_train.txt" – subject number associated with the train data  
- Test data is provided in the same structure as the train data:  
    i. "x_test.txt" – test data measurements  
    ii. "y_test.txt" – corresponding activities 
    iii. "subject_test.txt" – associated subject number  
- Apart that additional information is provided in  
	  i. “activity_labels.txt” – full list of captured activities  
	  ii. “features.txt” – full list of measurements taken  

## Transformations
1. Merge the training and the test sets to create one data set.  
    - Use download.file() together with unzip() function to download the zip file from website to working directory on the computer.  
    - Use read.table() function to read "X_train.txt", "y_train", "subject_train"; use cbind() to create one dataset on train data (train.all).  
    - Use read.table() function to read "X_test.txt", "y_test", "subject_test"; use cbind() to create one dataset on test data (test.all).  
    - Use rbind() to merge train and test data together (data.all).
2. Extract only the measurements on the mean and standard deviation for each measurement.
    - Use read.table() to load "features.txt" into R.
    - Use grep() to find the indexes with "mean()" and "std()".
    - Subset only the needed columns (subject number, activity, and selected features) into the data.cut
    - Provide the columns names to data.cut
3. Uses descriptive activity names to name the activities in the data set
    - Use read.table() to load "activity_labels.txt".
    - Use factor() with arguments "levels = " and "labels = " to transforms “Activity” variable into factor with 6 levels named according to activity labels
4. Appropriately labels the data set with descriptive variable names
    - Use gsub() to data names to obtain unified "signal_sourceForce_device_signalType_dimension_measure" structure for further data transformations
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
    - Use aggregate() function to create new data frame. 
    - Afterwards use gather(), separate(), and spread() functions from dplyr package to tidy the data. 
    - Apply write.table() to write the final data to txt format.

## Variables
| Variable | Comments |
|------:|:-------------------------|
| SubjectNum | an identifier of the subject who carried out the experiment <br> factor variable with the levels 1 to 30  
| Activity | name of activity subject performed <br> factor variable <br>1 LAYING <br> 2 SITTING <br>3 STANDING <br>4 WALKING<br>5 WALKING_DOWNSTAIRS <br>6 WALKING_UPSTAIRS)|
| signal |	whether it is time or frequency of signals <br> factor variable <br>1 time <br>2 frequency (derived) |
| sourceForce	| whether the signal is attributed to Body or Gravity <br> factor variable <br>1 Body <br>2 Gravity |
| device | from which device the data is obtained <br> factor variable <br>1 Accelerometer <br>2 Gyroscope |
| signalType	| whether it is measurements or derived Jerk signals <br> factor variable <br>1 Raw data signals <br>2 Derived Jerk signals |
| dimension	| either -XYZ dimensions or calculated magnitude <br> factor variable <br>1 X-axis <br>2 Y-axis <br>3 Z-axis <br>4 Magnitude (calculated) |
| mean | averaged data on means for each "participant-activity" combination <br>(from variables containing “mean()”) <br> numeric <br> normalized and bounded within [-1,1] |
| std	| averaged data on standard deviations for each "participant-activity" combination <br>(from variables containing “std()”) <br> numeric |
