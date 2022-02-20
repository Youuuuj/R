# 요인분석 : 다수의 변수를 대상으로 변수 간의 관계를 분석하여 공통 차원으로 축약하는 통계기법
#            변수들의 상관성을 바탕으로 변수를 정제하여 상관관계 분석이나 회귀분석에서 설명변수로 사용.


# 1) 탐색적 요인분석 : 요인 분석을 할 때 사전에 어떤 변수들끼리 묶어야 한다는 전제를 두지 않고 분석하는 방법.
# 2) 확인적 요인분석 : 사전에 묶일 것으로 기대되는 항목끼리 묶였는지를 조사하는 방법.

# 타당성 : 측정도구가 측정하고자 하는 것을 정확히 측정할 수 있는 정도
# 논문 작성을 위한 통계분석 방법에서 인구통계학적 분석(빈도분석, 교차분석 등)을 시행한 이후 
# 통계량 검정 이전에 구성 타당성 검증을 위해서 요인분석 시행

# 요인분석을 위한 전제조건
# - 하위요인으로 구성되는 데이터 셋이 준비되어 있어야 한다
# - 분석에 사용되는 변수는 등간척도나 비율척도여야 하며 표본의 크기는 최소 50 개 이상이 바람직하다
# - 요인 분석은 상관관계가 높은 변수들끼리 그룹화하는 것이므로 변수 간의 상관관계가 매우 낮다면() 보통 ±3 이하 ), 그 자료는 요인 분석에 적합하지 않다.

# 요인분석을 수행하는 목적
# - 자료의 요약 변인을 몇 개의 공통된 변인으로 묶음
# - 변인 구조 파악 변인들의 상호관계 파악 독립성 등
# - 불필요한 변인 제거: 중요도가 떨어진 변수 제거
# - 측정 도구의 타당성 검증 변인들이 동일한 요인으로 묶이는 지를 확인

# 요인 분석 결과에 대한 활용방안
# 1.타당성 검정 측정도구가 정확히 측정했는지를 알아보기 위하여 측정변수들이 동일한 요인으로 묶이는지를 검정
# 2.변수 축소 : 변수들의 상관관계가 높은 것끼리 묶어서 변수를 정제
# 3.변수 제거 : 변수의 중요도를 나타내는 요인적재량이 0.4 미만이면 설명력이 부족한 요인으로 판단하여 제거
# 4.활용 : 요인 분석에서 얻어지는 결과를 이용하여 상관분석이나 회귀분석의 설명변수로 활용


# 1.1 공통요인으로 변수 정제
# 특정항목으로 묶이는데 사용되는 요인 수 결정은 주성분 분석 방법과 상관계수 행렬을 이용한 초기 고유값 이용.

# 변수와 데이터 프레임 생성
# 1단계 : 과목 변수 생성
s1 <- c(1, 2, 1, 2, 3, 4, 2, 3, 4, 5)
s2 <- c(1, 3, 1, 2, 3, 4, 2, 4, 3, 4)
s3 <- c(2, 3, 2, 3, 2, 3, 5, 3, 4, 2)
s4 <- c(2, 4, 2, 3, 2, 3, 5, 3, 4, 1)
s5 <- c(4, 5, 4, 5, 2, 1, 5, 2, 4, 3)
s6 <- c(4, 3, 4, 4, 2, 1, 5, 2, 4, 2)
name <- 1:10

# 2단계: 과목 데이터프레임 생성
subject <- data.frame(s1, s2, s3, s4, s5, s6)
str(subject)

# 변수의 주성분 분석
# 주성분 분석 : 변동량(분산)에 영향을 주는 주요 성분을 분석하는 방법
# 1단계 : 주성분 분석으로 요인 수 알아보기
pc <- prcomp(subject)
summary(pc)
plot(pc)
# 주성분 분석에서 결정된 주성분의 수를 반드시 요인 분석에서 요인의 수로 사용되지는 않는다.
# 고유값 : 어떤 행렬로부터 유되는 실수값
# 일반적으로 변화량의 합(총분산)을 기준으로 요인의 수를 결정하는데 이용된다.

