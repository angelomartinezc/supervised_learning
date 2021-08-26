'''
Simple Linear Regression
+ Is a basic predictive analytics technique that uses historical data to predict an output variable
+ It is popular for predictive modelling because it is easily understood and can be explained 
+ Equation: Yₑ = α + β X where Yₑ is the estimated or predicted value of Y based on our linear equation
+ Our goal is to find statistically significant values of the parameters α and β that minimise the difference between Y and Yₑ
+ If we are able to determine the optimum values of these two parameters, then we will have the line of best fit that we can use to predict the values of Y, given X
+ How do we estimate α and β? We can use a method called Ordinary Least Squares
+ The objective of Least Squares method is to find values of α and β that minimise the sum of the squared difference between Y and Yₑ
'''


import pandas as pd
import numpy as np
from matplotlib import pyplot as plt

# ====================================================================================
# Generate random data
np.random.seed(0)
# Array of 100 values with mean = 1.5, stddev = 2.5
X = 2.5 * np.random.randn(100) + 1.5
np.mean(X)
np.std(X)
# Generate 100 residual terms
res = 0.5 * np.random.randn(100)
# Actual values of Y
y = 2 + 0.3 * X + res


df = pd.DataFrame({'X': X, 'Y': y})
df

# calculate the mean of x and y
xmean = np.mean(X)
ymean = np.mean(y)

# calculate the terms needed for the numator and denominator beta
df['xycov'] = (df['X'] - xmean) * (df['y'] - ymean)





