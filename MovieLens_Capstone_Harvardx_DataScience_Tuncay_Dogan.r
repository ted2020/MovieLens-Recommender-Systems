
library(tidyverse)
library(caret)
library(ggplot2)
libraryr(MLmetrics)
#library(nlme)
#library(plyr) # conflict with dplyr, be careful
#library(dplyr)
#library(magrittr)
#library(olsrr)
#library(psych)
#library(plotrix)
#library(MASS)
#library(broom)
#library(glmnet)
#library(stringr)

#library(rmarkdown)

#library(e1071)
#library(randomForest)


#movielens <- read.csv("test.csv") # this is a portion I used before working with the full movielens data.
                # this makes it easier to re-run and loads faster, since full data is quiet big.

#if(!require(tidyverse)) install.packages("tidyverse", repos = "http://cran.us.r-project.org")
#if(!require(caret)) install.packages("caret", repos = "http://cran.us.r-project.org")

# MovieLens 10M dataset:
# https://grouplens.org/datasets/movielens/10m/
# http://files.grouplens.org/datasets/movielens/ml-10m.zip

dl <- tempfile()
download.file("http://files.grouplens.org/datasets/movielens/ml-10m.zip", dl)

ratings <- read.table(text = gsub("::", "\t", readLines(unzip(dl, "ml-10M100K/ratings.dat"))),
                      col.names = c("userId", "movieId", "rating", "timestamp"))

movies <- str_split_fixed(readLines(unzip(dl, "ml-10M100K/movies.dat")), "\\::", 3)
colnames(movies) <- c("movieId", "title", "genres")
movies <- as.data.frame(movies) %>% mutate(movieId = as.numeric(levels(movieId))[movieId],
                                           title = as.character(title),
                                           genres = as.character(genres))

movielens <- left_join(ratings, movies, by = "movieId")



this_year <- as.numeric(format(Sys.time(), "%Y"))
    # convert timestamp to date format
movielens <- movielens %>% mutate(timestamp2 = structure(movielens$timestamp[],class=c('POSIXt','POSIXct')))
    # extract movie release year from the title
movielens <- movielens %>% mutate(releaseyear = as.numeric(str_extract(str_extract(title, "[/(]\\d{4}[/)]$"),regex("\\d{4}"))))
    # find how old the movie is
movielens <- movielens %>% mutate(age_of_movie=this_year-movielens$releaseyear)
    # find the year the movie is rated by the user(s)
movielens <- movielens %>% mutate(rateyear = as.numeric(as.character(format(as.Date(timestamp2), "%Y"))))
    # find the month the movie is rated
movielens <- movielens %>% mutate(ratemonth_numeric = as.numeric(as.character(format(as.Date(timestamp2), "%m"))))
movielens <- movielens %>% mutate(ratemonth = format(as.Date(timestamp2), "%B"))
    # which week day the movie is rated by the user(s)
movielens <- movielens %>% mutate(weekday = format(as.Date(timestamp2), "%A"))
    # rate_release_dif = gives difference between rate year and release year
movielens <- movielens %>% mutate(rate_release_dif=movielens$rateyear - movielens$releaseyear)
    # separate genres 
movielens2 <- separate_rows(movielens,genres,sep="\\|")
    # assign numeric values to separated genres
movielens2 <- movielens2 %>% mutate(genres_numeric=as.numeric(as.factor(movielens2$genres)))

head(movielens,1)
head(movielens2,1)

anyNA(movielens)
anyNA(movielens2)

summary(movielens)

table(movielens2$genres)
# of course, some movies fall in to a couple of genre categories, 
#but for the sake of understanding the intituion, this tool is good enough.

str(movielens2)

#describe(movielens)

length(unique(movielens$movieId))
n_distinct(movielens$userId)
min(movielens$releaseyear)
max(movielens$releaseyear)
min(movielens$rateyear)
max(movielens$rateyear)

