# 데이터 시각화

# 1. 시각화 도구 분류
# 데이터 분석의 도입부에서 전체적인 데이터 구조를 살펴보기 위해서 시각화 도구 사용
# 이산변수인 경우: 막대, 점, 원형 차트
# 연속변수: 상자 박스, 히스토그램, 산점도
# 칼럼 특성의 시각화 도구 분류
# hist(히스토그램), plot(산점도), barplot(막대 차트), pie(원형 차트), abline(선 추가), 
# boxplot(상자 박스), scatterplot3d(3차원 산점도), pair(산점도 매트릭스

# 2. 이산변수 시각화
# 이산변수 : 정수 단위로 나누어 측정할 수 있는 변수.
# 막대차트, 점 차트, 원차트 이용


# 2.1 막대차트 시각화
# barplot() 함수를 이용하여 세로 막대 차트와 가로 막대 차트 그리기

# (1) 세로 막대 차트
# barplot()함수는 새로 막대 차트 제공

# 세로막대 차트 그리기
# 형식
# barplot(x, ylim : y축 값의 범위, col : 각 막대를 나타낼 색상 지정, 
#         main : 차트 제목, beside = T/F: X축 값을 측면으로 배열, F인 경우 하나의 막대에 누적,
#         font.main : 제목 글꼴 지정, legend() : 범례의 위치, 이름, 글자 크기, 색상 지정,
#         title() : 아트 제목, 차트 글꼴 지정)

# 1단계 : 차트 작성을 위한 자료 만들기
chart_data <- c(305, 450, 320, 460, 330, 480, 380, 520)
names(chart_data) <- c("2018 1분기", "2019 1분기",
                       "2018 2분기", "2019 2분기", 
                       "2018 3분기", "2019 3분기", 
                       "2018 4분기", "2019 4분기")
str(chart_data)
chart_data

# 2단계 : 세로 막태 차트 그리기
barplot(chart_data, ylim = c(0, 600),
        col = rainbow(8),
        main = '2018년도 vs 2019년도 매출현황 비교')

# barplot()함수 도움말 보기
help('barplot')


# 막대 차트의 가로축과 세로축에 레이블 추가하기
barplot(chart_data, ylim = c(0, 600),
        ylab = '매출액(단위 : 만원)',  # y축 이름 지정
        xlab = '년도 별 분기 현황',  # x축 이름 지정
        col = rainbow(8),
        main = '2018년도 vs 2019년도 매출현황 비교')

# (2) 가로 막대 차트
# barplot()함수에 horiz속성을 TURE로 지정

# 가로 막대 그리기
barplot(chart_data, xlim = c(0, 600), horiz = T,
        ylab = '매출액(단위 : 만원)',  # y축 이름 지정
        xlab = '년도 별 분기 현황',  # x축 이름 지정
        col = rainbow(8),
        main = '2018년도 vs 2019년도 매출현황 비교')

# 막대차트에서막대 사이의 간격 조정하기
barplot(chart_data, xlim = c(0, 600), horiz = T,
        ylab = '매출액(단위 : 만원)',  # y축 이름 지정
        xlab = '년도 별 분기 현황',  # x축 이름 지정
        col = rainbow(8), 
        space = 1,  # 막대의 굵기와 간격 지정. 클수록 굵기 작아지고 막대 사이의 간격은 넓어짐
        cex.names = 0.8,  # 축 이름의 크기 지정
        main = '2018년도 vs 2019년도 매출현황 비교')

# 막대 차트에서 막대의 색상 지정
barplot(chart_data, xlim = c(0, 600), horiz = T,
        ylab = '매출액(단위 : 만원)',  # y축 이름 지정
        xlab = '년도 별 분기 현황',  # x축 이름 지정
        space = 1,  # 막대의 굵기와 간격 지정. 클수록 굵기 작아지고 막대 사이의 간격은 넓어짐
        cex.names = 0.8,  # 축 이름의 크기 지정
        main = '2018년도 vs 2019년도 매출현황 비교',
        col = rep(c(2, 4), 4))  # col : 색상지정  ->  2번 4번 색상 4번 반복 사용

