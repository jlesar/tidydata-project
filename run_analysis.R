##Script to satisfy Getting and Cleaning Data course assignment.
##Criteria enumerated below as specified in the assignment:

##Run script in directory where files have been extracted/downloaded - i.e., 
##"UCI HAR Dataset" if unchanged from default.

##we will use these libraries; assume already installed; if not, need to install
library(plyr)
library(dplyr)
library(tidyr)
library(stringr)

##1. Merges the training and the test sets to create one data set. 

        ##place files from test and train directories into same, new (or existing)
        ##directory ("all")
        ##subdirectories not copied as default is recursive = FALSE
        if("all"%in%dir()==FALSE) dir.create("all")      

        train <- list.files(path = "train", full.names = TRUE)
        test <- list.files(path = "test", full.names = TRUE)
        file.copy(from = train, to = "all")
        file.copy(from = test, to = "all")

        ##at this point we have the 6 relevant data files in the "all" directory
        ##convert to dataframes. There is undoubtedly a better way to batch this,
        ##but for the purposes of this assignment, these are the indiidual steps
        test1 <- read.table("all/subject_test.txt")
        ytest <- read.table("all/y_test.txt")
        xtest <- read.table("all/X_test.txt")
        train2 <- read.table("all/subject_train.txt")
        ytrain <- read.table("all/y_train.txt")
        xtrain <- read.table("all/X_train.txt")

        #bind test columns and train columns into respective dataframes and 
        ##label first two columns to avoid confusion between subject and activity
        ##values
        featurenames  <- read.table("features.txt")$V2
                
        testdf <- cbind(test1, ytest, xtest)
        colnames(testdf) = c("subject", "activity", colnames(xtest))

        traindf <- cbind(train2, ytrain, xtrain)
        colnames(traindf) = c("subject", "activity", colnames(xtrain))

        ##bind testdf and traindf into single dataset
        df <- rbind(testdf, traindf)

##2.Extracts only the measurements on the mean and standard deviation for 
##each measurement. 
        
        ##We find the labels for the mean & std measurements in the features.txt 
        ##file and extract those that contain "mean()" or "std()"        
        
        titles <- read.table("features.txt")
        meanstd <- grep("*-mean\\(\\)*|*-std\\(\\)*)", titles$V2)
        meanstdv <- grep("*-mean\\(\\)*|*-std\\(\\)*)", titles$V2, value = TRUE)

        ##meanstd is a vector containing the element numbers of mean and std
        ##measurements. Extract columns using this vector + 2 (to account for 
        ##subject and activity columns). meanstdv is the vector containing the 
        ##actual labels
        
        subset <- select(df, c(1, 2, (meanstd+2)))

##3.Uses descriptive activity names to name the activities in the data set
       
        ##extract activity labels from file; turn to lower case and match 
        ##numbers in activity column to label values
        
        labels <- read.table("activity_labels.txt")
        labels <- tolower(labels$V2)
        subset$activity <- mapvalues(subset$activity, from = 1:6, to = labels)
        
##4.Appropriately labels the data set with descriptive variable names.   

        ##subject and activity columns are already labelled; apply meanstdv 
        ##(mean/std value labels) to remaining columns in subset
        
        colnames(subset) <- c("subject", "activity", meanstdv) 
        
##5.From the data set in step 4, creates a second, independent tidy data set 
##with the average of each variable for each activity and each subject.        
        
        ##narrow dataset by combining individual measurements into single column
        ##under "measurement" variable
        tidymeasures <- gather(subset, key = measurement, value = meansd, 3:68)
        
        ##find averages for each measurement per subject
        tidymeans <- ddply(tidymeasures, c("subject", "activity", "measurement"), 
                           summarise, mean = mean(meansd))
        
        ##clarify labelling and identify variables as mean or std dev: split 
        ##measurement column into 3; reassign mean/std portion as separate 
        ##column, then recombine to preserve X/Y/Z notation as applicable
        
        tidy2 <- str_split_fixed(tidymeans$measurement, "-", n = 3)
        colnames(tidy2) <- c("measureA", "type", "measureB")
        tidy3 <- data.frame(tidy2)
        tidy3B <- mutate(tidy3, measure = paste(measureA, measureB))
        tidymerged <- mutate(tidymeans, measurement = tidy3B$measure, 
                             type = tidy3B$type)
        
        ##separate mean and sd measures into two separate columns to form final 
        ##tidy dataset

        tidyfinal <- spread(tidymerged, type, mean)
       
        ##rename mean and stddev columns to remove parens; remove spaces from 
        ##measurement label
        tidyfinal <- mutate(tidyfinal, measurement = sub(" ", "-", measurement))
        colnames(tidyfinal) <- c("subject", "activity", "measurement", "avemean", 
                                 "avestddev")
        
        
        ##final dataset is "tidyfinal", with each row displaying the average 
        ##mean and average standard variation for each variable, for each activity 
        ##and subject.
        
        tidyfinal
        