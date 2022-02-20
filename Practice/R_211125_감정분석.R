setwd('C:/Users/tj-bu/Desktop/Rwork/감정분석')

# 감정분석
# 텍스트에 어떤 감정이 담겨있는지 분석하는 방법
# 글쓴이가 어떤 감정을 담아 글을 썻는가?
# 사람들이 어떤 주제를 긍정정/부정적으로 느끼는가?


# 감정사전
# '감정 단어'와 '감정의 강도를 표현한 숫자'로 구성된 사전
# 사전을 이용해 문장의 단어에 감정 점수를 부여한 다음 합산
# word : 감정단어
# polarity : 감정의 강도

# KNU 한국어 감성사전 출처: github.com/park1200656/KnuSentiLex
install.packages('dplyr')
library(dplyr)
install.packages('readr')
library(readr)

dic <- read_csv('knu_sentiment_lexicon.csv')

# 긍정단어
dic %>% filter(polarity == 2) %>% arrange(word)
# 부정단어
dic %>% filter(polarity == -2) %>% arrange(word)

# word 
# 한 단어로 된 단일어, 둘 이상 단어 결합된 복합어
# 이모티콘 : ^^, ㅠㅠ

# polarity
# 5가지 정수(+2, +1, 0, -1, -2)
# + : 긍정단어, - : 부정단어, 0 : 중성단어

# 감정 단어의 종류 살펴보기
dic %>% filter(word %in% c('좋은','나쁜'))
dic %>% filter(word %in% c('기쁜','슬픈'))

# 이모티콘
library(stringr)
dic %>% filter(!str_detect(word, '[가-힣]')) %>% arrange(word)

dic %>% mutate(sentiment = ifelse(polarity >= 1, 'pos',
                                  ifelse(polarity <= -1, 'neg', 'neu'))) %>%
  count(sentiment)


# 문장의 감정 점수 구하기
# 1. 단어 기준으로 토큰화하기
df <- tibble(sentence = c('디자인 예쁘고 마감도 좋아서 만족스럽다.',
                          '디자인은 괜찮다. 그런데 마감이 나쁘고 가격도 비싸다.'))
df

# 텍스트를 단어 기준으로 토큰화 : 감정 사전과 동일하게 만드는 것
# install.packages('tidytext')
library(tidytext)
df <- df %>% unnest_tokens(input = sentence,
                              output = word,
                              token = 'words',
                              drop = F)
df
# unnest_tokens(drop = F) 
# 단어가 어느 문장에서 추출됐는지 알 수 있도록 원문 제거하지 않기

# 2. 단어에 감정 점수 부여하기
df <- df %>% left_join(dic, by = 'word') %>% 
  mutate(polarity = ifelse(is.na(polarity), 0, polarity))
df
# dplyr :: left_join() : word 기준 감정 사전 결합
# 감정사전에 없는 단어 polarity = NA -> 0 부여

# 3. 문장별로 감정 점수 합산하기
score_df <- df %>% group_by(sentence) %>%
  summarise(score = sum(polarity))

score_df


# 댓글 감정 분석하기
# 영화 '기생충' 아카데미상 수상 관련 기사 댓글
# 기본적인 전처리
# 고유 번호 변수 만들기 : 댓글 내용 같아도 구별할 수 있도록
# html 특수 문자 제거하기 : 웹에서 만들어진 텍스트는 html 특수 문자 포함되어 내용 알아보기 불편함
#                           textclean :: replace_html() : html태그를 공백으로 바꾸기
#                           stringr :: str_squish() : 중복 공백 제거
# 특수 문자와 두 글자 미만 단어 포함하기
# 감정 사전의 특수 문자, 모음, 자음으로 된 두 글자 미만의 이모티콘 활용


# 데이터 불러오기
raw_news_comment <- read_csv('news_comment_parasite.csv')
names(raw_news_comment)

# 기본적인 전처리
# install.packages('textclean')
library(textclean)

news_comment <- raw_news_comment %>%
  mutate(id = row_number(),
         reply = str_squish(replace_html(reply)))
glimpse(news_comment)

