##  Sparklyr 모델링

# 설명에서는  Spark를 사용하여 데이터 분석을 대규모 데이터 세트로 확장하는 방법을 배웠다.
# 앞으로는 분산 데이터에 대한 예측 모델링을 수행하고 기능 엔지니어링 및 탐색적 데이터 분석의 맥락에서 
# 데이터 랭글링을 사용할 수 있게 해주는 Spark의 구성 요소인 MLlib를 살펴봅니다.
# 목표는 엄격하고 일관된 분석을 수행하기보다는 대용량 데이터에 대한 데이터 과학 작업을 실행하는 다양한 기술을 보여주는 것

# 1. 개요
# Spark는기계 학습을 가능하게 하는 것을 목표로 하기 때문에 모델링에 중점을 둔다.

# 데이터 셋 다운
download.file(
  "https://github.com/r-spark/okcupid/raw/master/profiles.csv.zip",
  "okcupid.zip")

unzip("okcupid.zip", exdir = "data")
unlink("okcupid.zip")

profiles <- read.csv("data/profiles.csv")
write.csv(dplyr::sample_n(profiles, 10^3),
          "data/profiles.csv", row.names = FALSE)


# install.packages("ggmosaic")
# install.packages("forcats")
# install.packages("FactoMineR")

# 2. 탐색적 데이터 분석
# 예측 모델링의 맥락에서 탐색적 데이터 분석(EDA)은 데이터의 발췌 및 요약을 보는 연습입니다.

# 공통 목표
# - 데이터 품질을 확인하십시오. 누락된 값의 의미와 보급을 확인하고 기존 제어에 대한 통계를 조정합니다.
# - 변수 간의 일변량 관계를 이해합니다.
# - 포함할 변수와 해당 변수에 대해 수행해야 하는 변환에 대한 초기 평가를 수행합니다.
# - 시작하려면 Spark에 연결하고 라이브러리를 로드하고 데이터를 읽습니다.

library(sparklyr)
library(ggplot2)
library(dbplot)
library(dplyr)

sc <- spark_connect(master = "local", version = "3.0")

okc <- spark_read_csv(
  sc, 
  "data/profiles.csv", 
  escape = "\"", 
  memory = FALSE,
  options = list(multiline = TRUE)
) %>%
  mutate(
    height = as.numeric(height),
    income = ifelse(income == "-1", NA, as.numeric(income))
  ) %>%
  mutate(sex = ifelse(is.na(sex), "missing", sex)) %>%
  mutate(drinks = ifelse(is.na(drinks), "missing", drinks)) %>%
  mutate(drugs = ifelse(is.na(drugs), "missing", drugs)) %>%
  mutate(job = ifelse(is.na(job), "missing", job))
# 에세이 필드에 포함된 인용 문자와 줄 바꿈을 수용하기 위해 
# escape = "\"", options = list(multiline = TRUE)를 지정한다.
# key 및 income 열을 숫자 유형으로 변환하고 문자열 열의 누락된 값을 다시 코딩합니다.
# glimpse()를 사용하여 데이터를 빠르게 살펴볼 수 있습니다.
glimpse(okc)

# 이제 응답 변수를 데이터 세트의 열로 추가하고 분포를 살펴봅니다.
okc <- okc %>%
  mutate(
    not_working = ifelse(job %in% c("student", "unemployed", "retired"), 1 , 0)
  )

okc %>% 
  group_by(not_working) %>% 
  tally()

# 계속 진행하기 전에 데이터를 훈련 세트와 테스트 세트로 초기 분할을 수행하고 후자는 제거하겠습니다.
# 이것은 모델 성능을 평가하기 위해 모델링 프로세스가 끝날 때 
# 따로 설정해 두는 홀드아웃 세트를 갖고 싶기 때문에 중요한 단계입니다. 
# 훈련세트와 테스트 세트를 나누지않고 EDA 동안 전체 데이터 세트를 포함하는 경우 
# 데이터가 학습 알고리즘에서 직접 사용되지 않더라도
# 테스트 세트의 정보가 시각화 및 요약 통계로 "유출"되고 모델 구축 프로세스가 편향될 수 있습니다. 
# 이것은 우리의 성과 지표의 신뢰성을 훼손할 것입니다

