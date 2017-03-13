README notes on the tidydata project/tidyfinal dataset

Overview
This project is based on the Smartphone-Based Recognition of Human Activities and Postural Transitions Data Set (and ancillary documents) (http://archive.ics.uci.edu/ml/datasets/Smartphone-Based+Recognition+of+Human+Activities+and+Postural+Transitions#) available via the link above. 

The run_analysis.R script takes the data above, extracts the values for mean and standard variation for a number of measurements, and  computes the average of the means and standard deviations for each particular measurement, so that the final tidy dataset ("tidyfinal") gives the average of each mean and standard deviation for each activity and each subject observed in the study.

A short overview of the script is available in the Codebook <<insert link>>. 

Notes on the data 
--Subjects are divided between test and train datasets, hence no overlap of IDs between the two sets. The first portion of the script uses read.table to convert the txt files to dataframes, then uses cbind and rbind to form a single dataframe.

--I have used the measurement labels applied by the original researchers. To spell them out further would make the labels of an unreasonable length, and the existing labels are understandably descriptive. For details on the naming structure for the labels, see the Variables section of the Codebook <<insert link>>

Tidiness of the data
As the object of the final dataset (here, "tidyfinal") is to produce "a data set with the average of each variable for each activity and each subject", it makes sense to organize the data by subject, activity, and measurement. That is, each observation (hence, row) is for a subject, activity, and particular type of measurement (e.g., tBodyAcc-X). There are two values for each observation: avemeans and avestddev, or the average of the means and standard deviations of that type of measurement for that subject and activity. The tidy dataset thus has columns for:
-subject
-activity
-measurement
-avemeans
-avestddev
and one row per observation of each. 


Using the script
1. Starting from the downloaded zip file, extract files (unzip("activity.zip", exdir = "activity")). 

2. Run the script in the directory where the files were extracted. 
The relevant files for this exercise are: 
--in the "test" subdirectory -- subject_test.txt, X_test.txt, y_test.txt
--in the "train" subdirectory -- subject_train.txt, X_train.txt, y_test.txt

--The run_analysis.R script handles the following steps:
3. Move the files from the test and train subdirectories into a new subdirectory named "all". Other files may remain as is.

4. Convert the files in "all" to dataframes via read.table, maintaining the distinction between test and train files (retaining filenames is easiest).

5. Column-bind the "test" dataframes together into "testdf"; separately, column-bind the "train" dataframes together into "traindf". Ordering each as (subject_file, y_file, X_file) places the subject and activity columns at the beginning of the resulting dataframe, which makes subsequent manipulations easier. 

6. Assign "testdf" and "traindf" the column names "subject", "activity", and the column names from the X_file dataframe. This is to avoid confusion between the subject and activity columns, both of which consist of numeric values.

7. Row-bind the testdf and traindf dataframes together (as "df"). This produces a master dataframe with all data values.

8. Read the "features.txt" file from the root data folder into a "titles" dataframe. This contains the list of feature labels pertaining to the 561 columns of X_test/X_train.

9. Extract from the second column of "titles", as the vector "meanstd", the element numbers of the feature labels that include either the segment "-mean()" or the segment "-std()". Extract from the second column of "titles", as the vector "meanstdv", the values of these same feature labels. These are the measurements, as requested by the assignment, that are mean and standard deviations of the different variables. Each of the two vectors contains 66 elements.

10. Create a "subset" dataframe from "df" consisting of the subject, activity, and columns indicated by the meanstd vector. Note that to compensate for the subject and activity columns in df,  the meanstd element numbers must be increased by 2. The resulting "subset" dataframe is 10299 x 68; all extraneous measurements have been removed. 

11. Read the "activity_labels.txt" file from the root data folder into a "labels" dataframe. This df matches the numeric values in the "subset" activity column to the activity description.

12. Extract the second column of the labels dataframe and send to lowercase to form the "labels" vector of activity descriptions.

13. Map the values from the labels vector to the activity column of "subset". 

14. Assign the "meanstdv" labels to the remaining column names in "subset" (i.e., add them to the "subject" and "activity" names).

15. Narrow the "subset" df by gathering the 66 measured variables into a single "measurement" column, with values "meansd"; name this new df "tidymeasures".

16. Create df "tidymeans" by summarising "tidymeasures", finding the mean for each subject-activity-measurement observation. "Tidymeans" thus has four columns: subject, activity, measurement, and mean. 

17. Use str_split_fixed to separate the measurement column into 3 columns to isolate the "mean" or "sd" portion of the measurement variable ("tidy2" df). 

18. Convert "tidy2" to dataframe ("tidy3").

19. Recombine the first and third columns of "tidy3" to preserve the axial portion of the measurement labels where applicable.

20. Replace the "measurement" column of tidymeans with the recombined column "tidy3B$meaasure" and add column "type" with the middle column split from "tidy3" - i.e., the portion specifying whether the variable is mean or standard deviation. Assign this mutated dataframe the name "tidymerged".

21. Spread "tidymerged" into tidyfinal by separating mean and sd types into distinct columns. The data is now tidy, in that each observation has its own row; each column is a distinct variable; and the table is a single observational unit. 

22. Clean up the labels by replacing spaces with hyphens in the measurement column and renaming "mean()" and "std()" columns to "avemean" and "avestddev".

--

Running the script produces a dataset named "tidyfinal". This dataset is also provided in this repository, and can be opened in R with the following commands: 

data <- read.table("tidyfinal", header = TRUE)
View(data)