# 단어 기준으로 토큰화하고 감정 점수 부여하기
# 1. 토큰화
word_comment <- news_comment %>%
  unnest_tokens(input = reply,
                output = word,
                token = 'words',
                drop = F)
word_comment %>% select(word, reply)

# 2. 감정 점수부여
word_comment <- word_comment %>%
  left_join(dic, by = 'word') %>%
  mutate(polarity = ifelse(is.na(polarity), 0, polarity))

word_comment %>% select(word, polarity)


# 자주 사용된 감정 단어 살펴보기
# 1. 감정 분류하기
word_comment <- word_comment %>%
  mutate(sentiment = ifelse(polarity == 2, 'pos',
                            ifelse(polarity == -2, 'neg', 'neu')))

word_comment %>% count(sentiment)

# 2. 막대 그래프 만들기
top10_sentiment <- word_comment %>%
  filter(sentiment != 'neu') %>%
  count(sentiment, word) %>%
  group_by(sentiment) %>%
  slice_max(n, n = 10)

top10_sentiment  

library(ggplot2)
ggplot(top10_sentiment, aes(x = reorder(word, n),
                            y = n,
                            fill = sentiment)) +
  geom_col() + 
  coord_flip() +
  geom_text(aes(label = n), hjust = -0.3) +
  facet_wrap(~ sentiment, scales = 'free') +
  scale_y_continuous(expand = expansion(mult = c(0.05, 0.15))) + 
  labs(x = NULL) +
  theme(text = element_text(family = 'nanumgothic'))
# scale_y_continuous() : 막대 그래프 간격 넓히기. 
#                        막대끝의 빈도 값이 그래프 경계 밖으로 벗어나지 않도록 설정.


# 댓글 별 감정 점수 구하고 댓글 살펴보기
# 1. 댓글별 감정 점수 구하기
# id, reply별로로 분리한 다음 polarity합산
# id로 먼저 나누는 이유 : 내용이 같은 댓글이 여럿 있더라도 서로 다른 댓글로 취급
#                         id별로 먼저 나누지 않으면 내용 같은 댓글 점수 모두 하나로 합산
score_comment <- word_comment %>% 
  group_by(id, reply) %>%
  summarise(score = sum(polarity)) %>%
  ungroup()

score_comment %>%
  select(score, reply)

# 2. 감정 점수 높은 댓글 살펴보기
# 긍정 댓글
score_comment %>%
  select(score, reply) %>%
  arrange(-score)

# 부정 댓글
score_comment %>%
  select(score, reply) %>%
  arrange(score)

# 감정 경향 살펴보기
# 1. 감정 점수 빈도 구하기
score_comment %>% count(score)

# 2. 감정 분류하고 막대 그래프 만들기
# 감정 분류하기
score_comment <- score_comment %>%
  mutate(sentiment = ifelse(score >= 1, 'pos',
                            ifelse(score <= -1, 'neg', 'neu')))
# 감정 빈도와 비율 구하기
frequency_score <- score_comment %>%
  count(sentiment) %>%
  mutate(ratio = n/sum(n)*100)
frequency_score

# 막대 그래프 그리기
ggplot(frequency_score, aes(x = sentiment, y = n, fill = sentiment)) +
  geom_col() +
  geom_text(aes(label = n), vjust = -0.3) +
  scale_x_discrete(limits = c('pos','neu','neg'))
# scale_x_discrete() : x축 순서 정하기

# 3. 비율 누적 막대 그래프 만들기(예시)
df <- tibble(contry = c('Korea', 'Korea', 'Japen', 'Japen'),  # 축
             sex = c('M', 'F', 'M', 'F'), # 누적 막대
             ratio = c(60, 40, 30, 70))
df
ggplot(df, aes(x = contry, y = ratio, fill = sex)) +
  geom_col() +
  geom_text(aes(label = paste0(ratio, '%')),
            position = position_stack(vjust = 0.5))
# geom_txt() : 막대에 비율 표기
# position_stack(vjust = 0.5): 비율을 막대의 가운데에 표시

