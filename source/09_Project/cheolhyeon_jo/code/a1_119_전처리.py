# -*- coding: utf-8 -*-

# %% [markdown]
# # 1. 서울시 119 이송 건수·인구 밀집 — 전처리
#
# 전처리 1 노트북이 만든 최종 csv를 모델 학습용 데이터로 바꾸는 노트북입니다. 예측은 `2_119_예측.ipynb`에서 진행합니다.
#
# **흐름**
# - 최종 csv 불러오기 → 사용할 파일 고르기 → 이송 건수 정답 정리 → 시계열 분해 → 학습 데이터 생성 → 특성 선택 → 미래 예측용 입력 행 생성
#
# **결과 파일 (`ml_data` 폴더)**
#
# | 파일 | 내용 |
# |---|---|
# | `transport_dataset.csv` | 이송 건수 학습 데이터 전체 (자치구 × 월) |
# | `transport_selected.csv` | 선택된 특성만 남긴 이송 건수 데이터 |
# | `transport_future.csv` | 미래 예측용 입력 행 (정답 없음) |
# | `features_transport.csv` | 이송 건수 특성 선택 결과와 이유 |
# | `population_dataset.csv` | 인구 밀집 학습 데이터 전체 (자치구 × 일) |
# | `population_selected.csv` | 선택된 특성만 남긴 인구 밀집 데이터 |
# | `features_population.csv` | 인구 밀집 특성 선택 결과와 이유 |
# | `excluded_columns.csv` | 중복·값 하나뿐이라 뺀 컬럼 |

# %% [markdown]
# ## 0. 환경 설정
# - 경로 : `BASE_DIR` 하나만 바꾸면 나머지 폴더가 따라 바뀜
# - 폴더 역할 : `outputs`(최종 데이터 csv) · `ml_data`(학습 데이터) · `ml_result`(그래프)
# - `FORECAST_MONTHS` : 미래 예측용 입력 행을 만들 개월 수

# %%
import os
from pathlib import Path

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from matplotlib import font_manager
from statsmodels.tsa.seasonal import seasonal_decompose

# 한글 폰트 자동 선택
font_candidates = ['Malgun Gothic', 'AppleGothic', 'NanumGothic', 'Noto Sans CJK KR', 'Noto Sans KR', 'Noto Sans CJK JP']
installed_fonts = {f.name for f in font_manager.fontManager.ttflist}
selected_font = next((f for f in font_candidates if f in installed_fonts), None)
if selected_font:
    plt.rcParams['font.family'] = selected_font
else:
    print('[주의] 한글 폰트를 찾지 못했습니다. 그래프 한글이 깨질 수 있습니다.')
plt.rcParams['axes.unicode_minus'] = False
pd.set_option('display.max_columns', 30)

# 경로
BASE_DIR = Path(os.getenv('PROJECT_DIR', 'C:/ai/source/09_Project/cheolhyeon_jo'))
OUT_DIR = BASE_DIR / 'outputs'
ML_DATA_DIR = BASE_DIR / 'ml_data'
RESULT_DIR = BASE_DIR / 'ml_result'
for d in [OUT_DIR, ML_DATA_DIR, RESULT_DIR]:
    d.mkdir(parents=True, exist_ok=True)

FORECAST_MONTHS = 6    # 미래 6개월

GU_LIST = ['강남구', '강동구', '강북구', '강서구', '관악구', '광진구', '구로구', '금천구', '노원구',
           '도봉구', '동대문구', '동작구', '마포구', '서대문구', '서초구', '성동구', '성북구', '송파구',
           '양천구', '영등포구', '용산구', '은평구', '종로구', '중구', '중랑구']
VALID_GU = set(GU_LIST)

print('OUT_DIR    :', OUT_DIR)
print('ML_DATA_DIR:', ML_DATA_DIR)
print('RESULT_DIR :', RESULT_DIR)

# %%
# 자주 쓰는 함수

def month_start(s):
    # 날짜를 그 달의 1일로 통일
    return pd.to_datetime(s, errors='coerce').dt.to_period('M').dt.to_timestamp()


