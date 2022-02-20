# 인공신경망 모형

# 인간의 두뇌 신경(뉴런)들이 상호작용하여 경험과 학습을 통해서 패턴을 발견하고
# 이를 통해서 특정 사건을 일반화하거나 데이터를 분류하는데 이용되는 기계학습방법.

# 인간의 개입 없이 컴퓨터가 스스로 인지하고 추론하고, 판단하여 사물을 구분하거나
# 특정 상황의 미래를 예측하는데 이용될 수 있는 기계학습 방법

# 인공신경망은 은닉층에서의 연산 과정이 공개되지 않기 떄문에 블랙박스 모형으로 분류
# 따라서 어떤 원인으로 결과가 도출되었는지에 대한 설명을 할 수 없다.


# 인공 신경망 기계학습과 역전파 알고리즘
# 출력값(o1)과 실제 관측값(y1)을 비교하여 오차(E)를 계산하고, 이러한 오차를 줄이기 위해서
# 가중치(w1)와 경계값(b)을 조정한다.

# 오차(E) = 관측값(y1) - 출력값(o1)

# 인공신경망은 기본적으로 단방향 망으로 구성된다.
# 입력측 -> 은닉층 -> 출력층 의 한 방향으로만 전파
# 이러한 전파 방식을 개선하여 역방향으로 오차를 전파해 
# 은닉층의 가중치와 경계값을 조정하여 분류 정확도를 높이는 역전파 알고리즘 도입

# 역전파 알고리즘은 출력해서 생긴 오차를 신경망의 역방향(입력층)으로 전파하여
# 순차적으로 편미분을 수행하면서 가중치(w)와 경계값(b)등을 수정


# 간단한 인공신경망 모델 생성
# nnet패키지
# 형식 : nnet(formula, data, weights, size)
# formula : y ~ x 형식으로 반응변수와 설명변수
# data : 모델 생성에 사용될 데이터 셋
# weights : 각 case에 적용할 가중치(기본 : 1)
# size : 은닉층(hidden layer)의 수 지정


# 1단계 : 패키지 설치
install.packages('nnet')
library(nnet)

# 2단계 : 데이터 셋 생성
df = data.frame(
  x2 = c(1:6),
  x1 = c(6:1),
  y = factor(c('no', 'no', 'no', 'yes', 'yes','yes'))
)

str(df)

# 3단계 : 인공신경망 모델 생성
model_net = nnet(y ~ ., df, size = 1)

# 4단계 : 모델 결과 변수 보기
model_net

# 5단계 : 가중치(weights)보기
summary(model_net)

# 6단계 : 분류모델의 적합값 보기
model_net$fitted.values

# 7단계 : 분류모델의 예측치 생성과 분류 정확도
p <- predict(model_net, df, type = 'class')
table(p, df$y)




# iris데이터 셋을 이용한 인공신경망 모델 생성
# 1단계 : 데이터 생성
data(iris)
idx = sample(1:nrow(iris), nrow(iris)*0.7)
training <- iris[idx,]
testing <- iris[-idx,]
nrow(training)
nrow(testing)

# 2단계 : 인공신경망 모델(은닉층 1개와 은닉충 3개) 생성
model_net_iris1 = nnet(Species ~ ., training, size = 1)
model_net_iris1
model_net_iris3 = nnet(Species ~ ., training, size = 3)
model_net_iris3

# 입력 변수들의 값들이 일정하기 않거나 값이 큰 경우,
# 신경망 모델이 정상적으로 만들어지지 않음
# 때문에 입력 변수를 대상으로 정규화 과정이 필요.

# 3단계 : 가중치 네트워크 보기 - 은닉층 1개 신경망 모델
summary(model_net_iris1)

# 4단계 : 가중치 네트워크 보기 - 은닉층 3개 신경망 모델
summary(model_net_iris3)

# 5단계 : 분류 모델 평가
table(predict(model_net_iris1, testing, type = 'class'), testing$Species)
table(predict(model_net_iris3, testing, type = 'class'), testing$Species)



# neuralnet 패키지를 이용한 인공 신경망 모델 생성
# 역전파 알고리즘을 적용할 수 있다. 또한 가중치 망을 시각화 하는 기능도 제공

