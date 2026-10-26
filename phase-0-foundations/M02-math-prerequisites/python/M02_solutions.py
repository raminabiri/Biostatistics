# =============================================================
# ماژول M02 — ریاضیات پیش‌نیاز | مسیر Python | حل تمرین‌های عملی ع۱ تا ع۷
# اجرا از داخل همین پوشه:  python M02_solutions.py
# =============================================================
import numpy as np
import pandas as pd

d = pd.read_csv("../data/M02_clinic.csv")
g = pd.read_csv("../data/M02_genes.csv")

# %% ع۱: BMI = وزن / (قد به متر)**2
d["bmi"] = d["weight_kg"] / (d["height_cm"] / 100) ** 2
print("ع۱:", round(d["bmi"].mean(), 2), "| BMI>=30:", (d["bmi"] >= 30).sum())  # 29.44 | 10

# %% ع۲: تغییر مطلق و درصد تغییر فشار خون
d["sbp_change"] = d["sbp_12"] - d["sbp_0"]
d["sbp_pct"] = d["sbp_change"] / d["sbp_0"] * 100
print("ع۲:", round(d["sbp_change"].mean(), 2), "mmHg |",        # -14.96
      round(d["sbp_pct"].mean(), 2), "% |",                       # -10.01
      "reduced >=10:", (d["sbp_change"] <= -10).sum())            # 17

# %% ع۳: تبدیل واحد قند خون
d["glucose_mmol"] = d["glucose_mgdl"] / 18
print("ع۳:", round(d["glucose_mgdl"].mean(), 2), "mg/dL =",       # 151.42
      round(d["glucose_mmol"].mean(), 2), "mmol/L")               # 8.41

# %% ع۴: لگاریتم و میانگین هندسی تری‌گلیسرید
d["log_tg"] = np.log10(d["tg_mgdl"])      # np.log() لگاریتم طبیعی است
print("ع۴: mean", round(d["tg_mgdl"].mean(), 2),                 # 207.71
      "| median", d["tg_mgdl"].median(),                          # 208.5
      "| mean log10", round(d["log_tg"].mean(), 4),               # 2.2717
      "| geometric mean", round(10 ** d["log_tg"].mean(), 2))     # 186.93

# %% ع۵: نمادهای Σ روی سن
x = d["age"]
print("ع۵: n", len(x), "| Σx", x.sum(), "| x̄", x.mean(),        # 24 | 1401 | 58.375
      "| Σx²", (x ** 2).sum(),                                    # 84759
      "| SS", ((x - x.mean()) ** 2).sum())                        # 2975.625

# %% ع۶: fold change و log2
g["fc"] = g["treated"] / g["control"]
g["log2fc"] = np.log2(g["fc"])
print(g.round(2))
print("ع۶: |log2FC|>=1:", (g["log2fc"].abs() >= 1).sum(),         # 7
      "| up:", (g["log2fc"] >= 1).sum(),                          # 6
      "| down:", (g["log2fc"] <= -1).sum())                       # 1

# %% ع۷: کاهش نمایی غلظت دارو
t = np.arange(0, 25, 2)
conc = 100 * 0.5 ** (t / 4)
print(pd.DataFrame({"t": t, "conc": conc.round(2)}))
print("ع۷: first t < 10:", t[conc < 10][0],                       # 14
      "| exact:", round(4 * np.log2(10), 2))                      # 13.29
