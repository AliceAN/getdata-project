# Getting and Cleaning Data (getdata-010) - Course Project

_Author_: [Esmit Perez](esmitperez@gmail.com)

_Date_: Jan 18th 2015

## About the script

### Origin dataset

The `run_analysis.R` script pulls the data available from the [Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones), which is a "Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors." This dataset has been made available for download as a [zip file](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

|Number of observations in data set | Number of variables |
|----------------|------------|
| 10299   | 561 |

###Getting and cleaning data procedure

The script assumes the unzipped data resides in a folder called `UCI HAR Dataset` located in the current working directory (`getwd()`). If the folder does not exist it tries to find the data set zip file and if this one is missing it downloads a copy and unzips it. 

1. First `createFullDataSet()` is invoked to run in the default `UCI HAR Dataset` folder, in it `obtainDataSet()` is invoked for `train` and `test` sets from which it determines and merges the following data frames:`x` (measurements for each observation ), `y` (activity being performed when each observation was made) and `subjects` (who was performing the activity).

2. Then `train` and `test` sets are merged, and the variable names are assigned from the values found in the `features.txt` file.

3. Once this is done, the activity names are determined from the mapping available in `activity_labels.txt` and are merged into the data frame created in step #2

4. Only the columns ending in `-std()` and `-mean()` are chosen for the final tidy data set.

5. The column names are rewritten to comply with the _Naming Conventions_ explained below

6. A second, independant tidy data set is created by calculated the mean of every column, after the data has been grouped by `subject.id` and `activity.name`. This data set is stored (via `write.table()` into `data_averages.txt`)

7. `tidyDataSet` is created in the parent environment, making it available for analysis by the user.


###Observations and variables in my tidy dataset

Once the data has been tidied up, the following characteristics are true :

| Tidy data set |Number of observations in data set | Number of variables |
|---------------|----------------|------------|
| `tidyDataSet` | 10299   | 20 |
| `data_averages.txt` (when loaded using `read.table()`) | 180 | 20 |


In order to generate the datasets *ONLY* measurements ending with the suffixes `-std()` and `-mean()` were used, other measurements that contained the word "Mean" or "meanFreq()" were ignored.
```R
# Sample of variables IGNORED to generate data sets
gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean
```

The original variable names were expanded to explicitly and unambiguosly refer to the origin of the data and to be compliant with the _Naming Conventions_:

* prefixes `t` and `f` were expanded to `time.signal` and `frequency.signal`
* _body_ and _gravity_ originated data have kept that designation in the `body` and `gravity` portion of the name
* `mag` has been expanded to `magnitude` to avoid confusion with _magnestism_ or other unrelated nouns
* _Jerk_ was kept as a lowercase single word, `jerk`
* `-std()` suffix has been expanded to `std.dev` to more clearly convey standard deviation
* `-mean()` suffix has been replaced by just `mean`

With the above subsitutions in place, the variable names are now more descriptive, for example:

* `tBodyAccMag-mean()` becomes `time.signal.body.acceleration.magnitude.mean`
* `fBodyAccMag-std()` becomes `frequency.signal.body.acceleration.magnitude.std.dev`
* etc, etc

Activity names were made *friendly* by capitalizing only the first letter in each word and separating phrases by spaces instead of underscores, ie:


| Original value       | New value            |
|----------------------|----------------------|
| `WALKING`            | `Walking`            | 
| `WALKING_UPSTAIRS`   | `Walking Upstairs`   |
| `WALKING_DOWNSTAIRS` | `Walking Downstairs` |
| `SITTING`            | `Sitting`            |
| `STANDING`           | `Standing`           |
| `LAYING`             | `Laying`             |

**Note**: Please consult the [accompanying CodeBook](CodeBook.md) for a description of all variables.


###Naming conventions

The column names in the generated DataFrames follow the identifier rules as suggested on [Google's R Style Guide's](https://google-styleguide.googlecode.com/svn/trunk/Rguide.xml#identifiers). 

The script achieves each goal outlined in the project description slightly out of order, this means goal (step) number 3 is performed before goal (step) number 2 because it makes it easier to achieve the usage of the labels and saves a lot of unneeded temporary variables or transformations.

###Is the data tidy?

Absolutely. It's in wide form, each row contains 18 variables for each unique subject/activiy observation.

For more context on this please see the discussion thread in the [Coursera Forum for the Project](https://class.coursera.org/getdata-010/forum/thread?thread_id=241)




## Running the script

* Clone the project from Github

```bash
git clone https://github.com/esmitperez/getdata-project.git
```

* In R or R Studio set your working directory to the folder where the project was cloned into

```R
setwd("/PATH/TO/PROJECT")
```

* Source the project, this will **AUTOMATICALLY** download the data file and create a data folder if necessary. It wil also create a file named `data_averages.txt` containing the tidy data set requested in step number 5 of the project

 _Note_: If you wish to NOT have the script automatically perform the downloads set `hasBeenRunForFirstTime <- TRUE` before sourcing the file, then invoke `reload()` when ready to download them.

```R
source("run_analysis.R")
```

* The output should read:

```R
Re-sourcing .R file to ensure any changes are applied...
Done.
Creating data structures...
Creating data file with averages data (aka Step 5)...
tidyDataSet is now available, type summary(tidyDataSet) to see
```

## Viewing the data
5. At this moment you may peruse the `tidyDataSet` data frame created from the data files in the .zip
```R
> dim(tidyDataSet)
[1] 10299    20
```
6. **OR** Load the `data_averages.txt` file to view the tidy data set created for Step 5.
```R
r <- read.table("data_averages.txt", header = TRUE)
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