# sdf_random_split() 함수를 사용하여 데이터를 쉽게 분할할 수 있습니다.
data_splits <- sdf_random_split(okc, training = 0.8, testing = 0.2, seed = 42)
okc_train <- data_splits$training
okc_test <- data_splits$testing

# 응답 변수의 분포를 빠르게 확인할 수 있습니다.
okc_train %>%
  group_by(not_working) %>%
  tally() %>%
  mutate(frac = n / sum(n))

# sdf_describe() 함수를 사용하여 특정 열의 숫자 요약을 얻을 수 있습니다.
sdf_describe(okc_train, cols = c("age", "income"))

# dpplot을 사용하여 이러한 변수의 분포를 그릴 수 있다.
# 연령 변수 분포의 히스토그램을 보여줍니다.
dbplot_histogram(okc_train, age)
# 일반적인 EDA 연습은 반응과 개별 예측 변수 간의 관계를 살펴보는 것입니다.

prop_data <- okc_train %>%
  mutate(religion = regexp_extract(religion, "^\\\\w+", 0)) %>% 
  group_by(religion, not_working) %>%
  tally() %>%
  group_by(religion) %>%
  summarize(
    count = sum(n),
    prop = sum(not_working * n) / sum(n)
  ) %>%
  mutate(se = sqrt(prop * (1 - prop) / count)) %>%
  collect()

prop_data
# prop_data는 R 세션에서 메모리에 수집된 작은 DataFrame입니다. 

# ggplot2를 활용하여 유익한 시각화를 만들 수 있습니다.
# 현재 고용되지 않은 개인의 종교별 비율
prop_data %>%
  ggplot(aes(x = religion, y = prop)) + geom_point(size = 2) +
  geom_errorbar(aes(ymin = prop - 1.96 * se, ymax = prop + 1.96 * se),
                width = .1) +
  geom_hline(yintercept = sum(prop_data$prop * prop_data$count) /
               sum(prop_data$count))


# 알코올 사용과 약물 사용이라는 두 가지 예측 변수 사이의 관계를 살펴봅니다. 
# 우리는 그들 사이에 어떤 상관관계가 있을 것으로 예상할 것입니다. 
# sdf_crosstab()을 통해 분할표를 계산할 수 있습니다.
contingency_tbl <- okc_train %>% 
  sdf_crosstab("drinks", "drugs") %>%
  collect()

contingency_tbl

# 모자이크 플롯을 사용하여 이 분할표를 시각화할 수 있습니다
library(ggmosaic)
library(forcats)
library(tidyr)

# 약물 및 알코올 사용의 모자이크 플롯
contingency_tbl %>%
  rename(drinks = drinks_drugs) %>%
  gather("drugs", "count", missing:sometimes) %>%
  mutate(
    drinks = as_factor(drinks) %>% 
      fct_relevel("missing", "not at all", "rarely", "socially", 
                  "very often", "desperately"),
    drugs = as_factor(drugs) %>%
      fct_relevel("missing", "never", "sometimes", "often")
  ) %>%
  ggplot() +
  geom_mosaic(aes(x = product(drinks, drugs), fill = drinks, 
                  weight = count))


# FactoMineR 패키지를 사용하여 대응 분석18을 수행할 수 있습니다. 
# 이 기술을 사용하면 각 수준을 평면의 한 지점에 매핑하여 
# 고차원 요인 수준 간의 관계를 요약할 수 있습니다. 
# FactoMineR::CA()를 사용하여 매핑을 얻습니다.
dd_obj <- contingency_tbl %>% 
  tibble::column_to_rownames(var = "drinks_drugs") %>%
  FactoMineR::CA(graph = FALSE)

