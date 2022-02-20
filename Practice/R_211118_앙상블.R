# 앙상블

# 의사결정 나무의 문제점을 ctree와 다른 방식으로 보완하기 위하여 개발된 방법
# 주어진 자료로부터 예측 모형을 여러 개 만들고, 이것을 결합하여 최종적인 예측 모형을 만드는 방법

# 배깅
# 불안정한 예측모형에서 불안전성을 제거함으로 써 예측력을 향상
# 불안정한 예측모형? 데이터의 작은 변화에도 예측모형이 크게 바뀌는 경우
# 주어진 자료에 대하여 여러 개의 부트스트랩 자료를 만들고, 각 부트스트랩자료에 예측 모형을 만든 다음,
# 이것을 결합하여 최종 예측 모형을 만드는 방법
# 부트스트랩 ? 주어진 자료로부터 동일한 크기의 표본을 랜덤 복원 추출로 뽑은 것


# 실습
install.packages('party')
install.packages('caret')

library(party)
library(caret)

# 샘플링
data1 <- iris[sample(1:nrow(iris), replace = T),]
data2 <- iris[sample(1:nrow(iris), replace = T),]
data3 <- iris[sample(1:nrow(iris), replace = T),]
data4 <- iris[sample(1:nrow(iris), replace = T),]
data5 <- iris[sample(1:nrow(iris), replace = T),]

# 예측모형 생성
citree1 <- ctree(Species ~ ., data1)
citree2 <- ctree(Species ~ ., data2)
citree3 <- ctree(Species ~ ., data3)
citree4 <- ctree(Species ~ ., data4)
citree5 <- ctree(Species ~ ., data5)

# 예측수행
predicted1 <- predict(citree1, iris)
predicted2 <- predict(citree2, iris)
predicted3 <- predict(citree3, iris)
predicted4 <- predict(citree4, iris)
predicted5 <- predict(citree5, iris)


# 예측형 결합하여 새로운 예측모형 생성
newmodel <- data.frame(Species=iris$Species,predicted1,predicted2,predicted3,predicted4,predicted5)
head(newmodel)
newmodel


# 최종 모형로 통합
funcValue <- function(x){
  result <- NULL
  for(i in 1:nrow(x)){
    xtab <- table(t(x[i,]))
    rvalue <- names(sort(xtab, decreasing = T)[1])
    result <- c(result, rvalue)
  }
  return(result)
}

# 최종 모형의 2번째에서 6번째를 통합하여 최종 결과 생성
newmodel$result <- funcValue(newmodel[,2:6])
newmodel$result


# 최종 결과 비교
table(newmodel$result, newmodel$Species)



# adabag 패키지 이용
install.packages('adabag')
library(adabag)

iris.bagging <- bagging(Species ~ ., data = iris, mfinal = 10)
# mfinal = 반복수 또는 트리의 수(디폴트 = 100)

iris.bagging$importance  # 각 변수의 상대적인 중요도
# 변수의 중요도는 각 tree에서 변수에 의해 주어지는 지니지수(불확실성의 감소량)의 이익을 고려한 측도

windows()
plot(iris.bagging$trees[[10]])
text(iris.bagging$trees[[10]])

pred <- predict(iris.bagging, newdata = iris)
pred

table(pred$class, iris[,5])


# 부스팅
# 예측력이 약한 모형만 만들어지는 경우, 예측력이 약한 모형들을 결합하여 강한 예측 모형을 만드는 방법
# 예측력이 약한 모형 ? 랜덤한게 예측하는 것보다 더 좋은 예측력을 가진 모형

# 실습
library(adabag)
data(iris)
boo.adabag <- boosting(Species ~ ., data = iris, boos = T, mfinal = 10)
boo.adabag$importance


plot(boo.adabag$trees[[10]])
text(boo.adabag$trees[[10]])

pred <- predict(boo.adabag, newdata = iris)
tb <- table(pred$class, iris$Species)
tb

error.rpart <- 1 - (sum(diag(tb))/sum(tb))
error.rpart

# 랜덤 포레스트
# 배깅과 부스팅보다 더 많은 무작위성을 주어서 약한 학습 모델을 만든 다음
# 이것을 선형 결합하여 최종학습기를 만드는 방법
# 예측력 매우 높음
# 입력 변수 개수가 많을 떄는 배깅이나 부스팅과 비슷하거나 더 좋은 예측력을 보여주어 많이 사용됨

# 랜덤 포레스트 방식은 기존의 의사결정 트리 방식에 비해서 많은 데이터를 이용하여 학습을 수행하기 떄문에
# 비교적 예측력이 뛰어나고, 과적합 문제를 해결할 수 있다.

# 랜덤포레스트 모델은 기본적으로 원 데이터를 대상으로 복원추출 방식으로 데이터의 양을 증가시킨 후
# 모델을 생성하기 때문에 데이터의 양이 부족해서 발생하는 과적합의 원인을 해결할 수 있다.
# 각각의 분류모델에서 예측된 결과를 토대로 투표방식으로 최적의 예측치를 선택한다