# 댓글의 감정 비율로 누적 막대 그래프 만들기
# x축을 구성할 더미 변수(dummy variable) 추가
# 더미 변수 생성
frequency_score$dummy <- 0
frequency_score

ggplot(frequency_score, aes(x = dummy, y = ratio, fill = sentiment)) +
  geom_col() +
  geom_text(aes(label = paste0(round(ratio, 1), '%')),
            position = position_stack(vjust = 0.5))+
  theme(axis.title.x = element_blank(),  # x축 이름 삭제
        axis.text.x = element_blank(),  # x축 값 삭제
        axis.ticks.x = element_blank(),) # x축 눈금 삭제



# 감정 범주별 주요 단어 살펴보기
# 감정 범주별 단어 빈도 구하기
# 1. 토큰화하고 두 글자 이상 한글 단어만 남기기
comment <- score_comment %>%
  unnest_tokens(input = reply,  # 단어 기준 토큰화
                output = word,
                token = 'words',
                drop = F) %>%
  filter(str_detect(word, '[가-힣]') &  # 한글 추출
           str_count(word) >= 2)  # 두 글자 이상 추출

# 2. 감정 범주별 빈도 구하기
# 감정 및 단어별 빈도 구하기
frequency_word <- comment %>%
  filter(str_count(word) >= 2) %>%
  count(sentiment, word, sort = T)

frequency_word

# 긍정 댓글 고빈도 단어
frequency_word %>%
  filter(sentiment == 'pos')

# 부정 댓글 고빈도 단어
frequency_word %>%
  filter(sentiment == 'neg')


# 상대적으로 자주 사용된 단어비교하기
# 1. 로그 오즈비 구하기
# wide form으로 변환
library(tidyr)
comment_wide <- frequency_word %>%
  filter(sentiment != 'neu') %>%
  pivot_wider(names_from = sentiment,
              values_from = n,
              values_fill = list(n = 0))
comment_wide

# 로그 오즈비 구하기
comment_wide <- comment_wide %>%
  mutate(log_odds_ratio = log(((pos + 1) / (sum(pos + 1))) /
                                ((neg + 1) / (sum(neg + 1)))))
comment_wide

# 2. 로그 오즈비가 가장 큰 단어 10개씩 추출하기
top10 <- comment_wide %>%
  group_by(sentiment = ifelse(log_odds_ratio > 0, 'pos', 'neg')) %>%
  slice_max(abs(log_odds_ratio), n = 10, with_ties = F)
top10
# 로그 오즈비 동점 단어 제외

# 3. 막대 그래프 만들기
# 막대 그래프 만들기
ggplot(top10, aes(x = reorder(word, log_odds_ratio),
                  y = log_odds_ratio,
                  fill = sentiment)) +
  geom_col() +
  coord_flip() +
  labs(x = NULL) +
  theme(text = element_text(family = 'nanumgothic'))


# 감정 사전 수정하기
# 감정 단어가 사용된 원문 살펴보기
# '소름', '미친' : 긍정적인 감정을 극적으로 표현한 단어
# '소름'이 사용된 댓글
score_comment %>% filter(str_detect(reply, '소름')) %>%
  select(reply)
score_comment %>% filter(str_detect(reply, '미친')) %>%
  select(reply)
# '소름','미친'이 감정 사전에 부정적인 다넝로 분류되어 있어서 생긴 문제
# 텍스트의 맥락이 감정 사전의 맥락과 다르면 반대되는 감정 점수 부여
# 따라서 감정 사전 수정 필요
dic %>% filter(word %in% c('소름','소름이','미친'))

# '소름','소름이','미친'의 polarity를 양수 2로 수정
new_dic <- dic %>%
  mutate(polarity = ifelse(word %in% c('소름','소름이','미친'), 2, polarity))

new_dic %>% filter(word %in% c('소름','소름이','미친'))

# 수정한 사전으로 감정 점수 부여하기
new_word_comment <- word_comment %>%
  select(-polarity) %>%
  left_join(new_dic, by = 'word') %>%
  mutate(polarity = ifelse(is.na(polarity), 0, polarity))