# 막대 차트에서 색상 이름을 사용하여 막대의 색상 지정하기
barplot(chart_data, xlim = c(0, 600), horiz = T, 
        ylab = "매출액(단위: 만원)",
        xlab = "년도별 분기 현황", 
        space = 1, cex.names = 0.8,
        main = "2018년도 vs 2019년도 매출현항 비교",
        col = rep(c("red", "green"), 4))  # 색상 값이 아닌 색상의 이름을 사용

# (3) 누적 막대 차트
# 하나의 컬럼에 여러 개의 자료를 가지고 있는 경우
# 자료를 개별적인 막대로 표현 또는 누적형태로 표현

# 누적 막대 차트 그리기
# 1단계 : 메모리에 데이터 가져오기
data('VADeaths')
VADeaths

# 2단계 : VADeaths데이터 셋 구조 보기
str(VADeaths)
class(VADeaths)
mode(VADeaths)

# 3단계 : 개별 차트와 누적 차트 그리기
par(mfrow = c(1,2))
barplot(VADeaths, beside = T, col = rainbow(5),
        main = '미국 버지니아주 하위계층 사망비율')
legend(19, 71, c('50-54', '55-59', '60-64', '65-69', '70-74'),
       cex = 0.8, fill = rainbow(5))

barplot(VADeaths, beside = F, col = rainbow(5))
title(main = '미국 버지니아주 하위계층 사망비율', font.main = 4)
legend(3.8, 200, c('50-54', '55-59', '60-64', '65-69', '70-74'),
       cex = 0.8, fill = rainbow(5))



# 2.2 점 차트 시각화
# 점 파트(dotchart) 도움말 보기
help("dotchart")

# dotchart()함수
# 형식 : 
# x: 데이터
# label: 점에 대한 설명문
# cex: 점의 확대
# pch: 점 모양
# color: 점의 색
# lcolor: 선의 색
# main: 차트 제목
# xlab: x축의 이름

# 점 차트 사용하기
par(mfrow = c(1,1))
dotchart(chart_data, color = c('blue', 'red'),
         lcolor = 'black', pch = 1:2,
         labels = names(chart_data),
         xlab = '매출액',
         main = '분기별 판매현황 : 점 차트 시각화',
         cex = 1.2)


# 2.3 원형 차트 시각화
# 원형 차트(pie)도움말 보기
help(pie)

# 형식 : 
# x: 데이터
# labels: 원형 차트에서 각 조각에 대한 설명문
# col: 색상
# border: 테두리 색
# lty: 선 타입
# main: 차트 제목을 지정

# 분기별 매출현황을 파이 차트로 시각화
pie(chart_data, labels = names(chart_data), col = rainbow(8), cex = 1.2)
title('2018 ~ 2019년도 분기별 매출현황')
# clockwise = TRUE : 시계방향으로 데이터 표기. Default는 FALSE





# 3. 연속 변수 시각화
# 연속변수 : 시간, 길이 등과 같이 연속성을 가진 변수
# 상자 그래프, 히스토그램, 산점도

# 3.1 상자 그래프 시각화
# 상자 그래프 : 요약정보를 시각화하는데 효과적
# 데이터의 분포 정도와 이상치 발견을 목적으로 하는 경우 사용.

# VADeaths 데이터 셋을 상자 그래프로 시각화하기
# 1단계 : 'notch = FALSE'일 때
boxplot(VADeaths, range = 0)
# range = 0 속성에 의해 칼럼의 최소값과 최대값을 선으로 연결

# 2단계 : 'notch = TRUE' 일 때
boxplot(VADeaths, range = 0, notch = T)
abline(h = 37, lty = 3, col = 'red')
# 추가된 notch = T 속성에 의해 중위수 기준으로 허리선이 추가
# abline() 함수에 의해 지정된 y좌표(h)에 빨간색(col) 점선(lty)적용

# VADeaths 데이터셋의 요약 통계량 보기
summary(VADeaths)


# 3.2 히스토그램 시각화
# 히스토그램 : 측정값의 범위(구간)를 그래프의 x축으로 놓고, 
# 범위에 속하는 측정값의 출현 빈도수를 y축으로 나타낸 그래프 형태

# 분포곡선 : 히스토그램에 도수의 값을 선으로 연결하여 얻어지는 곡선

# iris 데이터셋 가져오기
data(iris)
names(iris)
str(iris)
head(iris)

