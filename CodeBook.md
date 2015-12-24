


**Getting and Cleaning data**  
=========================


[From the original data set](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
we have performed some changes till the tidy_data.txt file

###**1.download file from web and unzip it**

`download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "./data/data.zip")`    
`setwd("~/data/")`  
`unzip("~/data/data.zip")`  


###**2.Load needed data **

`features<-(t(read.table("~/data/UCI HAR Dataset/features.txt")))[2,]`
`activity_labels<-read.table("~/data/UCI HAR Dataset/activity_labels.txt")`
`names(activity_labels) <-c("activity","activity_label")`

`x_trainData <- read.table("~/data/UCI HAR Dataset/train/X_train.txt")`
`y_trainData <- read.table("~/data/UCI HAR Dataset/train/y_train.txt")`
`subject_trainData <-  read.table("~/data/UCI HAR Dataset/train/subject_train.txt")`

`x_testData <- read.table("~/data/UCI HAR Dataset/test/X_test.txt")`
`y_testData <- read.table("~/data/UCI HAR Dataset/test/y_test.txt")`
`subject_testData <-  read.table("~/data/UCI HAR Dataset/test/subject_test.txt")`



###**3 Merge data sets to create one data set **


`x_Data <-rbind(x_trainData,x_testData)`
`y_Data <-rbind(y_trainData,y_testData)`
`subject_Data <- rbind(subject_trainData,subject_testData)`

`names(x_Data)<-features`
`x_Data$activity <- y_Data[[1]]`
`x_Data$subject <- subject_Data[[1]]`


###**4.Extract only measurements with mean and standard deviation **


`LV = grepl("mean\\(\\)|std\\(\\)|activity|subject",names(x_Data))`
`x_Data<-x_Data[,LV]`

###**5.And add names and renamed it with more descriptive names **


`x_Data <- merge(x_Data,activity_labels,all=TRUE)
`x_Data <-select(x_Data,-activity)


`names(x_Data) = gsub("\\()","",names(x_Data))`
`names(x_Data) = gsub("-X","_X-axes",names(x_Data))`
`names(x_Data) = gsub("-Y","_Y-axes",names(x_Data))`
`names(x_Data) = gsub("-Z","_Z-axes",names(x_Data))`
`names(x_Data) = gsub("-mean","_Mean_",names(x_Data))`
`names(x_Data) = gsub("-std","-Standard-Deviation_",names(x_Data))`


###**6.And aggregate data to create average of each variable for each activity and each subject **  


`tidy_Data = (aggregate(x_Data, by=list(Activity = x_Data$activity_label, Subject=x_Data$subject), mean))[,1:68]`    



###At the end of the process the variables reported are:  

 * Activity: LAYING, SITTING, STANDING, WALKING, WALKING_DOWNSTAIRS, WALKING_UPSTAIRS.  
 * Subject: 1-30  

Each one of this values for the axis (X,Y,Z) and two measures (Mean and Standard Deviation)  

 * tBodyAcc  
 * tGravityAcc  
 * tBodyAccJerk  
 * tBodyGyro  
 * tBodyGyroJerk  
 * tBodyAccMag  
 * fBodyAcc  
 * fBodyAccJerk  
 * fBodyGyro  

And this Mean and Stardard Deviation  

 * fBodyAccMag  
 * fBodyAccJerkMag  
 * fBodyGyroMag  
 * fBodyGyroJerkMag  

All numerical values are the mean values for each Activity and subject group.  