# 댓글별 감정 점수 구하기
new_score_comment <- new_word_comment %>%
  group_by(id, reply) %>%
  summarise(score = sum(polarity)) %>%
  ungroup()

new_score_comment %>% select(score, reply) %>%
  arrange(-score)


# 전반적인 감정 경향 살펴보기
# 1. 감정분류하기
# 1점 기준으로 긍정 중립 부정 분류
new_score_comment <- new_score_comment %>%
  mutate(sentiment = ifelse(score >= 1, 'pos',
                            ifelse(score <= -1, 'neg', 'neu')))
# 2. 감정 범주별 빈도와 비율 구하기
# 원본 감정 사전 활용
score_comment %>%
  count(sentiment) %>%
  mutate(ratio = n/sum(n)*100)
# 수정한 감정 사전 활용
new_score_comment %>%
  count(sentiment) %>%
  mutate(ratio = n/sum(n)*100)

# 3. 분석 결과 비교
word <- '소름|소름이|미친'
# 원본 감정 사전 활용
score_comment %>%
  filter(str_detect(reply, word)) %>%
  count(sentiment)
# 수정한 감정 사전 활용
new_score_comment %>%
  filter(str_detect(reply, word)) %>%
  count(sentiment)
# str_detect()에 여러 문자를 입력할 때는 |로 문자를 구분


# 감정 범주별 주요 단어 살펴보기
# 1. 두 글자 이상 한글 단어만 남기고 단어 빈도 구하기
# 토큰화 및 전처리
new_comment <- new_score_comment %>%
  unnest_tokens(input = reply,
                output = word,
                token = 'words',
                drop = F) %>%
  filter(str_detect(word, '[가-힣]') & 
           str_count(word) >= 2)

# 감정 및 단어별 빈도구하기
new_frequency_word <- new_comment %>%
  count(sentiment, word, sort = T)

# 2. 로그 오즈비 구하기
# Wide form으로 변환
new_comment_wide <- new_frequency_word %>%
  filter(sentiment != 'neu') %>%
  pivot_wider(names_from = sentiment,
              values_from = n,
              values_fill = list(n = 0))
# 로그 오즈비 구하기
new_comment_wide <- new_comment_wide %>%
  mutate(log_odds_ratio = log(((pos + 1) / (sum(pos + 1))) /
                                ((neg + 1) / (sum(neg + 1)))))

# 3. 로그 오즈비가 큰 단어로 막대 그래프 만들기
new_top10 <- new_comment_wide %>%
  group_by(sentiment = ifelse(log_odds_ratio > 0, 'pos', 'neg')) %>%
  slice_max(abs(log_odds_ratio), n = 10, with_ties = F)

ggplot(new_top10, aes(x = reorder(word, log_odds_ratio),
                      y = log_odds_ratio,
                      fill = sentiment)) +
  geom_col() + 
  coord_flip() +
  labs(x = NULL) +
  theme(text = element_text(family = 'nanumgothic'))

# 4. 주요 단어가 사용된 댓글 살펴보기
# 긍정 댓글 원문
new_score_comment %>%
  filter(sentiment == 'pos' & str_detect(reply, '축하')) %>%
  select(reply)

new_score_comment %>%
  filter(sentiment == 'pos' & str_detect(reply, '소름')) %>%
  select(reply)

# 부정 댓글 원문
new_score_comment %>%
  filter(sentiment == 'neg' & str_detect(reply, '좌빨')) %>%
  select(reply)
new_score_comment %>%
  filter(sentiment == 'neg' & str_detect(reply, '못한')) %>%
  select(reply)

# 5. 분석 결과 비교하기
# 수정한 감정 사전 활용
new_top10 %>%
  select(-pos, -neg) %>%
  arrange(-log_odds_ratio)
# 원본 감정 사전 활용
top10 %>%
  select(-pos, -neg) %>%
  arrange(-log_odds_ratio)
# '미친'이 목록에서 사라짐 : 로그 오즈비가 10위 안에 들지 못할 정도로 낮기 때문
# 긍정단위 10위 '최고의' 로그 오즈비 2.90
new_comment_wide %>%
  filter(word == '미친')