# iris 데이터셋의 꽃받침 길이 컬럼으로 히스토그램 시각화
summary(iris$Sepal.Length)
hist(iris$Sepal.Length, xlab = 'iris$Sepal.Length', col = 'magenta',
     main = 'iris 꽃 받침 길이 Histogram', xlim = c(4.3, 7.9))

# iris 데이터셋의 꽃받침 너비 컬럼으로 히스토그램 시각화
summary(iris$Sepal.Width)
hist(iris$Sepal.Width, xlab = 'iris$Sepal.Width', col = 'mistyrose',
     main = 'iris 꽃 받침 너비 Histogram', xlim = c(2.0, 4.5))

# 히스토그램에서 빈도와 밀도 표현하기
# 1단계 : 빈도수에 의해서 히스토그램 그리기
par(mfrow = c(1,2))
hist(iris$Sepal.Width, xlab = 'iris$Sepal.Width',
     col = 'green',
     main = 'iris 꽃 받침 너비 Histogram', xlim = c(2.0, 4.5))

# 2단계 : 확률 밀도에 의해서 히스토그램 그리기
hist(iris$Sepal.Width, xlab = 'iris$Sepal.Width',
     col = 'mistyrose', freq = F,
     main = 'iris 꽃 받침 너비 Histogram', xlim = c(2.0, 4.5))

# 3단계 : 밀도를 기준으로 line 추가하기
lines(density(iris$Sepal.Width), col = 'red')
# 오른쪽 그래프는 ‘freq=F’속성에 의해 계급에 대한 밀도(Density)를 y축으로 표현한 결과
# density()와 lines()함수에 의해서 밀도 그래프에 분포곡선이 그려짐

# 정규분포 추정 곡선 나타내기
# 정규분포는 평균값을 중아으로 좌우대칭인 종 모양을 이루고 있음.
# 1단계 : 계급을 밀도로 표현한 히스토그램 시각화
par(mfrow = c(1,1))
hist(iris$Sepal.Width, xlab = 'iris$Sepal.Width', col = 'mistyrose',
     freq = F, main = 'iris 꽃 받침 너비 Histogram', xlim = c(2.0, 4.5))

# 2단계 : 히스토그램에 밀도를 기준으로 분포곡선 추가
lines(density(iris$Sepal.Width), col = 'red')

# 3단계 : 히스토그램에 정규분포 추정 곡선 추가
x <- seq(2.0, 4.5, 0.1)
curve(dnorm(x, mean = mean(iris$Sepal.Width),
            sd = sd(iris$Sepal.Width)),
      col = 'blue', add = T)

# 산점도 시각화
# 산점도 : 두 개 이상의 변수들 사이의 분포를 점으로 표시한 차트를 의미

# 산점도 그래프에 대각선과 텍스트 추가하기
# 1단계 : 기본 산점도 시각화
price <- runif(10, min = 1, max = 100)
plot(price, col = 'red')

# 2단계 : 대각선 추가
par(new = T)
line_chart = 1:100
plot(line_chart, type = 'l', col = 'red',
     axes = F, ann = F)  # axes : F = x,y축 표현 X, ann = F : x,y축 제목 지정 X

# 3단계 : 텍스트 추가
text(70, 80, '대각선 추가', col = 'blue')

# type속성으로 산점도 그리기
par(mfrow = c(2, 2))
plot(price, type = "l")
plot(price, type = "o")
plot(price, type = "h")
plot(price, type = "s")


# pch속성으로 산점도 그리기
# plot()함수 내 pch(ploting character)속성을 이용하여 30가지의 다양한 형태의 연결점 표현 가능
# col속성으로 연결점과 선의 색상 굵기 지정 가능

# 1단계 : pch속성과 col,ces속성 사용
par(mfrow = c(2,2))
plot(price, type = 'o', pch = 5)
plot(price, type = 'o', pch = 15)
plot(price, type = 'o', pch = 20, col = 'blue')
plot(price, type = 'o', pch = 20, col = 'blue', cex = 1.5)

# 2단계 : lwd속성 추가 사용
par(mfrow = c(1,1))
plot(price, type = 'o', pch = 20, col = 'green', cex = 2.0, lwd = 3)
# lwd속성으로 선의 굵기를 지정


# plot()함수의 시각화 도구 목록
methods("plot")
# methods()함수에 "plot"함수에서 제공하는 시각화 기능 확인 가능