def find_file(folder, name):
    # name.csv 또는 '숫자_name.csv' 중 가장 최근 파일, 없으면 None
    found = list(Path(folder).glob(name + '.csv')) + list(Path(folder).glob('*_' + name + '.csv'))
    if not found:
        return None
    return max(found, key=lambda p: p.stat().st_mtime)

# %% [markdown]
# ## 1. 최종 데이터 불러오기
# - 위치 : `outputs` (전처리 1 노트북의 결과 폴더)
# - 파일 이름 앞에 숫자가 붙어 있어도 찾음 (`find_file`)
# - 컬럼 이름 통일 : `district` → `District`, `ds` → 날짜형

# %%
FILE_NAMES = [
    'accident_cause_long', 'accident_cause_onehot',
    'ambulance_citywide_monthly', 'ambulance_incident_monthly', 'ambulance_monthly_gu_2022_2024',
    'ambulance_prophet', 'ambulance_prophet_201701_202512_api', 'ambulance_prophet_202512_api',
    'ambulance_sample_gwanak_202506',
    'medical_flow_district_demand', 'medical_flow_district_supply', 'medical_flow_seoul_od_matrix',
    'population_rf', 'realtime_er_beds',
]

raw = {}
for name in FILE_NAMES:
    path = find_file(OUT_DIR, name)
    if path is None:
        print(f'[없음] {name}.csv')
        continue
    df = pd.read_csv(path, encoding='utf-8-sig', low_memory=False)
    df = df.rename(columns={'district': 'District', '환자_district': '환자_District', '병원_district': '병원_District'})
    if 'ds' in df.columns:
        df['ds'] = pd.to_datetime(df['ds'])
    raw[name] = df
    print(f'{name:40s} {str(df.shape):12s} <- {path.name}')

# %% [markdown]
# ## 2. 사용할 파일 고르기
#
# | 파일 | 결정 | 이유 |
# |---|---|---|
# | `ambulance_prophet_201701_202512_api` | **정답(이송 건수)** | 2017~2025년 거의 모든 달, 한 가지 집계 기준 |
# | `ambulance_prophet_202512_api` | 제외 | 위 API 파일 안에 같은 행이 모두 있음 |
# | `ambulance_incident_monthly` | 제외 | 사고 **발생 구** 기준 (API는 **소방서 관할** 기준) → 섞으면 같은 구의 수준이 들쭉날쭉 |
# | `ambulance_monthly_gu_2022_2024` | 제외 | 출동 건수만 있음, API와 기간 겹침 |
# | `ambulance_prophet` | 제외 | 연 단위 |
# | `ambulance_citywide_monthly` | 제외 | 서울 전체 합계 (구 단위 아님) |
# | `ambulance_sample_gwanak_202506` | 제외 | 1개 구 1개월 표본 |
# | `accident_cause_long` | 제외 | `accident_cause_onehot`과 같은 내용 (형태만 다름) |
# | `medical_flow_seoul_od_matrix` | 제외 | 구별 합계가 수요·공급 표와 같음 |
# | `realtime_er_beds` | 제외 | 실시간 병상 스냅샷 (월별 예측과 시간 단위 다름) |
#
# 아래 셀에서 표의 판단 근거를 직접 확인합니다.

# %%
def is_contained(small, big, keys):
    # small의 모든 행이 big 안에 똑같이 있는지
    check = small.merge(big.drop_duplicates(keys), how='left', on=list(small.columns), indicator=True)
    return (check['_merge'] == 'both').all()


api = raw['ambulance_prophet_201701_202512_api'].copy()
print('202512 파일이 전체 API 안에 포함:', is_contained(raw['ambulance_prophet_202512_api'], api, ['ds', 'District']))

# long <-> onehot
long_df = raw['accident_cause_long']
wide = long_df.pivot_table(index=['ds', 'District'], columns='cause', values='rescued_count', aggfunc='sum', fill_value=0)
onehot = raw['accident_cause_onehot'].set_index(['ds', 'District'])
print('사고 원인 long = onehot:', np.allclose(wide.loc[onehot.index, onehot.columns], onehot))