# 2단계 : 고유값으로 요인수 분석
en <- eigen(cor(subject))
names(en)

en$values
en$vectors

plot(en$values, type = 'o')
# 고유값이 급격하게 감소하다가 완만하게 감소할 때 급격하게 감소하는 고유값 index수로 주성분 변수 개수 결정


# 변수 간의 상관관계 분석과 요인분석
# 1단계 : 상관관계 분석 - 변수 간의 상관서응로 공통요인 추출
cor(subject)


# 요인분석에서 요인회전법은 요인 해석이 어려운 경우 요인축을 회전시켜서 요인 해석을 용이하게 하는 방법을 의미.
# 대표적인 요인회전법으로는 배리맥스 회전법이 있다.
# 요인분석에 이용되는 R함수 : factanal()함수
# 형식: factanal(dataset, factors=요인수, scores=c(“none”, “regression”, “Bartlett”), rotation=”요인회전법”, …)

# 2단계 : 요인분석 - 요인회전법 적용(Varimax회전법)
# 2-1단계 : 주성분 분석의 가정에 의해서 2개 요인으로 ㅂ누석
result <- factanal(subject, factors = 2, rotation = 'varimax')
result
# 요인 분석 결과에서 만약 p-value값이 0.05미만이면 요인수가 부족하다는 의미로 요인수를 늘려서 다시 분석을 수행해야함.
# p-value값 0.0232, 따라서 요인수 변경 후 재분석 필요.

# 2-2단계 : 고유값으로 가정한 3개 요인으로 분석
result <- factanal(subject, factors = 3, rotation = 'varimax', scores = 'regression')
result
# 해석 :
# Uniquenesses항목: 유효성을 판단하여 제시한 값으로 통상 0.5이하이면 유효한 것으로 본다.
# Loadings 항목 : 요인 적재값(Loading)을 보여주는 항목으로 각 변수와 해당 요인간의 상관관계 계수를 나타낸다.
# 요인적재값(요인부하량)이 통상 +0.4이상이면 유의하다고 볼 수 있다.
# 만약 +0.4미만이면 설명력이 부족한 요인(중요도가 낮은 변수)으로 판단할 수 있다.
# 요인적재값(Loading)이 높게 나타났다는 의미는 해당 변수들이 해당 요인으로 잘 설명된다는 의미
# SS loadings 항목: 각 요인 적재값의 제곱의 합을 제시한 값. 각 요인의 설명력을 보여준다.
# Proportion Var 항목: 설명된 요인의 분산 비율로 각 요인이 차지하는 설명력의 비율
# Cumulative Var 항목: 누적 분산 비율. 요인의 분산 비율을 누적하여 제시한 값.
# 현재 정보손실은 1-0.94 = 0.06으로 적정한 상태. 만약 정보손실이 너무 크면 요인 분석의 의미가없어진다.

# 3단계 : 다양한 방법으로 요인적재량 보기
attributes(result)
result$loadings
print(result, digits = 2, cutoff = 0.5)
print(result$loadings, cutoff = 0)



# 요인점수를 이용한 요인적재령 시각화
# 요인점수(요인 분석에서 요인의 추정된 값)를 얻기 위해서는 scores속성(scores = 'regression' : 회귀분석으로 요인점수 계산)설정
# 1단계 : Factor1과 Factor2 요인적재량 시각화
plot(result$scores[, c(1:2)], main = "Factor1과 Factor2 요인점수 행렬")
text(result$scores[ , 1], result$scores[ , 2], labels = name, cex = 0.7, pos = 3, col = "blue")
# 요인점수행렬의 산점도

# 2단계 : 요인적재량 추가
points(result$loadings[ , c(1:2)], pch = 19, col = "red")
text(result$loadings[ , 1], result$loadings[ , 2], labels = rownames(result$loadings), cex = 0.8, pos = 3, col = "red")

