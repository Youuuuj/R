# 유준

# 1
library(reshape2)
data(iris)
str(iris)
head(iris)

# 1-1
species <- melt(iris, id = 'Species')
species

# 1-2
sum_spe <- dcast(species, Species ~ variable, sum)
head(sum_spe)

# 2
library(dplyr)
data(iris)

# 2-1
fil_iris <- iris %>% filter(Petal.Length >= 1.5) 
fil_iris

# 2-2
sel_iris <- fil_iris %>% select(c(1,3,5))
sel_iris

# 2-3
mu_iris <- sel_iris %>% mutate(diff = sel_iris[,1]-sel_iris[,2])
head(mu_iris)

# 2-4
group_iris <- mu_iris %>% group_by(Species) %>% summarise(mean_Sepal = mean(Sepal.Length), mean_Petal = mean(Petal.Length))
group_iris