# 약물 및 알코올 사용에 대한 대응 분석 주요 좌표
dd_drugs <-
  dd_obj$row$coord %>%
  as.data.frame() %>%
  mutate(
    label = gsub("_", " ", rownames(dd_obj$row$coord)),
    Variable = "Drugs"
  )

dd_drinks <-
  dd_obj$col$coord %>%
  as.data.frame() %>%
  mutate(
    label = gsub("_", " ", rownames(dd_obj$col$coord)),
    Variable = "Alcohol"
  )

ca_coord <- rbind(dd_drugs, dd_drinks)

ggplot(ca_coord, aes(x = `Dim 1`, y = `Dim 2`, 
                     col = Variable)) +
  geom_vline(xintercept = 0) +
  geom_hline(yintercept = 0) +
  geom_text(aes(label = label)) +
  coord_equal()
# 대응 분석 절차가 요인을 주 좌표라고 하는 변수로 변환한 것을 볼 수 있습니다.
# 이 변수는 플롯의 축에 해당하고 포함된 분할표의 정보 양을 나타냅니다
# 예를 들어, "자주 술을 마신다"와 "마약을 매우 자주 사용하다"의 근접성을 
# 연관성을 나타내는 것으로 해석할 수 있습니다.


# 3. Feature Engineering
# 피쳐 엔지니어링 연습에는 모델의 성능을 높이기 위해 데이터를 변환하는 작업이 포함됩니다.
# 숫자 값의 중심 맞추기 및 크기 조정, 문자열 조작을 수행하여
# 의미 있는 변수 추출 등이 포함될 수 있습니다. 
# 종종 변수 선택(모델에서 사용되는 예측 변수를 선택하는 프로세스)이 포함됩니다.
# 평균과 표준 편차를 계산하는 것으로 시작하여 평균을 제거하고 
# 단위 분산으로 스케일링하여 연령 변수를 정규화 해보겠습니다.

scale_values <- okc_train %>%
  summarize(
    mean_age = mean(age),
    sd_age = sd(age)
  ) %>%
  collect()

scale_values

# 그런 다음 이를 사용하여 데이터세트를 변환할 수 있습니다.
okc_train <- okc_train %>%
  mutate(scaled_age = (age - !!scale_values$mean_age) /
           !!scale_values$sd_age)

dbplot_histogram(okc_train, scaled_age)
# 기능 엔지니어링 워크플로 중에 모델에 포함하려는 모든 숫자 변수에 대해 정규화를 수행할 수 있습니다.

# 프로필 기능 중 일부는 다중 선택(즉, 사람이 변수에 대해 여러 옵션을 연결하도록 선택할 수 있음)이므로
# 의미 있는 모델을 구축하기 전에 해당 기능을 처리해야 합니다. 
# 예를 들어 민족성 열을 살펴보면 다양한 조합이 있음을 알 수 있습니다.
okc_train %>%
  group_by(ethnicity) %>%
  tally()

# 진행하는 한 가지 방법은 인종의 각 조합을 별도의 수준으로 처리하는 것이지만, 
# 이는 매우 많은 수의 수준으로 이어져 많은 알고리즘에서 문제가 됩니다. 
# 이 정보를 더 잘 인코딩하기 위해 다음과 같이 각 인종에 대한 더미 변수를 만들 수 있습니다.
ethnicities <- c("asian", "middle eastern", "black", "native american", "indian", 
                 "pacific islander", "hispanic / latin", "white", "other")
ethnicity_vars <- ethnicities %>% 
  purrr::map(~ expr(ifelse(like(ethnicity, !!.x), 1, 0))) %>%
  purrr::set_names(paste0("ethnicity_", gsub("\\s|/", "", ethnicities)))
okc_train <- mutate(okc_train, !!!ethnicity_vars)
okc_train %>% 
  select(starts_with("ethnicity_")) %>%
  glimpse()

