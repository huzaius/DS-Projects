import pandas as pd
import matplotlib.pyplot as plt
from scipy.stats import linregress
import numpy as np
def draw_plot():
    # Read data from file
    df=pd.read_csv('data\epa-sea-level.csv')


    # Create scatter plot
    x= df.Year
    y = df['CSIRO Adjusted Sea Level']
    #plt.plot(x,y,'o',label='Raw Data')
    plt.scatter(x,y)


    # Create first line of best fit
    linreg=linregress(x,y)
    #plt.plot(x,linreg.intercept + linreg.slope*x,'r',label='First Fitted Line')
    predicted_x = pd.Series([i for i in range(1880,2051)])
    predicted_y = linreg.intercept + (linreg.slope*predicted_x)
    plt.plot(predicted_x,predicted_y,'r')#,label='First best Fit')



    # Create second line of best fit
    second_x = df.loc[x>=2000].Year
    second_fit = linregress(second_x,df.loc[x>=2000]['CSIRO Adjusted Sea Level'])
    pred_x = pd.Series([i for i in range(2000,2051)])
    pred_y = (second_fit.slope*pred_x) + second_fit.intercept
    plt.plot(pred_x,pred_y,'g')



    # Add labels and title
    plt.xlabel("Year")
    plt.ylabel("Sea Level (inches)")
    plt.title("Rise in Sea Level")

    
    # Save plot and return data for testing (DO NOT MODIFY)
    plt.savefig('sea_level_plot.png')
    return plt.gca()