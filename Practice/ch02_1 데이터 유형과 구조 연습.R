#4??΄μ§ ??

x <- c(1,3,5,7)
y <- c(3,5)

union(x,y) #?©μ§ν©
intersect(x,y) #κ΅μ§?©
setdiff(x,y) #x-y

v1 <- c(33, -5, 20:23, 12, -2:3)
v2 <- c('?κΈΈλ', '?΄?? ', '? κ΄?')
v3 <- c(T, TRUE, FALSE, T, TRUE, F, T)
v1; v2; v3

v4 <- c(33, 05, 20:23, 12, '4')
v4

#?Έλ―Έμ½λ‘?(;) ?¬?©? ?μ€μ ?¬?¬κ°μ λͺλ Ήλ¬? ?¬?© κ°?₯
mode(v4)
class(v4)
v1; mode(v1); class(v1)
v2; mode(v2); class(v2)
v3; mode(v3); class(v3)

#names()?¨? : λ²‘ν°?? μ»¬λΌλͺ? μ§? 
#λ²‘ν°? NULLμΆκ? ? κ°μ²΄ ? κ±?
age <- c(30,35,40)
age
names(age) <- c('?κΈΈλ', '?΄?? ', 'κ°κ°μ°?')
age
age <- NULL

#index ?¬?©? κΌ? ??κ΄νΈ[]λ‘? λ¬Άμ΄?Όμ€μΌ?¨
#index? 1λΆ?° ???¨
a <- c(1:50)
a[10:45]
a[19: (length(a) - 5)] # = a[19:45]

v1 <- c(13, -5, 20:23, 12, -2:3)
v1[1]
v1[c(2,4)]
v1[c(3:5)]
v1[c(4, 5:8, 7)]

#index ??
#indexκ° ?? -> ?΄?Ή index ? ?Έ
#-c(2:5) = index 2~5 ? ?Έ

v1[-1]; v1[-c(2, 4)]; v1[-c(2:5)]; v1[-c(2, 5:10, 1)]


#λ²‘ν° κ°μ²΄ ?°?΄?° ?
install.packages("RSADBE")
library(RSADBE)
data(Severity_Counts) # RSADBE ?¨?€μ§?? ? κ³΅λ? ?°?΄?°? λ‘λ©
str(Severity_Counts) # ?°?΄?°? κ΅¬μ‘° λ³΄κΈ°
head(Severity_Counts)

#Matrix ?λ£? κ΅¬μ‘°
#?? ¬ ?λ£? κ΅¬μ‘°, 2μ°¨μ
#??Ό? ???? ?°?΄?°λ§? ???₯ κ°?₯?¨
#?? ¬ ??± ?¨?
#matrix(), rbind() -> row(?) bind, cbind() -> column(?΄) bind
#?? ¬ ?λ£? μ²λ¦¬ ?¨? : apply()

#c()?¨?? κΈ°λ³Έ? ?Όλ‘? ?΄? κΈ°μ??Όλ‘? κ°μ²΄ ??±

m <- matrix(c(1:5))
m

m <- matrix(c(1:10), nrow = 2) #nrow? ? κ°μ ?΅?
m

#?κ³? ?΄? ?κ° λΆμΌμΉν κ²½μ°

m <- matrix(c(1:11), nrow = 2)
m

# ?κ³? ?΄?΄ ?κ° λΆμΌμΉ? -> κ²½κ³  ?
# λͺ¨μ?Ό? ?°?΄?°? μ²«λ²μ§? ?°?΄?° ?¬?¬?©

#? ?°? ?Όλ‘? ?? ¬ ??±
m <- matrix(c(1:10), nrow = 2, byrow = T) #byrow = T? ? ?°?  λ°°μ΄ ?€?  ?΅? 
m

#? ?? ?΄ λ¬Άμ?Όλ‘? ?? ¬ ??±
#rbind() : ? λ¬Άμ, cbind() : ?΄ λ¬Άμ

#?€?΅ ?λ¬Άμ
x1 <- c(40, 50:52)
x2 <- c(30, 6:8)
mr <- rbind(x1, x2)
mr

#?€?΅ ?΄λ¬Άμ
mc <- cbind(x1, x2)
mc

mc2 <- cbind(x2, x1)
mc2


#matrix()?¨? ?΄?© ?? ¬ ??±
#?? : matrix(data = NA, nrow = 1, ncol = 1, byrow = FALSE, dimnames = NULL)

#2??Όλ‘? ?? ¬ ??±
m3 <- matrix(10:19, nrow = 2)
m4 <- matrix(10:20, nrow = 2)
m3 
m4
mode(m3); class(m3)
mode(m4); class(m4)

#indexλ₯? ?΄?©?΄ ?? ¬? ? κ·?
#?? : λ³?λͺ?[? index, ?΄ index]
#?Ή?  ? ? κ·? : λ³?λͺ?[? index,]
#?Ή?  ?΄ ? κ·? : λ³?λͺ?[, index]
#μ½€λ§(,) λΉΌλ¨Ή?Όλ©? ??Ό

m3[1,]
m3[,5]
m3[2,3]
m3[1,c(2:5)]


#? ?°? ?Όλ‘? ??± ? byrow = T ??± μΆκ?
x <- matrix(c(1:9), nrow = 3, ncol = 3, byrow = T)
x

