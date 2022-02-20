# 유준

getwd()
setwd('C:/Users/You/Desktop/빅데이터 수업자료/R/dataset3')


# 1. 본문에서 생성된 dataset2의 직급(postion)컬럼을 대상으로 1급->5급, 5급->1급 형식으로 역코딩하여 position2컬럼에 추가하시오.
position <- dataset2$position
inverpo <- 6 - position  # 역코딩
dataset2$postion2 <- inverpo

head(dataset2)  # 결과 확인  



# 2. 본문에서 생성된 dataset2의 resident 컬럼을 대상으로 NA값을 제거한 후 resident2변수에 저장하시오.
resident <- dataset2$resident
resident2 <- na.omit(resident)


omit.resi = ifelse(!is.na(resident), resident, 0) # 제거 하려고 했는데 값의 크기가 맞지 않아 0으로 대체.
dataset2$resident2 <- omit.resi

head(dataset2) # 결과 확인



# 3. 본문에서 생성된 dataset2의 gender컬럼을 대상으로 1 -> “남자”, 2 -> “여자”로 코딩 변경하여 gender2 컬럼에 추가하고, 파이차트로 결과를 확인하시오.
dataset2$gender2[dataset2$gender == 1] <- '남자'
dataset2$gender2[dataset2$gender == 2] <- '여자'
head(dataset2$gender2)  # 추가된 것 확인

table(dataset2$gender2)  # 빈도수 체크
pie(table(dataset2$gender2))  # 파이차트 시각화


# 4. 본문에서 생성된 dataset2의 age컬럼을 대상으로 30세이하 -> 1, 30-55세 -> 2, 55이상 -> 3으로리코딩하여 age3컬럼에 추가한 뒤에 age, age2, age3 컬럼만 확인하시오.
dataset2$age3[dataset2$age <= 30] <- 1  # 30세이하 -> 1
dataset2$age3[dataset2$age > 30 & dataset2$age < 55] <- 2  # 30-55세 -> 2
dataset2$age3[dataset2$age >= 55] <- 3  # 55이상 -> 3

head(dataset2[c('age','age3')])  # 결과학인



# 5. 정제된 data를 대상으로 작업 디렉터리(“C/Rwork/”)에 파일 이름을 “cleandata.csv”로 하여 따옴표와 행 이름을 제거하여 저장하고
#    저장된 파일의 내용을 읽어 new_data변수에 저장하고 확인하시오.
print(dataset2)
write.csv(dataset2, "cleandata.csv", quote = F, row.names = F)
new_data <- read.csv("cleandata.csv", header = T)
new_data

#6. dataset3 내 “user_data.csv”, “return_data.csv”파일을 이용하여 
#   고객별 반폼사유코드(return_code)를 대상으로 다음과 같이 파생변수를 추가하시오.

# 제품이상(1) -> return_code1
# 변심(2) -> return_code2
# 원인불명(3) -> return_code3
# 기타(4) -> return_code4

user_data <- read.csv("user_data.csv", header = T)
return_data <-read.csv("return_data.csv", header = T)
head(user_data)
head(return_data)

return_data$return_code[return_data$return_code == 1] <- 'return_code1'
return_data$return_code[return_data$return_code == 2] <- 'return_code2'
return_data$return_code[return_data$return_code == 3] <- 'return_code3'
return_data$return_code[return_data$return_code == 4] <- 'return_code4'

head(return_data)


library('reshape2')
User_return <- dcast(return_data, user_id ~ return_code, length)
User_return
names(User_return) <- c('user_id','제품이상(1)','변심(2)','원인불명(3)','기타(4)')
library(plyr)
User_return_data <- join(user_data, User_return, by = 'user_id')
User_return_data

#7. iris데이터를 이용하여 5겹 2회 반복하는 교차 검정 데이터를 샘플링하시오.

data('iris')
dim(iris)

library(cvTools)  # 교차 검정을 위한 패키지 불러오기
iris_sp <- cvFolds(n = nrow(iris), K = 5, R = 2)
iris_sp
