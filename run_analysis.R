install.packages("reshape2")
library(reshape2)

# Read the datasets into R

subtest <- read.table("./test/subject_test.txt")
xtest <- read.table("./test/X_test.txt")
ytest <- read.table("./test/y_test.txt")

subtrain <- read.table("./train/subject_train.txt")
xtrain <- read.table("./train/X_train.txt")
ytrain <- read.table("./train/y_train.txt")

features <- read.table("./features.txt")
activitylabels <- read.table("./activity_labels.txt")

# Combine the datasets
suball <- rbind(subtest, subtrain)
colnames(suball) <- "Subject"

label <- rbind(ytest, ytrain)
label <- merge(label, activitylabels, by=1)[,2]

data <- rbind(xtest, xtrain)
colnames(data) <- features[, 2]

data <- cbind(suball, label, data)

# Create a new dataset with the mean and sd
temp <- grep("-mean|-std", colnames(data))
meansd <- data[,c(1,2,temp)]

melted <- melt(meansd, id = c("Subject", "label"))
means <- dcast(melted , Subject + label ~ variable, mean)

# Save and output the tidy dataset
write.table(means, file="./tidy_data.txt", row.names=F)

means