# OD 합계 <-> 수요·공급
od = raw['medical_flow_seoul_od_matrix']
od_p = od.groupby(['ds', '환자_District'])['입원연인원'].sum()
od_h = od.groupby(['ds', '병원_District'])['입원연인원'].sum()
dem = raw['medical_flow_district_demand'].set_index(['ds', 'District'])['서울내입원연인원']
sup = raw['medical_flow_district_supply'].set_index(['ds', 'District'])['서울내환자연인원']
print('OD 합계 = 수요 서울내:', np.allclose(od_p.loc[dem.index], dem))
print('OD 합계 = 공급 서울내:', np.allclose(od_h.loc[sup.index], sup))

# 건별 집계(발생 구) vs API(소방서 관할) 이송 건수 비율
inc = raw['ambulance_incident_monthly'].merge(api, on=['ds', 'District'], suffixes=('_건별', '_API'))
ratio = (inc['transport_cnt_건별'] / inc['transport_cnt_API']).groupby(inc['District']).mean().sort_values()
print('\n건별 / API 이송 건수 비율 (1이면 같은 기준)')
print(ratio.round(2).to_string())

# %% [markdown]
# ## 3. 이송 건수 정답 데이터 (API, 자치구 × 월)
#
# **소방서 신설로 관할이 바뀐 구간**
# - 성동소방서 신설 전(~2017.7) : 성동구 출동이 광진구에 합산
# - 금천소방서 신설 전(~2022.1) : 금천구 출동이 구로구에 합산
# - 신설 첫 달 : 한 달 일부만 집계된 값
# - 처리 : 해당 4개 구는 관할이 정리된 달부터 사용 (두 구가 섞인 값·부분 집계 값 제외)
# - 효과 : 광진·구로의 가짜 "급감", 성동·금천의 가짜 "급증" 방지

# %%
# 관할이 정리된 첫 달
STATION_SPLIT = {
    '성동구': '2017-08-01', '광진구': '2017-08-01',
    '금천구': '2022-02-01', '구로구': '2022-02-01',
}

# 확인 : 신설 전후 연평균 출동 건수
for gu in STATION_SPLIT:
    g = api[api['District'] == gu]
    print(gu, g.groupby(g['ds'].dt.year)['y'].mean().round(0).to_dict())

start = pd.to_datetime(api['District'].map(STATION_SPLIT).fillna('2000-01-01'))
before = len(api)
monthly = api[api['ds'] >= start].copy()
monthly = monthly[monthly['District'].isin(VALID_GU)].drop_duplicates(['ds', 'District'])
monthly = monthly.sort_values(['District', 'ds']).reset_index(drop=True)
monthly['출처'] = 'API'

print(f'\n관할 변경 구간 제외: {before - len(monthly)}행 / 남은 행: {len(monthly)}')
print('기간:', monthly['ds'].min().date(), '~', monthly['ds'].max().date())

# %%
# 구별 월별 이송 건수 추이 (관할 변경 구 확인)
fig, axes = plt.subplots(1, 2, figsize=(16, 4))
for ax, pair in zip(axes, [('광진구', '성동구'), ('구로구', '금천구')]):
    for gu in pair:
        g_all = api[api['District'] == gu]
        g_use = monthly[monthly['District'] == gu]
        ax.plot(g_all['ds'], g_all['transport_cnt'], color='lightgray')
        ax.plot(g_use['ds'], g_use['transport_cnt'], marker='.', label=f'{gu} (사용 구간)')
    ax.set_title(' / '.join(pair) + ' 이송 건수 (회색 = 제외 구간)')
    ax.legend()
plt.tight_layout()
plt.savefig(RESULT_DIR / 'station_split_check.png')
plt.show()