# 3단계: Factor1과 Factor3 요인 적재량 시각화
plot(result$scores[ , c(1, 3)], main = "Factor1과 Factor3 요인점수 행렬")
text(result$scores[ , 1], result$scores[ , 3], labels = name, cex = 0.7, pos = 3, col = "blue")

# 4단계: 요인적재량 추가
points(result$loadings[ , c(1, 3)], pch = 19, col = "red")
text(result$loadings[ , 1], result$loadings[ , 3], labels = rownames(result$loadings), cex = 0.8, pos= 3, col = "red")



# 3차원 산점도로 요인적재량 시각화
# 1단계: 3차원 산점도 패키지 로딩
library(scatterplot3d)

# 2단계: 요인점수별 분류 및 3차원 프레임 생성
Factor1 <- result$scores[ , 1]
Factor2 <- result$scores[ , 2]
Factor3 <- result$scores[ , 3]
d3 <- scatterplot3d(Factor1, Factor2, Factor3, type = 'p')
# Scatterplot3d()함수: 3차원 산점도
# 형식: scatterplot3d(x축, y축, z축, type=”p”)

# 3단계: 요인적재량 표시
loadings1 <- result$loadings[ , 1]
loadings2 <- result$loadings[ , 2]
loadings3 <- result$loadings[ , 3]
d3$points3d(loadings1, loadings2, loadings3, bg = 'red', pch = 21, cex = 2, type = 'h')
# d3$points3d(): scatterplot3d()함수 내에서 점 찍기


# 요인별 변수 묶기
# 1단계: 요인별 과목 변수 이용 데이터프레임 생성
app <- data.frame(subject$s5, subject$s6)
soc <- data.frame(subject$s3, subject$s4)
nat <- data.frame(subject$s1, subject$s2)

# 2단계: 요인별 산술평균 계산
app_science <- round((app$subject.s5 + app$subject.s6) / ncol(app), 2)
soc_science <- round((soc$subject.s3 + soc$subject.s4) / ncol(soc), 2)
nat_science <- round((nat$subject.s1 + nat$subject.s2) / ncol(nat), 2)
# 산술평균을 계산하여 요인별로 3개의 파생변수 생성

# 3단계: 상관관계분석
subject_factor_df <- data.frame(app_science, soc_science, nat_science)
cor(subject_factor_df)
# 요인분석을 통해서 만들어진 파생변수는 상관분석이나 회귀분석에서 독립변수로 사용할 수 있다.



# 1.2 잘못 분류된 요인 제거로 변수 정제
# 특정 변수가 묶여질 것으로 예상되는 요인으로 묶이지 않는 경우 해당 변수를 제거하여 변수를 정제하는 방법

# 요인분석에 사용될 데이터 셋 가져오기
# 1단계 : spss데이터 셋 가져오기
# install.packages('memisc')
library(memisc)
setwd('C:/Users/You/Desktop/빅데이터/빅데이터 수업자료/R/dataset2')
data.spss <- as.data.set(spss.system.file('drinking_water.sav'))
data.spss[1:11]

# memisc 패키지 : spss데이터를 가져오기 위한 패키지
# as.data.set(spss.system.file()) : spss데이터를 가져오기

# 2단계 : 데이터프레임으로 변경
drinking_water <- data.spss[1:11]
drinking_water_df <- as.data.frame(data.spss[1:11])
str(drinking_water_df)

# 요인 수를 3개로 지정하여 요인 분석 수행
result2 <- factanal(drinking_water_df,factors = 3, rotation = 'varimax')
result2

# Uniquenesses항목에서 모든 변수가 0.5이하의 값을 갖기 때문에 모두 유효
# 데이터 셋에서 의도한 요인과 요인으로 묶여진 결과가 서로 다르게 나옴
# q4 변수의 타당성 의심
# p-value < 0.05 이므로 요인변수 선택에 문제가 있음
# 여기서 p-value는 chi_square검정으로 기대치와 관찰치에 차이가 있음을 알려주는 확률값 
# 요인 수를 3개로 전제하기 때문에 p-value값은 무시하고 실습 진행

