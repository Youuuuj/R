# 실습용 데이터 가져오기
getwd()
setwd("C:/Users/You/Desktop/빅데이터 수업자료/R/dataset3")

dataset <- read.csv("dataset.csv", header = T)
dataset

# 전체 데이터 보기
print(dataset)
View(dataset)

# 데이터의 앞부분과 뒷부분 보기
head(dataset)
tail(dataset)

# 데이터 셋 구조 보기
names(dataset)
attributes(dataset)
str(dataset)


# 데이터 셋 조회
# 1단계 : 데이터 셋에서 특정 변수 조회
dataset$age
dataset$resident
length(dataset$age)

# 2단계 : 특정 변수의 조회 결과를 변수에 저장
x <- dataset$gender
y <- dataset$price

x; y

# 3단계 : 산점도 그래프로 변수 조회
plot(y)


# 4단계 : 컬럼명을 사용하여 특정 변수 조회
dataset["gender"]
dataset["price"]


# 5단계 : index를 사용하여 특정 변수 조회
dataset[2]
dataset[6]
dataset[3,]
dataset[,3]

#6단계 : 2개 이상의 컬럼 조회
dataset[c('job','price')]
dataset[c(2,6)]
dataset[c(1,2,3)]
dataset[c(2,4:6,3,1)]


# 7단계 : 특정 행/열을 조회
dataset[,c(2:4)] # 2-4열의 모든 행 조회
dataset[c(2:4),]
dataset[-c(1,100),] # 1-100행 제외한 나머지 행의 모든 열 조회



# 결측치 확인
summary(dataset$price)
sum(dataset$price)


# 결측치 제거
sum(dataset$price, na.rm = TRUE)

# 결측치 제거 함수를 이용하여 결측치 제거
price2 <- na.omit(dataset$price)  # 특정 칼럼의 결측치 제거
sum(price2)
length(price2)


# 결측치 대체
# 결측치를 포함한 관측치를 유지하기 위한 방법: 1) 0으로 대체 2) 평균으로 대체

# 결측치를 0으로 대체
x <- dataset$price
x[1:30]
dataset$price2 = ifelse(!is.na(x), x, 0)
dataset$price2


# 결측치를 평균으로 대체
x <- dataset$price
x[1:30]
dataset$price3 = ifelse(!is.na(x), x, round(mean(x, na.rm = T),2))
dataset$price3

dataset[c('price','price2','price3')] # 결측치, 결측치=0, 결측치 = 평균값 컬럼 3개 확인



# 극단치 처리
# 극단치(outlier) : 정상적인 분포에서 벗어난 값
# 예, 나이의 분포가 0~100세 사이의 분포인데 -2 또는 250과 같은 비정상적 수치

# 범주형 변수의 극단치 처리
table(dataset$gender)
pie(table(dataset$gender))


# subset()함수를 사용하여 데이터 정제
dataset2 <- subset(dataset, gender == 1 | gender == 2)
dataset2
length(dataset2$gender)
table(dataset2$gender)
pie(table(dataset2$gender), col = c('red','blue'))


# 연속형 변수의 극단치 처리
# 연속된 데이터를 갖는 변수들을 대상으로 극단치 확인하고 데이터 정제

# 연속형 변수의 극단치 보기
dataset$price
length(dataset$price)
plot(dataset$price)
summary(dataset$price)

dataset3 <- subset(dataset, price >= 2 & price <= 8)
length(dataset3$price)
stem(dataset3$price)  # stem()함수를 사용하여 정보를 줄기와 잎 형태로 도표화


# age 변수의 데이터 정제와 시각화
# age 변수에서 NA발견
summary(dataset3$age)
length(dataset3$age)

dataset3$age

# age 변수 정제(20~69)
dataset4 <- subset(dataset3, age >= 20 & age <= 69)
length(dataset4$age)

# box 플로팅으로 평균연령 분석
boxplot(dataset4$age)  # boxplot()함수 : 정제된 결과를 상자 그래프로 시각화

# 극단치를 찾기 어려운 경우
# 범주형 변수는 극단치 발견이 상대적 쉬움.
# 연속형 변수는 극단치 찾기가 어려울 수 있음  ->  boxplot과 통계 이용하여 극단치 찾기.