# %% [markdown]
# ### 3-1. 시계열 분해 (서울 전체 월별 이송 건수)
# - `seasonal_decompose` : 실제값을 추세(trend) + 계절성(seasonal) + 잔차(resid)로 분리
# - 덧셈 모델(additive) : 계절 변동 폭이 해마다 비슷할 때 사용
# - `period=12` : 12개월 주기
# - 준비 조건 : 날짜를 인덱스로, 빈 달 없이 연속
# - 서울 전체 합계 : 관할이 바뀌어도 합계는 같으므로 3장에서 빼기 전 API 원본 사용
# - 확인 목적 : 계절성이 크면 `월`·`전년동월` 특성이 필요하다는 근거

# %%
# 서울 전체 합계는 관할 변경과 무관 -> 제외 전 API 원본으로 합계
city = api.groupby('ds')['transport_cnt'].sum()
city = city.asfreq('MS').interpolate()     # 빈 달이 있으면 앞뒤 값으로 선형 보간

rslt = seasonal_decompose(city, period=12, model='additive')

fig, axes = plt.subplots(nrows=4, ncols=1, figsize=(14, 10))
axes[0].plot(rslt.observed)
axes[0].set_title('Observed (서울 전체 이송 건수)')
axes[1].plot(rslt.trend)
axes[1].set_title('Trend')
axes[2].plot(rslt.seasonal)
axes[2].set_title('Seasonal')
axes[3].plot(rslt.resid)
axes[3].set_title('Resid')
plt.tight_layout()
plt.savefig(RESULT_DIR / 'transport_decompose.png')
plt.show()

season_by_month = rslt.seasonal.groupby(rslt.seasonal.index.month).mean()
print('월별 계절 효과 (건, 평균 대비)')
print(season_by_month.round(0).to_string())
print(f'계절 효과 폭 : {season_by_month.max() - season_by_month.min():,.0f}건 / 월평균 {city.mean():,.0f}건')

# %% [markdown]
# ## 4. 설명용 데이터 (생활인구 · 사고 원인 · 의료이용)
# - 생활인구 : 일별 표 → 6장에서 월평균으로 변환
# - 사고 원인 : 연 단위, 원인별 구조 인원
# - 의료이용 : 연 단위, 수요(유출률)와 공급(유입률)을 구·연도 기준으로 합침

# %%
pop = raw['population_rf'].copy()
accident = raw['accident_cause_onehot'].copy()

demand = raw['medical_flow_district_demand'].copy()
supply = raw['medical_flow_district_supply'].copy()
medical = demand.merge(supply, on=['ds', 'District'], how='outer')
medical['연도'] = medical['ds'].dt.year
medical = medical.drop(columns='ds')

print('생활인구 :', pop.shape, pop['ds'].min().date(), '~', pop['ds'].max().date())
print('사고 원인:', accident.shape, accident['ds'].dt.year.min(), '~', accident['ds'].dt.year.max())
print('의료이용 :', medical.shape, medical['연도'].min(), '~', medical['연도'].max())

# %% [markdown]
# ## 5. 중복·쓸모없는 컬럼 점검
# - 같은 값 컬럼 : 두 컬럼씩 `equals()`로 비교 → 뒤쪽 컬럼 제외
# - 값이 하나뿐인 컬럼 : `nunique() <= 1` → 예측에 정보 없음
# - 제외 기록 : `excluded_columns.csv`로 저장

# %%
excluded = []   # [표, 컬럼, 이유]


def drop_useless_columns(df, name, keys):
    cols = [c for c in df.columns if c not in keys]
    for i in range(len(cols)):
        for j in range(i + 1, len(cols)):
            a, b = cols[i], cols[j]
            if a in df.columns and b in df.columns and df[a].equals(df[b]):
                df = df.drop(columns=b)
                excluded.append([name, b, f'{a}와 값이 같음'])
    for c in [c for c in df.columns if c not in keys]:
        if df[c].nunique(dropna=False) <= 1:
            df = df.drop(columns=c)
            excluded.append([name, c, '값이 하나뿐임'])
    return df


