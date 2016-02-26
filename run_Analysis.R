
library(plyr)

# get local path
lpath <- getwd()

## ****************************************
## FUNCTION DEFINITIONS
## getTable - Function to read txt file and convert to a data frame
## getData - Combine subject, x, and y data into a single table
## saveFile - Saves the data frame into the output folder

## Function to read txt file and convert to a data frame
getTable <- function (filename,cols = NULL){
    print(paste("Getting table:", filename))
    f <- paste(datafolder,filename,sep="/")
    data <- data.frame()
    if(is.null(cols)){
        data <- read.table(f,sep="",stringsAsFactors=F)
    } else {
        data <- read.table(f,sep="",stringsAsFactors=F, col.names= cols)
    }
    data
}

## Combine subject, x, and y data into a single table
getData <- function(type, features){
    print(paste("Getting data", type))
    subject_data <- getTable(paste(type,"/","subject_",type,".txt",sep=""),"id")
    y_data <- getTable(paste(type,"/","y_",type,".txt",sep=""),"activity")
    x_data <- getTable(paste(type,"/","X_",type,".txt",sep=""),features$V2)
    return (cbind(subject_data,y_data,x_data))
}

## Saves the data frame into the output folder
saveFile <- function (data,name){
    myfile <- paste(outputfolder, "/", name,".csv" ,sep="")
    
    if(file.exists(myfile)){
        print(paste(myfile, "exists! Please remove and rerun."))
        stop('File already existing')
    } else {
        print(paste("Saving data to", myfile))
        write.csv(data,file.path(lpath,myfile))
    }
}
## ****************************************

# Download data file if not downloaded
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
file <- "data.zip"
if(!file.exists(file)){
    print("Downloading input file ...")
    download.file(url, file.path(lpath, file), method="libcurl")
} else {
    print("File already downloaded! Continuing...")
}

# Unzip data file if not unzipped
datafolder <- "UCI HAR Dataset"
if(!file.exists(datafolder)){
    print("Unzipping file ...")
    unzip(file, list = FALSE, overwrite = TRUE)
} else {
    print("Unzipped folder exists. Continuing...")
}

# Create output folder if not existing
outputfolder <- "Output"
if(!file.exists(outputfolder)){
    print("Create Output folder")
    dir.create(file.path(lpath, outputfolder))
} else {
    print("Output folder already exists. Continuing...")
}

# Load column labels from the features.txt
features <- getTable("features.txt")

# Load test and train data from the subfolders
test <- getData("test", features)
train <- getData("train", features)

# Merge data and arrange by id 
print("1) Merge Test and Train Data")
allData <- arrange(rbind(test, train), id)

# Optional: Save combined data into a csv file
#saveFile(allData, "combined")

# id + activity + use the grep function to extract col names with 'std' and 'mean'
print("2-4) Extracting std dev and mean measurements")
data.stats <- allData[,c(1,2,grep("std", colnames(allData)), grep("mean", colnames(allData)))]
 
# Load the activity labels from the file and replace values in the table
activity_labels <- getTable("activity_labels.txt")
data.stats$activity <- factor(data.stats$activity, levels=activity_labels$V1, labels=activity_labels$V2)

saveFile(data.stats, "std_mean_data")

# Use ddply function from plyr to split the data frame by id and activity and apply 
# an anonymous function to calculate the mean
print("5) Calculate  average of each variable for each activity and each subject")
data.average <- ddply(data.stats, .(id, activity), .fun=function(x){ colMeans(x[,-c(1:2)]) })
colnames(data.average)[-c(1:2)] <- paste("mean_", colnames(data.average)[-c(1:2)], sep="")

saveFile(data.average, "ave_byactivity_bysubject")

# Save column names as a text file to help build the code book
# For mean and std table
cat("Column names for Std dev and mean measurements", file="col_names.txt", sep = "\n")
cat(colnames(data.stats), file="col_names.txt", append = TRUE, sep = "\n")

# For average table
cat("********************", file="col_names.txt", append = TRUE, sep = "\n")
cat("Average by activity and subject", file="col_names.txt", append = TRUE, sep = "\n")
cat(colnames(data.average), file="col_names.txt", append = TRUE, sep = "\n")