# boxplot()함수와 통계를 이용한 극단치 철하기
# 변수 상/하위 0.3%를 극단치로 설정

# boxplot로 price 극단치 시각화
boxplot(dataset$price)

# 극단치 통계 확인
boxplot(dataset$price)$stats

# 극단치를 제거한 서브 셋 만들기
dataset_sub <-subset(dataset, price >= 2 & price <= 7.9)
summary(dataset_sub$price)



# 코딩변경
# 코딩변경 : 최초 코딩 내용을 용도에 맞게 변경하는 작업
# 코딩 변경 목적 : 데이터의 가독성, 척도 변경, 역 코딩

# 가독성을 위한 코딩 변경
# 일반적으로 데이터는 디지털화 하기 위해서 숫자로 코딩
# 예, 서울:1, 인천:2 등
# 이러한 코딩결과를 대상으로 기술통계분석을 수행하면 1과 2의 숫자를 실제 거주지명으로 표현해야함
# 이를 위해 코딩 변경 작업이 필요

# 가독성을 위해 resident 컬럼을 대상으로 코딩 변경
dataset2$resident2[dataset2$resident == 1] <- '1.서울특별시'
dataset2$resident2[dataset2$resident == 2] <- '2.인천광역시'
dataset2$resident2[dataset2$resident == 3] <- '3.대전광역시'
dataset2$resident2[dataset2$resident == 4] <- '4.대구광역시'
dataset2$resident2[dataset2$resident == 5] <- '5.시구군'

# 코딩 변경 전과 변경 후의 칼럼보기
dataset2[c("resident",'resident2')]


# 가독성을 위해 job 컬럼을 대상으로 코딩 변경하기
dataset2$job2[dataset2$job == 1] <- '공무원'
dataset2$job2[dataset2$job == 2] <- '회사원'
dataset2$job2[dataset2$job == 3] <- '개인사업'

# 코딩 변경 전과 변경 후의 칼럼보기
dataset2[c('job','job2')]



# 척도 변경을 이한 코딩 변경
# 나이 같은 연속형 변수를 20데, 30대 같이 범주형 변수로 변경

# 나이를 나타내는 age컬럼을 대상으로 코딩 변경하기
dataset2$age2[dataset2$age <= 30] <- '청년층'
dataset2$age2[dataset2$age > 30 & dataset2$age <= 55] <- '중년층'
dataset2$age2[dataset2$age > 55] <- '장년층'
head(dataset2$age2)


# 상관관계 분석이나 회귀분석 : 연속형 변수가 적합
# 빈도분석이나 교차분석 : 범주형 변수가 적함



# 역 코딩을 위한 코딩 변경
# 만족도 평가를 위해 설문지 문항을 5점 척도인 (1)매우만족 (2)만족 (3)보통 (4)불만족 (5)매우불맍ㄱ
# 형태로 작성된 경우 이를 역순으로 변경해야 한다.
# 역코딩(inverse coding) : 순서를 역순으로 변경
# 예, 만족도 컬럼을 대상으로 1~5순서로 코딩된 값을 5~1순서로 역코딩을 하기위해 
# '6-현재값'형식으로 수식 적용

# 만족도를 긍정순서로 역코딩
survey <- dataset2$survey
csurvey <- 6 - survey
csurvey

dataset2$survey <- csurvey
head(dataset2$survey)



# 변수 간의 관계분석
# 척도별로 시각화하여 데이터의 분포형태를 분석
# 명목척도와 서열척도의 범주형 변수와 비율척도의 연속형 변수간의 탐색적 분석 위주

# 범주형 vs 범주형
# 명목척도 도는 서열척도 같은 범주형 변수를 대상으로 시각화하여 컬럼 간의 데터 분포형태 파악

# 범주형 vs 범주형 데이터 분호 시각화
# 1단계 : 데이터 가져오기
getwd()
new_data <- read.csv('new_data.csv', header = T)
str(new_data)

# 2단계 : 코딩 변경된 거주지역(resident) 컬럼과 성별(gender) 컬럼을 대상으로 빈도수 구하기
resident_gender <- table(new_data$resident2, new_data$gender2)
resident_gender
gender_resident <- table(new_data$gender2, new_data$resident2)
gender_resident

