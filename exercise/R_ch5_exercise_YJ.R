# 유준


# 1. iris데이터 셋을 대상으로 다음 조건에 맞게 시각화 하시오
# 1) 1번 컬럼을 x축으로 하고 3번 컬럼을 y축으로 한다.
# 2) 5번 컬럼으로 색상지정한다.
# 3) 차트 제목을 “iris 데이터 산포도”로 추가한다.
# 4) 다음 조건에 맞추어 작성한 차트를 파일에 저장한다.
# - 작업 디렉토리: “C:/Rwork/output”
# - 파일명: “iris.jpg”
# - 크기: 폭(720픽셀), 높이(480픽셀)


setwd('C:/Rwork/output')


# 데이터가져오기
data(iris)

# 산포도 그리기
plot(iris[,1],iris[,3], col = iris[,5],
     main = 'iris 데이터 산포도')




# 2, iris3 데이터 셋을 대상으로 다음 조건에 맞게 산점도를 그리시오
# 1) iris3 데이터 셋의 컬럼명을 확인한다.
# 2) iris3 데이터 셋의 구조를 확인한다.
# 3) 꽃의 종별로 산점도 그래프를 그린다

# 데이터 가져오기
data(iris3)

# 데이터 셋의 컬럼명 확인
dimnames(iris3)

# 데이터 셋 구조 확인하기
str(iris3)
head(iris3)

# 종 별로 산점도 그래프 그리기
plot(iris3[,,1], xlim = c(4, 8.0), ylim = c(0, 8.0), col = 'red', pch = 2,
     main = 'iris3 데이터 산점도 그래프')

par(new = T)
plot(iris3[,,2], axes = F, ann = F, col = 'blue', pch = 6, xlim = c(4, 8.0), ylim = c(0, 8.0))

par(new = T)
plot(iris3[,,3], axes = F, ann = F, col = 'green', xlim = c(4, 8.0), ylim = c(0, 8.0))

legend('topleft', c('Setosa','Versicolor','Virginica'), title = 'Species',
       pch = c(2, 6, 1),col = c('red','blue','green'))
       
