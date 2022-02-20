#산술 연산자

num1 <- 100; num2 <- 20
rs <- num1 + num2; rs
rs1 <- num1 - num2; rs1
rs2 <- num1 * num2; rs2
rs3 <- num1 / num2; rs3
rs4 <- num1 %% num2; rs4 #num1을 num2로 나누고 남은 값
rs5 <- num1^2; rs5
rs6 <- num1^num2; rs6 # 1e+40 = 1*10^40 1.2e+2= 120


#관계 연산자
#== : 같다. != : NOT, > : 왼쪽이 크다, >= : 왼쪽이 크거나 같다
#< : 우측이 크다 <= 우측이 크거나 같다

bl1 <- num1 == num2; bl1 
bl2 <- num1 != num2; bl2
bl3 <- num1 > num2; bl3
bl4 <- num1 >= num2; bl4
bl5 <- num1 < num2; bl5
bl6 <- num1 <= num2; bl6

#논리연산자 : TRUE / FALSE 값 반환

# a b  a and b     a b  a|b(or)
# T T     T        T T   T
# T F     F        T F   T
# T T     F        F T   T
# T F     F        F F   F

logical <- num1 >= 50 & num2 <= 10; logical
logical <- num1 >= 50 | num2 <= 10; logical
logical <- num1 >= 50; logical
logical <- !(num1 >= 50); logical

x <- TRUE; y <- FALSE
xor(x,y)

#xor() 함수:
#X Y XOR
#T T F
#T F T
#F T T
#F F F



#조건문
#if()문
#if(조건식){참인경우 처리문
#}else{거짓인 경우 처리문
#}

x <- 4; y <- 4; z <- x * y
if(x * y >= 40){
  cat("x * y의 결과는 40이상입니다.\n")
  cat("x * y = ",z)
} else {
  cat("x * y의 결과는 40미만입니다. x * y = ",z,"\n")
  }


score <- scan()
score
result <- "노력"
if(score > 80){
  result <- "우수"
}
cat("당신의 학점은 ",result, score)

#if~else if 형식으로 학점 산출
score <- scan()
if(score >= 90){
  result = "A학점"
} else if(score >= 80){
  result = "B학점"
} else if(score >= 70){
  result = "C학점"
} else if(score >= 60){
  result = "D학점"
} else {
  reslut = "F학점"
}
cat("당신의 학점은", result)
print(result)


#ifelse()함수
#조건식이 참인 경우와 거짓인 경우 처리할 문장을 ifelse()문에 포함
#형식 : ifelse(조건식, 참인경우 처리문, 거짓인경우 처리문)

score <- scan()

ifelse(score>=80, "우수", "노력")


#ifelse()함수 응용

excel <- read.csv("C:/Temp/dataset1/excel.csv", header = TRUE)
q1 <- excel$q1 ; q1

ifelse(q1 >= 3, sqrt(q1), q1)
ifelse(q1 >= 2 & q1 <= 4, q1 ^ 2, q1)

#switch()함수
#비교 문장의 내용에 따라 여러 개의 실행문 중
#하나를 선택할 수 있도록 프로그램 작성
#형식 : switch(비교문, 실행문1[, 실행문2, 실행문3, ...])
#비교문 위치에 있는 변수의 이름이 
#실행문 위치에 있는 변수의 이름과 일치할 때 일치하는 변수에 할당된 값을 출력

switch("name", id = "hong", pwd = "1234", age = 105, name = "홍길동")

empname <- scan(what = "")
empname

switch (empname,
        hong = 250,
        lee = 350,
        kim = 200,
        kang = 400
)


#which()함수
#백터 객체를 대상으로 특정 데이터를 검색하는데 사용되는 함수
#조건식이 결과가 참인 벡터 원소의 위치(인덱스)가 출력되며,
#조건식의 결과가 거짓이면 0이 출력된다.
#형식 : which(조건)

name <- c("kim", "lee", "choi", "park"); name
which(name == "choi")

