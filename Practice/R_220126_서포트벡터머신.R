# 서포트벡터머신(Support Vector Machine)

# 서포트벡터머신(Support Vector Machine) 는 Corres 와 Vapnik 에 의해서 1995 년에 제안되었다
# 서포트벡터머신은 서포트 벡터 분류기를 확장하여 비선형 클래스 경계를 수용할 수 있도록 개발한 분류 방법
# 초평면 (Hyperplane) 
# 최대마진분류기(Maximum Margin Classifier): 데이터가 있을 때 이것을 곡선이 아닌 직선이나 평면으로 구별하는 방법

# 초평면(Hyperplane): 최대 마진 분류기가 경계로 사용하는 선이나 면
# 분리 초평면 Separting Hyperplane) Hyperplane): 데이터를 완벽하게 분리하는 초 평면

# 마진(Margin): 데이터와 초평면의 수직 거리 가장 짧은 거리
# 최대마진 초평면 (Maximal Margin Hyperplane): 마진이 가장 큰 초평면
# 최대마진 분류기 (Maximum Margin Classifier): 데이터가 초평면에 의해 가장 잘 분류

# 서포트 벡터 (Support Vector): 양쪽 데이터의 경계값을 포함하는 초평면 상에 위치한 데이터
# 대부분의 경우 분리 초평면이 존재하지 않을 수도 있고 최대 마진 분류기 또한 존재할 수 없는 경우가 많다. 
# 이런 문제의 해결을 위하여 데이터를 분류할 때 약간의 오차를 허용한다. 
# 이때 약간의 오차를 소프트 마진 (Soft margin) 이라고 한다

# 서포트 벡터 분류기 Support Vector Classifier): 소프트마진을 이용하여 데이터를 분류하는 것.
# 서포트 벡터 분류기는 최대 마진 분류기를 확장한 것으로 몇몇 관측치를 희생하더라도 나머지 관측치를 더 잘 분류할 수 있는 방법
# 코스트 (cost): 허용하는 오류의 정도

# R에서는 tune.svm 함수를 이용하여 코스트 값을 계산
# 커널 트릭을 이용하여 분류를 할 때 결정되어야 할 파라미터
# 코스트(cost): 오차 허용 정도
# 감마(Gamma): 커널과 관련된 파라미터

# SVM

setwd('C:/Users/You/Desktop/빅데이터/빅데이터 수업자료/R/dataset4')
credit1 <- read.csv("credit.csv", header=TRUE)
str(credit1)

# Creditability
# 컬럼의 0과 1의 숫자를 팩터형 1과 2로 바꿈
credit1$Creditability <- as.factor(credit1$Creditability)
str(credit1)

# 학습데이터와 테스트데이터 구성
library(caret)
set.seed(1234)

trData <- createDataPartition( y = credit1$Creditability, p=0.7, list=FALSE)
head(trData)

train <- credit1[trData,]
test <- credit1[-trData,]
str(train)

# 파라미터 설정
# install.packages("e1071")
library("e1071")

# radial 커널 사용 튜닝
result1 <- tune.svm(Creditability~., data=train, gamma=2^( 5:0), cost = 2^(0:4), kernel="radial")

# linear 커널 사용 튜닝
result2 <- tune.svm(Creditability~., data=train, cost = 2^(0:4), kernel="linear")

# polynomial 커널 사용 튜닝
result3 <- tune.svm(Creditability~., data=train, cost = 2^(0:4), degree=2:4, kernel="polynomial")

# 튜닝된 파라미터 확인
result1$best.parameters
result2$best.parameters
result3$best.parameters

# SVM 실행
normal_svm1 <- svm(Creditability~., data=train, gamma=0.0625, cost=1, kernel = "radial")
normal_svm2 <- svm(Creditability~., data=train, cost=1, kernel="linear")
normal_svm3 <- svm(Creditability ~., data=train, cost=1, degree=3, kernel = 'polynomial')

# 결과 확인
summary(normal_svm1)
summary(normal_svm2)
summary(normal_svm3)

# sv index 확인
normal_svm1$index
normal_svm2$index
normal_svm3$index


# SVM으로 예측
normal_svm1_predict <- predict(normal_svm1, test)
str(normal_svm1_predict)

normal_svm2_predict <- predict(normal_svm2, test)
str(normal_svm2)
    
normal_svm3_predict <-predict(normal_svm3, test)
str(normal_svm3)

# radial kernel 적용 시 Conf usion Matrix 구성 및 Statistics
confusionMatrix(normal_svm1_predict, test$Creditability)

# linear kernel 적용 시 Confusion Matrix 구성 및 Statistics
confusionMatrix(normal_svm2_predict, test$Creditability)

# polynomial kernel 적용 시 Confusion Matrix 구성 및 Statistics
confusionMatrix(normal_svm3_predict, test$Creditability)


# iris 데이터 대상으로 예측
# install.packages("kernlab")
library(kernlab)
model1 <- ksvm(Species~., data=iris)
iris_predicted <- predict(model1, newdata=iris)
table(iris_predicted, iris$Species)

