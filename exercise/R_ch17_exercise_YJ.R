# YJ

# 1.시계열 자료를 대상으로 다음과 같은 단계별로 시계열 모형을 생성하고 예측하시오
data(EuStockMarkets)
EuStock <- data.frame(EuStockMarkets) 
head(EuStock)
Second <- 1:500
DAX <- EuStock$DAX[1001:1500]
EuStock_df <- data.frame(Second, DAX)



# 1단계 : 시계열 자료 생성
EuStock_ts <- ts(EuStock_df$DAX, start = c(2017, 12), frequency = 12)
EuStock_ts

# 2단계 : 단위 시계열 자료분석
# 2-1단계 : 시계열 분해요소 시각화
EuStock_stl <- stl(EuStock_ts, s.window = 'periodic')
plot(EuStock_stl)

# 2-2단계 : decompose()함수 이용 분해 시각화와 불규칙 요인 시각화
EuStock_dec <- decompose(EuStock_ts)
plot(EuStock_dec)

# 2-3단계 : 계절요인, 추세요인, 제거 그래프 - 불규칙 요인만 출력
par(mfrow = c(3,1))
plot(EuStock_ts - EuStock_dec$seasonal, main = '계절 요인 제거 그래프', col = 'blue')
plot(EuStock_ts - EuStock_dec$trend, main = '추세 요인 제거 그래프', col = 'blueviolet')
plot(EuStock_ts - EuStock_dec$seasonal - EuStock_dec$trend, main = '불규칙 요인 그래프', col = 'violet')

# 3단계 : ARIMA 시계열 모형 생성
library(forecast)
EuStock_arima <- auto.arima(EuStock_ts)
EuStock_arima

# 3-1단계 : 모형 검증
EuStock_model <- arima(EuStock_ts, c(2,1,2), seasonal = list(order = c(1,0,2)))
tsdiag(EuStock_model)
Box.test(EuStock_model$residuals, lag = 1, type = 'Ljung')

# 4단계 : 시계열 예측 : 향휴 3년, 95% 신뢰 수준으로 예측 및 시각화
EuStock_for <- forecast(EuStock_model, h = 36)
par(mfrow = c(1,1))
plot(EuStock_for)




# 2. Sales.csv 자료를 대상으로 시계열 자료를 생성하고, 단계별로 시계열 모형을 생성하여 예측하시오.
getwd()
setwd('C:/Users/You/Desktop/빅데이터/빅데이터 수업자료/R/dataset4')

sales <- read.csv('Sales.csv', header = T)
sales

str(sales)

# 1-1단계 : 시계열 자료 생성 - sales$Goods 컬럼으로 2015년 1월 기준 12개월 단위
sales_ts <- ts(sales$Goods, start = c(2015, 1), frequency = 12)

# 1-2단계 : 추세선 시각화
plot(sales_ts)

# 2단계: 시계열 모형 추정과 모형 생성
# library(forecast)
sales_arima <- auto.arima(sales_ts)
sales_arima

sales_model <- arima(sales_ts, c(0,1,0), seasonal = list(order = c(1,1,0)))

# 3단계 : 모형 진단
tsdiag(sales_model)
Box.test(sales_model$residuals, lag = 1, type = 'Ljung')           

# 4단계 : 향후 7개월 예측
sales_fore <- forecast(sales_model, h = 7)

# 5단계 : 향후 7개월 예측결과 시각화
plot(sales_fore)

