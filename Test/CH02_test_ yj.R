# 유준

#1-1
D <- matrix(c("과목","윤봉길(Yoon)","안중근(Ahn)","이봉창(Lee)",
              "국어(Kor)", 95, 85, 70,
              "영어(Eng)", 80, 95, 80,
              "수학(Mat)", 75, 60, 95), nrow = 4, byrow = T); D

test <- data.frame(D); test

colnames(test) <- c("","","의사",""); test

#1-2
apply(test[4,2:4], 1, max)

#1-3
ff<- test[2:4,3]; ff
mean(as.numeric(ff))

#1-4
apply(test[2,2:4], 1, var)

#1-5
sqrt(apply(test[3,2:4], 1, var))


#2
library(RSADBE)
data(Bug_Metrics_Software)
str(Bug_Metrics_Software)
x <- Bug_Metrics_Software; x

x[,,2]

#2-1
apply(x[,,2], 1, sum)
#2-2
apply(x[,,2], 2, mean)
#2-3
apply(x[,,2], 2, summary)