# proportion of each genre in movielens set
 p1<- data.frame(sort(round(prop.table(table(movielens2$genres))*100,1)))%>%arrange(desc(Freq))
p1

# top 20 movies with the highest number of ratings given in descending order

titleratingcount <- movielens %>% group_by(title) %>%
summarize(count = n()) %>%
top_n(20,count) %>%
arrange(desc(count))

titleratingcount


#most given ratings in order from most to least

ratingcount <- movielens %>% group_by(rating) %>%
	summarize(count = n()) %>%
	arrange(desc(count))

ratingcount

# total rating counts for each rating category and its proportion

sum=sum(ratingcount$count)
ratingcount2 <- ratingcount%>%mutate(p_count=(ratingcount$count)/sum)
ratingcount2

# movie genre count by year in year descending order

moviecountperyear <- movielens2 %>%
select(movieId, releaseyear, genres) %>%
group_by(releaseyear, genres) %>%
summarise(count = n()) %>% arrange(desc(releaseyear))


head(moviecountperyear,10)

# movie genre count by year in count descending order

moviecountperyear2 <- movielens2 %>%
select(movieId, releaseyear, genres) %>%
group_by(releaseyear, genres) %>%
summarise(count = n()) %>% arrange(desc(count))

head(moviecountperyear2,10)

# ratings by the release year of the movies

ratingsbyreleaseyear <- movielens %>% group_by(releaseyear) %>% summarize(mean_rating = mean(rating))
head(ratingsbyreleaseyear,10)

# ratings by the rate year of the movies

mean_rating_by_rate_year <- movielens %>% group_by(rateyear) %>% summarize(mean_rating =mean(rating))
mean_rating_by_rate_year

# this shows the mean ratings of each genre.

#movielens %>% summarize(mean(rating), sd(rating))

# if RMSE = sd, model somewhat predicts the mean
# if RMSE < sd, model shows ability to learn, depends on how much it is lower
# if RMSE > sd, model didnt even learn to guess mean correctly 

# if overall accuracy between training and testing differs a lot, this can be due to overtrain that causes over fitting.


rating_mean_sd_genre <- movielens2 %>% group_by(genres) %>% summarize(mean(rating), sd(rating))
rating_mean_sd_genre

mean_sd_by_movieid <- movielens%>% group_by(movieId) %>% summarize(mean=mean(rating), sd=sd(rating),se=sd/length(movieId)) %>% arrange(desc(sd))
head(mean_sd_by_movieid)

mean_sd_by_userid <- movielens%>% group_by(userId) %>% summarize(mean=mean(rating), sd=sd(rating),se=sd/length(movieId)) %>% arrange(desc(sd))
head(mean_sd_by_userid)

movielens%>% group_by(movieId) %>% 
summarize(n=n(),howold=2019-first(releaseyear),title=title[1],mean=mean(rating)) %>%
mutate (hmray=n/howold)%>% 
top_n(10,hmray) %>% #hmray=how many rates a year
arrange(desc(mean))

# frequency of users voting(rating) for each genre 

a <- data.frame(table(movielens2$genres))
names(a) <- c("genre", "genre sum")
c <- a[2]/(n_distinct(movielens2$userId))
names(c) <- "freq"
d <- cbind(a,c)
d %>% arrange(desc(freq))

weekday_mean_sd <- movielens%>% group_by(weekday) %>% summarize(mean=mean(rating), sd=sd(rating)) %>% arrange(desc(mean))
weekday_mean_sd

corr <- movielens2 %>% select(rating,userId,movieId,releaseyear,age_of_movie,rateyear)
cor(corr)

#print(paste((n_distinct(movielens$rateyear)), "unique dates"))
#157 unique dates

movielens %>% group_by(rateyear) %>%
summarize(rating = mean(rating)) %>%
ggplot(aes(rateyear, rating, color=(rating>=mean(rating)))) +
geom_point() +
theme(text = element_text(),axis.text.x = element_text(size = 4,angle = 90, hjust = 0, vjust = 1, face = "plain"))+
ggtitle("rate year & rating distribution by mean rating")



