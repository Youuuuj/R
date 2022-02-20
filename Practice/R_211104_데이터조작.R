# dplyr 패키지 활용
# dplyr 패키지는 데이터프레임 자료구조를 갖는 데이터를 처리하는데 적합한 패키지
# dplyr 패키지의 주요 함수
# tbl_df()
# filter()
# arrange()
# select()
# mutate()
# summarise()
# group_by()
# join()
# bind()
# renames()


# 파이프 연산자(%>%)를 이용한 함수 적용
# 파이프 연산자(%>%): 데이터 프레임을 조작하는데 필요한 함수를 순차적으로 적용할 경우 사용할 수 있는 연산자

# %>% 연산자는 인수를 함수에 편하게 적용할 수 있다.
# %>% 연산자의 >(라이트 앵글 브래킷) 기호는 방향의 의미로 왼쪽에 있는 인자를 오른쪽에 있는 함수에 집어넣는 것이 파이프라인의 기능이다.
# %>% 연산자를 사용하면 여러 가지 함수를 한 번에 사용할 수 있다.
# %>% 함수의 큰 장점은 한 번에 한 줄로 코드를 사용할 수 있으므로 함수를 사용할 때마다 따로 저장하는 과정이 없이 여러 함수를 실행할 수 있는 편리성에 있다.
# %>% 연산자에서 왼쪽 %(퍼센트)를 LHS(Left Hand Side) 변수라고 하며 오른쪽 %(퍼센트)를 RHS(Right Hand Side) 변수라고 한다

# %>% 함수를 생성하여 반환한다.

csvgrade <- read.csv("grade_csv.csv")
csvgrade %>% head() %>% summary()


# iris 데이터셋을 대상으로 '%>%'연산자를 이용하여 함수 적용

library(dplyr)

iris %>% head()
iris %>% head() %>% subset(Sepal.Length >= 5.0)

# %>% 함수의 도트(.) 연산자
# 도트(.) 연산자를 사용하여 LHS가 들어갈 위치를 정할 수 있다.
# 도트(.) 연사자는 저장한 인자의 이름을 다시 쓰지 않고 데이터를 사용할 수 있다.

# 1:5의 인자를 다시 쓰지 않고 사용할 수 있으며 sum함수로 호출한다
1:5 %>% sum(.)

# length 함수에 의해서 길이인 5까지 더해져서 20을 반환
1:5 %>% sum(length(.))


# sum(length(1:5))와 같이 수열을 지정하여 반환하므로 수열의 길이인 5까지 더해서 20을 반환
5 %>% sum(1:.)

# {}(브레이스)를 적용하면 함수를 한 번씩만 실행한다
5 %>% {sum(1:.)}
csvgrade <- read.csv("grade_csv.csv")

# 1부터 행의 수만큼 수열로 출력하고 나눈 나머지가 0인 행의 부분집합을 추출한다.
csvgrade %>% subset(1:nrow(.) %% 2 == 0)




# 콘솔 창의 크기에 맞게 데이터 추출
# 데이터 셋을 대상으로 콘솔 창의 크기에 맞게 데이터를 추출하고, 나머지는 축약형으로 제공

install.packages("hflights")
library(hflights)

str(hflights)

# tbl_df()함수 사용하기
hflights_df <- tbl_df(hflights)
hflights_df

# tbl_df()함수: 현재 R의 console창 크기에서 볼 수 있는 만큼 결과를 나타내고, 나머지는 아래에 생략된 행 수와 컬러명 표시
hflights <- hflights %>% tbl_df()
hflights




# dplyr 패키지의 filter 함수를 사용하여 조건에 맞는 데이터만 추출한다.
# filter 함수는 조건에 해당하는 데이터의 모든 컬럼을 추출한다.
# 형식 : filter(dataframe, 조건1, 조건2)

# ==(더블 이퀄) 연산자
# ==를 적용하여 객체의 특정값을 호출한다

csvgrade %>% filter(class == 1)

# !=(엑스클러메이션 포인트 이퀄) 연산자
# != 연산자를 적용하여 객체의 특정값인 아닌 나머지 값들을 호출한다.

csvgrade %>% filter(class != 1)

