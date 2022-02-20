# 교차 검정 샘플링
# 전통적인 검정방식(hold-out): 학습데이터와 검정데이터를 7:3 비율로 구성하여 학습데이터로 모델을 생성하고 검정데이터로 모델을 평가

# 교차검정 : 동일한 데이터 셋을 N등분하여 N-1개의 학습데이터로 모델을 생서아고 나머지 1개를 검정데이터로 이용하여 모델을 평가하는 방식

# 1) Cross-Vaildation :
# 1~n개의 데이터를 랜덤(무작위)하게 n등분하여, 데이터를 Training/Vaildation으로 나눈 다음 교차하여 확인하는 바업
# 전체 데이터 셋을 동일한 크기를 가진 2개의 집합으로 분할하여 training set, vaildation set을 만듬
# 영향력이 큰 관측치가 어느 set에 속하느냐에 따라 MSE가 달라짐
# 관측치의 일부만 train에 속하여 높은 bias를 갖는다.

# 2) K-Fold Cross Vaildation :
# 데이터를 무작위로 섞은 후 K등분한 것 중 하나를 Vaildation set으로 사용하는 방법
# 전체 데이터 셋을 k 개의 그룹으로 분할하여 한 그룹은 validation set, 나머지 그룹은 train set으로 사용합니다.
# k 번 fit 을 진행하여 k 개의 MSE 를 평균내어 최종 MSE 를 계산합니다.
# LOOCV 보다 연산량이 낮습니다.
# 중간 정도의 bias 와 variance 를 갖습니다

# 3) LOOCV(Leave-One-Out Cross-Validation): 
# 데이터 중 하나만을 검정(Validation) Set으로 두고, 나머지를 학습(Training) Set으로 모델에 적합시키는 방법. 
# 자료가n개인경우, 위 과정을 n번 반복후 결과치들의 평균을 도출하여 사용함
# n 번 fitting 을 진행하고, n 개의 MSE 를 평균하여 최종 MSE 를 계산합니다.
# n-1 개 관측값을 train 에 사용하므로 bias 가 낮습니다.
# overfitting 되어 높은 variance 를 갖습니다.
# n 번 나누고 n 번 fit 하므로 랜덤성이 없습니다.
# n 번 fit 을 진행하므로 expensive 합니다



# K겹 교차 검정 데이터 셋 생성 알고리즘 사용
# Where
# k겹: k겹의 회수만큼 모델을 평가

# K겹 교차 검정 데이터 셋 생성 알고리즘 사용
# 1) K개로 데이터를 분할(D1, D2, …, Dk)하여 D1은 검정데이터, 나머지는 학습데이터 생성
# 2) 검정데이터의 위치를 하나씩 변경하고, 나머지 데이터를 학습데이터로 생성
# 3) 위의 1단계와 2단계의 과정을 K번 만큼 반복

# 예시) K=3인 경우 교차 검정 데이터 셋 구성
# K-fold 검정  학습
# K=1     D1  D2, D3
# K=2     D2  D1, D3
# K=3     D3  D1, D2


# 데이터 셋을 대상으로 K겹 교차 검정 데이터 셋 생성
# 1단계 : 데이터프레임 생성
name <- c('a','b','c','d','e','f')
score <- c(90, 85, 99, 75, 65,88)
df <- data.frame(Name = name, Score = score)

# 2단계 : 교차 검정을 위한 패키지 설치
install.packages("cvTools")
library(cvTools)  # K겹 교차 검정 데이터 셋을 생성
# 형식 : cvFolds(n, K=5, R=1, type=c(“random”, “consecutive”, “interleaved”)
# n: 데이터의 크기
# K: K겹 교차 검증
# R: R회 반복

# 3단계 : K겹 교차 검정 데이터 셋 생성
cross <- cvFolds(n = 6, K = 3, R = 1, type = 'random')
cross

# 4단계 : K겹 교차 검정 데이터 셋 구조 보기
str(cross)
cross$which

# K겹 교차 검정 데이터 셋의 구조: 
# 5개의 key로 구성된 List자료구조 결과에서 which는 Fold의 결과를 vector형태로 보관 subsets는 index의 결과를 matrix형태로 보관

# 5단계 : subsets 데이터 참조하기
cross$subsets[cross$which == 1, 1]
cross$subsets[cross$which == 2, 1]
cross$subsets[cross$which == 3, 1]

# 실제 관측치의 행 번호를 가지고 있는 subsets의 데이터는 which를 이용하여 접근 가능


# 6단계 : 데이터프레임의 관측치 적용
r = 1
K = 1:3
for(i in K){
  datas_idx <- cross$subsets[cross$which == i, r]
  cat('K = ', i , '검정데이터 \n')
  print(df[datas_idx, ])
  
  cat('K = ', i, '훈련데이터 \n')
  print((df[-datas_idx]))
}
