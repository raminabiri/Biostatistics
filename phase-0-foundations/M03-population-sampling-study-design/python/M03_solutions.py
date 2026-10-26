# =============================================================
# ماژول M03 — جامعه، نمونه و طرح مطالعه | مسیر Python | حل تمرین‌های عملی
# اجرا از داخل همین پوشه:  python M03_solutions.py
# =============================================================
import numpy as np
import pandas as pd

f = pd.read_csv("../data/M03_frame.csv")
tr = pd.read_csv("../data/M03_trial.csv")


def summ(x, label):
    """خلاصهٔ یک نمونه: n، میانگین فشار، درصد فشار خون بالا"""
    print(f"{label:12s} n={len(x):3d}  mean_sbp={x['sbp'].mean():.2f}  "
          f"prev_htn={100 * x['htn'].mean():.2f}%")


# %% ع۱: پارامترهای جامعه
summ(f, "population")                                       # 129.88, 27.50%
print((100 * f.groupby("district")["htn"].mean()).round(2))  # 38.00 24.38 22.86 18.00

# %% ع۲: نمونهٔ تصادفی ساده (۶۰ کوچک‌ترین u)
srs = f.nsmallest(60, "u")
summ(srs, "SRS")                                            # 133.12, 33.33%
print(srs["id"].head().tolist())                            # [552, 542, 273, 104, 361]

# %% ع۳: نمونهٔ سیستماتیک (k = 10، شروع 7)
sys_s = f[f["id"].isin(range(7, 601, 10))]
summ(sys_s, "systematic")                                   # 131.70, 31.67%

# %% ع۴: نمونهٔ طبقه‌ای متناسب (20/16/14/10)
alloc = (f["district"].value_counts(sort=False) / len(f) * 60).round().astype(int)
print(alloc.to_dict())                                      # {1: 20, 2: 16, 3: 14, 4: 10}
strat = pd.concat([f[f["district"] == d].nsmallest(k, "u") for d, k in alloc.items()])
summ(strat, "stratified")                                   # 135.25, 38.33%

# %% ع۵: نمونهٔ خوشه‌ای (بلوک‌های 4، 15، 27)
clus = f[f["block"].isin([4, 15, 27])]
summ(clus, "cluster")                                       # 129.28, 33.33%
print(clus["district"].value_counts().sort_index().to_dict())  # {1: 20, 2: 20, 4: 20}

# %% ع۶: تصادفی‌سازی بلوکی (بلوک 4 تایی؛ 2 کوچک‌ترین u ← A)
tr["block"] = (tr["id"] - 1) // 4 + 1
tr["group"] = np.where(tr.groupby("block")["u"].rank() <= 2, "A", "B")
print(tr["group"].value_counts().to_dict())                 # {'A': 12, 'B': 12}
print(tr.loc[tr["group"] == "A", "id"].tolist())            # [2, 3, 7, 8, 10, 11, 14, 15, 17, 20, 23, 24]

# %% ع۷: نمونهٔ در دسترس (۶۰ اولین مراجعه‌کننده)
conv = f[f["visit_order"] <= 60]
summ(conv, "convenience")                                   # 148.67, 95.00%
print("bias:", round(100 * conv["htn"].mean() - 100 * f["htn"].mean(), 1))  # +67.5

# %% ع۸ (فقط R و Python): شبیه‌سازی ۱۰۰۰ نمونه
rng = np.random.default_rng(2026)
B = 1000
p_srs = [f["htn"].iloc[rng.choice(len(f), 60, replace=False)].mean() for _ in range(B)]
p_str = []
for _ in range(B):
    idx = np.concatenate([rng.choice(np.flatnonzero(f["district"] == d), k, replace=False)
                          for d, k in alloc.items()])
    p_str.append(f["htn"].iloc[idx].mean())
print("SRS  mean=%.2f sd=%.2f" % (100 * np.mean(p_srs), 100 * np.std(p_srs, ddof=1)))
print("STR  mean=%.2f sd=%.2f" % (100 * np.mean(p_str), 100 * np.std(p_str, ddof=1)))
# هر دو ≈ 27.5؛ پراکندگی طبقه‌ای کمی کمتر. اعداد دقیق با R فرق دارد (مولد تصادفی متفاوت).
