# MovieLens Recommender Systems

## Introduction

#### Data analysis is more than just crunching numbers and visualizing them. It is, in fact, a storytelling. With the right mindset and enough data, it is feasible to create a digital footprint of human behavior. That's something that I strongly believe in. Human actions, inadvertently, leave traces of prefences, which can then be converted into assumptions about the future demand on the applicable products. In here, the decision-making process, by reading outcomes of well-analyzed data, by the management, can be simplified as well as increased in efficiency. All these then feed into the profits and the team with the most truthful story wins the Bayesian game.


## Overview


#### First, I will explore the data to understand the intuition of it, so that i can work with the variables.
#### Second, I will provide some graphs to further grasp the relationship between variables.
#### Third, I will try to reduce RMSE by using some techniques that are listed below.


## Summary

### Goal of the Movielens Recommendation Systems study:
#### By using the movielens dataset, I will try to build an algorithm that takes in independent variables and trains the model by using already known dependent variable, in this case it is the movie ratings, and then I hope to predict dependent variable, movie ratings, by using the model created with independent variables in hand. 

#### To accomplish the goal, we split the data into two parts: train set (edx) and validation set (validation).

#### Before I dive in, let's see some details of the project provided by Movielens. > link to  __[Movielens 10M Data Description](http://files.grouplens.org/datasets/movielens/ml-10m-README.html)__

#### <font color=blue>release year</font> refers to the release date of the movie and the ratings by release reflect the rates the movie received by that year, on average

####  <font color=blue>rate year</font> refers to when rates are collected 

####  <font color=blue>rate_release_dif</font> refers to the span of rating collection (rate year - release year), which can range from years to decades

####  <font color=blue>age_of_movie</font> refers to how old the movie is. It is calculated as this year minus the release year of the movie

#### Data Prep:
        The data didn't require cleaning.
        After checking possible missing values, time frame anomalies, and seeing whether the data is intact,
        I converted timestamps into dates, separated genres, and extracted the movie release years and rate years. 
        I also created weekday and age_of_movie and rate_month variables to grasp the dataset better.
        By doing so, I was able to compare the rate year vs release year rating differences and user voting frequency and on.

#### Other exploratory data analyses I've done are: 
        seeing distinct values 
        how old a movie is and for how long reviews being collected
        count of genres listed 
        proportion of each genre 
        top 20 movies with highest number of ratings 
        ratings given from most to least and their proportions
        movie genre count by year and by count order
        ratings by release year and rate year (defined below)
        mean ratings of each genre and standard deviations
        visual inspection vs data: which genre to produce?
        what week day the most people go to movies aand what are the quietest days? (Quora Thread)
            "Why are movies released on Thursdays?"
        correlation outputs and inference

#### Visualization part includes:
        rating distribution
        genres rating distribution
        rate year rating distribution
        release year rating distribution (observed two clusters: 1980 dropoff point)
            what happened in 1980?
                "The History of the Hollywood Movie Industry"
        user count rate distribution  (log2)        
        movie count rate distribution (log2)
		industry-wide movie boom just before tech-boom

#### RMSE:
        formula and explanation
        algorithm
            n() from dplyr library
            ddply from plyr library
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



## Intuition 1 

####  If I am a movie maker, producing which genre of movie may provide the highest rating and possibly profit???

#### Of course, this question requires data for the production cost of each movie, and ticket sales and prices, along with digital content incomes, and so on. But, for simplicity, I assume'em all constant across the platform.

#### From visual inspection, I see that making War, Fantasy, and Crime movies tend to rate higher and since there are not many of those produced, which can be seen in proportions  or in movie genre count by year section, these kinds of movies wont get lost in the jungle easily.

#### That's not to say that market demand analysis shouldn't be made. Each generation display different characteristics and therefore desire different products, although there are visible common denominators.

#### Let's try to show whetherthe visual inspection is true

#### Frequency table shows (on average, each user has n_freq rating for that genre) that due to high rating receival of comedy, drama, action, thriller, movie makers tend to produce more of those ( which can be seen in count values as well), and therefore their mean tend to regress toward the total mean faster than the ones with low frequency, such as documentary. 

#### Although the visual inspection turned out to be somewhat wrong, due to box office gross sums impact on production, now we learn that producers seem to make more of high grossing movies to maximize their profits which happen to fall into those categories... 

####  > link to  __[source of paraphrase](https://www.statista.com/statistics/188658/movie-genres-in-north-america-by-box-office-revenue-since-1995/)__


## Intuition 2 

#### since many people prefer to go to theatre and many movies are released on fridays,

