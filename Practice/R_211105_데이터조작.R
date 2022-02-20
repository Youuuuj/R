# 집단변수 대상 그룹화
# 데이터 셋 내 범주형 컬럼을 대상으로 그룹화하는 group_by()함수 사용
# 형식 : group_by(dataframe, 집단변수)
# group_by함수에 객체를 지정하면 컬럼별로 분리한다.

# 컬럼의 집단별 평균 요약 통계량
library('dplyr')  # dplyr을 왜 사용해? R의 기본함수보다 더 빠른 값을 내주기 때문에

getwd()
setwd('C:/Users/tj-bu/Desktop/Rwork/dataset3')

csvgrade <- read.csv("grade_csv.csv")
csvgrade %>% group_by(class) %>% summarise(mean_math = mean(math))

# group_by함수는 인자로 범주형 변수가 포함된 컬럼명을 인자로 받아 요약 통계량을 계산


# 컬럼의 집단별 다중 요약 통계량
csvgrade %>% group_by(class) %>% summarise(mean_math = mean(math), sum_math = sum(math),
                                           median_math = median(math))


# 집단 변수를 이용하여 그룹화
species <- group_by(iris, Species)
str(species)
species

species <- iris %>% group_by(Species)



# 데이터프레임 병합
# 서로 다른 데이터프레임을 대상으로 공통 컬럼을 이용하여 하나의 데이터 프레임을 병합하는 join()함수
# inner_join(df1, df2, x), left_join(df1, df2, x)
# right_join(df1, df2, x), full_join(df1, df2, x)



# inner_join(A, B, by = key)
# key를 기준으로 열에서 일치하는 열만 결합
a <- data.frame(id = c(1,2,3,4,5), score = c(60,80,70,90,85))
b <- data.frame(id = c(3,4,5,6,7), weight = c(80,90,85,60,85))

merge(a,b, by='id')
inner_join(a,b, by = 'id')

# 공통변수를 이용하여 내부조인하기(inner_join)
df1 <- data.frame(x = 1:5, y = rnorm(5))
df2 <- data.frame(x = 2:6, z = rnorm(5))

inner_join(df1, df2, by = 'x')



# left_join(A, B, by = key)
# key를 기준으로 왼쪽 열을 결합
a <- data.frame(id = c(1,2,3,4,5), score = c(60,80,70,90,85))
b <- data.frame(id = c(3,4,5,6,7), weight = c(80,90,85,60,85))

merge(a, b, by = 'id', all.x = T)
left_join(a, b, by = 'id')


# 공통변수를 이용하여 왼쪽 조인하기(left_join)
left_join(df1, df2, by = 'x')

# right_join(A, B, by = key)
# key를 기준으로 오른쪽 열 결합
a <- data.frame(id = c(1,2,3,4,5), score = c(60,80,70,90,85))
b <- data.frame(id = c(3,4,5,6,7), weight = c(80,90,85,60,85))

merge(a, b, by = 'id', all.y = T)
right_join(a, b, by = 'id')

# 공통변수를 이용하여 오른쪽 조인하기(right_join)
right_join(df1, df2, by = 'x')


# full_join(A, B, by = key)
# 키를 기준으로 모든 열을 결합
a <- data.frame(id = c(1,2,3,4,5), score = c(60,80,70,90,85))
b <- data.frame(id = c(3,4,5,6,7), weight = c(80,90,85,60,85))

merge(a, b, by = 'id', all = T)
full_join(a, b, by = 'id')


# 데이터프레임 합치기
# 서로다른 데이터프레임을 대상으로 행 단위 도는 열 단위로 합치는 함수
# bind_rows(df1, df2)
# bind_cols(df1, df2)

# 세로결합
# dplyr 패키지의 bind_rows 함수로 나뉘어져있는 데이터를 세로로 결합.
# bind_rows(df1, df2)
a <- data.frame(id = c(1,2,3,4,5), score = c(60,80,70,90,85))
b <- data.frame(id = c(3,4,5,6,7), weight = c(80,90,85,60,85))
bind_rows(a, b)

# 두 개의 데이터 프레임을 행 단위로 합치기
df1 <- data.frame(x = 1:5, y = rnorm(5))
df2 <- data.frame(x = 2:6, z = rnorm(5))

df_rows <- bind_rows(df1,df2)
df_rows

# rbind
# rbind로 행을 결합하기 위해서는 Dataframe의 열 개수, 칼럼 이름이 같아야함.
a <- data.frame(id = c(1, 2, 3, 4, 5), score = c(60, 80, 70, 90, 85))
b <- data.frame(id = c(6, 7 , 8), score = c(80, 90, 85))

rbind(a, b)


# 가로 결합
# dplyr 패키지의 bind_cols 함수로 나뉘어져 있는 데이터를 가로로 결합.
df_cols <- bind_cols(df1,df2)
df_cols

