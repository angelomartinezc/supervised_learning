# Libraries requiered
# install.packages("datarium")
# install.packages("caTools")
# install.packages("ggplot2") 
# install.packages("GGally")
# install.packages("MLmetrics")
# install.packages("cluster")

library(MLmetrics)  
library(magrittr)
library(datarium)
library(caTools)
library(ggplot2)
library(GGally)

# Loading the data
data("marketing", package = "datarium")
data_size = dim(marketing)


# Exploratory data analysis -----------------------------------------------
marketing %>% head
summary(marketing)

# Plot
plot(marketing, col='purple', main='Pairs')
ggpairs(marketing)


# Preparing data ----------------------------------------------------------
set.seed(101)
sample <-  sample.split(marketing$youtube, SplitRatio = .75)
train <- subset(marketing, sample == TRUE)
test <- subset(marketing, sample == FALSE)
train %>% dim
test %>% dim


# Model -------------------------------------------------------------------
model <- lm(formula = sales ~ youtube + facebook + newspaper, data = marketing)
summary(model)



# Evaluation --------------------------------------------------------------
pred <- predict(model, test)
numx <- data_size[1]*(1-0.75)
x_axis <- seq(numx)
df <- data.frame(x_axis, pred, test$sales)


r_score <- function(y_actual, y_predict){
  return(1 - (sum((y_actual - y_predict)^2) / sum((y_actual - mean(y_actual))^2)))
}


mse <- function(y_actual, y_predict){
  return(sum((y_actual - y_predict)^2) / nrow(test))
}


cat('The mean squared error is:', mse(test$sales, pred))
cat('The R2 score is:', r_score(test$sales, pred))



df %>% ggplot(aes(x = x_axis)) +
  geom_line(aes(y=pred, colour="Predicted"), size=1.5) +
  geom_point(aes(x=x_axis, y=pred, colour="Predicted")) + 
  geom_line(aes(y=test$sales, colour="Actual"), size=1.5) +
  geom_point(aes(x=x_axis, y=pred, colour="Actual")) +
  scale_colour_manual("", values = c(Predicted='red', Actual='blue')) + 
  theme_light()



R2_Score(pred, test$sales)
MSE(pred, test$sales)