#apply()?¨? 
#?? : apply(x, 1(??¨?) or 2(?΄?¨?), ?? ¬? ? ?©?  ?¨?[ex) max, min, mean])

apply(x, 1, max)
apply(x, 1, min)
apply(x, 2, mean)

#?¬?©? ? ? ?¨?
#?? : function(x)

f <- function(x){
  x *c(1,2,3)
}

result <- apply(x, 2, f)
result
x

#?? ¬? μ»¬λΌλͺ? μ§? 
#colnames()?¨?, rownames()?¨?

colnames(x) <- c('one', 'two', 'three')
x
rownames(x) <- c('ONE', 'TWO', 'THREE')
x


#array ?λ£κ΅¬μ‘?
#3μ°¨μ λ°°μ΄ ??
#λ°°μ΄ ??± ?¨? : array()

vec <- c(1:18)
arr <- array(vec, c(3,2,3))
arr

arr[,,1]
arr[,,2]

mode(arr)
class(arr)


#?°?΄?° ? κ°? Έ?€κΈ? #? ? ??;
library(RSADBE)
data("Bug_Metrices_Software")
str(Bug_Metrices_Software)

#DataFrame ?λ£κ΅¬μ‘?
#R?? κ°?₯ λ§μ΄ ?°? ?λ£κ΅¬μ‘?
#DB? ??΄λΈ? κ΅¬μ‘°?? ? ?¬
#μ»¬λΌ ?¨?λ‘? ?λ‘? ?€λ₯? ?°?΄?° ?? ???₯?΄ κ°?₯
#μ»¬λΌ?? λ¦¬μ€?Έ, μ»¬λΌ ?΄ ?°?΄?°? λ²‘ν° κ΅¬μ‘°
#DataFrame ??±?¨? : data.frame(), read,table(), read.csv()
#DataFrame ?λ£? μ²λ¦¬ ?¨? : str(), ncol(), nrow(), apply(), summary(), subset()


no <- c(1, 2, 3)
name <- c("hong", "lee", "kim")
pay <- c(150, 250, 300)
vemp <- data.frame(No = no, Name = name, Pay = pay)
vemp


#matrix ?΄?© data.frame ??±
m <- matrix(c(1,"hong", 150,
              2, "lee", 250,
              3, 'kim', 300), 3, byrow = T)
m

memp <- data.frame(m)
memp

colnames(memp) <- c('one','two','three')
memp

#text??Ό ?΄?© data.frame ??±
getwd()
txtemp <- read.table('emp.txt', header = 1, sep = '')
txtemp

#csv??Ό ?΄?© data.frame ??±
getwd()
csvtemp <- read.csv('emp.csv', header = T)
csvtemp

read.csv('emp2.csv', header = F)
name <- c('?¬λ²?', '?΄λ¦?','κΈμ¬')
read.csv('emp2.csv', header = F, col.names = name)

#data.frame λ§λ€κΈ?
df <- data.frame(x = c(1:5), y = seq(2, 10 ,2), z = c('a', 'b', 'c', 'd', 'e'))
df

 #data.frame??? $?­? 
#?? : λ³?λͺ?$μ»¬λΌλͺ?
df$x
df$z

str(df) #data.frame? κ΅¬μ‘°λ₯? λ³΄μ¬μ€?
ncol(df)
nrow(df)
names(df)
df[c(2:3),1]

#summary()?¨? : μ΅μκ°?, μ΅λ?κ°?, μ€μ?, ?κ·?, ?¬λΆμ?κ°μ ??½??¬ λ³΄μ¬μ€?€.
summary(df)

#?¨?? ?©
#apply()?¨?
#?? : apply(data.frame, ?/?΄, ?¨?)
apply(df[,c(1, 2)], 2, sum)

#data.frame? λΆλΆκ°μ²?
#subset() ?¨? : data.frame()?? μ‘°κ±΄? λ§μ‘±?? ?? μΆμΆ??¬ ?λ¦½λ κ°μ²΄?Έ subset ??±
#?? : subset(data.frame, μ‘°κ±΄)

df
x1 <- subset(df, x >=3)
x1

#2κ°μ μ‘°κ±΄ ?΄?© λΆλΆ? κ°μ²΄ λ§λ€κΈ?
y1 <- subset(df, y<=8)
xyand <- subset(df, x<=2 & y<=8 )
xyor <- subset(df, x<=2 | y>=8)
y1
xyand
xyor

#?€?΅
sid = c('A','B','C','D')
score = c(90,80,70,60)
subject = c('μ»΄ν¨?°', 'κ΅??΄κ΅?λ¬?', '???Έ?¨?΄', '? ?κ΅μ‘')

student <- data.frame(sid, score, subject)
student

mode(student); class(student)
str(sid)
str(score)
str(subject)
str(student)

#data.frame λ³ν©

#1?¨κ³? λ³ν©?  ?? ? ??±
height <- data.frame(id = c(1,2), h = c(180,175))
height
weight <- data.frame(id = c(1,2), w = c(80,75))
weight

#2?¨κ³? data.frame λ³ν©
user <- merge(height, weight, by.x = 'id', by.y = 'id')
user

#galton ?°?΄?°?
install.packages('UsingR')
library(UsingR)
data(galton)


str(galton)
dim(galton)
head(galton, 15)

ffff

h
