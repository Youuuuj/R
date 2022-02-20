#유준

#1 
#1-1
vec1 <- "R"
rep(vec1, 10)

#1-2
vec2 <- seq(1,10,3)
vec2

#1-3
vec3 <- rep(vec2,3)
vec3

#1-4 
vec4 <- c(vec2,vec3)
vec4

#1-5
q <- rev(seq(15, 25, 5))

#seq(15, 25, -5)
q

#1-6

vec5 <- vec4[seq(1,16,2)]
vec5


#2
name <- c("최민수", "유관순", "이순신", "김유신", "홍길동")
gender <- c(1, 2, 1, 1, 1)
job <- c("연예인", "주부", "군인", "직장인", "학생")
sat <- c(3, 4, 2, 5, 5)
grade <- c("C", "C", "A", "D", "A")
total <- c(44.4, 28.5, 43.5, NA, 27.1)

#2-1
user <- data.frame(Name = name, Gender = gender, Job = job, Sat = sat,
                     Grade = grade, Total = total)
str(user)
user

#2-2
hist(gender)

#2-3
user2 <- user[c(2,4),] #user2 <- user[seq(2, 5, 2),]

user2


#3
Kor <- c(90, 85, 90)
Eng<- c(70, 85, 75)
Mat <- c(86, 92, 88)

#3-1
ap <- data.frame(Kor, Eng, Mat)
ap

#3-2
result1 <- apply(ap, 1, max) #행
result1
result2 <- apply(ap, 2, max) #열
result2

#3-3
result3 <- apply(ap, 1, mean)
result3
result4 <- round(result3, digit=2)
result4

result5 <- apply(ap, 2, mean)
result5
result6 <- round(result5, digit=2)
result6

#3-4
apply(ap, 1, var)
apply(ap, 1, sd)


#4
Data2 <- c("2017-02-05 수입3000원", "2017-02-06 수입4500원", "2017-02-07 수입2500원")

#4-1
xa <- str_extract_all(Data2, '[0-9]{4}[가-힣]')
xa
unlist(xa)


#4-2
str_replace_all(Data2, "[0-9]{2}",'')

#4-3
Da <- str_replace_all(Data2, "-","/")
Da

#4-4
D <- paste(Data2, collapse = ",")
D