#print(paste((n_distinct(validation3$releaseyear)), "unique dates"))
#94 unique dates

movielens2 %>% group_by(releaseyear) %>%
summarize(rating = mean(rating)) %>%
ggplot(aes(releaseyear, rating,color=(rating>=mean(rating)))) +
geom_point() + 
geom_smooth(span=0.5)+
ggtitle("release year & rating distribution by mean rating")



#print(paste((n_distinct(validation3$releaseyear)), "unique dates"))
#94 unique dates

movielens2 %>% group_by(genres) %>%
summarize(rating = mean(rating)) %>%
ggplot(aes(genres, rating,color=(rating>=mean(rating)))) +
geom_point() + 
geom_smooth(span=0.2)+
theme(axis.text.x = element_text(angle = 90, hjust = 1))+
ggtitle("genres rating distribution")



movielens2 %>% 
  ggplot(aes(rating)) + 
  geom_histogram(binwidth=0.2, fill="black",color="black") +  
  ggtitle("Rating Distribution seq(0, 5, 0.5)")


# most users rated movies in single digits.

movielens2 %>% 
  count(userId) %>% 
  ggplot(aes(n)) + 
  geom_histogram(binwidth = 1, color = "black") + 
  #scale_x_continuous(trans="log2")+
  ggtitle("user count rate distribution")

# most users rated movies in single digits. To make better inference, i log the the n to visualize more clear

movielens2 %>% 
  count(userId) %>% 
  ggplot(aes(n)) + 
  geom_histogram(binwidth = 1, color = "black") + 
  scale_x_continuous(trans="log2")+
  ggtitle("user count rate distribution")

# movies ratings count distribution

movielens %>% 
  count(movieId) %>% 
  ggplot(aes(n)) + 
  geom_histogram(binwidth = 1, color = "black") + 
  scale_x_continuous(trans="log2")+
  ggtitle("movie count rate distribution")


# this shows that mid 1990s, almost every genre had an increase in count, meaning more produced films
# this is just before the tech boom
# people's expectation were high
# that leads to more consumption of leisure time

moviecountperyear %>%
    ggplot(aes(genres,releaseyear, color=count)) +
    geom_point(aes(size=log(count))) +
    theme(axis.text.x = element_text(angle = 90, hjust = 1))+
    ggtitle(" overall increase in each genre quantity before tech boom")


# this is another way of seeing increase in movie quantity just before the tech boom
moviecountperyear %>%
    filter(releaseyear <= 2000 & genres=="Action") %>%
    ggplot(aes(releaseyear, count)) +
    geom_line() +
    ggtitle("quantity jump before tech boom")

movielens2 %>%
    filter(releaseyear <= 1980 & genres %in% c("Comedy")) %>%
    ggplot(aes(rating,releaseyear))+
    geom_jitter()

# compare this to >=1980, it's clear to see that after 1980, movie industry started mass producing,
# therefore the quantity overcame the quality,
# thus the distribution of ratings almost did even out.
# before 1980, most comedy movies were rated between 3 and 5.
# but after 1980, range became 1 and 5
# the same idea can be applied to other genres

movielens %>% 
filter(releaseyear >= 2000) %>% 
group_by(movieId) %>%
summarize(n=n(),howold=2019-first(releaseyear),title=title[1],mean=mean(rating)) %>%
mutate (hmray=n/howold)%>% #hmray=how many rates a year
ggplot(aes(hmray, mean)) +
geom_point() +
geom_smooth() +
ggtitle("movie ratings by hmray")
# over time, ratings stabilize at around the mean

