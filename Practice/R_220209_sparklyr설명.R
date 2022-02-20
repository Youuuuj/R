rm(list=ls())

# spark 설치
# install.packages("sparklyr")
library(sparklyr)
# spark_available_versions()
# spark_install(version="3.0.0")
Sys.setenv(JAVA_HOME="C:/Program Files/Java/jdk-11.0.11")

library(dplyr)
library(ggplot2)

## 새 로컬 연결
sc <- spark_connect(master="local", version="3.0.0")

## 데이터 가져오기
cars <- copy_to(sc, mtcars)
cars

## 랭글
# 원자료(raw data)를 보다 쉽게 접근하고 분석할 수 있도록 
# 데이터를 정리하고 통합하는 과정
summarize_all(cars, mean)
summarize_all(cars, mean) %>% show_query()

# 유형별로 그룹화 tramsmission
cars %>%
  mutate(transmission = ifelse(am == 0, "automatic", "manual")) %>%
  group_by(transmission) %>%
  summarise_all(mean)


## 내장함수
# percentile() : 그룹에 있는 열의 정확한 백분위수를 반환한다.
summarise(cars, mpg_percentile = percentile(mpg, 0.25))  # 1/4 부분 반환
summarise(cars, mpg_percentile = percentile(mpg, 0.25)) %>%
  show_query()
# R에는 percentile()함수가 없기때문에, dplyr은 코드의 결과 그대로 sql 쿼리로 전달한다.

summarise(cars, mpg_percentile = percentile(mpg, array(0.25, 0.5, 0.75)))
# 여러 값을 percentile()에 전달하기 위해 array()라는 다른 Hive 함수를 호출할 수 있습니다. 
# 이 경우 array()는 R의 list() 함수와 유사하게 작동합니다. 
# 쉼표로 구분된 여러 값을 전달할 수 있습니다. 
# Spark의 출력은 배열 변수이며 R에 목록 변수 열로 가져옵니다.

summarise(cars, mpg_percentile = percentile(mpg, array(0.25, 0.5, 0.75))) %>%
  mutate(mpg_percentile = explode(mpg_percentile))
# explode() 함수를 사용하여 Spark의 배열 값 결과를 자체 레코드로 분리할 수 있습니다. 
# 이렇게 하려면 mutate() 명령 내에서 explode()를 사용하고 백분위수 연산 결과가 포함된 변수를 전달합니다.


## 상관관계
# 상관 관계는 쌍을 이루는 변수 집합 사이에 어떤 종류의 통계적 관계가 존재하는지 알아내기 위해 종종 계산합니다.
# Spark는 전체 데이터 세트에서 상관 관계를 계산하는 함수를 제공하고 결과를 DataFrame 객체로 R에 반환합니다.
ml_corr(cars)

## corrr package
# install.packages('corrr')
library(corrr)
correlate(cars, use = "pairwise.complete.obs", method = "pearson") 
# corrr R 패키지는 상관 관계를 전문으로 합니다. 
# 결과를 준비하고 시각화하는 친숙한 기능이 포함되어 있습니다

correlate(cars, use = "pairwise.complete.obs", method = "pearson") %>%
  shave() %>% rplot()
# shave() 함수는 복제된 모든 결과를 NA로 바꿉니다.
# rplot() 함수를 사용하여 결과를 쉽게 시각화할 수 있습니다.

# 어떤 관계가 긍정적인지 부정적인지 확인하는 것이 훨씬 쉽습니다. 
# 긍정적인 관계는 회색으로 표시되고 부정적인 관계는 검은색으로 표시됩니다.
# 원의 크기는 그들의 관계가 얼마나 중요한지를 나타냅니다.


## 시각화
# 시각화는 데이터에서 패턴을 찾는 데 도움이 되는 중요한 도구입니다. 
# 1,000개의 관측값으로 구성된 데이터 세트에서 이상값을 목록에서 읽는 것보다 
# 그래프에 표시하면 더 쉽게 식별할 수 있습니다.
# 시작하려면 프로그램이 원시 데이터를 가져와 일종의 변환을 수행합니다. 
# 변환된 데이터는 좌표 집합에 매핑됩니다. 마지막으로 매핑된 값이 플롯에 그려집니다.
# 본질적으로 시각화 접근 방식은 랭글링과 동일합니다.
# 계산을 Spark로 푸시한 다음 플로팅을 위해 R에서 결과를 수집합니다.
# 데이터를 집계하는 것과 같은 데이터 준비의 무거운 작업은 Spark 내에서 수행할 수 있으며 
# 훨씬 더 작은 데이터 집합을 R로 수집할 수 있습니다.

