# Getting and Cleaning Data (getdata-010) - Course Project

_Author_: Esmit Perez

_Date_: Jan 18th 2015

## Running the script

1. Clone the project from Github
```bash
git clone https://github.com/esmitperez/getdata-project.git
```
2. In R or R Studio set your working directory to the folder where the project was clone into
```R
setwd("/PATH/TO/PROJECT")
```
3. Source the project, this will **AUTOMATICALLY** download the data file and create a data folder, if the data is not already present with the name data.zip. It wil also create a file named ```averages.txt``` containing the tidy data set requested in step number 5 of the project
```R
source("run_analysis.R")
```
4. The output should read:
```R
Re-sourcing .R file to ensure any changes are applied...
Done.
Creating data structures...
Creating data file with averages data (aka Step 5)...
tidyDataSet is now available, type summary(tidyDataSet) to see
```

## Viewing the data
5. At this moment you may peruse the ```tidyDataSet``` data frame created from the data files in the .zip
6. **OR** Load the ```averages.txt``` file to view the tidy data set created for Step 5.
```R
r <- read.table("averages.txt", header = TRUE)
```

You can then view its contents:

```R
> nrow(r)
[1] 180
> colnames(r)
 [1] "subject.id"                                                       
 [2] "activity.name"                                                    
 [3] "time.signal.body.acceleration.magnitude.mean.average"             
 [4] "time.signal.body.acceleration.magnitude.std.dev.average"          
 [5] "time.signal.gravity.acceleration.magnitude.mean.average"          
 [6] "time.signal.gravity.acceleration.magnitude.std.dev.average"       
 [7] "time.signal.body.acceleration.jerk.magnitude.mean.average"        
 [8] "time.signal.body.acceleration.jerk.magnitude.std.dev.average"     
 [9] "time.signal.body.gyroscope.magnitude.mean.average"                
[10] "time.signal.body.gyroscope.magnitude.std.dev.average"             
[11] "time.signal.body.gyroscope.jerk.magnitude.mean.average"           
[12] "time.signal.body.gyroscope.jerk.magnitude.std.dev.average"        
[13] "frequency.signal.body.acceleration.magnitude.mean.average"        
[14] "frequency.signal.body.acceleration.magnitude.std.dev.average"     
[15] "frequency.signal.body.acceleration.jerk.magnitude.mean.average"   
[16] "frequency.signal.body.acceleration.jerk.magnitude.std.dev.average"
[17] "frequency.signal.body.gyroscope.magnitude.mean.average"           
[18] "frequency.signal.body.gyroscope.magnitude.std.dev.average"        
[19] "frequency.signal.body.gyroscope.jerk.magnitude.mean.average"      
[20] "frequency.signal.body.gyroscope.jerk.magnitude.std.dev.average"   
```

## About the script

###Naming conventions

The column names in the generated DataFrames follow the identifier rules as suggested on [Google's R Style Guide's](https://google-styleguide.googlecode.com/svn/trunk/Rguide.xml#identifiers). 

The script achieves each goal outlined in the project description slightly out of order, this means goal (step) number 3 is performed before goal (step) number 2 because it makes it easier to achieve the usage of the labels and saves a lot of unneeded temporary variables or transformations.

###Is the data tidy?

Absolutely. It's in wide form, each row contains 18 variables for each unique subject/activiy observation.

For more context on this please see the discussion thread in the [Coursera Forum for the Project](https://class.coursera.org/getdata-010/forum/thread?thread_id=241)

###Data cleanup and merging

In order to generate the datasets *ONLY* measurements ending with the suffixes `-std()` and `-mean()` were used, other measurements that contained the word "Mean" or "meanFreq()" were ignored.
```R
# Sample of variables IGNORED to generate data sets
gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean
```

The original variable names were expanded to explicitly and unambiguosly refer to the origin of the data and to be compliant with the naming conventions above:

* prefixes `t` and `f` were expanded to `time.signal` and `frequency.signal`
* body and gravity originated data have kept that designation
* `mag` has been expanded to `magnitude` to avoid confusion with `magnestism` or other unrelated nouns
* `Jerk` was kept as a single word.
* `-std()` suffix has been expanded to `std.dev` to more clearly convey standard deviation
* `-mean()` suffix has been replaced by just `mean`

With the above subsitutions in place, the variable names are now more descriptive, for example:

* `tBodyAccMag-mean()` becomes `time.signal.body.acceleration.magnitude.mean`
* `fBodyAccMag-std()` becomes `frequency.signal.body.acceleration.magnitude.std.dev`
* etc, etc

Activity names were made *friendly* by capitalizing only the first letter in each word and separating phrases by spaces instead of underscores, ie:

| Original value       | New value            |
|----------------------|---------------------:|
| `WALKING`            | `Walking`            | 
| `WALKING_UPSTAIRS`   | `Walking Upstairs`   |
| `WALKING_DOWNSTAIRS` | `Walking Downstairs` |
| `SITTING`            | `Sitting`            |
| `STANDING`           | `Standing`           |
| `LAYING`             | `Laying`             |

**Note**: Please consult the [accompanying CodeBook](CodeBook.md) for a description of all variables.

