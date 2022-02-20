# 상관관계 분석 수행

# 1단계 데이터 가져오기

getwd()
setwd('C:/Users/You/Desktop/빅데이터 수업자료/R/dataset2')
product <- read.csv('product.csv', header = T)
head(product)

# 2단계 : 기술통계량
summary(product)
sd(product$제품_친밀도);sd(product$제품_적절성);sd(product$제품_만족도)

# 상관계수 보기
# 변수간의 상관계수는 stats패키지에서 제공하는 cor()함수 사용
# 형식: cor(x, y=NULL, use=”everything”, method=c(“pearson”, “kendall”, “spearman”))
# method를 생략하면 pearson이 사용된다(default)


# 1단계 : 변수 간의 상관계수 보기
cor(product$제품_친밀도,product$제품_적절성)
cor(product$제품_친밀도,product$제품_만족도)

# 2단계 : 제품_적절성과 제품_만족도의 상관계수 보기
cor(product$제품_적절성, product$제품_만족도)

# 3단계 : 제품_적절성+제품_친밀도 와 제품_만족도의 상관계수 보기
cor(product$제품_적절성 + product$제품_친밀도, product$제품_만족도)


# 전체 변수 간의 상관계수 보기
cor(product, method = 'pearson')
# 대각선은 자기 상관계수 의미

# 방향성 있는 색상으로 표현
install.packages('corrgram')
library(corrgram)
corrgram(product)
corrgram(product, upper.panel = panel.conf)
corrgram(product, lower.panel = panel.conf)



# 차트에 밀도곡선, 상관성, 유의확률(별표) 추가
# 1단계 : 패키지 설치
install.packages("PerformanceAnalytics")
library(PerformanceAnalytics)

# 2단계 : 상관성, p값(*), 정규분포(모수 검정 조건) 시각화
chart.Correlation(product, histogram = , pch = '+')

# 서열척도 대상 상관계수
cor(product, method = 'spearman')

# 피어슨(Pearson) 상관계수: 대상변수가 등간척도 또는 비율척도일 때
# 스피어만(Spearman) 상관계수: 대상변수가 서열척도일 때



# 교차분석
# 두 개 이상의 범주형 변수를 대사응로 교차 분할표를 작성하고, 이를 통해서 변수 상호간의 관련성 여부를 분석
# 빈도 분석 결과에 대한 보충 자료를 제시하는데 효과적

# 교차검정(Cross Table Analyze): 범주형 자료(명목/서열 척도)를 대상으로 두개 이상의 변수들에 대한 관련성을 
# 알아보기위해서 결합분포를 나타내는 교차 분할표를 작성하고 이를 통해서 변수 상호간의 관련성 여부를 분석하는 방법

# 교차분석은 빈도분석의 특성별 차이를 분석하기 위해 수행하는 분석방법으로 빈도 분석 결과에 때한 보충자료를 제시하는데 효과적


# 연구 환경에서 변수(독립/종속 변수)를 확인하여 모델링한 후 범주형 데이터로 변환하는 변수 리코딩 과정을 거친다.
# 대상변수를 분할표로 작성하기 위해서는 데이터프레임을 생성해야 한다.
# 변수 모델링: 특정 객체를 대상으로 분석할 속성(변수)을 선택하여 속성 간의 관계를 설정하는 일련의 과정
# 예) smoke 객체에서 education과 smoking 속성을 분석대상으로 하여 교육수준(education)이
#     흡연율(smoking)과 관련성이 있는가를 모델링하는 하는 경우 ‘education -> smoking’ 형태로 기술한다.
# 독립변수 -> 종속변수


# 변수 리코딩과 데이터프레임 생성
# 1단계 : 실습 파일 가져오기
data <- read.csv("cleanDescriptive.csv", header = TRUE)
head(data)

# 2단계 : 변수 리코딩
x <- data$level2
y <- data$pass2

# 교차 분할표 작성을 위해 데이터프레임 생성 방법
# data.frame(컬럼명 = x, 컬럼명 = y)
# x,y : 명목척도 변수

# 3단계 : 데이터프레임 생성
result <- data.frame(Level = x, Pass = y)
dim(result)