pop = drop_useless_columns(pop, '생활인구', ['ds', 'District'])
accident = drop_useless_columns(accident, '사고원인', ['ds', 'District'])
if medical is not None:
    medical = drop_useless_columns(medical, '의료이용', ['연도', 'District'])

pop_cols = [c for c in pop.columns if c not in ['ds', 'District']]

excluded_df = pd.DataFrame(excluded, columns=['표', '컬럼', '이유'])
excluded_df.to_csv(ML_DATA_DIR / 'excluded_columns.csv', index=False, encoding='utf-8-sig')
print(excluded_df if len(excluded_df) else '제외된 컬럼 없음')

# %% [markdown]
# ## 6. 이송 건수 학습 데이터 (자치구 × 월)
#
# 예측 시점에 이미 알고 있는 **과거 값만** 특성으로 사용합니다.
#
# | 특성 | 의미 |
# |---|---|
# | `전월_transport_cnt` | 지난달 이송 건수 |
# | `전년동월_y`, `전년동월_transport_cnt` | 작년 같은 달 출동·이송 건수 |
# | `전월_생활인구` | 지난달 생활인구 월평균 |
# | `전년_사고원인` | 작년 원인별 구조 인원 |
# | `전년_의료이용` | 작년 유출률·유입률 등 |
#
# - 과거 값 붙이는 원리 : 과거 표의 날짜를 n개월 뒤로 민 다음 날짜·구 기준으로 병합
# - 같은 함수로 미래 입력 행(9장)도 계산 : 학습과 예측의 특성 계산 방식 일치
# - 지난달 출동 건수(`전월_y`)는 제외 : 미래 달의 출동 건수는 예측하지 않으므로 계산 불가

# %%
# 생활인구 : 일별 -> 월평균
pop_month = pop.copy()
pop_month['ds'] = month_start(pop_month['ds'])
pop_month = pop_month.groupby(['ds', 'District'], as_index=False)[pop_cols].mean()


def add_past(df, past_df, cols, months, prefix):
    # past_df 날짜를 months개월 뒤로 옮겨 붙이기 = 'months개월 전 값'
    past = past_df[['ds', 'District'] + cols].copy()
    past['ds'] = past['ds'] + pd.DateOffset(months=months)
    past.columns = ['ds', 'District'] + [prefix + c for c in cols]
    return df.merge(past, on=['ds', 'District'], how='left')


def add_last_year(df, year_df, prefix='전년_'):
    # 연 단위 표를 '작년 값'으로 붙이기
    y = year_df.copy()
    y['연도'] = y['연도'] + 1
    y.columns = [c if c in ['연도', 'District'] else prefix + c for c in y.columns]
    return df.merge(y, on=['연도', 'District'], how='left')


acc_year = accident.assign(연도=accident['ds'].dt.year).drop(columns='ds')


def make_transport_features(base, hist):
    # base : ds, District 뼈대 / hist : 월별 출동·이송 기록
    df = base[['ds', 'District']].copy()
    df['연도'] = df['ds'].dt.year
    df['월'] = df['ds'].dt.month
    df = add_past(df, hist, ['transport_cnt'], 1, '전월_')
    df = add_past(df, hist, ['y', 'transport_cnt'], 12, '전년동월_')
    df = add_past(df, pop_month, pop_cols, 1, '전월_')
    df = add_last_year(df, acc_year)
    if medical is not None:
        df = add_last_year(df, medical)
    return df


hist = monthly[['ds', 'District', 'y', 'transport_cnt']]
target_rows = monthly[monthly['transport_cnt'].notna()]

transport_df = make_transport_features(target_rows, hist)
transport_df = transport_df.merge(target_rows[['ds', 'District', '출처', 'transport_cnt']], on=['ds', 'District'])
transport_df = transport_df.sort_values(['District', 'ds']).reset_index(drop=True)

transport_df.to_csv(ML_DATA_DIR / 'transport_dataset.csv', index=False, encoding='utf-8-sig')
print(transport_df.shape)
print(transport_df.head())