# 3단계 : 성별(gender)에 따른 거주지역(resident)의 분포 현황 시각화
barplot(resident_gender, beside = T, horiz = T,
        col = rainbow(5),
        legend = row.names(resident_gender),
        main = '성별에 따른 거주지역 분포 현황')
# 4단계 : 거주지역(resident)에 따른 성별(gender)의 분포 현황 시각화
barplot(gender_resident, beside = T,
        col = rep(c(2,4),5), horiz = T,
        legend = c('남자','여자'),
        main = '거주지역별 성별 분포 현황')


# 연속형 vs 범주형
# 연속형 변수(나이)와 범주형 변수(직업 유형)를 대상으로 시각화하여 컬럼 간의 데이터 분포 형태 파악

# 연속형 vs 범주형 데이터의 시각화
# 1단계 : lattice 패키지 설치와 메모리 로딩 및 데이터 준비
install.packages("lattice")
library("lattice")  # 고급 시각화 분석에서 사용되는 패키지.

# 2단계 : 직업 유형에 따른 나이 분포 현황
densityplot( ~ age,data = new_data,
             groups = job2,
             # plot.points = T: 밀도, auto.key = T: 범례
             plot.points = T, auto.key = T)


# 연속형 vs 범주형 vs 범주형
# 연속형 변수(구매비용), 범주형 변수(성별), 범주형 변수(서열)을 대상으로 시각화하여 컬럼간의 데이터 분포 형태 파악

# 연속형 vs 범주형 vs 범주형 데이터 분포 시각화
# 1단계 : 성별에 따른 직급별 구매비용 분석
densityplot(~ price | factor(gender),
            data = new.data,
            groups = position2,
            plot.points = T, auto.key = T)

# densityplot()함수 사용 : Where속성
# factor(gender2) : 격자를 만들어주는 컬럼을 지정하는 속성(성별로 격자 생성)
# groups = positions2 : 하나의 격자에서 그룹을 지정하는 속성(직급으로 그룹 생성)

# 2단계 : 직급에 따른 성별 구매비용 분석
densityplot(~ price | factor(position2),
            data = new.data,
            groups = gender2,
            plot.points = T, auto.key = T)


# 연속형(2개) vs 범주형(1개)
# 연속형 변수 2개(구매비용, 나이)와 범주형 변수 1개(성별)을 대상으로 시각화하여 칼럼 간의 데이터 분포 형태 파악

# 연속형(2개) vs 범주형(1개) 데이터 분포 시각화
xyplot(price ~ age | factor(gender2),
       data = new_data)

# xyplot()함수 : 산점도 사용





# 파생변수
# 파생변수 : 코딩된 데이터를 대상으로 분석에 이용하기 위해 만들어진 새로운 변수
# 파생변수 생성방법: 
# 1) 사칙연산을 이용 : 총점, 평균 컬럼 생성 
# 2) 1:1관계로 나열하는 방법 : 본 교재 내 설명

# 3개의 컬럼을 갖는 테이블 구조의 데이터 셋
# 여기서 주거환경의 컬럼은 주택, 빌라, 아파트, 오피스텔의 4가지 범주를 갖는 컬럼
# 고객의 주거환경을 독립변수로 사용하기 위해서 1:N관계
# (개인 아이디에 4가지 범주를 갖는 주거환경)를 
# 1:1관계(개인 아이디에 4가지 범주를 모두 나열하는 방식)로 
# 변수를 나열하여 [표7.3]과 같이 파생변수를 생성
# 주거환경을 고객의 아이디와 1:1관계로 데이터 셋의 구조를 변경하면 
# 컬럼 수는 늘어나지만 다양한 분석 방법에서 이용 가능




# 파생변수 생성을 위한 테이블 구ㅈ
# 고객정보 - 지불정보, 반품정보 등 1:N관계

# 더미 형식으로 파생변수 생성
# 더미(dummy) : 특정 컬럼을 명목상 두가지 상태(0과 1)로 범주화하여 나타내는 형태

# 여기서 1:N 관계를 갖는 고객정보 테이블의 주거환경 컬럼을 대상으로
# '주택유형'(단독주택과 다세대주택)과
# '아파트유형'(아파트와 오피스텔)의 두가지 상태로 더미화하여 파생변수 생성