# randomforest()함수
# formula : y ~ x형식으로 반응변수와 설명변수 식
# data : 모델 생성에 사용될 데이터 셋
# ntree : 복원 추출하여 생성할 트리 수 지정
# mtry : 자식 노드를 분류할 변수 수 지정
# na.action : 결측치(NA)를 제거할 함수 지정
# importance : 분류모델 생성과정에서 중요 변수 정보 제공 여부




# 실습
# 샘플링
idx <- sample(2, nrow(iris), replace = T, prob = c(0.7,0.3))

trData <- iris[idx == 1,]
nrow(trData)
teData <- iris[idx == 2,]
nrow(teData)

install.packages('randomForest')
library(randomForest)

# 랜덤포레스트 실행 (100개의 tree를 다양한 방법(proximity = T)으로 생성)
RFmodel <- randomForest(Species ~ ., data = trData, ntree = 100, proximity = T)
RFmodel


plot(RFmodel, main = 'RandomForest Model of iris')

# 모델에 사용된 변수 중 중요한 것 확인
importance(RFmodel)

# 중요한 것 시각화
varImpPlot(RFmodel)

# 실제값과 예측값 비교
table(trData$Species, predict(RFmodel))

# 데스트데이터로 예측
pred <- predict(RFmodel, newdata = teData)

# 실제값과 예측값 비교
table(teData$Species, pred)

# 시각화
plot(margin(RFmodel, teData$Species))
# margin()함수 : 두 값의 차이



# 실습
# 1단계 : 패키지 설치 및 데이터 셋 가져오기
library(randomForest)
data(iris)

# 2단계 : 랜덤포레스트 모델 생성
model <- randomForest(Species ~ ., data = iris)
model

# ‘Number of trees: 500’: 학습데이터로 500개의 포레스트(Forest)가 복원 추출방식으로 생성
# ‘No. of variables tried at each split: 2’: 두 개의 변수 이용하여 트리의 자식 노드가 분류되었다는 의미


# 실습
# 파라미터 조정 - 트리 개수 300개, 변수 개수 4개 지정
model2 <- randomForest(Species ~ ., data = iris, ntree = 300, mtry = 4, na.action = na.omit)
model2


# 실습
# 중요 변수를 생성하여 랜덤 포레스트 모델 생성
# 1단계 : 중요 변수로 랜덤포레스트 모델 생성
model3 <- randomForest(Species ~., data = iris, importance = T, na.action = na.omit)

# 2단계 : 중요 변수 보기
importance(model3) 
# importance() : 분류모델을 생성하는 과정에서 입력 변수 중 가장 중요한 변수가 어떤 변수 인가를 알려주는 함수
# MeanDecreaseAccuracy : 분류정확도를 개선하는데 기여한 변수를 수치로 제공
# MeanDecreaseGini : 노드 불순도(불확실성)을 개선하는데 기여한 변수를 수치로 제공

# 3단계 : 중요 변수 시각화
varImpPlot(model3)



# rpart패키지의 stagec data set 이용 randomForest적용
library(rpart)

data('stagec')
str(stagec)

# 결측치 제거
stagec1 <- subset(stagec, !is.na(g2))
stagec2 <- subset(stagec1, !is.na(gleason))
stagec3 <- subset(stagec2, !is.na(eet))
str(stagec3)


set.seed(1)
ind <- sample(2, nrow(stagec3), replace = T, prob = c(0.7, 0.3))
ind

trainData <- stagec3[ind == 1,]
testData <- stagec3[ind == 2,]


library(randomForest)

rf <- randomForest(ploidy ~ ., data = trainData, ntree = 100, proximity = T)
# 반응변수는 상돔염색체수(예측변수는 7개)
# proximity = T는 개체들 간의 근접도 행렬을 제고
# 동일한 최종노드에 포함되는 빈도에 기초함

table(predict(rf), trainData$ploidy)

# 트리 수에 따른 종속변수의 범주율 오분류율
print(rf)
plot(rf)

# 변수의 중요도 측정 
importance(rf)

varImpPlot(rf)

# 테스트 자료에 대한 예측
rf.pred <- predict(rf, newdata = testData)
table(rf.pred, testData$ploidy)




# 더 알아보기 - 엔트로피 : 불확실성 척도
x1 <- 0.5; x2 <- 0.5
e1 <- x1 * log2(x1) - x2 * log2(x2)
e1

x1 <- 0.7; x2 <- 0.3
e2 <- x1 * log2(x1) - x2 * log2(x2)
e2
 
# 엔트로피가 작으면 불확실성이 낮아짐 -> 불확실성이 낮아지면 그만큼 분류정확도 향상됨


# 실습
# 최적의 파라미터(ntree, mtry) 찾기
# 1단계 : 속성값 생성
ntree <- c(400,500,600)
mtry <- c(2:4)
param <- data.frame(n = ntree, m = mtry)
param

# 2단계 : 이중 for()함수를 이용하여 모델 생성
for(i in param$n){
  cat('\n ntree = ', i, '\n')
  for(j in param$m){
    cat('\n mtry = ', j, '\n')
    model_iris <- randomForest(Species ~ ., data = iris,
                                 ntree = i, mtry = j, na.action = na.omit)
    print(model_iris, '\n')
  }
}


# 9개의 모델이 생성된 결과에서 오차 비율(OOB)를 비교하여 최적의 트리와 변수 결정.