# 자유 텍스트 필드의 경우 기능을 추출하는 간단한 방법은 총 문자 수를 계산하는 것입니다. 
# 계산 속도를 높이기 위해 compute()를 사용하여 기차 데이터 세트를 Spark의 메모리에 저장합니다.
okc_train <- okc_train %>%
  mutate(
    essay_length = char_length(paste(!!!syms(paste0("essay", 0:9))))
  ) %>% compute()

dbplot_histogram(okc_train, essay_length, bins = 100)
# Essay_length 변수의 분포를 볼 수 있습니다.

# 이 데이터세트를 사용하므로 먼저 Parquet 파일로 저장하겠습니다. 
# 숫자 데이터에 이상적인 효율적인 파일 형식입니다.
spark_write_parquet(okc_train, "data/okc-train.parquet")


# 4. 지도학습( Supervised Learning)
# 모델을 구축하기 전 "후보" 모델을 조정하고 검증할 계획을 세워야 합니다.
# 모델링 프로젝트에서 우리는 종종 다양한 유형의 모델과 모델을 적용하여 어떤 것이 가장 잘 작동하는지 확인하는 방법을 시도합니다.
# 이진 분류 문제를 다루기 때문에 사용할 수 있는 메트릭에는 정확도, 정밀도, 감도, ROC AUC(수신기 작동 특성 곡선 아래 면적) 등이 포함됩니다.
# 최적화하는 메트릭은 특정 비즈니스 문제에 따라 다르지만 이 연습에서는 ROC AUC에 중점을 둘 것입니다.

# 우리가 얻은 모든 정보가 모델링 결정에 영향을 미치고 결과적으로 모델 성능 추정의 
# 신뢰성이 떨어질 수 있기 때문에 마지막까지 테스트 홀드아웃 세트를 엿보지 않는 것이 중요합니다.

# 튜닝 및 검증을 위해 모델 튜닝의 표준 접근 방식인 10겹 교차 검증을 수행합니다. 
# 교차 검증의 순서는 먼저 데이터 세트를 대략 동일한 크기의 10개의 하위 집합으로 나눕니다.
# 알고리즘에 대한 훈련 세트로 두 번째에서 10번째 세트를 함께 사용하고 첫 번째 세트에서 결과 모델을 검증합니다. 
# 다음으로 두 번째 세트를 유효성 검사 세트로 예약하고 첫 번째 및 세 번째에서 10번째 세트에 대해 알고리즘을 훈련합니다. 
# 총 10개의 모델을 훈련하고 성능을 평균화합니다.
# 각 분할과 관련된 트레이닝 세트를 분석 데이터라고 하고, 
# 검증 세트를 평가 데이터라고 한다.

## 교차검증
# sdf_random_split() 함수를 사용하여 okc_train 테이블에서 하위 집합 목록을 만들 수 있습니다.
vfolds <- sdf_random_split(
  okc_train,
  weights = purrr::set_names(rep(0.1, 10), paste0("fold", 1:10)),
  seed = 42
)
# 첫 번째 분석/평가 분할을 만듭니다.
analysis_set <- do.call(rbind, vfolds[2:10])
assessment_set <- vfolds[[1]]
# 주의 깊게 다루어야 하는 항목은 변수의 크기 조정입니다. 
# 평가 세트에서 분석 세트로 정보가 누출되지 않도록 해야 하므로 
# 분석 세트에서만 평균과 표준 편차를 계산하고 두 세트에 동일한 변환을 적용합니다.
# age 변수에 대해 처리하는 방법입니다.
make_scale_age <- function(analysis_data) {
  scale_values <- analysis_data %>%
    summarize(
      mean_age = mean(age),
      sd_age = sd(age)
    ) %>%
    collect()
  
  function(data) {
    data %>%
      mutate(scaled_age = (age - !!scale_values$mean_age) / !!scale_values$sd_age)
  }
}

scale_age <- make_scale_age(analysis_set)
train_set <- scale_age(analysis_set)
validation_set <- scale_age(assessment_set)
# 간결함을 위해 여기서는 연령 변수를 변환하는 방법만 보여줍니다. 
# 그러나 실제로는 이전 섹션에서 파생된 Essay_length 변수와 같은 
# 각 연속 예측 변수를 정규화하려고 할 것입니다.


