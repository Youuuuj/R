# 유준


getwd()
setwd('C:/Users/You/Desktop/빅데이터/빅데이터 수업자료/R/dataset3')

# 1 
# 1-1) 파일 가져오기
clean_data <- read.csv('cleanData.csv', header = T)
clean_data

# 1-2) 코딩 변경(변수 리코딩)
x <- clean_data$position  # 행 - 직위변수
y <- clean_data$age3  # 열 - 나이 리코딩 변수

# 1-3) 산점도를 이용한 변수간의 관련성 보기(plot(x,y)이용)
plot(formula = y ~ x, data = clean_data, xlab = 'position', ylab = 'age')

# 1-4) 결과해석
# 직위 변수의 값이 높아짐에 따라 나이 변수의 값이 낮아진다.





# 2
# 2-1) 파일 가져오기
response <- read.csv('response.csv', header = T)
response

# 2-2) 코딩변경 - 리코딩
response$job[response$job == 1] <- '학생'
response$job[response$job == 2] <- '직장인'
response$job[response$job == 3] <- '주부'

response$response[response$response == 1] <- '무응답'
response$response[response$response == 2] <- '낮음'
response$response[response$response == 3] <- '높음'

# 2-3) 교차 분할표 작성
x <- response$job
y <- response$response

library(gmodels)
library(ggplot2)

table(result)
CrossTable(x, y)



# 2-4) 검정 결과 해석
# 주부는 56.2% 높음, 39% 낮음, 4.8%로 무응답 하였다.
# 직장인은 42.4% 높음. 49.6% 낮음, 8%로 무응답 하였다.
# 학생은 11.4% 높음, 52.9% 낮음, 35.7% 무응답 하였다.
# 주부와 직장인 간의 응답 정도의 차이는 미비하나 
# 학생과 나머지 두 직업 간의 차이가 있다.






# 3
# 3-1) 데이터 가져오기
data(mtcars)
mtcars

mtcars_ro <- mtcars[, c(1,8,9)]
mtcars_ro

# 3-2) 로지스틱 회귀분석 실행하고 회귀모델 확인
mtcars_model <- glm(vs ~ ., data = mtcars_ro, family = 'binomial')
mtcars_model

# 3-3) 로지스틱 회귀모델 요약정보 확인
summary(mtcars_model)

# 3-4) 로지스틱 회귀식
# vs = -12.7051 + 0.6809 * mpg +  (-3.0073 * am)

# 3-5) 결과 해석
# mpg가 1단위 증가할때 vs가 0.68 증가한다
# am이 1단위 증가할때 vs가 -3.00 감소한다 

# 3-6) mpg = 30 , am = 0 일때, 승산비(odd ratio)?
exp(mtcars_model$coefficients)


# 3-6의 답
mpg <- 30; am <-  0
vs = -12.7051 + 0.6809 * 30 +  (-3.0073 * 0)
odds <-  exp(vs)
odds 
