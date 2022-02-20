# 베이지안(baysian) 확률
# 베이지안 확률 모델은 주관적인 추론을 바탕으로 만들어진 '사전확률'을 
# 추가적인 관찰을 통한 '사후확률'로 업데이트하여 불확실성을 제거할 수 있다고 믿는 방법

# 베이즈 정리는 posteriori 확률을 찾는 과정이고 베이즈 추론을 MAP(Maximum a Posteriori)문제라고 부르기도 함


# 실습
install.packages('e1071')
install.packages('caret')

library(e1071)
getwd()
data <- read.csv('heart.csv', header = T)

head(data)
str(data)
library(caret)

set.seed(1234)  # 특정한 난수 생성 공식에서 처음 시작값을 주어 매번 같은 값이 나오게 만드는 것
tr_data <- createDataPartition(y = data$AHD, p = 0.7, list = FALSE) # 각기다른 항목의 비율을 일정하게 만들어줌
tr <- data[tr_data,]
te <- data[-tr_data,]

Bayes <- naiveBayes(AHD ~ ., data = tr)
Bayes

predicted <- predict(Bayes, te, type = 'class')
predicted

AHD <- as.factor(te$AHD)
confusionMatrix(predicted, AHD)



# 의사결정 나무(Decision Tree)
# 의사결정트리 방식은 나무 구조 형태로 분류 결과 도출

# (1) party패키지 이용 분류 분석
# 조건부 추론 마무
# cart기법으로 구현한 의사결정 나무의 문제점
# 1) 통계적 유의성에 대한 판단없이 노드를 분할하는데 대한 과적합(Overfitting) 문제 발생
# 2) 다양한 값으로 분할 가능한 변수가 다른 변수에 비해 선호되는 현상
# 이 문제를 해결하는 조건부 추론 나무(Conditional Inference Tree)
# party패키지의 ctree()함수 이용

# 의사결정 트리 생성
# 1단계 : party패키지 설치
install.packages('party')
library(party)

# 2단계 : airquality 데이터셋 로딩
library(datasets)
str(airquality)

# 3단계 : formula 생성
formula <- Temp ~ Solar.R + Wind + Ozone

# 4단계 : 분류 모델 생성 - formula를 이용하여 분류모델 생성
air_tree <- ctree(formula, data = airquality)
air_tree

# 첫번째: 반응변수(종속변수)에 대해서 설명변수(독립변수)가 영향을 미치는 중요 변수의 척도.
# 수치가 작을수록 영향을 미치는 정도가 높고, 순서는 분기되는 순서를 의미
# 두번째: 의사결정 트리의 노드명
# 세번째: 노드이 분기기준(criterion)이 되는 수치.
# 네번째: 반응변수(종속변수)의 통계량(statistic). 
# *마지막 노드이거나 또 다른 분기 기준이 있는 경우에는 세번째와 네 번째 수치는 표시되지 않는다.


# 5단계 : 분류분석 결과
plot(air_tree)



# 학습데이터와 검정데이터 샘플링으로 분류분석 수행
# 1단계 : 학습데이터와 검정데이터 샘플링
# set_seed(1234)
idx <- sample(1:nrow(iris), nrow(iris)*0.7)
train <- iris[idx,]
test <- iris[-idx,]

# 2단계 : formula 생성
formula <- Species ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width

# 3단계 : 학습데이터 이용 분류모델 생성
iris_ctree <- ctree(formula, data = train)
iris_ctree

# 4단계 : 분류모델 플로팅
# 4-1단계 : 간단한 형식으로 시각화
plot(iris_ctree, type = 'simple')

# 4-2 단계 : 의사결정 나무로 결과 플로팅
plot(iris_ctree)

# 5단계 : 분류모델 평가
# 5-1단계 : 모델의 예측치 생성과 혼돈 매트릭스 생성
pred <- predict(iris_ctree, test)
table(pred, test$Species)

# 5-2단계 : 분류 정확도
(17 + 14 + 11) / nrow(test)



# K겹 교차 검정 샘플링으로 분류 분석하기
# 1단계 : K겹 교차 검정을 위한 샘플링
library(cvTools)
cross <- cvFolds(nrow(iris), K = 3, R = 2)

# 2단계 : K겹 교차 검정 데이터 보기
str(cross)
cross
length(cross$which)
dim(cross$subsets)
table(cross$which)

# 3단계 : K겹 교차 검정 수행
R = 1:2
K = 1:3
CNT = 0
ACC <- numeric()

for(r in R){
  cat('\n R = ', r, '\n')
  for(k in K){
    
    datas_ids <- cross$subsets[cross$which == k,r]
    test <- iris[datas_ids,]
    cat('test : ', nrow(test), '\n')
    
    formula = Species ~ .
    train <- iris[-datas_ids,]
    cat('train : ', nrow(train), '\n')
    
    model = ctree(Species ~ ., data = train)
    pred <- predict(model, test)
    t <- table(pred, test$Species)
    print(t)
    
    CNT <- CNT + 1
    ACC[CNT] <- (t[1,1] + t[2,2] + t[3,3]) / sum(t)
  }
}

CNT

# 4단계 : 교차 검정 모델 평가
ACC
length(ACC)

result_acc <- mean(ACC, na.rm = T)
result_acc



# 고속도로 주행거리에 미치는 영향변수 보기
# 1단계 : 패키지 설치 및 로딩
library(ggplot2)
data(mpg)

# 2단계 : 학습데이터와 검정데이터 생성
t <- sample(1:nrow(mpg), 120)
train <- mpg[-t,]
test <- mpg[t,]
dim(train)
dim(test)

