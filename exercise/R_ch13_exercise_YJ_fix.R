# 유준


# 1. 교육 방법에 따라 시험성적에 차이가 있는지 검정하시오
# (힌트. 두 집단 평균 차이 검정)
# 1) 데이터셋: twomethod.csv
# 2) 변수: method(교육방법), score(시험성적)
# 3) 모델: 교육방법(명목) -> 시험성적(비율)
# 4) 전처리, 결측치 제거

# 연구가설
# H0 : 교육 방법에 따른 두 집단 간 실기시험의 평균에 차이가 없다.
# H1 : 교육 방법에 따른 두 집단 간 실기시험의 평균에 차이가 있다.

# 1단계 : 데이터 가져오기
data <- read.csv('twomethod.csv', header = T)
head(data)
summary(data)

# 2단계 : 전처리, 결측치제거
result <- subset(data, !is.na(score), c(method, score))

# 3단계 : 데이터 분리
a <- subset(result, method == 1)
b <- subset(result, method == 2)
a1 <- a$score
b1 <- b$score

# 4단계 : 두 집단 간의 동질성 검정
# 동질성 검정의 귀무가설: 두 집단 간 분포의 모양이 동질적이다.
var.test(a1, b1)
# p-value값이 0.8494로 유의수준 0.05하에서 두 집단의 분포의 모양이 같다라고 판단한다.
# 따라서  t.test()함수 이용 두 집단 간 평균차이 검정한다.

# 5단계 : 두 집단의 평균 차이 검정
# 5-1단계 : 양측 검정
t.test(a1, b1, alt = 'two.sided', conf.int = TRUE, conf.level = 0.95)
# 5-2단계 : 방향성을 갖는 단측 가설 검정
t.test(a1, b1, alt = 'greater', conf.int = TRUE, conf.level = 0.95)
t.test(a1, b1, alt = 'less', conf.int = TRUE, conf.level = 0.95)

# 결론 : 
# 유의수준 α = 0.05
# 분석 방법 독립 표본 T-검정
# 검정통계량 t= -5.6056, df = 43.705
# 유의확률 P = 6.513e-07
# 결과해석
# 유의수준 0.05에서 귀무가설이 기각되었다.
# 따라서, '교육방법에 따른 두 집단 간 실기시험의 평균에 차이가 있다.' 라고 말할 수 있다. 

# 2. 대학에 진학한 남학생과 여학생을 대상으로 진학한 대학에 대해서 만족도에 차이가 있는가를 검정하시오.
# (힌트. 두 집단 비율 차이 검정)
# 1) 데이터셋: two_sample.csv
# 2) 변수: gender(1,2), survey(0, 1)

# 연구가설 
# 귀무가설 : 성별에 따라 진학한 대학에 대한 만족율에 차이가 없다.
# 연구가설 : 성별에 따라 진학한 대학에 대한 만족율에 차이가 있다.

# 1단계 : 데이터 가져오기
data <- read.csv('two_sample.csv', header = TRUE)
head(data)

# 2단계 : 두 집단의 subset 작성 및 데이터 전처리
data$gender[data$gender == 1] <- '남자'
data$gender[data$gender == 2] <- '여자'
x <- data$gender
x
data$survey[data$survey == 0] <- '불만족'
data$survey[data$survey == 1] <- '만족'
y <- data$survey

# 3단계 : 집단별 빈도 분석
table(x)
table(y)
table(x,y, useNA = 'ifany')

# 4단계 : 두 집단 비율 차이 검정
# 4-1단계 : 양측 검정
prop.test(c(138,107), c(174,126), alt = 'two.sided', conf.level = 0.95)

# 4-2단계 : 방향성을 갖는 단측 가설 검정
prop.test(c(138,107), c(174,126), alternative = 'greater', conf.level =  0.95)
prop.test(c(138,107), c(174,126), alternative = 'less', conf.level =  0.95)

