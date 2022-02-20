#유준

#1
getwd()
setwd("C:/Users/tj-bu/Desktop/Rwork/dataset2")
# 문서가져오기
test <- read.csv('descriptive.csv', header = T)
test

test$type
test$pass

# 1-1

# type 내 NA제거
test2 <- subset(test, type == 1 | type == 2)
type <- test2$type
type

# pass 내 NA제거
test2 <- subset(test, pass == 1 | pass == 2)
pass <- test2$pass
pass

# 빈도수 확인
table(type)  
table(pass)

# 차트 생성
par(mfrow = c(2,2))

# type의 차트
barplot(table(type))
pie(table(type))

# pass의 차트
barplot(table(pass))
pie(table(pass))


# 1-2
test$age
age <- test$age
age


# 나이변수에 대한 요약치
mean(age)
sd(age)

# 왜도와 첨도 계산을 위한 moments패키지 불러오기
library('moments')

# 왜도
skewness(age)

# 첨도
kurtosis(age)

# 히스토그램
par(mfrow = c(1,1))
hist(age)

# 1-3
hist(age, freq = F)

# 밀도분포 곡선
lines(density(age), col='blue')

x <- seq(40, 70)
x

# 정규분포 곡선
curve(dnorm(x, mean(age), sd(age)), col = 'black', add=T)


# 2

# 패키지 설치
install.packages("MASS")
# 패키지 불러오기
library(MASS)

ani <-Animals
ani

#2
dim(ani)  # 데이터셋 차원보기
summary(ani)  # 요약통계량
mean(ani$brain)  # 평균
median(ani$brain)  # 중위수
sd(ani$brain)  # 표준편차
var(ani$brain)  # 분산
max(ani$brain)  # 최대값
min(ani$brain)  # 최소값
