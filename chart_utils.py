import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

def bar_plot_categorical(data, x_var, y_var
                        , figsize=(11.7, 8.27), ci=None, estimator=sum
                        , title=None , x_lab=None, y_lab=None, x_fontsize=20
                        , y_fontsize=16, title_fontsize=20
                        , tick_fontsize = 16, x_tick_caps=False, bar_labels=True
                        , palette="pastel", value_fontsize=None, axis_bold=500
                        , title_bold=500):
    
    sns.set_style("whitegrid")
    fig, ax = plt.subplots(figsize=figsize)
    sns.barplot(data = data, x = x_var, y = y_var
                , ax=ax, estimator=estimator, ci=ci, palette=palette)
    sns.despine(left=True)

    plt.rcParams.update({
    'font.sans-serif': 'Montserrat',
    'font.family': 'Montserrat'
    })
    
    ax.set_ylabel(y_lab, fontsize=y_fontsize, weight=axis_bold)
    ax.set_xlabel(x_lab, fontsize=x_fontsize, weight=axis_bold)
    ax.set_title(title, fontsize=title_fontsize, weight=title_bold)
    ax.tick_params(axis='both', labelsize=tick_fontsize)
    plt.xticks(rotation=90)
    
    if x_tick_caps is True: 
        labels = [item.get_text().capitalize() for item in ax.get_xticklabels()]
        ax.set_xticklabels(labels)

def scatter(data, x_var, y_var
            , figsize=(11.7, 8.27)
            , title=None , x_lab=None, y_lab=None, x_fontsize=20
            , y_fontsize=16, title_fontsize=20
            , tick_fontsize = 16, x_tick_caps=False
            , axis_bold=500, title_bold=500, color=None, hue = None
            , s=25):
    
    sns.set_style("whitegrid")
    fig, ax = plt.subplots(figsize=figsize)
    sns.scatterplot(data = data, x = x_var, y = y_var
                , ax=ax, color=color, hue=hue, s=s)
    sns.despine(left=True)

    plt.rcParams.update({
    'font.sans-serif': 'Montserrat',
    'font.family': 'Montserrat'
    })
    
    ax.set_ylabel(y_lab, fontsize=y_fontsize, weight=axis_bold)
    ax.set_xlabel(x_lab, fontsize=x_fontsize, weight=axis_bold)
    ax.set_title(title, fontsize=title_fontsize, weight=title_bold)
    ax.tick_params(axis='both', labelsize=tick_fontsize)