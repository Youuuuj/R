#21페이지부터

# List 자료구조
# 성격이 다른 자료형(문자형, 숫자형, 논리형)과 
# 자료구조( 벡터, 행렬, 리스트, 데이터프레임)를 객체로 생성가능
# 특징
# 키(key)와 값(value)이 한쌍으로 저장
# 함수 내에서 여러 값을 하나의 키로 묶어서 반환하는 경우 유용하다.         
# 리스트 생성함수 :  list()
# 리스트 자료 처리 함수 : ulist(), lapply(), sapply()

list <- list('lee', '이순신',95)
list


unlist <- unlist(list) # unlist()함수는 숫자도 벡터로 변환되면서 문자가 된다.
unlist

#1개 이상의 값을 갖는 리스트 객체 생성
num <- list(c(1:5), c(6,10))
num

# key와 value형식
# 형식 : list(key1 = value1, key2 = value2  ..... key n = value n) 

member <- list(name = c('홍길동','유관순'), age = c(35,25),
               address = c('한양','충남'), gender = c('남자','여자'),
               htype = c('아파트','오피스텔'))
member
member$name[3]
member$age[1] <- 45
member$age <- NULL
member$age[2] <- 20
member$age
member$id <- 'hong'
member$pwd <- '1234'
member

length(member)
mode(member)
class(member)


#lapply()함수 : 함수 적용 후 리스트 형태로 변환
a <- list(c(1:5))
b <- list(c(6:10))
a ; b
lapply(c(a,b),max)

#sapply()함수 : 함수 적용 후 벡터 형식으로 변환
sapply(c(a,b), max)

#다차원 리스트 객체 생성
multi_list <- list(c1 = list(1,2,3),
                   c2 = list(10,20,30),
                   c3 = list(100,200,300))

multi_list$c1 ; multi_list$c2 ; multi_list$c3


#다차원 리스트를 열 단위로 바인딩

do.call(cbind, multi_list)
do.call(rbind, multi_list)
class(do.call(cbind, multi_list))


install.packages('stringr')
library(stringr)

#문자열추출
str_extract("홍길동35이순신45유관순25", "[1-9]{2}") 
str_extract_all("홍길동35이순신45유관순25", "[1-9]{2}") 
#[1-9] -> 숫자를 찾아라
#[a-z] -> 문자를 찾아라
#{x} ->x개 연속된 첫번째 문자열을 찾는다

#정규 표현식
#추출하려는 문자열의 패턴을 지정 ! ex) [1-9], [a-z]
#문자열 처리 관련 함수는 대부분 정규표현식(약속된 기호에 의해 표현) 이용

#정규표현식에서 []기호는 대괄호 안의 문자가 {n}에서 n만큼 반복
#[a-z]{3} : 영문 소문자가 연속으로 3개 발생
#[a-z]{3,} : 영무 소묹가 3자 이상 여속하는 것 추출
#[a-z]{3,5} : 영문 소문자가 3-5자 연속하는 것 추출

#반복 수를 지저하여 영문자 추출
string <- "hongkd105leess1002you25강감찬2005"
str_extract_all(string, "[0-9]{3}")
str_extract_all(string, "[a-z]{3,}")
str_extract_all(string, "[a-z]{3,5}")

#문자열에서 한글, 영문자, 숫자 추출
str_extract(string, "hong") #해당 문자열 추출
str_extract(string, "35") #해당 숫자 추출
str_extract(string, "[가-힣]{3}") #연속된 3개의 한글문자열 추출
str_extract_all(string, "[a-z]{3}") #연속된 3개의 문자열 추출
str_extract_all(string, "[0-9]{4}") #연속된 4개의 숫자추출

#특정 문자열을 제외하는 정규 표현식
#형식 : "[^제외문자열]" : 해당 문자열을 제외하고 나머지 추출
#       "[^제외문자열]{n}" : 문자열을 제외하고 연속된 n글자 추출


str_extract_all(string, "[^a-z]")
str_extract_all(string, "[^a-z]{4}")
str_extract_all(string, "[^가-힣]{5}")
str_extract_all(string, "[^0-9]{3}")

#한 개의 숫자와 단어 관련 정규표현식
#"\\d{6}" : 숫자가 6개 연속된 패턴을 지정하는 정규표현식.
#"[0-9]{6}"과 같은 결과 산출

jumin <- "123456-1234567"
str_extract(jumin, "[0-9]{6}-[1234][0-9]{6}")
str_extract_all(jumin, "\\d{6}-[1234]\\d{6}")

#지정된 길이의 단어 추출
#"\\w{7}" : 단어의 길이가 7이상인 패턴을 지정하는 정규표현식
#*특수문자 제외

name <- "홍길동1234,이순신5678,강감찬1012"
str_extract_all(name, "\\w{7,}")


#문자열 연산
#str_length() : 문자열의 길이
len <- str_length(string)
len

#문자열 내 특정 문자열의 index
#str_locate() : 문자열 내에서 특정 단어의 위치 표시시
str_locate(string, "강감찬")

#부분 숫자열 만들기
string_sub <- str_sub(string, 1, len - 7)
string_sub
string_sub <- str_sub(string, 1, 23)


str_to_lower(ustr)
ustr <- str_to_upper(string_sub); ustr
ustr2 <- str_to_lower(string_sub); ustr2

#문자열 교체하기 str_replace(문자열, 변경될 인자, 변경할 인자)함수
string_rep <- str_replace(string_sub, "hongkd105", "홍길동35,")
string_rep <- str_replace(string_rep, "leess1002", "이순긴45,")
string_rep <- str_replace(string_rep, "유관순25,", "유관순25")
string_rep

#문자열 결합하기 str_c(문자열, 추가인자)함수
string_c <- str_c(string_rep, ',강감찬55')
string_c

#문자열 분리 str_split(문자열, 구분자)함수
string_c
string_sp <- str_split(string_c, ",")
string_sp

#문자열 합치기
#Paste()함수 : 여러 개의 문자열로 구성된 벡터 객체를대사응로 구분자를 적용하여
#              하나의 문자열을 갖는 벡터 객체로 합칠 수 있다.

#1단계 문자열 벡터 만들기
string_vec <- c("홍길동35", "이순신45", "유관순25", "강감찬55")
string_vec

#2단계 구분자를 기준으로 문자열 벡터 합치기
string_join <- paste(string_vec, collapse = ",")
string_join
#문자열 자료가 많은 경우 매우 유용함.