# neuralnet()함수
# 형식: neuralnet(formula, data, hidden = 1, threshold = 0.01, stepmax = 1e+05, 
#                 rep = 1, startweights = NULL, learningrate.limit = NULL, algorithm = "rprop+")
# formula: y ~ x형식으로 반응변수와 설명변수 식
# data: 모델 생성에 사용될 데이터 셋
# hidden = 1: 은닉층(hidden layer)의 수 지정
# threshold = 0.01: 경계값 지정
# stepmax = 1e+05: 인공신경망 학습을 위한 최대 스텝 지정
# rep = 1: 인공신경망의 학습을 위한 반복 수 지정
# startweights = NULL: 랜덤으로 초기화된 가중치를 직접 지정
# learningrate.limit = NULL: backpropagation 알고리즘에서 사용될 학습비율을 지정
# algorithm = "rprop+": backpropagation과 같은 알고리즘 적용을 위한 속성


# 1단계 : 패키지 설치
install.packages("neuralnet")
library(neuralnet)

# 2단계 : 데이터셋 생성
data('iris')
idx = sample(1:nrow(iris), nrow(iris) * 0.7)
training_iris = iris[idx,]
testing_iris = iris[-idx,]
dim(training_iris)
dim(testing_iris)

# 3단계 : 수치형으로 컬럼 생성
training_iris$Species2[training_iris$Species == 'setosa'] <- 1
training_iris$Species2[training_iris$Species == 'versicolor'] <- 2
training_iris$Species2[training_iris$Species == 'virginica'] <- 3

training_iris$Species <- NULL
head(training_iris)

testing_iris$Species2[testing_iris$Species == 'setosa'] <- 1
testing_iris$Species2[testing_iris$Species == 'versicolor'] <- 2
testing_iris$Species2[testing_iris$Species == 'virginica'] <- 3

testing_iris$Species <- NULL
head(testing_iris)

# 4단계 : 데이터 정규화
# 4-1단계 : 정규화 함수 정의
normal <- function(x){
  return((x - min(x))/(max(x) - min(x)))
}

# 4-2단계 : 정규화 함수를 이용하여 학습데이터 / 검정 데이터 정규화
training_nor <- as.data.frame(lapply(training_iris, normal))
summary(training_nor)

testing_nor <- as.data.frame((lapply(testing_iris, normal)))
summary(testing_nor)

# 정규화 vs. 표준화
# 정규화(Normalization): 데이터의 분포가 특정 범위 안에 들어가도록 조정하는 방법
#                        (예, 모든 값을 0과 1 사이의 값으로 재표현, 확률값)
#                        (X – Min(X)) / (Max(X) – Min(X))
# 표준화(Standardization): 동일한 평균을 중심으로 관측값들이 얼마나 떨어져 있는지를 나타내는
#                          방법 (예, 표준화 변수 Z를 이용하여 N(0,1)로 표현)
#                          (X – Xbar) / 표준편차


# 5단계 : 인공신경망 모델 생성 - 은닉 노드 1개
model_net = neuralnet(Species2 ~ ., data = training_nor, hidden = 1)
model_net

plot(model_net)

# 6단계 : 분류모델 성능 평가
# 6-1단계 : 모델의 예측치 생성 - compute()함수 이용
model_result <- compute(model_net, testing_nor[c(1:4)])
model_result$net.result

# 6-2단계 : 상관관계 분석 - 상관계수로 두 변수 간 선형 관계의 강도 측정
cor(model_result$net.result, testing_nor$Species2)

# 7단계 : 분류모델 성능 향상 - 은닉층 노드 2개 지정, backprop속성 적용
# 7-1단계 : 인공신경망 모델 생성
model_net2 = neuralnet(Species2 ~., data = training_nor, hidden = 100,
                       algorithm = 'backprop', learningrate = 0.01)
# 7-2단계 : 분류모델 예측치 생성과 평가
model_result2 <- compute(model_net2, testing_nor[c(1:4)])
model_result2$net.result

# 7-3단계 : 상관관계 분석
cor(model_result2$net.result, testing_nor$Species2)

# Neuralnet()함수 내 learningrate 속성은 역전파 알고리즘을 적용할 경우 학습비율을 지정하는 속성
