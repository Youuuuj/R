#17페이지부터
#표본분산 : x변량을 대상으로 "변량의 차의 제곱이 합/ (변량의 개수-1)"
#표본분산 식 :  var <- sum((x - 산술평균)^2)/ (length-1)
#표본표준편차 식 :sqrt(var)

X <- c(7, 5, 12, 9, 15, 6)
summary(X)
var(X)
sqrt(var(X))

x <- c(7, 5, 12, 9, 15, 6)

var_sd <- function(x){
  var <- sum((x - mean(x)) ^ 2) / (length(x) -1)
  sd <- sqrt(var)
  cat("표본분산 : ", var, "\n")
  cat("표본표준편차: ",sd)
}

var_sd(x)


#피타고라스와 구구단 함수 정의
pytha <- function(s, t){
  a <- s ^ 2 - t ^ 2
  b <- 2 * s * t
  c <- s ^ 2 + t ^ 2
  cat("피타고라스 정리 : 3개의 변수: ", a, b, c)
}

pytha(2,1)


gugu <- function(i, j){
  for(x in i){
    cat("**", x, "단**\n")
    for(y in j){
      cat(x, " * ", y, " = ", x * y, "\n")
    }
    cat("\n")
  }
}


i <- c(2:9)
j <- c(1:9)

gugu(i,j)


#결측치 포함 자료의 평균 계산 함수 정의
#결측치 데이터(NA)를 포함하는 데이터의 평균을 구하기 위해서는
#먼저 결측치를 처리한 후 평균을 구해야한다

#1단계 : 결측치(NA)를 포함하는 데이터 생성
 data <- c(10, 20, 5, 4, 40, 7, NA, 6, 3, NA, 2, NA)

#2단계에서 1차 : NA를 제거하고 평균 산출
#2차: NA를 0으로 대체하여 평균을 구한다.
#3차 : NA를 평균으로 대체하여 평균을 구한다.
 
 #단계 2 : 결측치 데이터를 처리하는 함수 정의
 
 na <- function(x){
   # 1차 option 이용
   print(x)
   print(mean(x, na.rm = T))

   #2차 -->  0
   data2 = ifelse(!is.na(x), x, 0)
   print(data)
   print(mean(data))
   
   #3차 -->  NA를 평균으로 대체
   data3 = ifelse(!is.na(x), x, round(mean(x, na.rm = TRUE), 2))
   print(data2)
   print(mean(data2))
 }

na(data) 



#몬테카를로 시뮬레이션 함수 정의
#몬테가를로 시뮬레이션은 현실적으로 불가능한 문제의 해답을 얻기 위해 
#난수의 확률 분포를 이용하는 모의 시험으로 근사적 해를 구하는 기법

#동전 앞면과 뒷면에 대한 난수 확률분포의 기대확률 모의시험

 coin <- function(n){
   r <- runif(n, min = 0, max = 1)
   result <- numeric()
   for(i in 1:n){
     if(r[i] <= 0.5)
       result[i] <- 0
     else
       result[i] <- 1
   }
   return(result)
 }

 coin(10) 

 
#몬테카를로 시뮬레이션 함수 정의
montaCoin <- function(n){
  cnt <- 0
  for(i in 1:n){
    cnt <- cnt + coin(1)
  }
  result <- cnt / n
  return(result)
}

montaCoin(10)
montaCoin(1000000)

#runif() 함수 :  난수 발생 함수


#주요 내장 함수
#min(), max(), range(), mean(), median(), sum(), sort()
#order() :  벡터의 정렬된 값의  index를 보여주는 함수
#rank(), sd(), summary(), table()
#sample(x,y): x범위에서 y만큼 sample데이터를 생성하는 함수

library(RSADBE)
data('Bug_Metrics_Software')
Bug_Metrics_Software[,,1]

# 행단위 합계와 평균 구하기

rowSums(Bug_Metrics_Software[,,1])
rowMeans(Bug_Metrics_Software[,,1])


# 열 단위 합계와 평균 구하기

colSums(Bug_Metrics_Software[,,1])
colMeans(Bug_Metrics_Software[,,1])





















#rowSums() :  행 단위 합계
#rowMeans() : 행 단위 평균균
#colSums() : 열 단위 합계
#colMeans() : 열 단위 평균



#기술 통계량 처리 관련 내장함수 사용
seq(-2, 2, by = .2)
vec <- 1:10
min(vec)
max(vec)
range(vec)
mean(vec)
median(vec)
sum(vec)
sd(rnorm(10))
table(vec)


#정규분포의 난수 생성

n <- 1000
rnorm(n, mean = 0, sd = 1)
hist(rnorm(n, mean = 0, sd = 1))