movielens2 %>% group_by(genres) %>%
	summarize(n = n(), avg = mean(rating), se = sd(rating)/sqrt(n())) %>%
	filter(n >= 100) %>% 
	mutate(reorder(genres, avg)) %>%
	ggplot(aes(x = genres, y = avg, ymin = avg - 2*se, ymax = avg + 2*se)) + 
	geom_point() +
	geom_errorbar() + 
	theme(axis.text.x = element_text(angle = 90, hjust = 1))
	ggtitle("average movie ratings by genre")


movielens2 %>% group_by(weekday) %>%
	summarize(n = n(), avg = mean(rating), se = sd(rating)/sqrt(n())) %>%
	filter(n >= 1000) %>% 
	mutate(reorder(weekday, avg)) %>%
	ggplot(aes(x = weekday, y = avg, ymin = avg - 2*se, ymax = avg + 2*se)) + 
	geom_point() +
	geom_errorbar() + 
	theme(axis.text.x = element_text(angle = 90, hjust = 1))
	ggtitle("average movie ratings by week day")


movielens2 %>% group_by(releaseyear) %>%
	summarize(n = n(), avg = mean(rating), se = sd(rating)/sqrt(n())) %>%
	filter(n >= 5) %>% 
	mutate(reorder(releaseyear, avg)) %>%
	ggplot(aes(x = releaseyear, y = avg, ymin = avg - 2*se, ymax = avg + 2*se)) + 
	geom_line() +
	geom_smooth() +
	ggtitle("movie ratings by release year")



movielens2 %>% group_by(rateyear) %>%
	summarize(n = n(), avg = mean(rating), se = sd(rating)/sqrt(n())) %>%
	filter(n >= 10) %>% 
	mutate(reorder(rateyear, avg)) %>%
	ggplot(aes(x = rateyear, y = avg, ymin = avg - 2*se, ymax = avg + 2*se)) + 
	geom_line() +
	geom_smooth() +
	ggtitle("movie ratings by rate year")




# Validation set will be 10% of MovieLens data

set.seed(1)
test_index <- createDataPartition(y = movielens$rating, times = 1, p = 0.1, list = FALSE)
edx <- movielens[-test_index,]
temp <- movielens[test_index,]

# Make sure userId and movieId in validation set are also in edx set

validation <- temp %>% 
     semi_join(edx, by = "movieId") %>%
     semi_join(edx, by = "userId")

# Add rows removed from validation set back into edx set

removed <- anti_join(temp, validation)
edx <- rbind(edx, removed)

rm(dl, ratings, movies, test_index, temp, movielens, removed)

length(validation$rating)
length(edx$rating)
head(validation,1)

mu <- mean(edx$rating)
paste0("sd is ", sd(validation$rating))
paste0("baseline RMSE is ", RMSE(mu,validation$rating))

# by using ddply functionality of plyr library
    # fyi: running plyr and dplyr library at the same time causes an error.

cdata_movieId <- ddply(edx, c("movieId"), summarise,
               N = length(movieId),
               group_rating = mean(rating),
               group_se_by_movie = (group_rating - mean(edx$rating))/N
)
cdata_movieId <- cdata_movieId %>% arrange(desc(group_se_by_movie))
head(cdata_movieId)
anyNA(cdata_movieId)
showmissing <- cdata_movieId[!complete.cases(cdata_movieId),]

cdata_userId <- ddply(edx, c("userId"), summarise,
               N = length(userId),
               group_rating = mean(rating),
               group_se_by_user = (group_rating - mean(edx$rating))/N
)
cdata_userId <- cdata_userId %>% arrange(desc(group_se_by_user))
head(cdata_userId)
anyNA(cdata_userId)
showmissing <- cdata_userId[!complete.cases(cdata_userId),]

MyMerge <- function(x, y){
  df <- merge(x, y, by= "userId", all.x= TRUE, all.y= TRUE)
  return(df)
}
cdata_merged_edx <- Reduce(MyMerge, list(edx,cdata_userId))
head(cdata_merged_edx) %>% arrange(desc(group_se_by_user))