# 요인별 변수 묶기
# 1단계 : q4를 제외하고 데이터프레임 생성
dw_df <- drinking_water_df[-4]
str(dw_df)
dim(dw_df)

# 2단계 : 요인에 속하는 입력 변수별 데이터프레임 구성
s <- data.frame(dw_df$Q8, dw_df$Q9, dw_df$Q10, dw_df$Q11)
c <- data.frame(dw_df$Q1, dw_df$Q2, dw_df$Q3)
p <- data.frame(dw_df$Q5, dw_df$Q6, dw_df$Q7)

# 3단계: 요인별 산술평균 계산
satisfaction <- round((s$dw_df.Q8 + s$dw_df.Q9 + s$dw_df.Q10 + s$dw_df.Q11) / ncol(s), 2)
closeness <- round((c$dw_df.Q1 + c$dw_df.Q2 + c$dw_df.Q3) / ncol(s), 2)
pertinence <- round((p$dw_df.Q5 + p$dw_df.Q6 + p$dw_df.Q7) / ncol(s), 2)

# 요인 제품만족도(satisifaction)를 구성하는 4개의 변수의 산술평균 계산
# 요인 제품친밀도(closeness)와 요인 제품만족도(pertinence)는 3개 변수에 대한 산술평균을 계산하여 파생변수를 생성

# 4단계: 상관관계 분석
drinking_water_factor_df <- data.frame(satisfaction, closeness, pertinence)
colnames(drinking_water_factor_df ) <- c("제품만족도", "제품친밀도", "제품적절성")
cor(drinking_water_factor_df)
length(satisfaction); length(closeness); length(pertinence)



# 예제1 패키지 psych를 이용하여 FA수행
# 분석에 사용될 자료는 300명의 대학생에 대해 6개 항목(과목에 대해 좋아하는 정도)에 대한 설문을 실시한 결과(가상의 자료)이다. 
# 각 항목은 1(아주 싫어함)부터 5(아주 좋아함)의 값을 가진다. 
# 6개의 항목은 서로 다른 영역의 과목에 대한 선호도를 학생들에게 묻는 것으로 구성되었다.
# 6개 과목은 biology(BIO), geology(GEO), chemistry(CHEM), algebra(ALG), calculus(CALC), statistics(STAT)이다.

BIO <- sample(1:5, 300, replace = T)
GEO <- sample(1:5, 300, replace = T)
CHEM <- sample(1:5, 300, replace = T)
ALG <- sample(1:5, 300, replace = T)
CALC <- sample(1:5, 300, replace = T)
STAT <- sample(1:5, 300, replace = T)
subjects <- data.frame(BIO,GEO,CHEM,ALG,CALC,STAT)

head(subjects, 3)
tail(subjects, 3)

# install.packages('psych')
library(psych)
# options(digit = 3)
corMat <- cor(subjects)
corMat

#  fa() 함수를 이용하여 FA를 수행한다. fa() 함수의 주요 옵션은 다음과 같다.
# • r: 상관행렬
# • nfactors: 요인의 수(디폴트는 1)
# • rotate: 회전의 방법으로, 직교회전에는 “none", "varimax", “quartimax"등이 있고, 사교회전에는 "promax", "oblimin"등이 있다.
# • fm: 요인화 방법(factoring method)
# (예: "pa"(principal axis), "ml"(maximum likelihood), “minres"(minimum residual,OLS), "wls"(weighted least square, WLS), "gls"(generalized least square,GLS),...) 

# fa() 함수는 여러 가지 회전과 요인화 방법을 제공한다. 
# 회전은 직교(orthogonal)과 사교(oblique) 회전으로 구분되며, 
# 두 방법의 차이는 요인들 간의 상관을 허용하느냐의 차이다. 

# 요인화(factoring)의 방법은 common과 component로 구분되는데, 
# common은 데이터를 잘 묘사하는 것이 주목적이며, 
# component는 데이터의 양을 줄이는데 그 목적이 있다.
# fa()함수는 common 요인화에 사용된다.