# 3단계 : formula작성과 분류모델 생성
test$drv <- factor(test$drv)
formula <- hwy ~ displ + cyl + drv
tree_model <- ctree(formula, data = test)
plot(tree_model)




# Adultuci 데이터 셋을 이용한 분류 분석
# 1단계 : 패키지 설치 및 데이터 셋 구조 보기
install.packages('arules')
library(arules)
data("AdultUCI")
str(AdultUCI)
names(AdultUCI)

# 2단계 : 데이터샘플링
set.seed(1234)
choice <- sample(1:nrow(AdultUCI), 10000)
choice

adult.df <- AdultUCI[choice,]
str(adult.df)

# 3단계 : 변수 추출 및 데이터 프레임 생성
# 3-1단계 : 변수 추출
capital <- adult.df$`capital-gain`
hours <- adult.df$`hours-per-week`
education <- adult.df$`education-num`
race <- adult.df$race
age <- adult.df$age
income <- adult.df$income

# 3-2단계 : 데이터프레임 생성
adult_df <- data.frame(capital = capital, age = age, race = race, hours = hours, education = education, income = income)
str(adult_df)

# 4단계 : formula 생성 - 자본이득(capital)에 영향을 미치는 변수
formula <- capital ~ income + education + hours + race + age

# 5단계 : 분류모델 생성 및 예측
adult_ctree <- ctree(formula, data = adult_df)
adult_ctree

# 6단계 : 분류모델 플로팅
plot(adult_ctree)

# 7단계 : 자본이득(capital) 요약 통계량 보기
adultResult <- subset(adult_df, adult_df$income == 'large' & adult_df$education > 14)
length(adultResult)
summary(adultResult)
boxplot(adultResult)



# 조건부 추론 나무
library(party)

# 샘플링
str(iris)
set.seed(1000)
sampnum <- sample(2, nrow(iris), replace = T, prob = c(0.7, 0.3))
sampnum

# training & testing data 구분
trData <- iris[sampnum == 1,]
head(trData)
teData <- iris[sampnum == 2,]
head(teData)

shortvar <- Species ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width

# 학습
citreeResult <- ctree(shortvar, data = trData)
citreeResult

# 예측값과 실제값 비교
forcated <- predict(citreeResult, trData)
table(forcated, trData$Species)

# 테스트 데이터를 이용하여 분류
citreeResult2 <- ctree(shortvar, data = teData)

forcated2 <- predict(citreeResult2, data = teData)
table(forcated2, teData$Species) 


# 시각화
plot(citreeResult2)


# 종(Species) 판단
# Petal.Length <= 1.9 : setosa로 판단
# Petal.Length > 1.9 & Petal.Width <= 1.6 : versicolor로 판단
# 나머지: virginica 로 판단









# rpart패키지 이용 분류분석
# 1단계 : 패키지 설치 및 로딩
install.packages('rpart')
library(rpart)
install.packages('rpart.plot')
library(rpart.plot)

# 2단계 : 데이터 로딩
data(iris)

# 3단계 : rpart()함수를 이용한 분류분석
rpart_model <- rpart(Species ~ ., data = iris)
rpart_model

# 4단계 : 분류분석 시각화
rpart.plot(rpart_model)


# 날씨 데이터를 이용하여 비 유무 예측
# 1단계 : 데이터가져오기
setwd('C:/Users/You/Desktop/빅데이터/빅데이터 수업자료/R/dataset4')
weather = read.csv('weather.csv', header = T)

# 2단계 : 데이터 특성 보기
str(weather)
head(weather)

# 3단계 : 분류분석 데이터 가져오기
weather.df <- rpart(RainTomorrow ~ ., data = weather[, c(-1, -14)], cp = 0.01)

# 4단계 : 분류분석 시각화
rpart.plot(weather.df)

# 5단계 : 예측치 생성과 코딩 변경
# 5-1단계 : 예측치 생성
weather_pred <- predict(weather.df, weather)
weather_pred[,2]

# 5-2단계 : y의 범주로 코딩 변환
weather_pred2 <- ifelse(weather_pred[,2] >= 0.5, 'Yes','No')

# 6단계 : 모델 평가
table(weather_pred2, weather$RainTomorrow)

# 정확도
(278+53)/nrow(weather)





# rpart패키지 이용 의사결정 나무 iris데이터
# 의사결정나무 생성
CARTTree <- rpart(Species ~ ., data = iris)
CARTTree

# 의사결정나무 시각화
plot(CARTTree, margin = 0.2)
text(CARTTree, cex = 1)

# CARTTree를 이용하여 iris데이터 총 전체를 대상으로 예측
predicted <- predict(CARTTree, newdata = iris, type = 'class')

# 예측 정확도
sum(predicted == iris$Species)/NROW(predicted)

# 실제값과 예측값의 비교
real <- iris$Species
table(real, predicted)

50+49+45/nrow(iris)



# y의 값을 setosa로 하면 100개를 설명할 수 없음
# 각 종마다 확률은 0.3333으로 동일
# Petal.Length가 2.45보다 작은 것이 50개 있고 y의 값을 setosa로 했을 때, 설명되지 않는 부분은 없음
# Petal.Length가 2.45보다 크거나 같은 것이 100개. y의 값을 versicolor로 했을 때, 50개가 설명되지 않음
# 의사결정나무를 보면 species(종)인 setosa, versicolor, virginica를 식별하기 위하여 네개의 항목 중
# Petal.Length와 Petal.Width만을 기준으로 사용. --> 두개의 기준으로 충분히 분리가 가능
# 결과로 부터 해석:
# Petal.Length < 2.45 : setosa로 분류
# Petal.Length > 2.45 & Petal_Width < 1.75 : vericolor로 분류
# 나머지: verginica로 분류
# 예측정확도: 96%