# >(라이트 앵글 브래킷) 연산자
# >연산자를 적용하여 객체의 특정값 초과인 값들을 호출
csvgrade %>% filter(math > 50)

# <(레프트 앵글 브래킷) 연산자
# < 연산자를 적용하여 객체의 특정값 미만인 값들을 호출한다.
csvgrade %>% filter(math < 50)

# >=(라이트 앵글 브래킷 이퀄) 연산자
# >= 연산자를 적용하여 객체의 특정값 이상인 값들을 호출한다
csvgrade %>% filter(eng >= 80)

# <=(레프트 앵글 브래킷 이퀄) 연산자
# <= 연산자를 적용하여 객체의 특정값 이하인 값들을 호출한다.
csvgrade %>% filter(eng <= 80)

# &(앰퍼샌드) 연산자
# & 연산자는 객체를 평가하고 객체 모두 TRUE일 때 TRUE로 평가하고 그렇지 않으면 FALSE로 평가한다.
# & 연산자를 적용하여 여러 조건을 충족하는 행을 추출한다
csvgrade %>% filter(class == 1 & math >= 50)

# |(버티컬바) 연산자
# | 연산자는 객체를 평가하고 객체가 모두 FALSE일 때 FALSE로 평가하고 그렇지 않으면 TRUE로 평가한다.
# | 연산자를 적용하여 여러 조건 중 하나 이상 충족하는 행을 추출한다.
csvgrade %>% filter(eng < 90 | sci < 50)
csvgrade %>% filter(class == 1 | class == 3 | class == 5)

# %in% 연산자
# %in% 연산자는 값의 포함 여부를 확인하고 반환한다.
# %in% 연산자는 여러 객체에서 여러 조건을 줄 때는 사용할 수 없다.
csvgrade %>% filter(class %in% c(1, 3, 5))


# 객체생성 - 필터링한 데이터의 객체를 생성한다
# 데이터의 객체를 생성하여 반환한다

 
# 객체생성
class1 <- csvgrade %>% filter(class == 1)
# class1객체의 math 컬럼에 접근하여 평균산출
mean(class1$math)
# class1 객체의 eng 컬럼에 접근하여 평균 산출
mean(class1$eng)
# class1 객체의 sci 컬럼에 접근하여 평균 산출
mean(class1$sci)


# hfilghts_df를 대상으로 특정일의 데이터 추출하기
filter(hflights_df, Month == 1 & DayofMonth == 2) # 1월 2일 데이터 추출

# %>%연산자를 사용해서 hflights_df데이터 셋에 filter()함수 적용:
hflights_df %>% filter(Month == 1 & DayofMonth == 2)

# hflights_df 대상으로 지정된 월의 데이터 추출
filter(hflights_df, Month == 1 | Month == 2)  # 1월 또는 2월 데이터 추출
hflights_df %>% filter(Month == 1 | Month == 2)


# 컬럼으로 데이터 정렬
# 데이터 셋의 특정 컬럼을 기준으로 오름차순 또는 내림차순으로 정렬하는 arrange()함수
# 형식 :  arrange(dataframe, 컬럼1, 컬럼2, ..)  # default는 오름차순
#  arrange(dataframe, desc(컬럼1, ...))  # desc()함수로 내림차순


# 단일 객체의 오름차순 정렬
# 오름차순으로 데이터를 정렬하여 추출
csvgrade %>% arrange(math)

# 단일객체의 내림차순 정렬
# arrange()를 이용하여 데이터를 내림차순으로 저렬하여 추출하려면 기준 객체에 desc()함수적용
csvgrade %>% arrange(desc(math))

# 다중 객체의 오름차순 정렬
# arrange 함수를 이용하여 다중 객체의 데이터를 ,(콤마)로 기준으로 오름차순으로 정렬하며 추출한다.
# 여러 객체의 데이터를 오름차순으로 정렬하여 추출한다.
csvgrade %>% arrange(class, math)

# hglights_df를 대상으로 데이터 정렬
arrange(hflights_df, Year, Month, DepTime, ArrTime)


# 오름차순 정렬 시 우선순위는 가장 왼쪽의 컬럼부터 시작하여 오른쪽 컬럼 순으로 정렬
# 파이프연산자를 사용하여 hflights_df 데이터에 arrange()적용
hflights_df %>% arrange(Year, Month, DepTime, ArrTime)


