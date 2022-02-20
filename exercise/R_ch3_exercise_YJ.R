#유준

#1-1
data(CO2)
str(CO2)
CO2

n.c <- subset(CO2, Treatment == "nonchilled"); n.c

getwd()
write.csv(n.c, "CO2_df1.csv", row.names = F)

#1-2

c <- subset(CO2, Treatment == "chilled"); c

write.csv(c, "CO2_df2.csv", row.names = F)


#2-1
getwd()

titanicData <- read.csv(file = "titanic.csv", sep = ","); titanicData

str(titanicData)

#2-2
a <- titanicData$class
b <- titanicData$sex
c <- titanicData$survived

d <- data.frame(Class = a, Sex = b, Survived = c); d

head(d)#head(titanicData$class); head(titanicData$sex); head(titanicData$survived)


#head(titanicData[,-c(1,3)]) 이게 정답
