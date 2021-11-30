import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns
from pandas.plotting import register_matplotlib_converters
register_matplotlib_converters()

# Import data (Make sure to parse dates. Consider setting index column to 'date'.)
df = df=pd.read_csv('data\fcc-forum-pageviews.csv',parse_dates=True,index_col='date')

# Clean data
df=df[(df.value >=df.value.quantile(0.025)) & (df.value<=df.value.quantile(.975))]

def draw_line_plot():
    # Draw line plot
    
    fig=plt.figure(figsize=(14,6))
    plt.plot(df,'red')
    plt.xlabel('Date')
    plt.ylabel('Page Views')
    plt.title("Daily freeCodeCamp Forum Page Views 5/2016-12/2019")

    # Save image and return fig (don't change this part)
    fig.savefig('line_plot.png')
    return fig

def draw_bar_plot():
    # Copy and modify data for monthly bar plot
    df['month'] = df.index.month
    df['year'] = df.index.year
    #df_bar = df.groupby(['year','month'],as_index=False)['value'].mean()
    df_bar = df.groupby(['year','month'])['value'].mean().unstack()
    

    # Draw bar plot
    #fig=df_bar.pivot(index='year',columns='month',values='value').plot(kind='bar',figsize=(12,6),xlabel='Years',ylabel='Average Page Views')

    fig = df_bar.plot.bar(figsize=(12,6),xlabel="Years",ylabel='Average Page Views').figure
    plt.legend(['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'])
    

    # Save image and return fig (don't change this part)
    fig.savefig('bar_plot.png')
    return fig

def draw_box_plot():
    # Prepare data for box plots (this part is done!)
    df_box = df.copy()
    df_box.reset_index(inplace=True)
    df_box['year'] = [d.year for d in df_box.date]
    df_box['month'] = [d.strftime('%b') for d in df_box.date]


    df_box['month_index']=df_box.date.dt.month
    df_box=df_box.sort_values('month_index')

    # Draw box plots (using Seaborn)
    fig, axes = plt.subplots(1,2,figsize=(14,7))
    axes[0] = sns.boxplot(x=df_box['year'], y=df_box['value'],ax=axes[0],data=df_box)
    axes[1] = sns.boxplot(x=df_box.month,y=df_box.value,ax=axes[1],data=df_box)

    sns.set_theme(style='white')
    axes[0].set_title('Year-wise Box Plot (Trend)')
    axes[0].set_xlabel('Year')
    axes[0].set_ylabel('Page Views')

    axes[1].set_title('Month-wise Box Plot (Seasonality)')
    axes[1].set_xlabel('Month')
    axes[1].set_ylabel('Page Views')
    


    # Save image and return fig (don't change this part)
    fig.savefig('box_plot.png')
    return fig