# 이 예제에서는 학생들의 잠재 과목(요인)간에 다소의 상관이 있을 것으로 생각하여 사교회전(rotation="oblimin")을 사용한다.  
# 또한, 데이터의 잠재된 요인(구인)을 식별하는데 가장 관심이 있으므로 주축요인화 방법(fm="pa")을 사용하였다(factor.pa{pcych}를 이용할 수 도 있음).


# R 패키지 {GPArotation}은 "varimax", "promax" 이외의 다양한 회전("oblimin" 옵션 등) 을 수행하게 해 준다. 
# install.packages('GPArotation')
library(GPArotation)  # 사교회전('oblimin'옵션)의 수행에 필요함
EFA <- fa(r = corMat, nfactors = 2, rotate = 'oblimin', fm = 'pa')
EFA


# 데이터 차이로 인한 결과 복붙
# Factor Analysis using method = pa
# Call: fa(r = corMat, nfactors = 2, rotate = "oblimin", fm = "pa")
# Standardized loadings (pattern matrix) based upon correlation matrix
#       PA1  PA2  h2    u2  com
# BIO  0.86 0.02 0.75 0.255 1.0
# GEO  0.78 0.05 0.63 0.369 1.0
# CHEM 0.87 -0.05 0.75 0.253 1.0
# ALG -0.04 0.81 0.65 0.354 1.0
# CALC 0.01 0.96 0.92 0.081 1.0
# STAT 0.13 0.50 0.29 0.709 1.1
-------------------------------
# 해석 
# 요인부하(factor loadings)를 살펴보면, BIO, GEO, CHEM은 모두 제1요인(PA1)에 0.8 근방의 매우 높은 요인부하를 가진다. 
# 따라서 이 요인을 과학(Science)으로 명명하고, 학생들의 과학에 대한 관심도를 나타내는 것으로 해석할 수 있다. 
# 유사한 방법으로, ALG, CALC, STAT은 제2요인(PA2)에 높은 부하를 가지므로 제2요인을 수학(Math)으로 명명한다.
# 한가지 주목할 점은 STAT의 경우 ALG나 CALC에 비해 제2요인에 상대적으로 낮은 부하를 가지면서 PA1에도 약간의 부하를 가진다. 
# 이것은 통계학(statistics)이 대수(algebra)와 미적분 (caculus) 보다는 수학(MATH)의 개념과 덜 연관되어있음을 의미한다. 
  
  
#                        PA1 PA2
# SS loadings           2.14 1.84
# Proportion Var        0.36 0.31
# Cumulative Var        0.36 0.66
# Proportion Explained  0.54 0.46
# Cumulative Proportion 0.54 1.00


# With factor correlations of
#      PA1  PA2
# PA1 1.00 0.21
# PA2 0.21 1.00
----------------------------
# 해석
# 각 요인은 분산의 약 30% 정도를 설명하고 있으며, 두 개의 요인은 전체 분산의 66% 를 설명한다. 
# 두 요인은 어느 정도 상관되어 있으며(상관계수: 0.21), 이는 우리가 사교회전을 선택한 것과 맥락이 같다.
----------------------------------------------------
  
ls(EFA)
EFA$loadings  
load <- EFA$loadings[,1:2]
plot(load, type='n')
text(load, labels=names(subjects), cex=.7)


# 이제 요인의 수를 정하는 문제를 생각해보자. 이 예제에서는 요인의 수를 미리 2로 정하여 FA를 수행하였으나, 이 값의 결정을 위해서는 R 패키지 {nFactors}를 이용한다. 
# install.packages('nFactors')
library(nFactors)
ev <- eigen(cor(subjects)) # get eigenvalues
ap <- parallel(subject=nrow(subjects),var=ncol(subjects), rep=100,cent=.05)
nS <- nScree(x=ev$values, aparallel=ap$eigen$qevpea)
plotnScree(nS)

# install.packages('FactoMineR')
library(FactoMineR)
result <- PCA(subjects) 
