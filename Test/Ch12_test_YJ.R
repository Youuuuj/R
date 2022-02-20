# 유준


# 1. iris 데이터를 이용하요 CART 기법 적용 (rpart()함수) 이용 분류분석

# (1) 데이터 가져오기 & 샘플링
data(iris)

idx <- sample(1:nrow(iris), nrow(iris) * 0.7)
train <- iris[idx,]
test <- iris[-idx,]

# (2) 분류 모델 생성
library(rpart)
library(rpart.plot)

rpart_iris <- rpart(Species ~ ., data = train)
rpart_iris

rpart.plot(rpart_iris)

# (3) 테스트 데이터를 이용하여 분류
pre_rpart_iris <- predict(rpart_iris, newdata = test, type = 'class')
table(pre_rpart_iris, test$Species)

# (4) 예측 정확도
sum(pre_rpart_iris == test$Species) / nrow(test)



# 2. iris 데이터를 이용하여 조건부 추론나무 적용(ctree()함수) 이용 분류분석

# (1) 데이터 가져오기 & 샘플링
data(iris)

idx2 <- sample(2, nrow(iris), replace = T, prob = c(0.7, 0.3))
tr <- iris[idx2 == 1,]
te <- iris[idx2 == 2,]

# (2) 분류 모델 생성
library(party)

ctree_iris <- ctree(Species ~ ., data = tr)

# (3) 테스트 데이터를 이용하여 분류
pre_ctree_iris <- predict(ctree_iris, newdata = te)
table(pre_ctree_iris, te$Species)

# (4) 시각화
plot(pre_ctree_iris)



# 3. iris데이터 셋의 1~4번 변수를 대상으로 유클리드 거리 매트릭스를 구하여 idist에 저장한 후 계층적 클러스터링을 적용하여 결과를 시각화.

# (1) 유클리드 거리 계산
data(iris)

iris2 <- iris[, c(1:4)]
head(iris2)

idist <- dist(iris2, method = 'euclidean')

# (2) 계층적 군집 분석(클러스터링)
hc <- hclust(idist)

# (3) 분류결과를 대상으로 음수값을 제거하여 덴드로그램 시각화
plot(hc, hang = -1)

# (4) 그룹수를 3개로 지정하여 그룹별로 테두리 표시
rect.hclust(hc, k = 3, border = 'blueviolet')
