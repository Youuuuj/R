#유준

library(stringr)

EMP <- c("2014홍길동220","2002이순신300","2010유관순260"); EMP

emp_pay <- function(x){
  pay <- str_sub(EMP, 8, 10)
  nupay <- as.numeric(pay);nupay
  me <- mean(nupay);me
  cat("전체급여 평균: ", me, "\n")
  
  name <- str_extract_all(EMP, "[가-힣]{3}"); name
  uln <- unlist(name); uln
  
  cat("평균 이상 급여 수령자","\n")
  
  i <- 1
    if(nupay[i] >= 260){
      cat(uln[i], "->", nupay[i], "\n")
        i <- i + 1
    }
  }


emp_pay(EMP)


#2

name <- c("유관순", "홍길동", "이순신", "신사임당"); name
gender <- c("F", "M", "M", "F"); gender
price <- c(50, 65, 45, 75); price

#2-1 
client <- data.frame(Name = name, Gender = gender, Price = price); client

#2-2
result <- ifelse(price >= 65, "beat","Normal"); result

#2-3
table(result)

