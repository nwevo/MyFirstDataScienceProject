#Application of K-Nearest Neighbors Classification Model on the Default of Credit Card Clients data set; to compare overall model accuracy when data is normalized and when data is not normalized.

setwd("C:/Users/faco9/Downloads")
getwd()
#install.packages('readxl')
library(readxl)

#Read data file
card_default<-read_excel("default of credit card clients.xls")

#inspect the data
names(card_default)

#Data cleaning and prepping#
#rename target variable to make it easier to read
library(tidyverse)
card_default<-card_default%>% rename("DEFAULT"="default payment next month")

names(card_default)
head(card_default)
tail(card_default)
summary(card_default)
str(card_default)

#Feature scaling using the Normalize function on our dataset min_max scaling.
normalize <- function(x){return((x-min(x))/(max(x) - min(x)))}
cd_n<- as.data.frame(lapply(card_default[,2:24], normalize))
names(cd_n)

#using the cbind to put back the target variable
cd_n<-cbind(cd_n, card_default[,25])
names(cd_n)

#Split our data into samples (train and test)
set.seed(123)
cd_split <-sample(2, nrow(cd_n), replace =TRUE, prob = c(0.7, 0.3))
head(cd_split)
train_cd<-cd_n[cd_split==1, 1:23]
test_cd<-cd_n[cd_split==2, 1:23]

#extract the target variable
train_cd_Labels<-cd_n[cd_split==1, 24]
test_cd_labels <-cd_n[cd_split==2, 24]
head(train_cd_Labels)


NROW(train_cd_Labels)
NROW(test_cd_labels)

#install.packages('class')
library(class)

#using k=25 we build the KNN classifier
knn_pred <-knn(train=train_cd, test=test_cd,cl=train_cd_Labels, k=25)
knn_pred


#Evaluate model by calculating the proportion of correct predictions for k=25
Acc_knn_pred<-100*sum(test_cd_labels==knn_pred)/NROW(test_cd_labels)
Acc_knn_pred

#Test model accuracy using confusion matrix
#install.packages('caret')
library(caret)
confusionMatrix(table(knn_pred, test_cd_labels))

#for model optimisation
i=1
k.opt=1
for(i in 1:50){
  knn.mod<-knn(train=train_cd, test=test_cd,cl=train_cd_Labels, k=i)
  k.opt[i]<-100*sum(test_cd_labels==knn.mod)/NROW(test_cd_labels)
  k=i
  cat(k, '=', k.opt[i],'\n')
}

###############################################################################
#Alternatively, as stated in the task topic we do not normalize our data set but we convert to factor the categorical variables in our data and rerun the model.
creditcard_default<-card_default

#we drop the ID as it is not essential for our model
creditcard_default<-subset(creditcard_default, select = -c(ID))
names(creditcard_default)

#we convert categorical variables to factor using the column names
names<-c("SEX", "EDUCATION","MARRIAGE", "PAY_0", "PAY_2", "PAY_3", "PAY_4", "PAY_5", "PAY_6","DEFAULT")
creditcard_default[,names]<-lapply(creditcard_default[,names],factor)
str(creditcard_default)

#assign levels to target variable
levels(creditcard_default$DEFAULT)<-c("No", "Yes")
levels(creditcard_default$DEFAULT)


#Split data set into Training and Test set using the caret package as we build our model
library(caret)

#partition data
#Split our data into samples (train and test)
set.seed(123)
cc_split <-sample(2, nrow(creditcard_default), replace =TRUE, prob = c(0.7, 0.3))
head(cc_split)
train_cc<-creditcard_default[cc_split==1, 1:23]
test_cc<-creditcard_default[cc_split==2, 1:23]
head(train_cc)

#extract the target variable
train_cc_Labels<-creditcard_default[cc_split==1,24]
test_cc_labels <-creditcard_default[cc_split==2,24]
head(train_cc_Labels)


#using k=25 we build the KNN classifier
library(class)
pred_knn <-knn(train=train_cc, test=test_cc,cl=train_cc_Labels$DEFAULT, k=25)
pred_knn


#Evaluate model by calculating the proportion of correct predictions for k=25
Acc_pred_knn<-100*sum(test_cc_labels$DEFAULT==pred_knn)/NROW(test_cc_labels$DEFAULT)
Acc_pred_knn

#Test model accuracy using confusion matrix in order to complete our comparison
#install.packages('caret')
library(caret)
confusionMatrix(table(pred_knn, test_cc_labels$DEFAULT))

#for model optimisation
i=1
k.opt=1
for(i in 1:50){
  knn.mod<-knn(train=train_cc, test=test_cc,cl=train_cc_Labels$DEFAULT, k=i)
  k.opt[i]<-100*sum(test_cc_labels$DEFAULT==knn.mod)/NROW(test_cc_labels$DEFAULT)
  k=i
  cat(k, '=', k.opt[i],'\n')
}