Data Dictionary `tidyDataSet` 

**Note**: Variable names in `data_averages.txt` are the same as in `tidyDataSet` but they add the suffix `.average` and their data is an average of each of the numeric columns, grouped by `subject.id` and `activity.name`

| Variable name | Description |
|---------------|-------------|
|`subject.id` | Identifies the subject who performed the activity for each window sample. Range is 1 to 30 |
|`activity.name` | Activity name, words are capitalized and separated by spaces, possible values: `Walking, Walking Upstairs,Walking Downstairs,Sitting,Standing,Laying`|        
|`time.signal.body.acceleration.magnitude.mean` | Mean of body linear acceleration magnitude using the Euclidean norm |
|`time.signal.body.acceleration.magnitude.std.dev` |Standard deviation of body linear acceleration magnitude using the Euclidean norm |
|`time.signal.gravity.acceleration.magnitude.mean` | Mean of gravity linear acceleration magnitude using the Euclidean norm|
|`time.signal.gravity.acceleration.magnitude.std.dev` |Standard deviation of gravity linear acceleration magnitude using the Euclidean norm |
|`time.signal.body.acceleration.jerk.magnitude.mean` | Mean of jerk (body linear acceleration and angular velocity derived in time) magnitude using the Euclidean norm |
|`time.signal.body.acceleration.jerk.magnitude.std.dev` |  Standard deviation of jerk (body linear acceleration and angular velocity derived in time) magnitude using the  Euclidean norm |
|`time.signal.body.gyroscope.magnitude.mean` | Mean of body linear angular magnitude using the Euclidean norm |
| `time.signal.body.gyroscope.magnitude.std.dev` | Standard deviation of body linear angular magnitude using the Euclidean norm |
|`time.signal.body.gyroscope.jerk.magnitude.mean` | Mean of jerk (body linear acceleration and angular velocity derived in time) magnitude using the Euclidean norm |
|`time.signal.body.gyroscope.jerk.magnitude.std.dev` | Standard deviation of jerk (body linear acceleration and angular velocity derived in time) magnitude using the Euclidean norm |
|`frequency.signal.body.acceleration.magnitude.mean` | Mean of Fast Fourier Transform (FFT) of body linear acceleration magnitude using the Euclidean norm |
|`frequency.signal.body.acceleration.magnitude.std.dev` | Standard deviation of Fast Fourier Transform (FFT) of body linear acceleration magnitude using the Euclidean norm |
|`frequency.signal.body.acceleration.jerk.magnitude.mean` | Mean of Fast Fourier Transform (FFT) of jerk (body linear acceleration and angular velocity derived in time) magnitude using the Euclidean norm |
|`frequency.signal.body.acceleration.jerk.magnitude.std.dev` | Standard deviation of Fast Fourier Transform (FFT) of jerk (body linear acceleration and angular velocity derived in time) magnitude using the Euclidean norm |
|`frequency.signal.body.gyroscope.magnitude.mean` | Mean of Fast Fourier Transform (FFT) of body linear angular magnitude using the Euclidean norm |
|`frequency.signal.body.gyroscope.magnitude.std.dev` | Standard deviation of Fast Fourier Transform (FFT) of body linear angular magnitude using the Euclidean norm |
|`frequency.signal.body.gyroscope.jerk.magnitude.mean` | Mean of Fast Fourier Transform (FFT) of jerk (body linear acceleration and angular velocity derived in time) magnitude using the Euclidean norm |
|`frequency.signal.body.gyroscope.jerk.magnitude.std.dev` | Standard deviation of Fast Fourier Transform (FFT) of jerk (body linear acceleration and angular velocity derived in time) magnitude using the Euclidean norm |