# 교차분석 
# 교차 분할표를 통해서 범주형 변수의 관계를 분석하는 방법으로 이전에 작성한 데이터프레임을 이용하여 교차분석을 수행한다


# 교차 분할표 작성
# 1단계 : 기본 함수를 이용한 교차 분할표 작성
table(result)

# 2단계 : 교차 분할표 작성을 위한 패키지 설치
install.packages('gmodels')
library(gmodels)
install.packages("ggplot2")
library(ggplot2)

# 3단계 : 패키지를 이용한 교차 분할표 작성
CrossTable(x = diamonds$color, y=diamonds$cut)



# 패키지를 이용한 교차 분할표 작성 : 부모의 학력수준과 자녀 대학 진학여부
# 변수모델 : 학력수준(독립변수) -> 진학여부(종속변수)
x <- data$level2
y <- data$pass2

CrossTable(x,y)




# 로지스틱 회귀분석
# 종속 변수와 독립변수 간의 관계를 나아태어 예측 모델을 생성한다는 점에서 선형 회귀분석방법과 유사

# 로지스틱 회귀분석의 특징
# 1) 분석목적: 종속 변수와 독립변수 간의 관계를 통해서 예측 모델 생성
# 2) 회귀분석과 차이점 : 종속변수는 반드시 범주형 변수(Yes/No. iris데이터의 Species)
# 3) 정규성 : 정규분포 대신에 이항분포를 따른다
# 4) 로짓변환 : 종속변수의 출력범위를 0과 1로 조정하는 과정
# 5) 활용분야 : 의료, 통신, 날씨 등 다양한 분야

install.packages("ROCR")
library(car)
library(lmtest)
library(ROCR)


# 1단계 : 데이터 가져오기
getwd()
setwd('C:/Users/You/Desktop/빅데이터 수업자료/R/dataset4')
weather = read.csv('weather.csv', stringsAsFactors = F)
dim(weather)
head(weather)
str(weather)

# 2단계 : 변수 선택과 더미 변수 생성
weather_df <- weather[, c(-1, -6, -8, -14)]
str(weather_df)

weather_df$RainTomorrow[weather_df$RainTomorrow == 'Yes'] <- 1
weather_df$RainTomorrow[weather_df$RainTomorrow == 'No'] <- 0
weather_df$RainTomorrow <- as.numeric(weather_df$RainTomorrow)
head(weather_df)

# X,Y 변수 설정
# Y변수를 대상으로 더미 변수를 생성하여 로지스틱 회귀분석 환경설정

# 3단계 : 학습데이터와 검정데이터 생성(7:3 비율)
idx <- sample(1:nrow(weather_df), nrow(weather_df)*0.7)
train <- weather_df[idx,]
test <- weather_df[-idx,]


# 4단계 :  로지스틱 회귀모델 생성
weather_model <- glm(RainTomorrow ~ ., data = train, family = 'binomial', na.action = na.omit)
weather_model
summary(weather_model)

# glm()함수
# 형식 : glm(y~x, data, family)
# family = 'binomial' 속성 : y변수가 이항형

# 로지스틱 회귀모델의 결과는 선형 회귀모델과 동일하게 x변수의 유의성 검정을 제공
# 하지만 F-검정 통계량과 모델의 설명력은 제공되지 않는다.

# 5단계 : 로지스틱 회귀모델 예측치 생성
pred <- predict(weather_model, newdata = test, type = 'response')
pred


result_pred <- ifelse(pred >= 0.5, 1, 0)
result_pred

table(result_pred)

# type=”response”속성:  예측 결과를 0-1사이의 확률값으로 예측치를 얻기 위해서 지정

# 모델 평가를 위해서 예측치가 확률값으로 제공되기 때문에 이를 이항형으로 변환하는 과정이 필요 
# Ifelse()함수를 이용하여 예측치의 벡터변수(pred)를 입력으로 이항형의 벡터변수(result_pred)를 생성

# 6단계 : 모델평가 - 분류정확도 계산
table(result_pred, test$RainTomorrow)

# 7단계 : ROC(Receiver Operation Characteristic) Curve를 이용한 모델 평가
pr <- prediction(pred, test$RainTomorrow)
prf <- performance(pr, measure = 'tpr', x.measure = 'fpr')

