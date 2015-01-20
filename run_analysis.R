# Author: Esmit Perez
# Getting and Cleaning Data , Coursera getdata-010
# Date: Jan 18th 2015

library(reshape2)
library(plyr)
library(dplyr)
library(tidyr)
library(stringr)

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

# "borrowed" from the documentation in ?tolower
capwords <- function(s, strict = FALSE) {
        cap <- function(s) paste(toupper(substring(s, 1, 1)),
        {s <- substring(s, 2); if(strict) tolower(s) else s},
        sep = "", collapse = " " )
        sapply(strsplit(s, split = " "), cap, USE.NAMES = !is.null(names(s)))
}

# Utility function to abstract away the data extraction process for each set
obtainDataSet <- function(folder,measurementType, featureNames){
        x <- read.table(file.path(folder,measurementType,paste0("X_",measurementType,".txt")), col.names = featureNames )
        y <- read.table(file.path(folder,measurementType,paste0("y_",measurementType,".txt")), col.names = "activity_id")
        subjects <- read.table(file.path(folder,measurementType,paste0("subject_",measurementType,".txt")), col.names = "subject_id")
        
        # dplyr not useful here since there is no common "key" to merge by, row number assumed to match
        # in each file
        tempData <- cbind(subjects,y,x)
}

# Given a folder it will find the necessary files to create the tidy data sets
createFullDataSet <- function(folder){
        # These goals are not "in order" but the result is the same in the end :)
        
        # "4. Appropriately labels the data set with descriptive variable names."
        # PART 1 , see part 2 below
        # See features_info.txt for more context
        # extracts the features, used to name the columns in the train and test sets
        # R replaces the punctuation marks (ie: "()", "-") with dots (".")
        # so a variable originally named tBodyAcc-mean()-X becomes tBodyAcc.mean...X
        features <- read.table(file.path(folder,"features.txt"), row.names=1, col.names=c("id","name"))
        
        # train and test data sets, joined together
        wholeDataSet <- rbind(obtainDataSet(folder,"test", features$name),
                              obtainDataSet(folder,"train", features$name))

        
        # "1. Merges the training and the test sets to create one data set."
        # Makes the label names "prettier" by removing underscores and capitalizing words
        activity_labels <- read.table(
                                file.path(folder,"activity_labels.txt"), 
                                col.names=c("activity_id","activity_name")) %>%
                                mutate(activity_name = str_replace_all(activity_name,"_"," ") %>% tolower %>% capwords)
        
        # "3. Uses descriptive activity names to name the activities in the data set"
        dataWithActivityLabels <- merge(x=wholeDataSet,y=activity_labels) 
        
        # "2. Extracts only the measurements on the mean and standard deviation for each measurement. "
        # as per the renaming performed by R in obtainDataSet, -mean() and -std() suffixes end up being named 
        # .mean.. and .std.. , so we filter by them
        tidyData <- select(dataWithActivityLabels, subject_id, activity_name, matches("(.mean..|.std..)$"))
       
        # "4. Appropriately labels the data set with descriptive variable names."
        # PART 2, prettyfy the names
        # Will rely on Google's R Style Guide's identifier rules
        # see https://google-styleguide.googlecode.com/svn/trunk/Rguide.xml
        prettyColumnNames <- unlist(lapply(unlist(colnames(tidyData)), 
                      function(x){ 
                              x %>% tolower %>%
                                      str_replace("subject_id", "subject.id") %>% 
                                      str_replace("activity_name", "activity.name") %>% 
                                      str_replace("^t", "time.signal.") %>% 
                                      str_replace("^f","frequency.signal.") %>% 
                                      str_replace("acc",".acceleration.") %>%
                                      str_replace("gyro",".gyroscope.") %>% 
                                      str_replace("mag",".magnitude") %>% 
                                      str_replace(".std..",".std.dev") %>% 
                                      str_replace(".mean..",".mean") %>%
                                      str_replace("\\.\\.","\\.") %>%
                                      str_replace("bodybody", "body")  # remove duplicate names in orig data
                                      
                      }
        ))
        colnames(tidyData) <- prettyColumnNames
        # This yields something like the following:
        #[1] "subject.id"                                                "activity.name"                                            
        #[3] "time.signal.body.acceleration.magnitude.mean"              "time.signal.body.acceleration.magnitude.std.dev"          
     
       
        # "5. From the data set in step 4, creates a second, independent tidy data set with 
        # the average of each variable for each activity and each subject."
        #
        # "group by" subject and activity, pass the resulting groups to summarise_each(), 
        # 
        averagedData <- tidyData %>% group_by(subject.id, activity.name) %>% summarise_each(funs(mean))
        
        # then apply the mean function, then add the suffix .average to every numeric column
        # prepend the 2 columns we excluded from the renaming operation too.
        cn <- setdiff(colnames(averagedData), c("subject.id","activity.name"  ) )        
        colnames(averagedData) <- c("subject.id","activity.name", unlist(lapply(cn, function(x){ paste0(x,".average") })))
        
        # write the file that will be uploaded to coursera
        message("Creating data file with averages data (aka Step 5)...")
        write.table(x=averagedData, file = "averages.txt",row.names = FALSE, )
        
        
        # Returns the generated tidy data set
        tidyData
}

# Run the project using the default base folder, assumes "data/UCI HAR Dataset"
# When called will reload the script in case there were changes to it :)
reload <- function(baseFolder = "data/UCI HAR Dataset"){
        message("Re-sourcing .R file to ensure any changes are applied...")
        source("run_analysis.R")
        message("Done.")
        prepareWorkingDirectory()
        
        # create a tidy data set in the parent environment
        message("Creating data structures...")
        tidyDataSet <<- createFullDataSet(baseFolder)
        
        message("tidyDataSet is now available, type summary(tidyDataSet) to see") 
}

# Upon first invokation of source("run_analysis.R) creates the 
# necessary data structures using default values
# if necessary, one can run reload() again to apply any changes to script
# Note: without the hasBeenRunForFirstTime we'd have infinite recursion, it's a no no.
if (!exists("hasBeenRunForFirstTime")){
        hasBeenRunForFirstTime <<- TRUE
        reload()
}