# 결과 : 검정 결과 모두 p-value값이 유의수준 0.05보다 높기때문에, 
# 성별에 따라 진학한 대학에 대한 만족율에 차이가 없다고 할 수 있다.



# 3. 우리나라 전체 중학교 2학년 여학생 평균 키가 148.5cm 로 알려진 상태에서
# A 중학교 2학년 전체 500명을 대상으로  10%인 50명을 표본으로 선정하여 
# 표본평균 신장을 계산하고 모집단의 평균과 차이가 있는 지를 단계별로 분석을 수행하여 검정하시오.
# 1) 데이터셋: student_height.csv
# 2) height <- student$height
# 3) 기술통계량 평균 계산
# 4) 정규성 검정
# 5) 가설 검정

# 연구가설
# 귀무가설 : 모집단의 평균신장과 표본평균 신장은 차이가 없다.
# 연구가설 : 모집단의 평균신장과 표본평균 신장은 차이가 있다.

# 1단계 : 데이터 가져오기
student <- read.csv('student_height.csv', header = TRUE)
student

height <- student$height
height
is.na(height)

# 2단계 : 기술 통계량 평균 계산
summary(height)
mean(height)

# 3단계 : 정규성 검사
# 귀무가설 H0 : 모집단은 정규분포를 따른다
# 대립가설 H1 : 모집단은 정규분포를 따르지 않는다
shapiro.test(height)
# p-value값이 0.0001853이므로 대립가설을 채택한다.
# 따라서 정규분포가 아니기에 wilcox검정을 시행한다.

# 4단계 : wilcox검정
# 4-1단계 : 양측검정
wilcox.test(height, alt = 'two.sided', mu = 148.5, conf.level = 0.95)
# 4-2단계 : 방향성을 갖는 단측 가설 검정
wilcox.test(height, alt = 'greater', mu = 148.5, conf.level = 0.95)
wilcox.test(height, alt = 'less', mu = 148.5, conf.level = 0.95)

# 결론 :
# greater의 경우에 p-value값이 0.0335로 유의수준 0.05보다 낮기 때문에,
# 모집단의 평균신장보다 표본평균의 신장의 차이가 있다고 판단한다.



# 4. 중소기업에서 생산한 HDTV판매율을 높이기 위해서 프로모션을 진행한 결과 
# 기존 구매비율보다 15% 향상되었는지를 단계별로 분석을 수행하여 검정하시오.
# 귀무가설(H0): 기존 판매율과 프로모션을 진행 한 후 판매율에 차이가 없다.
# 연구가설(H1): 기존 판매율과 프로모션을 진행 한 후 판매율에 차이가 있다.
# 1) 구매여부 변수: buy (1: 구매하지 않음, 2: 구매)
# 2) 데이터셋: hdtv.csv
# 3) 빈도수와 비율 계산
# 4) 가설 검정

# 1단계 : 데이터 가져오기
data <- read.csv('hdtv.csv', header = TRUE)
data


# 2단계 : 빈도수와 비율계산
x <- data$buy
summary(x)
length(x)
table(x)

# 3단계 : 패키지를 이용하여 빈도수와 비율 계산
# install.packages('prettyR')
library(prettyR)
freq(x)

# 4단계 : 판매율 기준 비율 검정
# 4-1단계 : 양측검정
binom.test(10, 50, p = 0.15, alternative = 'two.sided', conf.level = 0.95)

# 4-2단계 : 방향성을 갖는 단측 가설 검정
# 프로모션 전 판매율 < 프로모션 후 판매율
binom.test(10, 50, p = 0.15, alternative = 'greater', conf.level = 0.95)
# 프로션 전 판매율 > 프로모션 후 판매율
binom.test(10, 50, p = 0.15, alternative = 'less', conf.level = 0.95)

# 결론 : greater, less 모두 p-value값이 유의수준 0.05보다 높으므로
# 기존 판매율과 프로모션을 진행한 후 판매율에 차이가 없다고 할 수 있다.













