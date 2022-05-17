# MyFirstDataScienceProject
Application of K-Nearest Neighbours Classification Model on “Default of Credit Card Clients” dataset sourced from the UCI Machine Learning Repository. 
In the first instance of the data preparation we will be applying the normalisation feature scaling process on the dataset before building our model.
Then the second instance we will not normalise the data but will convert to factor the categorical variables in our data before building the model. 
In the end we will compare the model accuracy obtained through both preparation methods and hopefully get more insights from both results.

FINDINGS:
From the results obtained in our analysis using the McNemar’s test values from the confusion matrix we deduce that normalization improves model performance 
but not necessarily the model precision while the precision was good it was not as good as when the data was not normalised. 
The general practice of using the square root of the number of train observations in a data set as the value for k is not practicable
for large datasets like the one used in this analysis. 
Running the loop for k optimum showed that beyond k=39 which was the saturation point for our dataset, 
any increase in k will not enhance performance.
