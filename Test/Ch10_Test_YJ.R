# 유준

# 2
library(dplyr)
data(iris)
str(iris)

# 2-1
fil_iris <- iris %>% filter(Sepal.Width >= 3.7)

# 2-2
fil_iris <- fil_iris[,c(2,4,5)]
fil_iris <- fil_iris %>% select(2,4,5)
fil_iris

rm(list = ls())

# 2-3
diff_iris <- fil_iris %>% mutate(diff = .[,1]-.[,2])
head(diff_iris$diff, 10)


# 2-4
spe_iris <- diff_iris %>% group_by(Species) %>% summarise(S_W_mean = mean(Sepal.Width), P_W_mean = mean(Petal.Width))
spe_iris


# 2-5
ar_iris <- diff_iris %>% arrange(desc(diff))
ar_iris[4,3]



# 3
getwd()
setwd('C:/Users/You/Desktop/빅데이터 수업자료/R/dataset3')


# 3-1
user_data <- read.csv('user_data.csv', header = T)
str(user_data)
head(user_data)

# 3-2
return_data <- read.csv('return_data.csv', header = T)
str(return_data)
head(return_data)

# 3-3
library(reshape2)

customer_return <- dcast(return_data, user_id ~ return_code, length)
head(customer_return)

colnames(customer_return) <- c('user_id', '제품이상(1)', '원인불명(2)', '변심(3)', '기타(4)')
customer_return

# 3-4
library(plyr)

customer_return_data <- join(user_data, customer_return, by = 'user_id')
head(customer_return_data)

# 3-5
tail(customer_return_data, 10)
