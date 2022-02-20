# 변수 선택
# 회귀모델에서 독립변수의 증가는 모델의 결정계수를 증가시켜 설명력을 높이는 장점이 있지만 
# 다중 공선성 문제를 일으킬 수 있어서 추정의 신뢰도를 저하시킬 수 있고, 
# 독립변수가 많을 경우 예측성능이 좋지 않을 가능성이 많고 
# 독립성, 등분산성 등의 가정을 만족시키기 어렵기 때문에 독립변수를 줄일 필요가 있다.


# 전진 선택법(Forward Selection): 절편만 있는 모델에서 기준 통계치를 가장 많이 개선시키는 변수를 차례로 추가

# 후진 제거법(Backward elimination): 모든 변수가 포함된 모델에서 기준 통계치에 가장 도움이 되지 않는 변수를 하나씩 제거하는 방법

# 단계선택법(Stepwise selction): 모든 변수가 포함된 모델에서 출발하여 기준 통계치에 가장 도움이
# 되지 않는 변수를 삭제하거나, 모델에서 빠져 있는 변수 중에서 기준 통계치를 가장 개선시키는 변수를 추가. 
# 이렇게 변수의 추가 또는 삭제를 반복. 또는 절편만 포함된 모델에서 시작해 변수의 추가, 삭제를 반복할 수도 있다.



# 1. 전진선택법 (Forward Selection)
# install.packages('mlbench')
library(mlbench)
data("BostonHousing")
# 회귀
ss <- lm(medv ~ .,data=BostonHousing)
# 전진선택
ss1 <- step(ss, direction = "forward")
formula(ss1)


# 2. 후진제거법 (Backward Elimination)
# library(mlbench)
# data("BostonHousing")
# 회귀
ss <- lm(medv ~ .,data=BostonHousing)
# 후진제거
ss2 <- step(ss, direction = "backward")
formula(ss2)



# 실습2
# attitude 데이터 이용
# rating(등급)에 영향을 미치는 요인을 회귀를 이용해 식별
# 종속변수 rating에 영향을 미치는 독립변수: complaints, privileges, learning, raises, critical, advance
data(attitude)
head(attitude)
# 회귀분석
model <- lm(rating~. , data=attitude)
# 수행결과
summary(model)

##독립변수 제거
reduced <- step(model, direction="backward")
summary(reduced)



# 3. 단계선택법(Stepwise Selection)
library(mlbench)
data("BostonHousing")
# 회귀
ss <- lm(medv ~ .,data=BostonHousing)
# 단계적선택
ss3 <- step(ss, direction = "both")
formula(ss3)



# 변수 제거
# 1. 주성분 분석
# 2. 0에 가까운 분산을 가지는 변수 제거
# 분산이 0에 가까운 변수는 제거해도 큰 영향이 없음.

# nearZeroVar()함수
# 'saveMetrics=FALSE'속성: 예측변수의 컬럼위치에 해당하는 정수 벡터
# 'saveMetrics=TRUE'속성: 컬럼을 가지는 데이터프레임
# freqRatio: 가장 큰 공통값 대비 두번째 큰 공통값의 빈도의 비율
# percentUnique: 데이터 전체로 부터 고유 데이터의 비율
# zeroVar: 예측변수가 오직 한개의 특이값을 갖는지 여부에 대한 논리 벡터
# nzv: 예측변수가 0에 가까운 분산에측 변수인지 여부에 대한 논리 벡터



# 실습
# install.packages("caret")
library(caret)
# install.packages("mlbench")
library(mlbench)

# 0에 가까운 분산을 가지는 변수의 존재 여부 확인
nearZeroVar(Soybean, saveMetrics=TRUE)
data(Soybean)
head(Soybean)


# 3. 상관관계가 높은 변수 제거
# 상관관계가 높은 컬럼을 제외
# findCorrelation()함수

# 실습
library(caret)
library(mlbench)
data(Vehicle)
head(Vehicle)
# 상관관계 높은 열 선정
findCorrelation(cor(subset(Vehicle, select=-c(Class))))
# 상관관계가 높은 열끼리 상관관계 확인
cor(subset(Vehicle, select=-c(Class))) [c(3,8,11,7,9,2), c(3,8,11,7,9,2)]
# 상관관계 높은 열 제거
Cor_Vehicle <- Vehicle[,-c(3,8,11,7,9,2)]
findCorrelation(cor(subset(Cor_Vehicle, select=-c(Class))))
head(Cor_Vehicle)




# 4. 카이 제곱 검정을 통한 중요 변수 선발
# 카이제곱검정을 실행하여 중요 변수 선발

# 실습
install.packages("FSelector")
devtools::install_github('larskotthoff/fselector')
library(FSelector)
library(mlbench)
data(Vehicle)
#카이 제곱 검정으로 변수들의 중요성 평가
cs <- chi.squared(Class ~., data=Vehicle)
#변수 중에서 중요한 5개 선별
cutoff.k(cs,5)