# 로지스틱 회귀는 종종 이진 분류 문제의 합리적인 시작점이므로 시도해 보겠습니다. 
# 또한 도메인 지식이 초기 예측 변수 집합을 제공한다고 가정합니다. 
# 그런 다음 Formula 인터페이스를 사용하여 모델을 피팅할 수 있습니다.
lr <- ml_logistic_regression(
  analysis_set, not_working ~ scaled_age + sex + drinks + drugs + essay_length
)
lr

# 평가 세트에 대한 성능 메트릭 요약을 얻으려면 ml_evaluate() 함수를 사용할 수 있습니다.
validation_summary <- ml_evaluate(lr, assessment_set)

# validation_summary를 인쇄하여 사용 가능한 메트릭을 볼 수 있습니다.
validation_summary

# validation_summary$roc()의 출력을 수집하고 ggplot2를 사용하여 ROC 곡선을 그릴 수 있습니다.
roc <- validation_summary$roc() %>%
  collect()

ggplot(roc, aes(x = FPR, y = TPR)) +
  geom_line() + geom_abline(lty = "dashed")
# ROC 곡선은 분류 임계값의 다양한 값에 대한 거짓 양성률(1-특이성)에 대한 참 양성률(민감도)을 표시합니다. 
# 실제로 비즈니스 문제는 곡선에서 분류 임계값을 설정하는 위치를 결정하는 데 도움이 됩니다. 
# AUC는 모델의 품질을 결정하기 위한 요약 척도이며 area_under_roc() 함수를 호출하여 계산할 수 있습니다.
validation_summary$area_under_roc()



# Spark는 일반화된 선형 모델(선형 모델 및 로지스틱 회귀 포함)에 대해서만 평가 방법을 제공합니다. 
# 다른 알고리즘의 경우 평가자 함수(예: 예측 DataFrame의 ml_binary_classification_evaluator())를
# 사용하거나 고유한 메트릭을 계산할 수 있습니다.
# 이제 이미 가지고 있는 논리를 쉽게 반복하고 각 분석/평가 분할에 적용할 수 있습니다.
cv_results <- purrr::map_df(1:10, function(v) {
  analysis_set <- do.call(rbind, vfolds[setdiff(1:10, v)]) %>% compute()
  assessment_set <- vfolds[[v]]
  
  scale_age <- make_scale_age(analysis_set)
  train_set <- scale_age(analysis_set)
  validation_set <- scale_age(assessment_set)
  
  model <- ml_logistic_regression(
    analysis_set, not_working ~ scaled_age + sex + drinks + drugs + essay_length
  )
  s <- ml_evaluate(model, assessment_set)
  roc_df <- s$roc() %>% 
    collect()
  auc <- s$area_under_roc()
  
  tibble(
    Resample = paste0("Fold", stringr::str_pad(v, width = 2, pad = "0")),
    roc_df = list(roc_df),
    auc = auc
  )
})
# 이것은 우리에게 10개의 ROC 곡선을 제공합니다

unnest(cv_results, roc_df) %>%
  ggplot(aes(x = FPR, y = TPR, color = Resample)) +
  geom_line() + geom_abline(lty = "dashed")
# 로지스틱 회귀 모델에 대한 교차 검증된 ROC 곡선
# 평균 AUC 메트릭을 얻을 수 있습니다.
mean(cv_results$auc)


## 일반선형회귀(Generalized Linear Regression)
# 일반 선형 모델(GLM) 진단에 관심이 있는 경우 family = "binomial"을 지정하여 
# 일반 선형 회귀 인터페이스를 통해 로지스틱 회귀를 맞출 수도 있습니다. 
# 결과는 회귀 모델이기 때문에 ml_predict() 메서드는 클래스 확률을 제공하지 않습니다. 
# 그러나 여기에는 계수 추정치에 대한 신뢰 구간이 포함됩니다.
glr <- ml_generalized_linear_regression(
  analysis_set, 
  not_working ~ scaled_age + sex + drinks + drugs, 
  family = "binomial"
)

