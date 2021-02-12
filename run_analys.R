# load libraries
library(dplyr) 

# set dataset directory)

# reading train data from directory
x_train   <- read.table("./train/X_train.txt")
y_train   <- read.table("./train/Y_train.txt") 
sub_train <- read.table("./train/subject_train.txt")

# reading test data from directory
x_test   <- read.table("./test/X_test.txt")
y_test   <- read.table("./test/Y_test.txt") 
sub_test <- read.table("./test/subject_test.txt")

#reading data description from directory
variable_names <- read.table("./features.txt")

# reading activity labels 
activity_labels <- read.table("./activity_labels.txt") 

# merging of training and test sets
x_total   <- rbind(x_train, x_test)
y_total   <- rbind(y_train, y_test) 
sub_total <- rbind(sub_train, sub_test) 


sel_features <- variable_names[grep(".*mean\\(\\)|std\\(\\)", features[,2], ignore.case = FALSE),]
x_total      <- x_total[,sel_features[,1]]

# col names
colnames(x_total)   <- sel_features[,2]
colnames(y_total)   <- "activity"
colnames(sub_total) <- "subject"

# merging last dataset
total <- cbind(sub_total, y_total, x_total)

# turning activities & subjects into factors 
total$activity <- factor(total$activity, levels = activity_labels[,1], labels = activity_labels[,2]) 
total$subject  <- as.factor(total$subject) 

# tidying dataset
# with the average of each variable for each activity and each subject. 
total_mean <- total %>% group_by(activity, subject) %>% summarize_each(funs(mean)) 

# texting file of final dataset
write.table(total_mean, file = "./tidydata.txt", row.names = FALSE, col.names = TRUE) 
