# =============================================================
# ماژول M01 — داده، متغیر و ساختار مجموعه‌داده | مسیر Python
# اجرا: از داخل همین پوشه   python M01_walkthrough.py
# یا سلول‌به‌سلول در VS Code / Jupyter (هر «# %%» یک سلول است).
# نیاز: pandas
# =============================================================

# %% گام ۱: خواندن داده (درس ۱.۱)
import pandas as pd

uti = pd.read_csv("../data/M01_uti.csv")
print(uti.shape)       # (سطر، ستون)
print(uti.head())
print(uti.dtypes)      # نوعی که pandas برای هر ستون حدس زده است

# %% گام ۲: تعیین نوع متغیرها (درس ۱.۲)
# متغیرهای اسمی -> category
uti["sex"] = uti["sex"].map({1: "Female", 2: "Male"}).astype("category")
uti["ward"] = pd.Categorical(
    uti["ward"].map({1: "Internal", 2: "Surgery", 3: "ICU"}),
    categories=["Internal", "Surgery", "ICU"])
uti["organism"] = uti["organism"].astype("category")
uti["cipro_res"] = uti["cipro_res"].map(
    {0: "Susceptible", 1: "Resistant"}).astype("category")
# متغیر ترتیبی -> category با ordered=True
uti["severity"] = pd.Categorical(
    uti["severity"].map({1: "Mild", 2: "Moderate", 3: "Severe"}),
    categories=["Mild", "Moderate", "Severe"], ordered=True)
print(uti.dtypes)

# %% گام ۳: داده‌های گمشده (درس ۱.۴)
print(uti["crp"].describe())          # min = -99 ! این مقدار واقعی نیست
uti["crp"] = uti["crp"].replace(-99, pd.NA).astype("Float64")
print(uti["crp"].describe())
print(uti.isna().sum())               # تعداد گمشده در هر ستون
print(uti["crp"].notna().sum())       # تعداد مقادیر معتبر CRP

# %% گام ۴: کد عددی ≠ عدد (درس ۱.۲)
raw = pd.read_csv("../data/M01_uti.csv")
print(raw["ward"].mean())             # محاسبه‌پذیر، ولی بی‌معنا
print(uti["ward"].value_counts(sort=False))
print(uti["severity"].value_counts(sort=False))

# %% گام ۵: ساختار پهن و بلند (درس ۱.۳)
wide = pd.read_csv("../data/M01_crp_wide.csv")
print(wide)
long = wide.melt(id_vars="id", var_name="day", value_name="crp")
long["day"] = long["day"].str.replace("crp_d", "").astype(int)
long = long.sort_values(["id", "day"]).reset_index(drop=True)
print(long.head(6))
print(long.shape)

# %% گام ۶: ذخیرهٔ داده با حفظ نوع ستون‌ها
uti.to_pickle("M01_uti_labeled.pkl")  # category ها حفظ می‌شوند
# بازخوانی: uti = pd.read_pickle("M01_uti_labeled.pkl")