#데이터프레임에서 해당 원소가 없으면 0이 출력
#which함수는 크기가 큰 데이터프레임이나 테이블 구조의 자료를 대상으로 
#특정 정보를 검색하는데 사용

no <- c(1:5) ; no
name <- c("홍길동", "이순신", "강감찬", "유관순", "김유신"); name
score <- c(85, 78, 89, 90, 74); score
exam <- data.frame(학번 = no, 이름 = name, 성적 = score) ; exam

#일치하는 이름의 인덱스 반환
which(exam$이름 == "유관순")
exam[4,]


#반복문
#조건에 따라서 특정 실행문을 지정된 획수만큼 반복적으로 수행할 수 있는 문

#for()함수
#지정된 횟수만큼 실행문을 반복 수행하는 함수
#형식 : for(변수 in 변수){실행문} for(variable in vector)
#반복할 문장이 하나 뿐일때는 {} 생략가능

i <- c(1:100)
for(n in i){
  print(n * 10)
  print(n)
}

#짝수 값만 출력
# %%연산자 : 나머지 계산
i <- c(1:10)
for(n in i){
  if(n %% 2 == 0){print(n)}
}

#짝수이면 넘기고, 홀수 값만 출력
i <- c(1:10)
for(n in i){
  if(n %% 2 ==0){
    next
  } else {
    print(n)
  }
}

#next문 : for()함수의 반복 범위에서 문장을 실행하지 않고, 계속 반복할 때 사용

#변수의 컬러명 출력

name <- c(names(exam))
name
for(n in name){
  print(n)
}

#벡터 데이터 사용

score <- c(85, 95, 98)
name <- c("홍길동", "이순신", "강감찬")

i <- 1
for(s in score){
  cat(name[i]," -> ", s,"\n")
  i <- i + 1
}

#while()함수
#for()함수는 반복 회수를 결정하는 변수를 사용. 
#while()함수는 사용자가 블록내에서 증감식을 이용하여 반복 회수를 지정해야 한다.
#형식 : while(조건){실행문}
#조건이 FLASE가 되면 while문에서 탈출.

i = 0

while(i < 10){
  i <- i + 1
  print(i)
}


#함수의 정의
#사용자 정의 함수 : 사용자가 직접 함수 내에 필요한 코드를 작성하여 
#필요한 경우 함수를 호출하여 사용기 위하여 작성한 함수
#형식 : 함수명 <- function(매개변수){실행문}

f1 <- function(){
  cat("매개변수가 없는 함수")
}
f1()

#매개변수가 없는 함수는 '함수명()' 형태로 함수명에 빈 괄호를 붙여 호출
#정의된 함수를 호출하지 않으면 함수의 내용은 실행되지 않는다

#결과를 반환하는 사용자 함수 정의

f3 <- function(x, y){
  add <- x + y
  return(add)
}
add <- f3(10,20); add
#return()함수 : 사용자 정의 함수 내에 있는 값을 함수를 호출하는 곳으로 반환하는역할


#기술통계랑을 계산하는 함수 정의
#요약통계량, 빈도 수등의 기술 통계량을 계산하는 함수를 정의


getwd()
setwd("C:/Temp2/Rwork/data/dataset1")
test <- read.csv("test.csv", header = TRUE)
head(test)
test
summary(test) #요약 통계량 구하기
table(test$A) # 특정 변수의 빈도수 구하기

datapro <- function(x){
  for(idx in 1:length(x)){   #데이터 프레임에서의  length는 칼럼 수
    cat(idx, "번째 칼럼의 빈도 분석 결과")
    print(table(x[idx]))
    cat("\n")
  }
  
  for(idx in 1: length(x)){
  f <- table(x[idx])
  cat(idx, "번째 칼럼의 최대값/최소값\n")
  cat("max = ", max(f), "min = ", min(f), "\n")
  }
}

datapro(test)


#사용자 정의 함수 data_pro() : 컬럼 단위로 빈도수, 최대값, 최소값 계산