# ggplot2로 시각화하기
library(ggplot2)
ggplot(aes(as.factor(cyl), mpg), data = mtcars) +
  geom_col()
# ggplot2 패키지를 사용하면 숫자는 자동변환 되었고, 알아서 편리하게 시각화했다.

# park에는 "푸시 컴퓨팅, 결과 수집" 접근 방식을 코드화할 때 몇 가지 주요 단계가 있습니다.
# 첫번째는 변환작업으로써 group_by() 및 summarise()는 Spark 내에서 실행합니다. 
# 두 번째는 데이터가 변환된 후 결과를 R로 다시 가져오는 것입니다. 
# 반드시 순서대로 변형 후 수집하십시오. 
# collect()가 먼저 실행되면 R은 Spark에서 전체 데이터 세트를 수집하려고 시도합니다. 
# 데이터 크기에 따라 모든 데이터를 수집하면 속도가 느려지거나 시스템이 다운될 수도 있습니다.
car_group <- cars %>%
  group_by(cyl) %>%
  summarise(mpg = sum(mpg, na.rm = TRUE)) %>%
  collect() %>%
  print()

ggplot(aes(as.factor(cyl), mpg), data = car_group) + 
  geom_col(fill = "#999999") + coord_flip()
# 위에서 데이터가 사전 집계되어 R로 수집되었으므로 플로팅 함수에 세 개의 레코드만 전달됩니다.
# 이 접근 방식을 사용하여 다른 모든 ggplot2 시각화를 작동할 수 있습니다. 


## dbplot을 이용하여 시각화하기
# 시각화하기 전에 이 변환 단계를 용이하게 하기 위해 dbplot 패키지는 Spark에서 집계를 
# 자동화하는 바로 사용할 수 있는 몇 가지 시각화를 제공합니다.
# install.packages('dbplot')
library(dbplot)
# 데이터를 변환하는 데 사용되는 R 코드 dbplot은 Spark로 변환할 수 있도록 작성됩니다. 
# 그런 다음 해당 결과를 사용하여 데이터 변환과 플로팅이 모두 단일 함수에 의해 
# 트리거되는 ggplot2 패키지를 사용하여 그래프를 생성합니다.

# 히스토그램
cars %>%
  dbplot_histogram(mpg, binwidth = 3) +
  labs(title = "MPG Distribution",
       subtitle = "Histogram over miles per gallon")
# dbplot_histogram() 함수는 Spark가 bin과 bin당 개수를 계산하도록 하고 ggplot 개체를 출력합니다.
# bin을 계산하는데 사용되는 범위를 제어하기 위해 binwidth 인수를 이용한다.

# 산점도
ggplot(aes(mpg, wt), data = mtcars) + 
  geom_point()

# 래스터
dbplot_raster(cars, mpg, wt, resolution = 16)
# dbplot_raster()를 사용하여 Spark에서 분산형 플롯을 생성하면서 
# 원격 데이터 세트의 작은 하위 집합만 검색(수집)할 수 있습니다.



## 모델링
cars %>% 
  ml_linear_regression(mpg ~ .) %>%
  summary()
# 선형 회귀를 수행하고 갤런당 마일을 예측합니다.


## Caching
# 데이터를 먼저 변환해야 하는 경우 데이터 볼륨으로 인해 Spark 세션에 막대한 피해가 발생할 수 있습니다. 
# 모델을 맞추기 전에 모든 변환 결과를 Spark 메모리에 로드된 새 테이블에 저장하는 것이 좋습니다.
# compute() 명령은 dplyr 명령을 끝내고 결과를 Spark 메모리에 저장할 수 있습니다.
cached_cars <- cars %>% 
  mutate(cyl = paste0("cyl_", cyl)) %>%
  compute("cached_cars")

cached_cars %>%
  ml_linear_regression(mpg ~ .) %>%
  summary()
# 데이터에서 더 많은 insight을 얻을수록 더 많은 질문이 제기될 수 있습니다. 
# 그렇기 때문에 데이터 랭글, 시각화 및 모델링 주기를 여러 번 반복해야 합니다. 
# 각 반복은 데이터가 "말하는 것"에 대한 점진적인 insight을 제공해야 합니다. 
# 어느 정도 이해가 되는 시점이 올 것입니다. 
# 이 시점에서 우리는 분석 결과를 공유할 준비가 될 것입니다. 


## Communicate
# 분석 결과를 명확하게 전달하는 것이 중요합니다. 
# R Markdown 문서는 자체 포함되어 있고 재현 가능해야 하므로 문서를 렌더링하기 전에
# 먼저 Spark에서 연결을 해제하여 리소스를 확보해야 합니다.
spark_disconnect(sc)
# spark_disconnect_all()

