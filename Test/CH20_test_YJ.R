# 유준

# 문항 : sparklyr 패키지와 다음 정보를 이용하고, 조건에 맞게 R로 coding하시오.
# - 데이터 : 온라인 데이팅 site에서 수집한 성별, 나이, 개인적 관심사 등을 포함하는 OkCupid 데이터셋

# 수행과제1 : 데이터 다운로드 및 unzip
# https://github.com/r-spark/okcupid/raw/master/profiles.csv.zip
# 에서 profiles.csv.zip을 다운로드 받고 okcupid.zip으로 이름을 변경하여 unzip하시오.

download.file(
  "https://github.com/r-spark/okcupid/raw/master/profiles.csv.zip",
  "okcupid.zip")

unzip("okcupid.zip", exdir = "data")
unlink("okcupid.zip")

# 수행과제2 : profile.csv파일에서 1,000개의 profile을 sampling하시오.
profiles <- read.csv("data/profiles.csv")
write.csv(dplyr::sample_n(profiles, 10^3),
          "data/profiles.csv", row.names = FALSE)

# 수행과제3 : Spark 3.0에 연결하시오.
library(sparklyr)
library(ggplot2)
library(dbplot)
library(dplyr)

sc <- spark_connect(master = "local", version = "3.0")

# 수행과제4 : data/profiles.csv 파일을 스파크로 read하여 okc라는 변수에 저장하시오.
okc <- spark_read_csv(
  sc, 
  "data/profiles.csv", 
  escape = "\"", 
  memory = FALSE,
  options = list(multiline = TRUE)
)

# 수행과제5 :  ‘height’는 numeric으로 변환하고, ‘income’의 값이 ‘-1’로
# 설정되어 있으면 ‘NA’로 그렇지 않으면 numeric으로 변환하시오.
okc <- okc %>%  mutate(height = as.numeric(height),
  income = ifelse(income == "-1", NA, as.numeric(income)))
  
# 수행과제6 : 성별(sex), 음주(drinks), 약(drugs), 직업(job) 항목에 NA로 표기
# 되어 있으면 ‘missing’으로 표기하고 그렇지 않으면 해당 값을 사용하시오.
okc <- okc %>%
  mutate(sex = ifelse(is.na(sex), "missing", sex)) %>%
  mutate(drinks = ifelse(is.na(drinks), "missing", drinks)) %>%
  mutate(drugs = ifelse(is.na(drugs), "missing", drugs)) %>%
  mutate(job = ifelse(is.na(job), "missing", job))

# 수행과제7 : 직업(job)란에 학생(student), 무직(unemployed), 은퇴(retired)가
# 있으면 1, 아니면 0을 ‘not working’ 변수에 저장하고 데이터 셋의 열로 추가하시오
okc <- okc %>%
  mutate(
    not_working = ifelse(job %in% c("student", "unemployed", "retired"), 1 , 0)
  )

# 수행과제8 :  데이터를 7:3비율로 training set과 testing set으로 random 분할하시오. (seed는 100으로 설정하시오
data_splits <- sdf_random_split(okc, training = 0.7, testing = 0.3, seed = 100)
okc_train <- data_splits$training
okc_test <- data_splits$testing

# 수행과제9 : 나이(age)변수의 정규화를 실행하고 결과를 화면 출력하시오
scale_values <- okc_train %>%
  summarize(
    mean_age = mean(age),
    sd_age = sd(age)
  ) %>%
  collect()

scale_values

okc_train <- okc_train %>%
  mutate(scaled_age = (age - !!scale_values$mean_age) /
           !!scale_values$sd_age)

okc_train %>%
  group_by(scaled_age) %>%
  tally() 

# 수행과제10 :  training 데이터를 대상으로 정규화된 age값을 히스토그램으로 그리고 제출하시오.
dbplot_histogram(okc_train, scaled_age)

spark_disconnect(sc)


