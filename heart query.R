rm(list=ls())
library(rpart)
library(rpart.plot)

#filtering and training
HeartData <- read.csv(file="D:/Nadya Alimin/uph/5th sem/Operation Research/Project/heart.csv", header=TRUE, sep=",")
data <- HeartData

#Splitting the data to be trained and tested
set.seed(1)
id<-sample(1:nrow(data),round(0.5*nrow(data)),replace = FALSE)
data_test<-data[-id,]
data_train<-data[id,]
data_model<-rpart(target~., data = data_train)
data_model$frame$yval<-round(data_model$frame$yval)

#Filtering the best Complexity Parameter with the least data error
printcp(data_model)
bestcp <- data_model$cptable[which.min(data_model$cptable[,"xerror"]),"CP"]

#pruning data according to the best Complexity Parameter
data_model.pruned <- prune(data_model, cp = bestcp)

#predictions
pred_data<-predict(data_model.pruned, newdata = data_test, type = "vector")
pred_data<-round(pred_data)
pred_data<-as.data.frame(pred_data)
pred_temp<-pred_data

#Prediction's age in years 
pred_data$age<-data_test$age

#Prediction's sex (1 = male; 0 = female) 
pred_data$sex<-data_test$sex

#Prediction's chest pain type 
pred_data$cp<-data_test$cp

#Prediction's resting blood pressure (in mm Hg on admission to the hospital) 
pred_data$trestbps<-data_test$trestbps

#Prediction's serum cholestoral in mg/dl 
pred_data$chol<-data_test$chol

#Prediction's (fasting blood sugar > 120 mg/dl) (1 = true; 0 = false) 
pred_data$fbs<-data_test$fbs

#Prediction's resting electrocardiographic results 
pred_data$restecg<-data_test$restecg

#Prediction's maximum heart rate achieved 
pred_data$thalach<-data_test$thalach

#Prediction's exercise induced angina (1 = yes; 0 = no) 
pred_data$exang<-data_test$exang

#Prediction's ST depression induced by exercise relative to rest 
pred_data$oldpeak<-data_test$oldpeak

#Prediction's the slope of the peak exercise ST segment 
pred_data$slope<-data_test$slope

#Prediction's number of major vessels (0-3) colored by flourosopy 
pred_data$ca<-data_test$ca

#Prediction's 1 = normal; 2 = fixed defect; 3 = reversable defect 
pred_data$thal<-data_test$thal

#Sorting the column order according to the table
pred_data<-pred_data[c(2,3,4,5,6,7,8,9,10,11,12,13,14,1)]

#To draw the model.
pred_model<-rpart(pred_data~., data = pred_data)
pred_model$frame$yval<-round(pred_model$frame$yval)

#To check the accuracy of correctly predicted data according to the real table
confMat <- table(data_test$target,pred_data$pred_data)
accuracy <- sum(diag(confMat))/sum(confMat)
tab <- table(pred_data$pred_data,data_test$target)
print(tab)

#Plot Graph
rpart.plot(pred_model)

################################################################################################################
################################################################################################################

library(shiny)

# Define UI for application that draws a plot
ui <- fluidPage(
  # Application title
  titlePanel("Heart Disease"),

  sidebarPanel(
      numericInput("age", "Age", value = 20),
      sliderInput("sex", "Sex", 
                  min = 0, max = 1, step = 1, value = 0),
      sliderInput("cp", "Chest Pain Type",
                  min = 0, max = 3, value = 0),
      sliderInput("trestbps", "Resting Blood Pressure (mmHg)",
                  min = 50, max = 200, value = 50),
      sliderInput("chol", "Cholestoral Value (mg/dl)",
                  min = 50, max = 250, value = 50),
      sliderInput("fbs", "Fasting Blood Sugar > 120", 
                  min = 0, max = 1, value = 0),
      sliderInput("restecg", "Resting ElectroCardioGraphic",
                  min = 0, max = 2, value = 0),
      sliderInput("thalach", "Maximum Heart Rate",
                  min = 50, max = 250, value = 50),
      sliderInput("exang", "Exercise Induced Angina", 
                  min = 0, max = 1, value = 0),
      sliderInput("oldpeak", "ST Depression of Heart Rate",
                  min = 0.0, max = 6.0, step = 0.1, value = 0.0),
      sliderInput("slope", "ST Peak of Heart Rate",
                  min = 0, max = 2, value = 0),
      sliderInput("ca", "Number of Major Vessels",
                  min = 0, max = 3, value = 0),
      sliderInput("thal", "Blood Defection", 
                  min = 0, max = 1, value = 0)
    ),
  
  conditionalPanel("input.tbPanel=='a'",
                   sidebarPanel(
                     h4('Heart Disease Accuracy and Plot'))),
  conditionalPanel("input.tbPanel=='b'",
                   sidebarPanel(
                     h4('Heart Disease Data Table'))),
  
  
  
  mainPanel(
    tabsetPanel(id = 'tbPanel',
                tabPanel('Heart Disease Accuracy and Plot',value = 'a',
                         plotOutput('plot1'),
                         includeMarkdown("D:/Nadya Alimin/uph/5th sem/Operation Research/Project/notes.Rmd"), br(),
                         tableOutput('table1'),
                         textOutput("value2"),
                         verbatimTextOutput("prediction")
                ),
                tabPanel('Heart Disease Data Table',value = 'b',
                         tableOutput('table2')
                )
    )
  )
)

# Define server logic required to draw a plot
server <- function(input, output, session) {
  
  heartRisk <- function(x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13){
    values <- as.data.frame(cbind(x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,pred_temp))
    colnames(values) <- c("age","sex","cp","trestbps","chol","fbs","restecg","thalach",
                         "exang","oldpeak","slope","ca","thal","prediction")
    
    pred <- predict(pred_model, newdata = values, type = "vector")
    pred <- round(pred)
    pred <- as.data.frame(pred)
    
    print(pred[1,1])
    
  }
  
  
  output$plot1 <- renderPlot({
    rpart.plot(pred_model)
  })
  
  output$value1 <- renderText({
    "Notes: \n
        - 0 = Chances of having heart disease below 50% \n
        - 1 = Chances of having heart disease above 50% \n
    \n"
  })
  
  output$table1 <- renderTable({
    true.positive    <- sum(pred_data$pred_data == "1" & data_test$target == "1")
    false.positive    <- sum(pred_data$pred_data == "0" & data_test$target == "1")
    true.negative    <- sum(pred_data$pred_data == "0" & data_test$target == "0")
    false.negative   <- sum(pred_data$pred_data == "1" & data_test$target == "0")
    row.names <- c("Prediction - FALSE", "Prediction - TRUE" )
    col.names <- c("Reference - FALSE", "Reference - TRUE")
    cbind(Outcome = row.names, as.data.frame(matrix( 
      c(true.negative, false.negative, false.positive, true.positive) ,
      nrow = 2, ncol = 2, dimnames = list(row.names, col.names))))
  }
  )
  
  output$value2 <- renderText({
    paste("Classification Accuracy = ", accuracy)
  })
  
  output$table2 <- renderTable({
    head(pred_data, n=151)
  })
  
  output$prediction <- renderText({
    paste("Your Heart Disease probability is = ", 
    heartRisk(input$age,input$sex,input$cp,input$trestbps,input$chol,input$fbs,input$restecg,input$thalach,
                input$exang,input$oldpeak,input$slope,input$ca,input$thal))
  })
}
  
# Run the application 
shinyApp(ui = ui, server = server)