# %% [markdown]
# ## 7. 인구 밀집 학습 데이터 (자치구 × 일)
# - 정답 : `일최대인구수`
# - 특성 : 월·요일·주말 여부, 전일 생활인구, 7일 전 같은 요일의 일최대인구수
# - 전일 값 원리 : 구별로 묶은 뒤 `shift(1)`로 하루씩 밀기
# - `요일`·`월`·`주말여부`는 예측 노트북에서 모델 입력에 항상 포함

# %%
TARGET_POP = '일최대인구수'

pop_df = pop.copy()
pop_df['월'] = pop_df['ds'].dt.month
pop_df['요일'] = pop_df['ds'].dt.dayofweek          # 0=월요일 ... 6=일요일
pop_df['주말여부'] = (pop_df['요일'] >= 5).astype(int)

lag1 = pop_df.groupby('District')[pop_cols].shift(1)
lag1.columns = ['전일_' + c for c in pop_cols]
pop_df['7일전_' + TARGET_POP] = pop_df.groupby('District')[TARGET_POP].shift(7)

population_df = pd.concat(
    [pop_df[['ds', 'District', '월', '요일', '주말여부', '7일전_' + TARGET_POP]], lag1, pop_df[[TARGET_POP]]],
    axis=1).dropna().reset_index(drop=True)

population_df.to_csv(ML_DATA_DIR / 'population_dataset.csv', index=False, encoding='utf-8-sig')
print(population_df.shape)

# %% [markdown]
# ## 8. 특성 선택 (상관계수 기준)
# - 결측률 20% 초과 컬럼 제외 : 행 손실 방지
# - 정답과 상관 |r| < 0.3 제외 : 직선 관계가 약한 컬럼
# - 이미 고른 컬럼과 |r| ≥ 0.9 제외 : 같은 정보 반복(다중공선성) 방지
# - 추가 시 완전행 보존율 70% 미만 제외 : 빈 값 겹침으로 행이 과도하게 줄어드는 것 방지
# - 빈 값은 평균·0으로 채우지 않음 : 시계열 왜곡 방지
# - `월`은 상관계수 대신 원-핫 인코딩으로 모델에 항상 포함 (계절 효과는 직선 관계가 아님)

# %%
def select_features(df, target, candidates, min_corr=0.3, max_inter_corr=0.9,
                    max_missing=0.20, min_row_retention=0.70):
    rows = []
    usable = []
    for col in candidates:
        missing = df[col].isna().mean()
        if missing > max_missing:
            rows.append([col, np.nan, '제외', f'결측 {missing:.0%} > {max_missing:.0%}'])
        else:
            usable.append(col)

    corr_target = df[usable + [target]].corr()[target].drop(target)
    selected = []
    for col in corr_target.abs().sort_values(ascending=False).index:
        r = corr_target[col]
        if pd.isna(r):
            rows.append([col, r, '제외', '상관계수 계산 불가'])
            continue
        if abs(r) < min_corr:
            rows.append([col, r, '제외', f'정답과 상관 약함 (|r| < {min_corr})'])
            continue
        similar = [s for s in selected if abs(df[col].corr(df[s])) >= max_inter_corr]
        if similar:
            rows.append([col, r, '제외', f'{similar[0]}와 너무 비슷함'])
            continue
        retention = df[selected + [col, target]].notna().all(axis=1).mean()
        if retention < min_row_retention:
            rows.append([col, r, '제외', f'추가 시 완전행 보존율 {retention:.0%} < {min_row_retention:.0%}'])
            continue
        selected.append(col)
        rows.append([col, r, '선택', f'완전행 보존율 {retention:.0%}'])

    return selected, pd.DataFrame(rows, columns=['컬럼', '정답과_상관계수', '결과', '이유'])


