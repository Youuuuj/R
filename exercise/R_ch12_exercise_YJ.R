# 유준
setwd("C:/Users/You/Desktop/빅데이터/빅데이터 수업자료/R/dataset2")
library(gmodels)

# 1. 직업 유형에 따른 응답 정도에 차이가 있는가를 단계별로 검정하시오 (동질성 검정)

# 귀무가설 : 직업 유형에 따라 응답 정도의 차이가 없다.
# 대립가설 : 직업 유형에 따라 응답 정도의 차이가 있다.

# 1) 파일 가져오기 - Response.csv
data <- read.csv("Response.csv", header = TRUE)
data

# 2) 코딩변경 - 리코딩
# Job 컬럼: 1. 학생, 2. 직장인, 3. 주부
# response 컬럼: 1. 무응답, 2. 낮음. 3. 높음
data$job1[data$job == 1] <- '학생'
data$job1[data$job == 2] <- '직장인'
data$job1[data$job == 3] <- '주부'
data$response1[data$response == 1] <- '무응답'
data$response1[data$response == 2] <- '낮음'
data$response1[data$response == 3] <- '높음'

job <- data$job1
response <- data$response1

# 3) 교차 분할표 작성
table(job, response)

# 4) 동질성 검정
chisq.test(job, response)

# 5) 검정결과 해석
# p-value값이 0.05보다 작으므로 귀무가설을 기각한다.
# 따라서 직업 유형에 따라 응답 정도의 차이가 있다.



# 2. 나이(age)와 직위(position)간의 관련성을 단계별로 분석하시오 (독립성 검정)

# 귀무가설 : 나이와 직위는 관련성이 없다.
# 대립가설 : 나이와 직위는 관련성이 있다.

# 1) 파일 가져오기 - cleanData.csv
data1 <- read.csv("cleanData.csv", header = TRUE)
data1

# 2) 코딩 변경(변수 리코딩)
# X <- data1$position  # 행 : 직위 변수 이용
# Y <- data1$age3  # 열 : 나이 리코딩 변수 이용
X <- data1$position  # 숫자가 클수록 낮은 직위
Y <- data1$age3  # 숫자가 클수록 나이 많음
X; Y;

# 3) 산점도를 이용한 변수간의 관련성 보기 - (힌트. Plot(x,y)함수 이용)
plot(X,Y)

# 4) 독립성 검정
CrossTable(X,Y, chisq = T)
# 5) 검정 결과 해석
# p-value값이 0.05보다 작기때문에 귀무가설 기각
# 따라서, 나이와 직위는 연관성이 있다. 



# 3. 교육수준(education)과 흡연율(smoking)간의 관련성을 분석하기 위한 연구가설을 수립하고, 단계별로 가설을 검정하시오. (독립성 검정)
# 귀무가설(H0): 교육수준과 흡연율 사이에 관련성이 없다.
# 연구가설(H1): 교육수준과 흡연율 사이에 관련성이 있다.

# 1) 파일 가져오기 - smoke.csv
data2 <- read.csv("smoke.csv", header = TRUE)
data2

# 2) 코딩변경
# education 컬럼(독립변수) : 1. 대졸, 2. 고졸, 3. 중졸
# smoke 컬럼(종속변수): 1. 과다흡연, 2. 보통흡연, 3. 비흡연
data2$education1[data2$education ==  1] <- '대졸'
data2$education1[data2$education ==  2] <- '고졸'
data2$education1[data2$education ==  3] <- '중졸'
data2$smoking1[data2$smoking == 1] <- '과다흡연'
data2$smoking1[data2$smoking == 2] <- '보통흡연'
data2$smoking1[data2$smoking == 3] <- '비흡연'

edu <- data2$education1
smoking <- data2$smoking1

# 3) 교차분할표 작성
CrossTable(edu, smoking, chisq = T)

# 4) 검정 결과 해석
# p-value값이 0.05보다 작기때문에 귀무가설 기각
# 따라서, 교육수준과 흡연율 사이에 관련성이 있다.