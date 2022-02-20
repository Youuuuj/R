# 유준

install.packages("MASS")
library("MASS")


# 1

# 1-1 데이터셋 구조 보기
dim(Animals)
str(Animals)
head(Animals)

# 1-2 요약통계량
summary(Animals$body)

# 1-3 평균
mean(Animals$body)

# 1-4 표준편차
sd(Animals$body)

# 1-5 빈도수 확인
table(Animals$body)



# 2 데이터 프레임 구성
exam_data = data.frame(name = c('Anastasia','Dima','Katherine',
                              'James','Emily','Michael','Matthew',
                              'Laura','Kevin','Jonas'),
                       score = c(12.5,9,16.5,12,9,20,14.5,13.5,8,19),
                       attempts = c(1,3,2,3,2,3,1,1,2,1),
                       qualify = c('yes','no','yes','no','no','yes','yes',
                                   'no','no','yes'))

exam_data

# 2-1 국적추가
exam_data[,"country"] <- c("RUS","CHN","USA","USA","USA","USA","USA","USA","USA","USA")
exam_data


# 2-2 두명 추가
ex_data = data.frame(name = c('Kim','Lee'),
                     score = c(15,10),
                     attempts = c(1,3),
                     qualify = c('yes','no'),
                     country = c('KOR','KOR'))

ex_data

exam_data2 <- rbind(exam_data, ex_data)
exam_data2

# 2-3 Qualify 항목 제외 추출
exam_data3 <- subset(exam_data2, select = -qualify)
exam_data3

# exam_data2[,-4]


# 2-4 Dima, Jonas 제외 추출
exam_data2[-c(2,10)]

# 2-5 이름 국척 추출
exam_data2[c(1:12),c(1,5)]
