# 'Getting and Cleaning Data' Course Project  
by nlypyavka  
July 26, 2020  

## Project goal
As per project instructions:  
*The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.*


## Input Dataset
The [data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) used in this project comes from the accelerometers on a Samsung Galaxy S smartphone from [Human Activity Recognition Using Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)   
The data is spread out across a few different files and must be merged, tidied and summarized to get the output tidy dataset.


## Submitted files:
* 'README.md'

- 'CodeBook.md' a code book that describes the variables, the data, and transformations and work performed to clean up the data

- 'run_analysis.R' performs 5-step data preparation according to the course project assignment:  
    1. Merges the training and the test sets to create one data set.  
  *It first loads & unzips the files, then reads the train data and combines it with corresponding activity & subject data, then reads the test data and combines it with corresponding activity & subject data, and finally merges train and test datasets into one.*  
    2. Extracts only the measurements on the mean and standard deviation for each measurement.  
  *To do that, it first reads the full list of features, then selects only those containing “mean()” or “std()”; finally only the columns with subject number, activity, and selected features are taken to the analysis.*  
    3. Uses descriptive activity names to name the activities in the data set.  
  *For that, it reads activity_labels.txt and then transforms activity variable into factor with 6 levels named according to activity labels.*
    4. Appropriately labels the data set with descriptive variable names.  
  *Applies gsub() function to data names to obtain unified "signal_sourceForce_device_signalType_dimension_measure" structure for further data transformations*
    5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.  
  *Uses aggregate() function to create new data frame. Afterwards uses gather(), separate(), and spread() functions from dplyr package to tidy the data. Applies write.table() to write the final data to txt format.*

- 'TidyData.txt ' is the final dataset obtained at the 5th step of data preparation. In the final tidy dataset, each record is provided:
    1) SubjectNum - an identifier of the subject who carried out the experiment.
    2) Activity – its activity label. 
    3) signal - whether it is time or frequency of signals
    4) sourceForce - whether the signal is attributed to Body or Gravity
    5) device - from which device the data is obtained ("Accelerometer" or "Gyroscope")
    6) signalType - whether it is Raw measurements or derived Jerk signals
    7) dimension - either -XYZ dimensions or calculated Magnitude 
    8) mean - averaged data on means for each "participant-activity" combination
    9) std - averaged data on standard deviations for each "participant-activity" combination

## Review Criteria:
1.	The submitted data set is tidy.
2.	The Github repo contains the required scripts.
3.	GitHub contains a code book that modifies and updates the available codebooks with the data to indicate all the variables and summaries calculated, along with units, and any other relevant information.
4.	The README that explains the analysis files is clear and understandable.
5.	The work submitted for this project is the work of the student who submitted it.
