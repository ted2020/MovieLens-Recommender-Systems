# MovieLens Recommender Systems

## Introduction

#### Data analysis is more than just crunching numbers and visualizing them. It is, in fact, a storytelling. With the right mindset and enough data, it is feasible to create a digital footprint of human behavior. That's something that I strongly believe in. Human actions, inadvertently, leave traces of prefences, which can then be converted into assumptions about the future demand on the applicable products. In here, the decision-making process, by reading outcomes of well-analyzed data, by the management, can be simplified as well as increased in efficiency. All these then feed into the profits and the team with the most truthful story wins the Bayesian game.


## Summary

### Goal of the Movielens Recommendation Systems study:
#### By using the movielens dataset, I will try to build an algorithm that takes in independent variables and trains the model by using already known dependent variable, in this case it is the movie ratings, and then I hope to predict dependent variable, movie ratings, by using the model created with independent variables in hand. 

#### To accomplish the goal, we split the data into two parts: train set (edx) and validation set (validation).
![train validation test split visual](https://github.com/ted2020/MovieLens-Recommender-Systems/blob/master/train_validation_test_split.png)

#### Before I dive in, let's see some details of the project provided by Movielens. > link to  __[Movielens 10M Data Description](http://files.grouplens.org/datasets/movielens/ml-10m-README.html)__

#### Data Prep:
        The data didn't require cleaning.
        After checking possible missing values, time frame anomalies, and seeing whether the data is intact,
        I converted timestamps into dates, separated genres, and extracted the movie release years. 
        By doing so, I was able to compare the rate year vs release year rating differences and user voting frequency.

#### Other exploratory data analyses I've done are: 
        seeing distinct values 
        how old a movie is and for how long reviews being collected
        count of genres listed 
        proportion of each genre 
        top 20 movies with highest number of ratings 
        ratings given from most to least and their proportions
        movie genre count by year and by count order
        ratings by release year and rate year (defined below)
        mean ratings of each genre
        visual inspection vs data: which genre to produce?
        what week day the most people go to and mean rating is higher? (Quora Thread)
        correlation outputs and inference

#### Visualization part includes:
        rating distribution
        genres rating distribution
        rate year rating distribution
        release year rating distribution (observed two clusters: 1980 dropoff point)
        user count rate distribution (log2)        
        movie count rate distribution (log2)

#### RMSE:
        formula and intuition
        
        noise clean-up ( image here is for illustrative purposes, but the idea for this project is the same)
![noise visually explained](https://github.com/ted2020/MovieLens-Recommender-Systems/blob/master/noise_explained.png)
    
        
        algorithm
            n()
            plyr
            ridge and lasso
            ranger
            regularization
            kmeans
            svm
            xgboost
            randomforest
            slope one
            sparse matrix
            OLS and GLS
        graphs
        
#### Please see the links file for the resources I used.


