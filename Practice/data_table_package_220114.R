# data.table 설치
# install.packages('data.table')
library(data.table)

# 데이터 불러오기
input <- if (file.exists("flights14.csv")) {
  "flights14.csv"
} else {
  "https://raw.githubusercontent.com/Rdatatable/data.table/master/vignettes/flights14.csv"
}
flights <- fread(input)
flights

# data.table()함수를 이용하여 생성
DT = data.table(
  ID = c("b","b","b","a","a","c"),
  a = 1:6,
  b = 7:12,
  c = 13:18
)
DT
class(DT$ID)

# 데이터프레임과 달리 열은 기본적으로 변환되지않음
# 1: 행번호는 첫번째 열과 행 번호를 시각적으로 구분하기 위해 사용되어짐
# 기본값 100개의 행을 넘어가면 상위 5개 하위 5개 보여줌.
getOption("datatable.print.nrows")  # datatable 행 기본 값


# 부분집합
ans <- flights[origin == "JFK" & month == 6L]
head(ans)

# 특정 행 또는 열 추출
flights[1:2]
flights[, arr_delay]
# flights[, list(arr_delay)]  == flights[, .(arr_delay)]

# 컬럼이름 변경하기(변경할 이름 = 변경 전 이름)
ans <- flights[, .(delay_arr = arr_delay, delay_dep = dep_delay)]
ans

# 계산
ans <- flights[, sum((arr_delay + dep_delay) < 0 )]
ans

# 부분집합 i 및 수행j
# 6월의 출발지 공항이 "JFK"인 모든 항공편의 평균 도착 및 출발 지연을 계산
ans <- flights[origin == "JFK" & month == 6L,
               .(m_arr = mean(arr_delay), m_dep = mean(dep_delay))]
ans

# 2014년 6월에 "JFK" 공항에서 몇 번이나 여행을 갔습니까?
ans <- flights[origin == "JFK" & month == 6L, length(dest)]
ans

ans <- flights[origin == "JFK" & month == 6L, .N]
ans

# with()
DF = data.frame(x = c(1,1,1,2,2,3,3,3), y = 1:8)

## (1) normal way
DF[DF$x > 1, ] # data.frame needs that ',' as well
#   x y
# 4 2 4
# 5 2 5
# 6 3 6
# 7 3 7
# 8 3 8

## (2) using with
DF[with(DF, x > 1), ]
#   x y
# 4 2 4
# 5 2 5
# 6 3 6
# 7 3 7
# 8 3 8


# 특정 열 빼고 추출
ans <- flights[, !c("arr_delay", "dep_delay")]
# or
ans <- flights[, -c("arr_delay", "dep_delay")]

# 시작 및 끝 열 이름을 지정하여 선택할 수도 있다
ans <- flights[, year:day]
ans
ans <- flights[, day:year]
ans


# 집계
# by를 이용해 그룹화
# – 각 출발 공항에 해당하는 여행 횟수는 어떻게 알 수 있습니까?
ans <- flights[, .(.N), by = .(origin)] 
ans <- flights[, .(.N), by = "origin"]  # 같은결과
ans <- flights[, .N, by = origin]
ans

# –  AA 운송업체 코드에 대해 각 출발지 공항의 여행 횟수를 어떻게 계산합니까?
ans <- flights[carrier == 'AA', .N, by = origin]
ans

# origin, dest–AA 운송업체 코드에 대한 각 쌍 의 총 여행 횟수를 어떻게 알 수 있습니까?
ans <- flights[carrier == 'AA', .N, by = .(origin, dest)]
ans

# origin,dest–AA운송업체 코드에 대해 월별 각 쌍의 평균 도착 및 출발 지연을 어떻게 알 수 있습니까?
ans <- flights[carrier == 'AA', .(mean(arr_delay),mean(dep_delay)) , by = .(origin, dest, month)]
ans


# 정렬
# keyby
# – 그렇다면 어떻게 모든 그룹화 변수로 직접 정렬할 수 있습니까?
ans <- flights[carrier == "AA",
               .(mean(arr_delay), mean(dep_delay)),
               keyby = .(origin, dest, month)]
ans


# 체이닝
ans <- flights[carrier == "AA", .N, by = .(origin, dest)]
ans <- ans[order(origin, -dest)]
head(ans)

ans <- flights[carrier == "AA", .N, by = .(origin, dest)][order(origin, -dest)]
head(ans, 10)
# 두개가 같은 결과
# 세로로 연결도 가능하다.

# 식의 표현
# 늦게 출발 - 일찍(또는 정시에) 도착한 항공편, 먼저 출발하고 늦게 도착한 항공편 등을 알고 싶다면…
ans <- flights[, .N, .(dep_delay>0, arr_delay>0)]
ans

# 특수기호 .SD (하위집합)
DT
DT[, print(.SD), by = ID]
DT[, lapply(.SD, mean), by = ID]

# .SDcols (계산하려는 열만 지정)
flights[carrier == "AA",                       
        lapply(.SD, mean),                     
        by = .(origin, dest, month),           

# .SD 각 그룹에 대한 부분집합
# 각각month에 대해 처음 두 행을 어떻게 반환할 수 있습니까?
ans <- flights[, head(.SD, 2), by = month]
head(ans)


# id a와 b의 열과 각 그룹을 어떻게 연결?
DT[, .(val = c(a,b)), by = ID]

# column의 모든 값을 a연결 b하고 싶지만 list column으로 반환된다면?
DT[, .(val = list(c(a,b))), by = ID]