MyMerge <- function(x, y){
  df <- merge(x, y, by= "movieId", all.x= TRUE, all.y= TRUE)
  return(df)
}
cdata_merged_edx <- Reduce(MyMerge, list(cdata_merged_edx,cdata_movieId))
head(cdata_merged_edx)  %>% arrange(desc(group_se_by_movie))

cdata_merged_edx <- cdata_merged_edx %>% mutate(adj_rating = mean(cdata_merged_edx$group_rating.x) + group_se_by_user+group_se_by_movie)
head(cdata_merged_edx)

paste0("edx RMSE is: ",RMSE(cdata_merged_edx$rating,cdata_merged_edx$adj_rating))

cdata_movieId <- ddply(validation, c("movieId"), summarise,
               N = length(movieId),
               group_rating = mean(rating),
               group_se_by_movie = (group_rating - mean(validation$rating))/N
)
cdata_movieId <- cdata_movieId %>% arrange(desc(group_se_by_movie))
head(cdata_movieId)
anyNA(cdata_movieId)
showmissing <- cdata_movieId[!complete.cases(cdata_movieId),]

cdata_userId <- ddply(validation, c("userId"), summarise,
               N = length(userId),
               group_rating = mean(rating),
               group_se_by_user = (group_rating - mean(validation$rating))/N
)
cdata_userId <- cdata_userId %>% arrange(desc(group_se_by_user))
head(cdata_userId)
anyNA(cdata_userId)
showmissing <- cdata_userId[!complete.cases(cdata_userId),]

MyMerge <- function(x, y){
  df <- merge(x, y, by= "userId", all.x= TRUE, all.y= TRUE)
  return(df)
}
cdata_merged_validation <- Reduce(MyMerge, list(validation,cdata_userId))
head(cdata_merged_validation) %>% arrange(desc(group_se_by_user))

MyMerge <- function(x, y){
  df <- merge(x, y, by= "movieId", all.x= TRUE, all.y= TRUE)
  return(df)
}
cdata_merged_validation <- Reduce(MyMerge, list(cdata_merged_validation,cdata_movieId))
head(cdata_merged_validation)  %>% arrange(desc(group_se_by_movie))

cdata_merged_validation <- cdata_merged_validation %>% mutate(adj_rating = mean(cdata_merged_validation$group_rating.x) + group_se_by_user+group_se_by_movie)
head(cdata_merged_validation)

paste0("validation RMSE is: ",RMSE(cdata_merged_validation$rating,cdata_merged_validation$adj_rating))

# ------------------

# by using n() functionality of dyplr library
mu <- mean(edx$rating)

bi <- edx %>% 
group_by(movieId) %>% 
summarize(bi= sum(rating - mu)/(n()))

bu <- edx %>% 
group_by(userId) %>% 
summarize(bu= sum(rating - mu)/(n()))

predicted_ratings3 <- edx %>%
    left_join(bi, by = "movieId") %>%
    left_join(bu, by = "userId") %>%
    mutate(pred = mu+bu+bi) %>% .$pred

#plot(predicted_ratings3)
#plot(movielens$rating)

paste0("edx set RMSE is: ",RMSE(predicted_ratings3,edx$rating))


# by using n() functionality of dyplr library
mu <- mean(validation$rating)

bi <- validation %>% 
group_by(movieId) %>% 
summarize(bi= sum(rating - mu)/(n()))

bu <- validation %>% 
group_by(userId) %>% 
summarize(bu= sum(rating - mu)/(n()))

predicted_ratings4 <- validation %>%
    left_join(bi, by = "movieId") %>%
    left_join(bu, by = "userId") %>%
    mutate(pred = mu+bu+bi) %>% .$pred

#plot(predicted_ratings4)
#plot(movielens$rating)

paste0("validation set RMSE is: ",RMSE(predicted_ratings4,validation$rating))
