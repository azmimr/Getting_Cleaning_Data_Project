# Getting_Cleaning_Data_Project
Final course project for Coursera's "Getting and Cleaning Data" course

## Objectives of Project
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Background
One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies
like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from
the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is 
available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

## Description of scripts

Only one R script is in this project **run_Analysis.R**

**Library required**: plyr

**Output**: 2 csv files saved in the 'Output' subfolder
  - std_mean_data.csv: Combined test and training datasets with mean and 
    std dev measurements
  - ave_byactivity_bysubject.csv: Calculated from above file, averaged
    measurement values by acivity (6 types) and subject (30 subjects)

### To Run
```
> source("run_Analysis.R")
```

### Script Workflow
1. Load plyr library
2. Gets the working directory path. All files created will be relative to this path
3. Download zipped dataset if not downloaded. URL to dataset has been hardcoded. 
4. Unzip dataset. Skips if 'UCI HAR Dataset' already exists i.e. previously unzipped
5. Creates the 'Output' subfolder if not previously created
6. From the original data load:
  1. features.txt - which contains the variable labels for the final table
  2. Test and Train datasets (subject_test, x_test, y_test) loaded seperately. The 3 files from each set are combined by columns and variable labels(column names) are set using the 'features' list.
7. The test and train datasets are combined by rows into a single table *allData*. This has 10299 observations of 563 variables.
8. Optional: Save the combined table (code commented out)
9. In addition to id and activity, columns whose label contain 'std' and 'mean' are extracted into another table *data.stats*.
10. Table is saved as *std_mean_data.csv*
11. Using *dpply* function, the table is then split by id and activity. An anonymous function is applied to calculate the mean of the columns. Result is put into a new table *data.average*
12. Table is saved as *ave_byactivity_bysubject.csv*
13. Extra: The column names from *data.stats* and *data.average* are output to a text file to help build the codebook.

Progress for the script is shown via messages printed on the STDOUT for the main steps described above. 

Script will stop if any of the output files already exist. Please remove and rerun.
