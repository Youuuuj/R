# 유준

setwd('C:/Users/You/Desktop/빅데이터/빅데이터 수업자료/R/dataset4')

# 1. tranExam.csv.파일을 대상으로 중복된 트랜잭션 없이 1-2컬럼만 single형식으로 트랜잭션 객체를 생성하시오.
# 1단계: 트랜잭션 객체 생성 및 확인
Exam <- read.transactions('tranExam.csv', format = "single", sep = ",", cols = c(1, 2), rm.duplicates = T)
inspect(Exam)
# 2단계: 각 items별로 빈도수 확인
summary(Exam)
# 3단계: 파라미터(supp = 0.3, conf = 0.1)를 이용하여 규칙(rule)생성
rules <- apriori(Exam, parameter = list(supp = 0.3, conf = 0.1))
# 4단계: 연관규칙 결과 보기
inspect(rules)


# 2. Adult데이터 셋을 대상으로 다음 조건에 맞게 연관분석을 수행하시오.
# 1) 최소 support = 0.5, 최소 confidence = 0.9를 지정하여 연관규칙을 생성한다.
data(Adult)
Adult
summary(Adult)

rules1 <- apriori(Adult, parameter = list(supp = 0.5, conf = 0.9))
# 2) 수행한 결과를 lift기준으로 정렬하여 상위 10개 규칙을 기록한다.
inspect(head(sort(rules1, by = 'lift'),10))
# 3) 연관분석 결과를 LHS와 RHS의 빈도수로 시각화한다.
plot(rules1, method = "grouped")
# 4) 연관분석 결과를 연관어의 네트워크 형태로 시각화한다.
plot(rules1, method = "graph")
# 5) 연관어 중심 단어를 해설한다.
# sex=Male, native-country=United-States, race=White, 
# capital-gain=None, capital-loss=None, workclass=Private 
# hours-per-week=Full-time 이 있다.