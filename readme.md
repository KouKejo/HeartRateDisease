# Heart Rate Disease
The goal of this repository is to know the presence of heart disease in the patient (https://www.kaggle.com/ronitf/heart-disease-uci). User can input their own data, so the user know the possibility of potentially having a heart disease.

## Dependency
- [R-3.5.2](https://www.rstudio.com/)
- Ms. Excel
- [Google Chrome](https://www.google.com/intl/id_ALL/chrome/) / Other Browsers 

## Installment/running instruction
- Install some libraries needed:
  - `rpart` with command `install.packages("rpart")`
  - `rpart.plot` with command `install.packages("rpart.plot")`
  - `shiny` with command `install.package("shiny")`
- Compile the source code from this repository and execute the program by clicking `Ctrl+A` and click the `Run` button above to run all the command.
- Compile the Shiny app from R Studio
- Change directory file="C:/.../heart.csv" to get data address from the repository

## Explanation

### Predictions

From the data we have, we proccessed using Regression Tree. There are 2 reasons why we choose using Regression Tree. First, in `csv` data type already have the `target` part as references with other parameters, which will be easier to make classification based on existing data. In additional, because there is classification, the making of decision tree for determine the results of predictions that similar with the original data.

In this Regression Tree, we used `round = 0.5` to get the best `accuracy` which is `0.78` (rounded). Further explanation can be seen on [Testing Accuracy](https://github.com/nadyaalimin/HeartRateDisease/blob/master/TestingAccuracy/Accuracy-Comparasion.md)

![Regression Tree](https://github.com/nadyaalimin/HeartRateDisease/blob/master/HD_RT.png)<br>

### Testing

There are `data training` and `data testing` for testing. The data is split into half to be trained and tested. The result of this splitting is saved as `data model`. Then the data is pruned to get the best result with least data error using `complexity parameter`

### Server.R

This part of the code is the proccess of all input turns into output to displays on `ui`.

Here are the code snippet of Server.R:
![SnipOfServer](https://github.com/nadyaalimin/HeartRateDisease/blob/master/server.R.png)

### ui.R

This part of the code is works as the connector between user and the program; all the inputs given by the user on `ui` will be proccessed on `server`.

Here are the code snippet of ui.R:
![SnipOfUI](https://github.com/nadyaalimin/HeartRateDisease/blob/master/ui.R.png)

## Suggestion
1. Add SUBMIT BUTTON, so the result won't be changed while the user haven't submitted the data
2. Add Data Log / History Log and User ID (username, password, etc) to save the user's previous result.
3. Adding more real data variants, so the accuration of data training and testing are more accurate.

## Disclaimer 
The data is from https://www.kaggle.com/ronitf/heart-disease-uci and only used for academic purposes. 

This Shiny application is made by Keren Angelia Raintung, Kevin Jonathan, and Nadya Natasha Alimin to fulfill the assignments for the Research Operation courses of Informatics major at the Pelita Harapan University Main Campus 2018/2019 Even semester.