# plot() 함수에서 시계열 개체 사용하여 추세선 그리기
data("WWWusage")  # 시계열 데이터 가져오기
str(WWWusage)
plot(WWWusage)  # plot.ts(WWWusage)와 같음


# 3.4 중첩 자료 시각화
# 2차원 산점도 그래프느 x축과 y축의 교차점에 점을 나타내는 원리로 그려진다.
# 동인한 좌표값을 갖는 여러 개의 자료가 존재한다면 점들이 중첩되어 해당 촤표에는 하나의 점으로만 표시 되어진다
# 중첩된 자료를 중첩된 자료의 수 만큼 점의 크기를 확대하여 시각화 하는 방법

# 중복된 자료의 수 만큼 점의 크기 확대하기
# 1단계 : 두개의 벡터 객체 준비
x <- c(1,2,3,4,2,4)
y <- rep(2,6)
x; y

# 2단계 : 교차테이블 작성
table(x,y)

# 3단계 : 산점도 시각화
plot(x,y)

# 4단계 : 교차테이블로 데이터프레임 생성
xy.df <- as.data.frame(table(x,y))
xy.df

# 5단계 : 좌표에 중복된 수 만큼 점을 확대
plot(x, y, pch = '@', col = 'blue', cex = 0.5 * xy.df$Freq,
     xlab = 'x 벡터의 원소', ylab = 'y 벡터 원소')


# galton 데이터 셋을 대상으로 중복된 자료 시각화하기
# 1단계 : galton 데이터 셋 가져오기
install.packages('UsingR')
library(UsingR)
data(galton)

# 2단계 : 교차테이블을 작성하고, 데이터프레임으로 변환
# -> 데이터프레임 생성하여 중복 수 컬럼 생성하기 위함
galtonData <- as.data.frame(table(galton$child, galton$parent))
head(galtonData)

# 3단계 : 컬럼 단위 추출
names(galtonData) = c('child', 'parent', 'freq')
head(galtonData)
parent <- as.numeric(galtonData$parent)
child <- as.numeric(galtonData$child)

# 4단계 : 점의 크기 확대
par(mfrow = c(1,1))
plot(parent, child,
     pch = 21, col = 'blue', bg = 'green',  # bg 속성 : 원 내부 색 채우기
     cex = 0.2 * galtonData$freq,
     xlab = 'parent', ylab = 'child')


# 3.5 변수간의 비굑 시각화
# 변수와 변수 사이의 관계를 시각화

# iris 데이터셋의 4개 변수를 상호 비교
attributes(iris)
pairs(iris[iris$Species == 'virginica', 1:4])
pairs(iris[iris$Species == 'setosa', 1:4])
# pairs() 함수 : matrix 또는 데이터프레임의 numeric컬럼을 대상으로
#                변수들 사이의 비교결과를 행렬구조이 분산된 그래프로 제공

# 3차원으로 산점도 시각화
# 1단계 : 3차원 산점도를 위한 scatterplot 3d 패키지 설치 및 로딩
install.packages('scatterplot3d')
library(scatterplot3d)
# 형식 :
# scatterplot3d(밑변, 오른쪽변의 컬럼명, 왼쪽 변의 컬럼명, type)

# 2단계 : 꼴의 종류별 분류
iris_setosa = iris[iris$Species == 'setosa',]
iris_versicolor = iris[iris$Species == 'versicolor',]
iris_virginica  = iris[iris$Species == 'virginica',]

# 3단계 : 3차원 틀(Frame)생성하기
d3 <- scatterplot3d(iris$Petal.Length,
                    iris$Sepal.Length,
                    iris$Sepal.Width,
                    type = 'n')

# 4단계 : 3차원 산점도 시각화
d3$points3d(iris_setosa$Petal.Length,
            iris_setosa$Sepal.Length,
            iris_setosa$Sepal.Width,
            bg = 'orange', pch = 21)

d3$points3d(iris_versicolor$Petal.Length,
            iris_versicolor$Sepal.Length,
            iris_versicolor$Sepal.Width,
            bg = 'blue', pch = 23)

d3$points3d(iris_virginica$Petal.Length,
            iris_virginica$Sepal.Length,
            iris_virginica$Sepal.Width,
            bg = 'green', pch = 25)