# cbind
# cbind로 열을 결합하귀 위해서는 데이터프레임이 행 개수가 같아야 함
a <- data.frame(id = c(1, 2, 3, 4, 5), score = c(60, 80, 70, 90, 85))
b <- data.frame(age = c(20, 19 , 20, 19, 21), weight = c(80, 90, 85, 60, 85))
cbind(a, b)

# 관측치가 서로 다른 열의 결합 -> 잘못된 결합으로 반환
a <- data.frame(id = c(1, 2, 3, 4, 5), score = c(60, 80, 70, 90, 85))
b <- data.frame(id = c(3, 4 , 5, 6, 7), weight = c(80, 90, 85, 60, 85))
cbind(a, b)


# 다른 관측치 열의 결합
# 열을 결합하기 위해서는 데이터프레임의 행 개수가 서로 같지 않아도 됌.
# merge 함수로 열을 결합

# merge 함수는 키를 기준으로 열을 결합하여 반환
# 형식 : merge(A, B, by = key, all = False, all.x = all, all.y = all)
# all 옵션: 모든 열을 결합하며 기본값은 FALSE다.
# all.x 옵션: A 객체를 기준으로 열을 결합한다.
# all.y 옵션: B 객체를 기준으로 열을 결합한다.

# 데이터프레임을 구성하는 컬럼명을 수정하는 rename()함수 사용
# 형식: rename(데이터프레임, 변경후컬럼명 = 변경전컬럼명)

df <- data.frame(one = c(4, 3, 8))
df
df <- rename(df, "원" = one)
df

# 데이터프레임의 컬럼명 수정
df_rename <- rename(df_cols, y1 = z)
df_rename <- rename(df_rename, y2 = y1)
df_rename



# reshape2 패키지 활용
# reshape2 패키지의 기본 골격만을 대상으로 개발된 패키지
# melt()함수와 dcast/acast()함수를 적용하여
# 집단변수를 통해서 데이터의 구조를 유연하게 변경해주는 기능 제공

# 긴 형식을 넓은 형식으로 변경
# dcast()함수 : Long format -> wide format
# dcast(dataset, 앞변수 ~ 뒤변수, 적용함수)
install.packages('reshape2')
library(reshape2)
data <- read.csv("data.csv")
data

wide <- dcast(data, Customer_ID ~ Date, sum)
wide

# Custormer_ID -> 행으로 구성
# Date는 열로 구성
# Buy는 측정변수로 사용

write.csv(wide, "wide.csv", row.names = FALSE)

wide2 <- read.csv("wide.csv")
colnames(wide) <- c('Customer_ID', 'day1','day2','day3','day4','day5','day6','day7')
wide

# 넓은 형식을 긴 형식으로 변경
# melt()함수 : wide format -> long format
# melt(데이터셋, id='컬럼명')

# 1단계 : 데이터를 긴 형식으로 변경
long <- melt(wide, id = "Customer_ID")
long

# 2단계 : 컬럼명 변경
name <- c('Customer_ID', 'Date', 'Buy')
colnames(long) <- name
head(long)



# smiths 데이터 셋 확인
# 1단계 : smiths 데이터셋 가져오기

data('smiths')
smiths

# 2단계 : 넓은 형식의 smiths 데이터 셋을 긴 형식으로 변경
long <- melt(id = 1:2, smiths)
long

# 3단계 : 긴 형식을 넓은 형식으로 변경하기
# subject와 time컬럼 기준 : subjuct+time~
dcast(long, subject+time ~ ...)

# 3차원 배열 형식으로 변경
# dcast()함수 : 데이터프레임 형식으로 구조를 변경
# acast()함수 : 3차원 구조를 갖는 배열 형태로 변경

# airquality 데이터셋 구조 변경
# 1단계 : 데이터셋 가져오기
data('airquality')
str(airquality)
airquality

# 2단계 : 컬럼제목을 대문자로 일괄 변경
names(airquality) <- toupper(names(airquality))
head(airquality)

# 3단계 : melt()함수를 이용하여 넓은 형식을 긴 형식으로 변경
air_melt <- melt(airquality, id = c('MONTH','DAY'), na.rm = TRUE)
head(air_melt)
# MONTH와 DAY 기준 긴 형식

# 4단계 : acast()함수를 이용하여 3차원으로 구조 변경
names(air_melt) <-  tolower(names(air_melt))
acast <- acast(air_melt, day ~ month ~ variable)
acast
class(acast)
# day ~ month ~ variable의 3차원 배열

# 집합함수 적용하기
acast(air_melt, month ~ variable, sum, margins = TRUE)
# month칼럼을 기준으로 측정변수의 합계계산
# margin=T 속성 : 각 행과 열의 합계 컬럼 추가
# 3차 구조인 air_melt데이터셋에 dcast()함수 적용 시 데이터프레임 형태로 구조가 변경

