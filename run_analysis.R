

#Course Assignement

#Things to do

# You should create one R script called run_analysis.R that does the following. 
# 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.



library(dplyr)

if (!file.exists("data")){
  dir.create("data")
}


download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "./data/data.zip")
setwd("~/data/")
unzip("~/data/data.zip")



features<-(t(read.table("~/data/UCI HAR Dataset/features.txt")))[2,]
activity_labels<-read.table("~/data/UCI HAR Dataset/activity_labels.txt")
names(activity_labels) <-c("activity","activity_label")

x_trainData <- read.table("~/data/UCI HAR Dataset/train/X_train.txt")
y_trainData <- read.table("~/data/UCI HAR Dataset/train/y_train.txt")
subject_trainData <-  read.table("~/data/UCI HAR Dataset/train/subject_train.txt")

x_testData <- read.table("~/data/UCI HAR Dataset/test/X_test.txt")
y_testData <- read.table("~/data/UCI HAR Dataset/test/y_test.txt")
subject_testData <-  read.table("~/data/UCI HAR Dataset/test/subject_test.txt")




# 1. Merges the training and the test sets to create one data set.

x_Data <-rbind(x_trainData,x_testData)
y_Data <-rbind(y_trainData,y_testData)
subject_Data <- rbind(subject_trainData,subject_testData)

names(x_Data)<-features
x_Data$activity <- y_Data[[1]]
x_Data$subject <- subject_Data[[1]]



# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

LV = grepl("mean\\(\\)|std\\(\\)|activity|subject",names(x_Data))
x_Data<-x_Data[,LV]


# 3. Uses descriptive activity names to name the activities in the data set

x_Data <- merge(x_Data,activity_labels,all=TRUE)
x_Data <-select(x_Data,-activity)


# 4. Appropriately labels the data set with descriptive variable names. 

names(x_Data) = gsub("\\()","",names(x_Data))
names(x_Data) = gsub("-X","_X-axes",names(x_Data))
names(x_Data) = gsub("-Y","_Y-axes",names(x_Data))
names(x_Data) = gsub("-Z","_Z-axes",names(x_Data))
names(x_Data) = gsub("-mean","_Mean_",names(x_Data))
names(x_Data) = gsub("-std","-Standard-Deviation_",names(x_Data))



# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidy_Data = (aggregate(x_Data, by=list(Activity = x_Data$activity_label, Subject=x_Data$subject), mean))[,1:68]

write.table(tidy_Data,"~/data/tidy_data.txt",row.name=FALSE,sep = ";")