# 파생변수  생성하기
# 1단계 : 데이터 파일 가져오기
getwd()
setwd("C:/Users/tj-bu/Desktop/Rwork/dataset3")
user_data <- read.csv("user_data.csv", header = T)
head(user_data)
table(user_data$house_type)

# 2단계 : 더미변수 생성
# 단독주택 or 다세대주택이면 0, 아파트 or 오피스텔이면 1

house_type2 <- ifelse(user_data$house_type == 1 | user_data$house_type == 2, 0 ,1)
house_type2[1:10]

# 3단계 : 파생변수 추가
user_data$house_type2 <- house_type2
head(user_data)




# 1:1 관계로 파생변수 생성
# 지불정보(pay_data)데이블의 고객식별번호(user_id)와 
# 상품 유형(product_type)테이블의 고객식별번호(user_id)
# 그리고 지불방식(pay_method)간의 1:N관계를 1:1관계로 변수를 나열하여 
# 파생변수를 생성

# 1단계 : 데이터 파일 가져오기
pay_data <- read.csv('pay_data.csv', header = T)
head(pay_data, 10)
table(pay_data$product_type)

# 2단계 : 고객별 상품 유형에 따른 구매금액과 합계를 나타내는 파생변수 생성
install.packages('reshape2')
library('reshape2')
product_price <- dcast(pay_data, user_id ~ product_type,
                       sum, na.rm = T)
head(product_price)

# dcast()함수 : user_id를 행으로 지정, product_type를 열로 지정하여 
# 고객별로 구매한 상품 유형에 다라서 구매금액의 합계를 계산하여 파생 변수 생성

# 3단계 : 컬럼명 수정
names(product_price) <- c('user_id','식료품(1)','생필품(2)',
                          '의류(3)','잡화(4)','기타(5)')
head(product_price)  # 가독성 향상을 위해 컬럼명 추가


# 고객식별번호(user_id)에 대한 지불유형(pay_method)의 파생변수 생성
# 1단계 : 고객별 지불유형에 따른 구매상품 개수를 나타내는 파생변수 생성
pay_price <- dcast(pay_data, user_id ~ pay_method, length)
head(pay_price)

# 2단계 : 컬럼명 변경
names(pay_price) <- c('user_id', '현금(1)', '직불카드(2)',
                      '신용카드(3)', '상품권(4)')
head(pay_price, 3)



# 파생변수 합치기
# 고객정보 테이블에 파생변수를 추가하여 새로운 형태의 데이터프레임 생성
# 고객정보(user_data)테이블에 파생변수 추가

# 1단계 : 고개정보 테이블과 고객별 상품 유형에 따른 구매금액 합계 병합하기
library(plyr)
user_pay_data <- join(user_data, product_price, by = 'user_id')
head(user_pay_data)

# join()함수 사용하여 고객식별번호(user_id)를 기준으로 고객정보 테이블(user_data)과 고객별 상품
# 유형에 따른 구매금액 합계(product_price)를 하나의 데이터프레임으로 병합

# 2단계 : 고객별 지불유형에 따른 구매상품 개수 병합하기
user_pay_data <- join(user_pay_data, pay_price, by = 'user_id')
user_pay_data[c(1:10),c(1, 7:15)]

# join()함수 사용하여 고객식별번호(user_id)를 기준으로 1단계에서 병합된 데이터프레임에 고객별
# 지불유형에 따른 구매상품 개수를 추가하여 하나의 데이터프레임으로 병합

# 사칙연산으로 총 구매급액 파생변수 생성
# 1단계 : 고객별 구매금액의 합계(총 구매금액) 계산
user_pay_data$'총구매금액' <- user_pay_data$'식료품(1)'+
  user_pay_data$'생필품(2)'+
  user_pay_data$'의류(3)'+
  user_pay_data$'잡화(4)'+
  user_pay_data$'기타(5)'

# 2단계 : 고객별 상품 구매 총 금액 컬럼 확인
user_pay_data[c(1:10), c(1, 7:11, 16)]


# 표본추출
# 샘플링(sampling) : 정제한 데이터셋에서 표본으로 사용할 데이터를 추출

# 정제된 데이터 저장
print(user_pay_data)
write.csv(user_pay_data, "cleanData.csv", quote = F, row.names = F)
data <- read.csv("cleanData.csv", header = TRUE)
data





# 70:30 검정 : 홀드아웃