def draw_heatmap(df, cols, title, save_path):
    corr = df[cols].corr()
    mask = np.triu(np.ones_like(corr, dtype=bool))
    plt.figure(figsize=(2 + len(cols) * 0.8, 1 + len(cols) * 0.7))
    sns.heatmap(corr, vmin=-1, vmax=1, annot=True, fmt='.2f', cmap='Blues', mask=mask)
    plt.title(title)
    plt.tight_layout()
    plt.savefig(save_path, bbox_inches='tight')
    plt.show()

# %%
topics = {
    'transport':  (transport_df,  'transport_cnt', ['ds', 'District', '출처', '월']),
    'population': (population_df, TARGET_POP,      ['ds', 'District']),
}

selected_features = {}
for topic, (df, target, keys) in topics.items():
    candidates = [c for c in df.select_dtypes('number').columns if c != target and c not in keys]
    selected, result = select_features(df, target, candidates)
    selected_features[topic] = selected

    print(f'===== {topic} (정답: {target}, 전체 {len(df)}행) =====')
    print(result.to_string(index=False))
    result.to_csv(ML_DATA_DIR / f'features_{topic}.csv', index=False, encoding='utf-8-sig')

    selected_df = df[keys + selected + [target]].dropna(subset=selected + [target]).reset_index(drop=True)
    selected_df.to_csv(ML_DATA_DIR / f'{topic}_selected.csv', index=False, encoding='utf-8-sig')
    print(f'선택 변수: {selected}')
    print(f'-> {topic}_selected.csv : {len(df)}행 중 {len(selected_df)}행 저장\n')

    if selected:
        draw_heatmap(df, selected + [target], f'{topic} 선택 컬럼 상관계수', RESULT_DIR / f'fig_corr_{topic}.png')

# %% [markdown]
# ## 9. 미래 예측용 입력 행 (`transport_future.csv`)
# - 뼈대 : 마지막 실제 달 다음부터 `FORECAST_MONTHS`개월 × 25개 구
# - 특성 계산 : 6장과 같은 `make_transport_features` 사용 (학습 데이터와 계산 방식 일치)
# - `전월_transport_cnt` : 첫 달만 실제 값, 이후 달은 빈 값 → 예측 노트북에서 전달 예측값으로 채움 (재귀 예측)
# - 그 외 아직 없는 값(작년 의료이용 등) : 구별 가장 최근 값으로 채움 (최근 수준 유지 가정)

# %%
last_month = monthly['ds'].max()
future_months = pd.date_range(last_month + pd.DateOffset(months=1), periods=FORECAST_MONTHS, freq='MS')
base = pd.DataFrame([(m, gu) for m in future_months for gu in GU_LIST], columns=['ds', 'District'])

future = make_transport_features(base, hist)

fill_cols = [c for c in future.columns
             if c not in ['ds', 'District', '연도', '월', '전월_transport_cnt']]
last_known = transport_df.sort_values('ds').groupby('District')[fill_cols].last()
for c in fill_cols:
    # 구 이름으로 최근 값을 찾아 빈칸에만 채우기
    future[c] = future[c].fillna(future['District'].map(last_known[c]))
future = future[transport_df.columns.drop(['출처', 'transport_cnt'])]
future = future.sort_values(['ds', 'District']).reset_index(drop=True)

future.to_csv(ML_DATA_DIR / 'transport_future.csv', index=False, encoding='utf-8-sig')
print(f'예측 대상 : {future_months[0]:%Y-%m} ~ {future_months[-1]:%Y-%m}, {len(future)}행')
print('전월_transport_cnt 가 채워진 행 (첫 달만):', future['전월_transport_cnt'].notna().sum())

# %% [markdown]
# ## 10. 결과 요약

# %%
for f in ['transport_dataset.csv', 'transport_selected.csv', 'transport_future.csv', 'features_transport.csv',
          'population_dataset.csv', 'population_selected.csv', 'features_population.csv', 'excluded_columns.csv']:
    df = pd.read_csv(ML_DATA_DIR / f, encoding='utf-8-sig')
    print(f'{f:28s} {df.shape}')

for topic, cols in selected_features.items():
    print(f'\n{topic} 선택 특성 {len(cols)}개 : {cols}')