#rnorm() 함수
#형식 : rnorm(n, mean, sd) 평균과 표준편차 이용


#균등분포의 난수 생성하기
n <- 1000
runif(n, min = 0, max = 10)
hist(runif(n, min = 0, max = 10))

#이항분포의 난수 생성하기
#형식 :  rbinom(n, size, prob) #독립적 n의 반복

n <- 20


rbinom(n, 1, prob = 1/2)
rbinom(n, 2, 0.5)
rbinom(n, 10, 0.5)

n <- 1000
rbinom(n, 5, prob = 1/6)

#종자값으로 동일한 난수 생성
#종자(seed)값을 지정하면 동일한 난수 발생 가능
#종자(seed)값 지정을 위해 seed()함수 사용
#형식 : set.seed(임의의 정수) #임의의 정수를 종자값으로 하여 동일한 난수 생성

rnorm(5, mean = 0, sd = 1) #표준정규분포 mean 0 sd 1
set.seed(123)
rnorm(5, mean = 0, sd = 1)

set.seed(123)
rnorm(5, mean = 0, sd = 1)

set.seed(345)
rnorm(5, mean = 0, sd = 1)


#수학 관련 내장함수
#abs(x)=절대값, sqrt(x)=표준편차차, ceiling(x)=올림
#floor(), round(), facrtorial(x)
#which.min(x), which.max(x) : 벡터 내 최소값과 최대값의 인덱스를 구하는 함수
#Pmin(x), Pmax(x) 여러 벡터에서의 원소 단위 최소값과 최대값을 구하는 함수
#Prod() : 곱
#cumsum(), cumprod(0, cos(x), sin(x), tan(x), log(x),log10(x), exp(x)

vec <- 1:10

prod(vec)
factorial(vec)
abs(-5)
sqrt(16)
vec
cumsum(vec)
log(10)
log10(10)

#행렬 연산 관련 내장함수
#행렬 분해는 행렬을 특정한 구조를 가진 다른 행렬의 곱으로 나타내는 것
#eigen(), svd(0, qr(), chol()
#ncol(x), nrow(x), r(), cbind(), rbind(), diag(x), det(x), apply(x, m, function)
#solve() : 역행렬
#eigen(x) : 정방행렬을 대상으로 고유값 분해하는 함수
#svd(x): m x n 행렬을 대상으로 특이값을 분해하는 함수
#x%*%y : 두행렬의 곱을 구하는 수식식

#행렬 연산 관련 내장함수 사용
x <- matrix(1:9, nrow = 3, byrow = T)
x

y <- matrix(1:3, nrow = 3)
y

ncol(x)
nrow(x)
t(x)

cbind(x, 1:3)
rbind(x, 10:12) 

x
diag(x)
det(x)
x
apply(x,1, sum)
apply(x,2, mean)
svd(x)
eigen(x)

x%*%y

#R %any%특별 연산자

# %% 나머지연산자
#형식: a%%b

x <- c(1,2,3,4,5)
y <- c(5)
x%%y


# %*% 연산자
#형식: a%*%b  
#첫번재 행렬의 두번째 자리수와 두번째 행렬의 첫번째 자리수가 같아야함
x <- matrix(c(1, 4, 2, 3), nrow = 2)
x
y <- matrix(c(1, 3, 2, 4, 5, 6), nrow = 2)
y

x%*%y

z <- matrix(c(1, 2, 3, 4, 5, 6, 7, 8, 9), nrow = 3)
z

x%*%z

c(1,2,3) %*% c(4,5,6)

#%/%  연산자
#형식 : a%/%b 
#a를 b로 나눈다. 요소별로 연산한다.
# %/% 연산자로 나눈 겨로가에서ㅏ 소수점은 절삭을 하여 반환,

x <- matrix(c(1, 4,2, 3), nrow = 2)
x
y <- matrix(c(1, 3, 2, 4), nrow = 2)
y

x %/% y

z <- matrix(c(1, 2, 3, 4, 5, 6, 7, 8, 9), nrow = 3)
z

x %/% z

#벡터 내 특정 값 포함 여부 확인 연산자 %in%
#형식 : a%in%b
#벡터 내 특정값이 포함되었는지 여부 확인
# TRUE, FALSE 논리형 벡터 출력


x %in% y

sum(x %in% y)

#집합연산 관련 내장함수
#집합을 대상으로 합집합, 교집합, 차집합 등의 집합연산을 수행하는 R의 내장함수
#union(x,y), setequal(x,y), intersect(x,y), setdiff(x,y). c%in%y

x <- c(1,3,5,7,9)
y <- c(3,7)

union(x,y)
setequal(x,y)
intersect(x,y)
setdiff(x,y)
setdiff(y,x)
5%in%y