_[Why are movies released on Thursdays?](https://www.quora.com/Why-are-movies-released-on-Thursdays)_

#### it's plausible to observe a higher rating on fridays and weekends.
#### seeing higher mean rating on mondays may be because professional movie critiques are only ready by then, 
#### as well as people give it some time to digest the movie.
#### mid weekdays (tuesday, wednesday, and thursday) offer the lowest average rating.
#### most people work the mid-weekdays, even if time zone differences accross the globe is taken into consideration,
#### assuming that data collection is not time-zone variant


## Intuition 3

#### Correlation between year of rating collected and how old a movie is
#### in time, rating accumulate, therefore it is expected that older movies to have more rating
#### on the other hand, new generation is more tech savvy, 
#### so the newly produced movies that attract young generation to receive more reviews and rate.


#### as it can be seen, older the movie, higher its rating.( cor(rating,age_of_movie)=.1143)
##### also, if the rate collection year is further into the future than its release year, it's got a positive impact on rating
#### cor(rating,rate_release_dif)=.1039


## Data Visualization

#### Given enough time, ratings get closer to the mean value. But, the businesses, due to ever advancing technology and fast adopting and fast consuming society, may not pay much attention to this, because although the rates regress to the mean in the long run, the most profits are realized in the short and in some instances medium run. As Keynes said: "in the long run, we are all dead."



#### it looks like movie ratings across the year differ between the rates of movies by release year and the rates of movies by rate year.

#### <font color=blue>release year</font> refers to the release date of the movie and the ratings by release reflect the rates the movie received by that year, on average

####  <font color=blue>rate year</font> refers to when rates are collected since the release time, which spans over several years/decades in many instances.

#### average rating should be about 3.52
#### ratings which are collected over a period time, rather the just the release year rating, reflect the mean rating better. In fact, though the earliest movie in the dataset dates back to 1915, rating collection starts at 1995.

#### it also proves the point of 'regress to the mean' concept.

#### additionally, by looking at the release year rate, movies that had been produced between roughly 1920 and 1970 received better ratings when they were released, compared to the 1990s and 2000s.

#### categorically, what genres of movies pushed the overall rating higher than mean from 1920 to 1970??? (answer is given below)

#### also, by looking at the release year rating graph, it is almost as if there are two clusters, which is separated by the year 1980 that acts like a cutoff point, in where sudden drop can be observed. For simplicity, i cut off the two clusters by mean rating.


#### "In the 1980’s, the past creativity of the film industry became homogenized and overly marketable. Designed only for audience appeal, most 1980’s feature films were considered generic and few became classics. This decade is recognized as the introduction of high concept films that could be easily described in 25 words or less, which made the movies of this time more marketable, understandable, and culturally accessible."....   
#### > link to  __[source of quotation](https://historycooperative.org/the-history-of-the-hollywood-movie-industry/)__



## RMSE

#### RMSE:

\begin{equation*}
 \mbox{RMSE} = \sqrt{\mbox{MSE}} = \sqrt{\frac{1}{N}\sum_{i=1}^N (\hat{y}_i - y_i)^2} 
\end{equation*}

#### sqrt(mean(pred - obs)^2)

#### > link to  __[source of RMSE equation](https://rafalab.github.io/dsbook/introduction-to-machine-learning.html)__



#### if RMSE = sd, model somewhat predicts the mean
#### if RMSE < sd, model shows ability to learn, depends on how much it is lower
#### if RMSE > sd, model didnt even learn to guess mean correctly

#### if overall accuracy between training and testing differs a lot, this can be due to overtrain that causes over fitting.



#### there are users that rate only one movie, i.e. userId=="1"
#### there are other users that rate certain genre movies higher, i.e. userId=="10"
#### therefore, each user carries a certain bias in his/her decision toward certain movies and genres


#### RMSE = sqrt(1/n (r_hat_u_m - r_u_m))
#### r_hat_u_m = predicted rating for movie m and user u.
#### r_u_m = test set rating for movie m and user u.

#### b_u = bias for user u
#### b_m = this provides an amount to diminish the effect of user bias

#### ratings from each user was centered around zero by removing the mean and then divide the sum of centered means by the count of values within.
#### ratings for each movie was centered around zero by removing the mean and then divide the sum of centered means by the count of values within.

#### in other words, it could be seen as deriving standard errors out of each sub group of userID and movieId.

#### I have tried n() function of dplyr library to divide it by the frequency of each sub-group of userId and movieId, so that I can reduce the impact of variations. 

#### second, I tried ddply functionality of plyr library, again, to have a better estimate




## Conclusion

#### Recommender systems are parts of our daily lives. Understanding the preferences of each individual to better suit them with the products is the goal of every profit maximizing business. Therefore, the importance of it is undeniable. From a movie to watch on any given day, to what to wear at events, to what to reads, and on, recommendation tools play such a critical role in shaping the demand creation. Given the current structure of social media and their genius ability to collect data about the people's choices in such detail enable marketing to reach an incredibly accurate efficiency levels. By filtering those choice in a content base or collaborative, we can match consumers with the right products at the right time.

#### For this assignment, I have tried multiple models to reduce RMSE. Some models, unfortunately, due to RAM constraints, didn't produce results. Because of this, just to see whether they work, I exported a 1% of the data to check the code and it works fine. But, on the full data, my laptop is unable to produce any results and warn me for being unable to "allocate a vector size of 7.3 Gb."

#### On the partial data, the models that I specified are able to reduce RMSE between 1% and 5%, but that stills keeps me above the specified threshold.

#### To overcome this problem, I applied the model that's been created by Hans Bystrom at Stanford University. In his paper of "Movie Recommendations from User Ratings", he stated this equation:  bui = mu + bu + bi. 

#### After obtaining the bu and bi values that are stated in this paper by using the n() function from dpylr and ddply function from plyr, I was finally able to reduce RMSE even further and eventually pass the target.

#### Though more work is required to get a better picture of ways of reducing RMSE, my preliminary results are able to reduce RMSE below the asked threshold.