tidy_glr <- tidy(glr)

# 계수 추정값을 깔끔한 DataFrame으로 추출한 다음 추가 처리할 수 있습니다. 
# 예를 들어 그림 4.9에서 볼 수 있는 계수 플롯을 생성합니다.
tidy_glr %>%
  ggplot(aes(x = term, y = estimate)) +
  geom_point() +
  geom_errorbar(
    aes(ymin = estimate - 1.96 * std.error, 
        ymax = estimate + 1.96 * std.error, width = .1)
  ) +
  coord_flip() +
  geom_hline(yintercept = 0, linetype = "dashed")
# 95% 신뢰 구간의 계수 추정치
# 참고: ml_logistic_regression() 및 ml_linear_regression()은 모두 
# reg_param 및 elastic_net_param 매개변수를 통해 탄력적 순 정규화를 지원합니다. 
# reg_param 해당 λ, 반면 elastic_net_param은 α. 
# ml_generalized_linear_regression()은 reg_param만 지원합니다.


## 기타 모델
# Spark는 많은 표준 모델링 알고리즘을 지원하며 특정 문제에 대해 이러한 모델과 
# 하이퍼파라미터(모델 피팅 프로세스를 제어하는 값)를 쉽게 적용할 수 있습니다. 
# 부록에서 지원되는 ML 관련 기능 목록을 찾을 수 있습니다. 
# 이러한 기능에 액세스하는 인터페이스는 거의 동일하므로 쉽게 실험할 수 있습니다. 
# 예를 들어 신경망 모델에 맞추기 위해 다음을 실행할 수 있습니다.
nn <- ml_multilayer_perceptron_classifier(
  analysis_set,
  not_working ~ scaled_age + sex + drinks + drugs + essay_length, 
  layers = c(12, 64, 64, 2)
)
# 이것은 각각 64개의 노드로 구성된 두 개의 은닉층이 있는 피드포워드 
# 신경망 모델을 제공합니다. 레이어 인수에서 입력 및 출력 레이어에 
# 대해 올바른 값을 지정해야 합니다. ml_predict()를 사용하여 검증 
# 세트에 대한 예측을 얻을 수 있습니다.
predictions <- ml_predict(nn, assessment_set)
# 그런 다음 ml_binary_classification_evaluator()를 통해 AUC를 계산할 수 있습니다.
ml_binary_classification_evaluator(predictions)


# 5. 비지도 학습(Unsupervised Learning)
# 음성, 이미지 및 비디오와 함께 텍스트 데이터는 빅 데이터 폭발의 구성 요소 중 하나입니다

## 데이터 준비
# 데이터 세트(또는 데이터 세트의 하위 집합)를 분석하기 전에 
# 데이터 세트를 빠르게 살펴보고 방향을 잡기를 원합니다. 
# 이 경우 사용자가 데이트 프로필에 입력한 자유 형식 텍스트에 관심이 있습니다.
essay_cols <- paste0("essay", 0:9)
essays <- okc %>%
  select(!!essay_cols)
essays %>% 
  glimpse()
# 이 출력에서 다음을 볼 수 있습니다.
# 텍스트에 HTML 태그가 포함되어 있습니다.
# 텍스트에 개행(\n) 문자가 포함됩니다.
# 데이터에 누락된 값이 있습니다.
 
# HTML 태그와 특수문자는 사용자가 직접 입력한 것이 아니고 흥미로운 정보를 제공하지 않아 데이터를 오염시킨다. 
# 마찬가지로, 누락된 문자열로 누락된 문자 필드를 인코딩했으므로 이를 제거해야 합니다.
# (이렇게 함으로써 우리는 사용자가 작성한 "missing"이라는 단어의 인스턴스도 제거하지만
# 이 제거로 인해 손실되는 정보는 작을 가능성이 있습니다.)


