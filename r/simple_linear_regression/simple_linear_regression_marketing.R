library(datarium)
library(data.table)
library(ggplot2)
library(GGally)
library(dplyr)
library(caret)
library(broom)
library(MLmetrics)

# Loading data
data("marketing", package = "datarium")
marketing %>% dim

marketing %>% head
marketing %>% summary

# youtube
marketing %>% ggplot(aes(x = youtube)) +
  geom_density(fill = "dodgerblue", alpha = .5) + 
  geom_vline(xintercept = mean(marketing$youtube), size = 1, color = "red") +
  geom_vline(xintercept = median(marketing$youtube), size = 1, color = "yellow")  

# conclusion: la mediana es mayor a la media, sesgada a la derecha


# facebook
marketing %>% ggplot(aes(x = facebook)) + 
  geom_density(fill = "dodgerblue", alpha = 0.5) +
  geom_vline(xintercept = mean(marketing$facebook), size = 1, color = "red") +
  geom_vline(xintercept = median(marketing$facebook), size = 1, color = "yellow")


# pairwise plotting technique
plot(marketing, col='purple', main='Plotting Pairs Against Each Other')

ggpairs(marketing)


# preparing data
set.seed(101)
splitRatio = 0.75

sample <-  createDataPartition(y = marketing$sales, p = splitRatio, times = 1, list = F)
train <- marketing[sample,]
test <- marketing[-sample,]
cat("Train", dim(train), " y test ", dim(test))
train %>% summary
test %>% summary


# creating the model
model1 <- lm(formula = sales ~ youtube, data = train)

train %>% ggplot(aes(x = youtube, y = sales)) +
  geom_point() +
  geom_smooth(method = "lm", se = F)

coefficients(model1)
fitted(model1)
residuals(model1)  

summary(model1)

tidy(model1)
augment(model1)
glance(model1)


# tranforming variables
model2 <- lm(formula = sqrt(sales) ~ sqrt(youtube), data = train)

train %>% ggplot(aes(x = sqrt(youtube), y = sqrt(sales))) +
  geom_point() +
  geom_smooth(method = "lm", se = F)

summary(model2)


model3 <-  lm(formula = I(sales^0.10) ~ I(youtube^0.10), data = train)

train %>% ggplot(aes(x = youtube^0.10, y = sales^0.10)) +
  geom_point() +
  geom_smooth(method = "lm", se = F)

coefficients(model3)
summary(model3)

# sales = 0.8128665 + 0.3087935 * youtube

test_trans <- test %>% mutate(youtube = youtube^0.10, sales = sales^0.10)

# Predicting
pred_model1 <- predict(model1, test)
pred_model2 <- predict(model2, test)
pred_model3 <- predict(model3, test_trans)

test_trans <- test_trans %>% mutate(youtube = youtube^1, sales = sales^1)

# evaluation
MLmetrics::MSE(pred_model1, test$sales)
MLmetrics::MSE(pred_model2, test$sales)
MLmetrics::MSE(pred_model3, test_trans$sales)

MLmetrics::R2_Score(pred_model1, test$sales)
MLmetrics::R2_Score(pred_model2, test$sales)
MLmetrics::R2_Score(pred_model3, test_trans$sales)






