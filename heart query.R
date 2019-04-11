rm(list=ls())
library(rpart)
library(rpart.plot)

#filtering and training
HeartData <- read.csv(file="D:/Documents/Kuliah/INF/Semester 11/Riset Operasional/Project/heart.csv", header=TRUE, sep=",")
data <- HeartData
set.seed(1)
id<-sample(1:nrow(data),round(0.5*nrow(data)),replace = FALSE)
data_test<-data[-id,]
data_train<-data[id,]
data_model<-rpart(target~., data = data_train)
data_model$frame$yval<-round(data_model$frame$yval)

printcp(data_model)
bestcp <- data_model$cptable[which.min(data_model$cptable[,"xerror"]),"CP"]

data_model.pruned <- prune(data_model, cp = bestcp)

#predictions
pred_data<-predict(data_model.pruned, newdata = data_test, type = "vector")
pred_data<-round(pred_data)
pred_data<-as.data.frame(pred_data)
pred_data$age<-data_test$age
pred_data$sex<-data_test$sex
pred_data$cp<-data_test$cp
pred_data$trestbps<-data_test$trestbps
pred_data$chol<-data_test$chol
pred_data$fbs<-data_test$fbs
pred_data$restecg<-data_test$restecg
pred_data$thalach<-data_test$thalach
pred_data$exang<-data_test$exang
pred_data$oldpeak<-data_test$oldpeak
pred_data$slope<-data_test$slope
pred_data$ca<-data_test$ca
pred_data$thal<-data_test$thal
pred_data<-pred_data[c(2,3,4,5,6,7,8,9,10,11,12,13,14,1)]

confMat <- table(data_test$target,pred_data$pred_data)
accuracy <- sum(diag(confMat))/sum(confMat)

pred_model<-rpart(pred_data~., data = pred_data)
pred_model$frame$yval<-round(pred_model$frame$yval)

#Plot Graph
rpart.plot(pred_model)
