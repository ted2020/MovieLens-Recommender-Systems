# MovieLens Recommender Systems

## Summary

### Goal of the Movielens Recommendation Systems study:
#### By using the movielens dataset, I will try to build an algorithm that takes in independent variables and trains the model by using already known dependent variable, in this case it is the movie ratings, and then I hope to predict dependent variable, movie ratings, by using the model created with independent variables in hand. 

#### To accomplish the goal, we split the data into two parts: train set (edx) and test set (validation).

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
        corr

#### Visualization part includes:
        rating distribution
        genres rating distribution
        rate year rating distribution
        release year rating distribution (observed two clusters: 1980 dropoff point)
        user count rate distribution (test and train set) (log2)        
        movie count rate distribution (test and train set) (log2)

#### RMSE:
        formula and explanation
        algorithm
        graphs


