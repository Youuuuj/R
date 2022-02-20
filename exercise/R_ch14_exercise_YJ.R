# 유준

# 1. 다음은 drinking,_water_example.sav 파일의 데이터셋이 구성된 테이블이다. 
# 전체 2 개의 요인에 의해서 7 개의 변수로 구성되어 있다. 
# 아래에서 제시된 각 단계에 맞게 요인 분석을 수행하시오.

rm(list = ls())

# 1) 데이터파일 가져오기
library(memisc)
setwd("C:/Users/You/Desktop/빅데이터/빅데이터 수업자료/R/dataset2")
data.spss <- as.data.set(spss.system.file('drinking_water_example.sav'))
data.spss
drinkig_water_exam <- data.spss[1:7]
drinkig_water_exam_df <- as.data.frame(drinkig_water_exam)
names(drinkig_water_exam_df) <- c('브랜드','친근감','익숙함','목넘김','맛','향','가격')
str(drinkig_water_exam_df)

# 2) 베리맥스 회전법, 요인수 2, 요인점수 회귀분석 방법을 적용하여 요인 분석
result <- factanal(drinkig_water_exam_df,factors = 2, rotation = 'varimax', scores = 'regression')
result
# Uniquenesses항목에서 모든 변수가 0.5이하의 값을 갖기 때문에 모두 유효
# Loadings항목을 살펴봤을때, 데이터셋에서 의도한 요인과 요인으로 묶여진 결과 같음.
# p-value 값 > 0.05이므로 요인변수 선택 문제 없다.


# 3) 요인적재량 행렬의 컬럼명 변경
colnames(result$loadings) <- c('제품 만족도', '제품 친밀도')
result

# 4) 요인점수를 이용한 요인적재량 시각화
plot(result$scores[, c(1:2)], main = "Factor1과 Factor2 요인점수 행렬")
text(result$scores[ , 1], result$scores[ , 2], labels = names(drinkig_water_exam_df), cex = 0.7, pos = 3, col = "blue")


# 5) 요인별 변수 묶기
Affi <- data.frame(drinkig_water_exam_df$브랜드, drinkig_water_exam_df$친근감, drinkig_water_exam_df$익숙함)
Sati <- data.frame(drinkig_water_exam_df$목넘김, drinkig_water_exam_df$맛, drinkig_water_exam_df$향,drinkig_water_exam_df$가격)


# 2. 1 번에서 생성된 두 개의 요인을 데이터프레임으로 생성한 후 이를 이용하여 두 요인 간의 상관관계 계수를 제시하시오.
# 1) 요인별 산술평균 계산
Affi_round <- round((Affi$drinkig_water_exam_df.브랜드 + Affi$drinkig_water_exam_df.친근감 + Affi$drinkig_water_exam_df.익숙함) / ncol(Affi), 2)
Sati_round <- round((Sati$drinkig_water_exam_df.목넘김 + Sati$drinkig_water_exam_df.맛 + Sati$drinkig_water_exam_df.향 + Sati$drinkig_water_exam_df.가격) / ncol(Sati), 2)

# 2) 상관관계 분석
product_factor_df <- data.frame(Affi_round, Sati_round)
cor(product_factor_df)

# 둘이 상관관계 계수는 0.4047543