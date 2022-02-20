# 유준

library(ggplot2)
library(plotly)
# 1. iris데이터를 대상으로 다음 조건에 맞게 시각화 하시오.
# 조건 : 
# (1) 1번 컬럼을 x축으로 하고 3번 컬럼을 y축으로 한다.
# (2) 5번 컬럼을 색상 지정한다.
# (3) 차트 제목을 'Scatter plot for iris data'로 추가한다
# (4) 폭 720픽셀 높이 480픽셀로 설정하여 작성한 차트를 파일명이 'iris_(YJ).jpg'인 파일에 저장하고 제출한다


# 데이터 불러오기
data(iris)
names(iris)
# 그래프 그리기
ggplot(iris, aes(x = Sepal.Length, y = Petal.Length , color = Species)) +
  geom_point() +  # 산점도 표시
  labs(title = 'Scatter plot for iris data') +  # 제목
  theme(plot.title = element_text(hjust = 0.5))  # 제목 위치 설정


ggsave('iris_YJ.jpg', width = 720, height = 480, units = c('px'), dpi = 100)


Scatter <- plot_ly(iris, x = ~Sepal.Length , y = ~Petal.Length, color = ~Species,
                   type = 'scatter', marker = list(size = 10))
Scatter <- layout(Scatter, title = 'Scatter plot for iris data')

Scatter

# 2. diamonds 데이터셋을 대상으로
# (1) x축에 carat변수, y축에 price 변수를 지정하고,
# (2) clarity변수를 선색으로 지정하여 미적 요소 맥핑 개채를 생성한 후
# (3) 산점도 그래프 주변에 부드러운 곡선이 추가되도록 레이아웃을 추가하시오.
# 작성한 차트 파일명이 'diamonds_(YJ),jpg'인 파일에 저장하여 제출한다.

# 데이터 불러오기
data(diamonds)
head(diamonds)
# 그래프 그리기
ggplot(diamonds, aes(x = carat, y = price, color = clarity)) + 
  geom_point() +  # 산점도
  geom_smooth() +   # 부드러운 곡선
  labs(title = 'Scatter plot for diamonds data') +  # 제목
  theme(plot.title = element_text(hjust = 0.5))  # 제목 위치 설정

ggsave('diamonds_YJ.jpg', width = 720, height = 480, units = c('px'), dpi = 100)

plot_ly(diamonds, x = ~carat, y = ~price, color = ~clarity,
        type = 'scatter', marker = list(size = 5))