# 자신의 텍스트 데이터를 분석할 때 특정 데이터 세트의 특성을 빠르게 발견하고 
# 익숙해질 것입니다. 표 형식의 숫자 데이터와 마찬가지로 텍스트 데이터를 전처리하는
# 것은 반복적인 프로세스이며 몇 번의 시도 후에 다음과 같은 변환이 이루어집니다.
essays <- essays %>%
  # `missing`을 빈 문자열로 바꿉니다.
  mutate_all(list(~ ifelse(. == "missing", "", .))) %>%
  # 열을 연결합니다.
  mutate(essay = paste(!!!syms(essay_cols))) %>%
  # 기타 문자 및 HTML 태그 제거
  mutate(words = regexp_replace(essay, "\\n|&nbsp;|<[^>]*>|[^A-Za-z|']", " "))

## 주제 모델링(Topic Modeling)
# LDA는 문서 집합에서 추상적인 "주제"를 식별하기 위한 주제 모델 유형입니다. 
# 입력 문서에 대한 레이블이나 주제를 제공하지 않는다는 점에서 감독되지 않은 
# 알고리즘입니다. LDA는 각 문서가 주제의 혼합이며 각 주제는 단어의 혼합이라고 
# 가정합니다. 훈련하는 동안 이 두 가지를 동시에 추정하려고 시도합니다. 
# 토픽 모델의 일반적인 사용 사례는 많은 문서를 분류하는 것과 관련되며, 
# 많은 수의 문서로 인해 수동 접근 방식이 불가능합니다.애플리케이션 도메인은
# GitHub 문제에서 법적 문서에 이르기까지 다양합니다.

# 이전 섹션의 워크플로(업무흐름)를 따라 합리적으로 깨끗한 데이터 세트를 얻은 후에는 
# ml_lda()를 사용하여 LDA 모델을 맞출 수 있습니다.
stop_words <- ml_default_stop_words(sc) %>%
  c(
    "like", "love", "good", "music", "friends", "people", "life",
    "time", "things", "food", "really", "also", "movies"
  )

lda_model <-  ml_lda(essays, ~ words, k = 6, max_iter = 1, min_token_length = 4, 
                     stop_words = stop_words, min_df = 5)
# 일반적으로 사용되는 영어 단어와 데이터 세트의 일반적인 단어로 구성된 stop_words
# 벡터도 포함하여 알고리즘이 이를 무시하도록 지시합니다. 모델이 적합된 후, 
# 우리는 모델에서 주제별 확률인 관련 베타를 추출하기 위해 tidy() 함수를 사용할 수 있습니다.
betas <- tidy(lda_model)
betas
# 그런 다음 주제별 단어 확률을 확인하여 이 출력을 시각화할 수 있습니다. 
# 그림 4.10과 그림 4.11에서는 1회 반복과 100회 반복의 결과를 보여줍니다. 
# 그림 4.10을 생성하는 코드는 다음과 같습니다. 
# 그림 4.11을 생성하려면 ml_lda()를 실행할 때 max_iter = 100을 설정해야 하지만 
# 단일 시스템에서는 시간이 정말 오래 걸릴 수 있다는 점에 주의하십시오. 
# 쉽게 대처할 수 있습니다.
betas %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup() %>%
  arrange(topic, -beta) %>%
  mutate(term = reorder(term, beta)) %>%
  ggplot(aes(term, beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  coord_flip()
# 100번의 반복에서 우리는 "주제"가 나타나기 시작하는 것을 볼 수 있습니다. 
# 익숙하지 않은 많은 문서 모음을 조사하는 경우 이 정보 자체만으로도 흥미로운 
# 정보가 될 수 있습니다. 학습된 주제는 다운스트림 지도 학습 작업의 기능으로도 
# 사용할 수 있습니다. 예를 들어, 예측 모델링 예제에서 고용 상태를 예측하기 위해 
# 모델에서 주제 번호를 예측 변수로 사용하는 것을 고려할 수 있습니다.

spark_disconnect(sc)
