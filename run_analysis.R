# Author: Esmit Perez
# Getting and Cleaning Data , Coursera getdata-010
# Date: Jan 18th 2015

library(plyr)
library(dplyr)

# Get the necessary data, if missing, and extracts the files into a "data" folder in the current working directory
prepareWorkingDirectory <- function(){
        if ( !file.exists("data.zip")){
                message("Downloading file...")
                download.file(url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
                              destfile = "data.zip", 
                              method = "curl",)    
                message("Unzipping data.zip into 'data' folder...")
                unzip(zipfile = "data.zip",exdir = "data")
                
                message("Done.")
        }
}

# Utility function to abstract away the data extraction process for each set
obtainDataSet <- function(folder,measurementType, featureNames){
        x <- read.table(file.path(folder,measurementType,paste("X_",measurementType,".txt", sep = "")), col.names = featureNames )
        y <- read.table(file.path(folder,measurementType,paste("y_",measurementType,".txt", sep = "")), col.names = "activity_id")
        subjects <- read.table(file.path(folder,measurementType,paste("subject_",measurementType,".txt", sep="")), col.names = "subject_id")
        
        # These files are the ones that according to README.txt were used to
        # calculate the values in y.txt
        # commented out since they're not necessary for the tidy data set
        # body_acc_x <- read.table(file.path(folder,measurementType,"Inertial Signals",paste("body_acc_x_",measurementType,".txt",sep="")))
        # body_acc_y <- read.table(file.path(folder,measurementType,"Inertial Signals",paste("body_acc_y_",measurementType,".txt", sep="")))
        # body_acc_z <- read.table(file.path(folder,measurementType,"Inertial Signals",paste("body_acc_z_",measurementType,".txt",sep="")))
        
        # body_gyro_x <- read.table(file.path(folder,measurementType,"Inertial Signals",paste("body_gyro_x_",measurementType,".txt",sep="")))
        # body_gyro_y <- read.table(file.path(folder,measurementType,"Inertial Signals",paste("body_gyro_y_",measurementType,".txt",sep="")))
        # body_gyro_z <- read.table(file.path(folder,measurementType,"Inertial Signals",paste("body_gyro_z_",measurementType,".txt",sep="")))
        
        # total_acc_x <- read.table(file.path(folder,measurementType,"Inertial Signals",paste("total_acc_x_",measurementType,".txt",sep="")))
        # total_acc_y <- read.table(file.path(folder,measurementType,"Inertial Signals",paste("total_acc_y_",measurementType,".txt",sep="")))
        # total_acc_z <- read.table(file.path(folder,measurementType,"Inertial Signals",paste("total_acc_z_",measurementType,".txt",sep="")))
        
        # dplyr not useful here since there is no common "key" to merge by, row number assumed to match
        # in each file
        tempData <- cbind(subjects,y,x)
}

# Given a folder it will find the necessary files to create the tidy data sets
createFullDataSet <- function(folder){
        # extracts the features, used to name the columns in the train and test sets
        features <- read.table(file.path(folder,"features.txt"), row.names=1, col.names=c("id","name"))
        
        # both data sets, joined together
        wholeDataSet <- rbind(obtainDataSet(folder,"test", features$name),
                              obtainDataSet(folder,"train", features$name))

        # These steps are not "in order" but the result is the same in the end :)
        # "1. Merges the training and the test sets to create one data set."
        activity_labels <- read.table(file.path(folder,"activity_labels.txt"), col.names=c("activity_id","activity_name"))
        
        # "3. Uses descriptive activity names to name the activities in the data set"
        dataWithActivityLabels <- merge(x=wholeDataSet,y=activity_labels) 
        
        # "2. Extracts only the measurements on the mean and standard deviation for each measurement. "
        tidyData <- select(dataWithActivityLabels, subject_id, activity_name, matches("(mean|std)"))
        
        # "4. Appropriately labels the data set with descriptive variable names."
        
        # Returns the generated tidy data sets
        list(tidyData=tidyData, w=wholeDataSet, l=activity_labels, f=features)
}

# Run the project using the default base folder, assumes "data/UCI HAR Dataset"
# When called will reload the script in case there were changes to it :)
reload <- function(baseFolder = "data/UCI HAR Dataset"){
        source("run_analysis.R")
        prepareWorkingDirectory()
        
        # create a tidy data set in the parent environment
        message("Creating data structures...")
        tidyDataSets <<- createFullDataSet(baseFolder)
        
        message("tidyDataSets is now available, displaying its summary")
        summary(tidyDataSets)
}

# Upon first invokation of source("run_analysis.R) creates the 
# necessary data structures using default values
# if necessary, one can run reload() again to apply any changes to script
# Note: without the hasBeenRunForFirstTime we'd have infinite recursion, it's a no no.
if (!exists("hasBeenRunForFirstTime")){
        hasBeenRunForFirstTime <<- TRUE
        reload()
}
