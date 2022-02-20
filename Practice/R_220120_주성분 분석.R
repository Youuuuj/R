# 주성분 분석 Principal Component Analysis)

# 많은 변수로 구성된 데이터에 대해 주성분이라는 새로운 변수를 만들어 기존 변수보다 차원을 축소하여 분석을 수행

# 주성분 P1은 데이터 분산을 가장 많이 설명할 수 있는 것을 선택하고 P2는 P1과 수직인 주성분을 만들어 다중 공선성 문제를 해결

# 다중 공선성(MultiCollinearity):  독립 변수사이에 강한 상관관계가 나타나서 종속변수에 영향을 미치는 경우
# 완전 공선성 : 독립 변수들 사이에 정확한 선형 관계가 존재하는 경우
# 다중 공선성 문제는 분석과 예측의 정확성을 위해서 피하거나 해결해야 한다.

### PCA
data('iris')
head(iris)

# 변수 간 상관관계 확인
cor(iris[1:4])

# 변수간 S.L와P.L, S.L와 P.W간의 상관관계 높음
# 다중공선성 문제 발생 예상
# 독립변수 새롭게 설계 필요

# 전처리 과정
iris2 <- iris[, 1:4]
ir.species <- iris[,5]

# 중앙을 0, 분산은 1로 설정
prcomp.result2 <- prcomp(iris2, center=T, scale=T)
prcomp.result2
# R 코드에서 연속형 자료에 대해 로그 변환을 수행하고, 
# prcomp() 함수를 통해 PCA를 수행하기 전에 변수에 대해 중심화(center=TRUE)와 표준화 (scale=TRUE)를 수행한다
# prcomp() 함수에서 center=TRUE와 scale=FALSE가 디폴트이다. 

# 결과
summary(prcomp.result2)

# 주성분 수 설정
plot(prcomp.result2, type="l")
# 처음 2개의 주성분이 자료 변동의 대부분을 설명하는 것을 알 수 있다.
# 처음으로 크게 꺾인 포인트가 2여서인듯

# result2의 데이터 확인
prcomp.result2$rotation
iris2

# iris2 데이터와 prcomp.result2데이터를 행렬곱하여 변환
Result3 <- as.matrix(iris2) %*% prcomp.result2$rotation
Result3

# 종 데이터와 Result3의 데이터프레임을 열병합
final2 <- cbind(ir.species, as.data.frame(Result3))
final2
# factor형으로 변환
final2[,1] <- as.factor(final2[,1])
# 컬럼명을 label1로 명명
colnames(final2)[1] <- "label1"
# final2 확인
final2
# 새로 구성된 데이터로 회귀 분석 실시
fit3 <- lm(label1 ~ PC1 + PC2, data=final2)
fit3_pred <-predict(fit3, newdata=final2)
b2 <- round(fit3_pred)
a2 <- ir.species
table(b2,a2)

