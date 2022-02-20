# 유준

setwd('C:/Users/You/Desktop/빅데이터/빅데이터 수업자료/R/R 평가')

library(KoNLP)
library(tm)
library(wordcloud2)
# install.packages('dplyr')
library(dplyr)


# 1단계 : 데이터 가져오기 및 전처리
# 1-1단계 : 데이터 가져오기
Drking <- file('Drking.txt', encoding = 'UTF-8')
Drking_data <- readLines(Drking)
head(Drking_data)
# 1-2단계 : 단어추출
Drking_nouns <- extractNoun(Drking_data)
Drking_nouns <- gsub('[a-z]+', '', Drking_nouns)  # 소문자 제거


# 2단계 : 추출된 단어를 대상으로 전처리하기
# 2-1단계 : 추출된 단어를 이용하여 말뭉치(Corpus) 생성
Drking_corpus <- Corpus(VectorSource(Drking_nouns))
# 2-2단계 : 문장부호 제거
Drking_corpus_tm <- tm_map(Drking_corpus, removePunctuation)
# 2-3단계 : 수치 제거
Drking_corpus_tm <- tm_map(Drking_corpus_tm, removeNumbers)
# 2-4단계 : 불용어 제거
Drking_corpus_tm <- tm_map(Drking_corpus_tm, removeWords, stopwords('english'))
# 2-5단계 : 전처리 결과 확인
inspect(Drking_corpus_tm[1:35])


# 3단계 : 단어 선별(2 ~ 8 음절 사이 단어 선택)하기
# 3-1단계 : 전처리된 단어집에서 단어 대상 선정
Drking_tdm <- 
  TermDocumentMatrix(Drking_corpus_tm, control = list(wordLengths = c(4,16)))  
Drking_tdm
# 3-2단계 : matrix 자료구조를 data.frame 자료구조로 변경
Drking_df <- as.data.frame(as.matrix(Drking_tdm))
dim(Drking_df)


# 4단계 : 단어 출변 빈도수 구하기
Drking_word <- sort(rowSums(Drking_df), decreasing = T)
Drking_word


# 5단계 : 단어구름 만들기
# 5-1단계 : 단어 이름과 빈도수로 data.frame 셍성
Drking_name <- names(Drking_word)
Drking_word_df <- data.frame(word = Drking_name, freq = Drking_word)
str(Drking_word_df)
# 5-2단계 : 빈도수 2회 이상 단어 추출
Drking_word_df2 <- filter(Drking_word_df, freq >= 2)
Drking_word_df2
# 5-3단계 : 단어 구름 시각화
wordcloud2(data = Drking_word_df2, size=1.5, color='random-light', backgroundColor = "black")

