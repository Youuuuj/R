# 유준

rm(list = ls())

getwd()
setwd('C:/Users/You/Desktop/빅데이터 수업자료/R/dataset2')
product <- read.csv('product.csv', header = T)
str(product)

install.packages("car")
library(car)


# 1 

# 1-1
# 샘플링
x <-sample(1:nrow(product), 0.7 * nrow(product))
train <- product[x,]  # 학습데이터
test <- product[-x,]  # 검정데이터

# 변수 모델링
formula = 제품_만족도 ~ 제품_친밀도 + 제품_적절성

# 1-2
# 학습데이터 이용 회귀모델 생성
pro <- lm(formula = formula, data = train)
pro
summary(pro)


# 1-3
# 검증데이터 이용 예측치 생성
pre <- predict(pro, test)
pre

# 1-4
# 평가
cor(pre, test$제품_만족도)





# 2
library(ggplot2)
data("diamonds")
diamonds
str(diamonds)


result.lm <- lm(formula = price ~ carat + table + depth, data = diamonds)
result.lm


library(car)
vif(result.lm)
sqrt(vif(result.lm)) > 2

summary(result.lm)

# 2-1 
# 큰 영향을 미치는 변수는 x1. 캐럿이다

# 2-2
# carat이 1단위 증가할때 가격은 7858.771 증가(+)하고
# table이 1단위 증가할때 가격은 104.473 감소(-)
# depth가 1단위 증가할때 가격은 151.235 감소(-) 