# 컬럼으로 데이터 검색
# 데이터 셋의 특정 컬럼을 기준으로 데이터 검색 시 select()함수 사용
# 형식 : select(dataframe, 컬럼1, 컬럼2, ...)
# select()함수는 추출하고자 하는 객체를 할당하면 해당 객체만 추출함

# 단일객체
csvgrade %>% select(math)

# 다중객체
csvgrade %>% select(class, math)

# 객체제외
# select 함수의 인자에 -(마이너스) 연산자를 활용하여 객체 제외하고 추출함
csvgrade %>% select(-math)


# %>% 함수 적용
# %>% 함수를 적용하여 함수를 조합하여 구현한다.
# %>% 함수를 적용하면 코드의 길이가 줄어들어 이해하기도 쉽고 실행하는데 불필요한 부분이 줄어들어 시간이 단축된다ㅓ
csvgrade %>% filter(class == 1) %>% select(eng)

# 특정 객체의 값 일부를 추출.
csvgrade %>% select(id, math) %>% head(3)


# hflights_df를 대상으로 지정된 컬럼 데이터 검색
select(hflights_df, Year, Month, DepTime, ArrTime)
hflights_df %>% select(Year, Month, DepTime, ArrTime)

# hflights_df 대상 컬럼의 범위로 검색
select(hflights_df, Year : ArrTime)
hflights_df %>% select(Year : ArrTime)

# hflights_df 대상 컬럼의 검색제외
select(hflights_df, -(Year : DepTime))
hflights_df %>% select(-(Year : DepTime))



# 데이터 셋에 컬럼 추가
# 데이터 셋에 특정 컬럼을 추가하는 mutate()함수
# 형식 : mutate(dataframe, 컬럼명1 = 수식1, 컬럼명2 = 수식2, ....)

# hflights_df에서 출발 지연시간과 도착 지연시간의 차이를 계산한 컬럼 추가
mutate(hflights_df, gain = ArrTime - DepTime,
       gain_per_hour = gain / (AirTime / 60))

hflights_df %>% mutate(gain = ArrTime - DepTime,
                       gain_per_hour = gain / (AirTime / 60))


# mutate()함수에 의해 추가된 컬럼 보기
select(mutate(hflights_df, gain = ArrTime - DepTime,
              gain_per_hour = gain / (AirTime / 60)),
       Year, Month, ArrDelay, DepDelay, gain, gain_per_hour)


# 요약통계 구하기
# 데이터 셋에 특정 컬럼을 대상으로 기술통계량을 계산하는 summarise()함수
# 형식 : summarise(dataframe, 추가할 컬럼명 = 함수(컬럼명), ...)

# 컬럼의 평균과 같이 컬럼을 요약한 통계량을 구할 때는 summarise 함수와 group_by함수를 사용한다.
# 구한 결과를 요약표로 만들면 컬럼의 집단 간에 어떤 차이가 있고 어떤 분포를 갖는지 쉽게 파악할 수 있다.
# 그룹으로 나눈 데이터는 다른 분석에도 사용할 수 있으므로 활용도가 매우 높다.


# 전체평균, 사분위수 등 전체적인 값들에 대한 요약 통계량을 산출할 때는 summary함수를 사용하고,
# 개별 컬럼의 데이터에 대한 요약 통계량을 구할 떄는 summarise 함수를 사용
csvgrade %>% summarise(mean_math = mean(math))

# hflights_df에서 비행시간의 평균 구하기
summarise(hflights_df, avgAirTime = mean(AirTime, na.rm = T))
hflights_df %>% summarise(avgAirTime = mean(AirTime, na.rm = T))

# hflights_df 의 관측치 길이 구하기
summarise(hflights_df, cnt = n(),
          delay = mean(AirTime, na.rm = T))

# n()함수 : 데이터 셋의 관측치 길이를 구하는 함수

# 도착시간(AirTime)의 표준편차와 분산 계산
summarise(hflights_df, arrTimeSd = sd(ArrTime, na.rm = T),
          arrTimeVar = var(ArrTime, na.rm = T))


