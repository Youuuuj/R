#데이터 불러오기

#키보드입력
#scan()함수, #edit()함수


num <- scan()
num
sum(num)

name <- scan(what = character())
name

#edit()함수. 표 형식의 데이터편집기 제공
df = data.frame()
df = edit(df)
df

#로컬파일 가져오기
#read.table()함수 이용
#컬럼이 공백, 탭, 콜론(:), 세미콜론(;), 콤마(,) 등의 구분자가 
#포함된 자료파일을 불러올 수 있는 함수
#구분자가 공백 또는 tab이면 sep속성 생략가능
#컬럼명이 있는 경우 header속성을 'header = TRUE'로 지정
#read.table(file = "경로명/파일명", sep="구분자",header = "T or F")

getwd()
setwd("C:/Temp/dataset1")
student <- read.table(file = "student.txt")
student

#names()함수는 원하는 컬럼명 지정 가능
names(student) <- c("번호", "이름", "이름", "몸무게")
student

student <- read.table(file = "student.txt", header = T)
student

#탐색기를 이용한 파일 선택
student1 <- read.table(file.choose(), header = T)

#구분자가 있는 경우
#구분자가 tab인 경우 sep = "\t"형식으로 sep속성 값 지정하여 파일 불러온다
student2 <- read.table(file = "student2.txt", sep = ";", header = T)
student2

#결측치를 처리하여 파일 불러오기
#특정 문자열을 NA로 처리하여 파일을 불러올 수 있다.
#na.string = "-"을 사용하면 '-'문자를 NA로 변경하여 파일의 데이터 불러옴
student3 <- read.table(file = "student3.txt", header = T, na.strings = "-")
student3

#read.csv()함수
#형식은 콤마(,)를 기준으로 각 컬럼을 구분하여 저장한 데이터 형식
#형식 : read.csv(file = "경로명/파일명", sep = ",", header = TRUE)
#csv는 콤마(,)가 구분자이기 때문에 sep속성은 생략 가능
student4 <- read.csv(file = "student4.txt", sep = ",", na.strings = "-")
student4

#인터넷에서 파일 가져오기
titanic <- read.csv("http://vincentarelbundock.github.io/Rdatasets/csv/COUNT/titanic.csv")
titanic

dim(titanic) #dim()은 자료의 차원정보, 몇개의 행 몇개의 열이 있는지 알려주는 함수
str(titanic) #str() 자료 구조파악하는 함수
 
table(titanic$age) #table 빈도수 보여주는 함수
table(titanic$sex)
table(titanic$survived)

head(titanic, 20) #head()함수는 기본 6줄. head(x,n) n에 보고싶은만큼 숫자 입력
tail(titanic, 20) #tail함수도 마찬가지

#교차테이블(분할표)의 작성
#table함수에서 첫번쨰 인수는 교차분할표에서 행으로 나타나고, 
#두번째 인수는 열로 나타낸다.
tab <- table(titanic$survived, titanic$sex)
tab

#범주의 시각화 - 막대차트 그리기
#barplot()함수 : 막대그래프 그리기
barplot(tab, col = rainbow(2), main = "성별에 따른 생존 여부")

#데이터 저장하기 : 콘솔에 출력하거나 처리가 완료된 결과물을 특정 파일에 저장하는 방법
#화면(Console) 출력
#처리 결과가 저장된 변수를 화면에 출력하는 R함수 : cat(),print()
#cat함수는 출력할 문자열과 벼수를 함꼐 결합하여 콘솔에 출력.
#print함수는 각각 하나의 변수만 출력가능 ex) 1 , "문자" 등등
x <- 10
y <- 20
z <- x*y
cat("x*y의 결과는 ", z,"입니다\n")# \n(new line) : 새로운 줄로 바꿔라
cat("x*y = ",z)

#파일 저장 : 결과를 특정 파일에 저장하는 방법
#sink()함수 : sink함수를 실행하면 이후에 작업한 모든 내용 지정된 함수에 저장
#sink()함수의 기능 종료를 위해 인수없이 sink()함수 한번 더 실행

getwd()
setwd("C:/Temp/Rwork")
library(RSADBE)
data("Severity_Counts")
sink("severity.txt")
severity <- Severity_Counts
severtiy
sink()


#write.table()함수 : 처리된 결과(변수)를 테이블 형식으로 파일에 저장하는 함수
#'row.names = TRUE' 속성 : 행 번호 제거
#"quote = TRUE' 속성 : 따옴표 제거
#write.table함수로 저장된 데이터는 read.table함수를 이용하여 텍스트파일을
#데이터프레임 형식으로 불러올 수 있다.

titanic
write.table(titanic, "titanic2.txt", row.names = FALSE, quote = F)

titanic_df <- read.table(file = "titanic2.txt", sep="", header = T)
titanic_df

#write.csv함수 : 데이터프레임 형식의 데이터를 csv형식으로 파일에 저장
setwd("C:/Temp/dataset1")
st.df < studentx
write.csv(st.df, "stdf.csv", row.names = F, quote = F)

