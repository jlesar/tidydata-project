<h1>Codebook</h1>
<h2>Project Description</h2>
This project was undertaken for the completion of the Coursera "Getting and Cleaning Data" course. Per the course project assignment, the "purpose of this project is to demonstrate [the] ability to collect, work with, and clean a [specific] data set." The data set in question consisted of a series of text files, elaborated on below, which has been manipulated as explained in the steps below to produce a tidy, R-readable data set consisting of the average means and standard deviations for each of a number of variables, by subject and activity. 

<h2>Study design and data processing</h2>

<h3>Collection of the raw data</h3>

The raw data was collected by researchers in Italy, who performed some calculations (detailed in their own README file in the data folder linked to below) to arrive at the dataset used for this project. That dataset (as well as the README and other relevant files and contextual information) was and can be obtained from the UCI Machine Learning Repository at http://archive.ics.uci.edu/ml/datasets/Smartphone-Based+Recognition+of+Human+Activities+and+Postural+Transitions 


<h3>Notes on the original (raw) data</h3>
--The unzipped raw data files are in text (.txt) format, and do not have headers.<br/>
--The downloaded data set unzips to the following set of files:<br/>
<ul>
<li>activity_labels.txt: matches the numeric values 1-6 with the activity represented (sitting, standing, lying, walking, walking upstairs, walking downstairs)</li>

<li>features.txt: matches the numeric values 1-561 with the 561 "features" (measurement labels) recorded for each action or posture, e.g., "tBodyAcc-mean()-x".</li>

<li>features_info.txt: describes how measurements for the 561 features were obtained/calculated.</li>

<li>README.txt: contains background and contextual information about the experiment, method, variables, and files contained in the dataset package.</li>

<li>and two subfolders, "test" and "train", each of which contain three files: 

<ul>
<li>subject_test (subject_train): "Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30." (From the original data README.txt) </li>

<li>X_test (X_train): values for each of the 561 features, by time-window observation [X_test: 2947 rows; X_train: 7352 rows]</li>

<li>y_test (y_train): a list of numbers representing the activity undertaken by the subject for that observation  [y_test: 2947 rows; X_test: 2947 rows]
</li> </ul>
</li></ul>

<h2>Creating the tidy datafile</h2>

<h3>Guide to create the tidy data file</h3>

<ol> 
<li>Download the data at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip </li>

<li>Unzip the data package; set working directory to the resulting "UCI HAR Dataset" folder.</li>

<li>Run "run_analysis.R" in directory where files have been extracted/downloaded. </li>
</ol>
--The accompanying <a href="https://github.com/jlesar/tidydata-project/blob/master/run_analysis.R">run_analysis.R</a> file handles the steps enumerated in the <a href="https://github.com/jlesar/tidydata-project/blob/master/README.md">README.md</a> file to create tidy dataset "tidyfinal", meeting the criteria specified above. -- 

To open the attached tidyfinal dataset without running the script:<br/>
data <- read.table("tidyfinal", header = TRUE)
View(data)
 

<h3>Cleaning of the data</h3>

The run_analysis.R script combines the six pertinent text files from the original data package into a dataframe, extracts the variables measuring mean and standard variation, and transforms the data into a narrower set by presenting those variables as a single variable ("measurement"). It then applies labels and takes the average of the means and standard deviations for each measurement, so that the final tidy dataset ("tidyfinal") gives the average of each mean and standard deviation for each activity and each subject.

The <a href="https://github.com/jlesar/tidydata-project/blob/master/README.md">README.md file</a> describes the code in greater detail.

<h2>About the tidyfinal file</h2>

Tidyfinal is a dataframe:
<ul>
<li>Consisting of 5940 observations of 5 variables </li>
<li>Representing 30 subjects engaged in 6 different activities and the average mean and average standard deviation of 66 observed measures for each </li>  
</ul>
<h3>Variables</h3>
<ul>
<li>subject: integer variable identifying the subject that performed the activity; ranges from 1-30. Obtained from subject_test.txt and subject_train.txt.</li>

<li>activity: character variable representing the activity being performed by subject. For each observation, one of: standing, sitting, lying, walking, walkingupstairs, walkingdownstairs. Obtained from y_test.txt and y_train.txt.</li>

<li>measurement: character variable representing the kind of measurement taken. Obtained from features.txt. Measurement naming pattern consists of up to six parts as follows:
<ol>
<li>"t" or "f". Entries starting with "t" represent time domain signals; "f" represents frequency domain signals.</li>
<li>"Body" or "Gravity". Represents body acceleration or gravity acceleration. </li>
<li>"Acc" or "Gyro". Denotes whether the signals were obtained by accelerometer or gyroscope. </li>
<li>"Jerk" (opt.). Represents a body Jerk signal, either as linear acceleration (BodyAccJerk) or angular velocity (BodyGyroJerk). </li>
<li>"Mag" (opt.). Represents magnitude, calculated using the Euclidean norm.</li>
<li>-X/Y/Z (opt.). Denotes 3-axial signals in the respective directions. </li>
</ol></li>
<li>avemean: numeric variable representing the mean of the mean values for a given measurement, per subject and activity combination. Calculated from the individual standard deviation values for each selected measurement. Measurements were normalized and bounded within [-1, 1] as part of the original dataset. "Acc" measurement units are in 'g's (gravity of earth -> 9.80665 m/seg2); "Gyro" measurement units are are rad/seg.</li> 

<li>avestddev: numeric variable representing the mean of the standard deviations for a given measurement, per subject and activity combination. Calculated from the individual standard deviation values for each selected measurement. Measurements were normalized and bounded within [-1, 1] as part of the original dataset. "Acc" measurement units are in 'g's (gravity of earth -> 9.80665 m/seg2); "Gyro" measurement units are are rad/seg. </li>
</ul>

<h2>Sources </h2>
http://archive.ics.uci.edu/ml/datasets/Smartphone-Based+Recognition+of+Human+Activities+and+Postural+Transitions#, including data set files.

