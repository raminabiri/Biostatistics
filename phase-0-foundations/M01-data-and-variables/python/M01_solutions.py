# =============================================================
# ماژول M01 | مسیر Python | حل تمرین‌های عملی ع۱ تا ع۷
# پیش از نگاه کردن به این فایل، تمرین‌ها را خودتان حل کنید.
# اجرا از داخل همین پوشه.
# =============================================================
import pandas as pd

# %% ع۱: خواندن فایل و ابعاد داده
uti = pd.read_csv("../data/M01_uti.csv")
print("ع۱:", uti.shape)                        # (30, 12)

# %% ع۲: تعریف نوع و برچسب متغیرها
uti["sex"] = uti["sex"].map({1: "Female", 2: "Male"}).astype("category")
uti["ward"] = pd.Categorical(
    uti["ward"].map({1: "Internal", 2: "Surgery", 3: "ICU"}),
    categories=["Internal", "Surgery", "ICU"])
uti["organism"] = uti["organism"].astype("category")
uti["cipro_res"] = uti["cipro_res"].map(
    {0: "Susceptible", 1: "Resistant"}).astype("category")
uti["severity"] = pd.Categorical(
    uti["severity"].map({1: "Mild", 2: "Moderate", 3: "Severe"}),
    categories=["Mild", "Moderate", "Severe"], ordered=True)
print("ع۲:\n", uti.dtypes)
print("severity ordered?", uti["severity"].cat.ordered)   # True

# %% ع۳: تعریف کد گمشده
print("ع۳: mean with -99 =", round(uti["crp"].mean(), 2))  # 35.1 — اشتباه
uti["crp"] = uti["crp"].replace(-99, pd.NA).astype("Float64")
print("valid CRP =", uti["crp"].notna().sum())             # 28
print("mean CRP =", round(float(uti["crp"].mean()), 2))    # 44.68
print("missing WBC =", uti["wbc"].isna().sum())            # 1

# %% ع۴: میانگین کد بخش در برابر جدول فراوانی
print("ع۴: mean ward code =", uti["ward"].cat.codes.add(1).mean())  # 1.8
print(uti["ward"].value_counts(sort=False))                # 12, 12, 6
print(uti["organism"].value_counts(sort=False))            # 17, 9, 4

# %% ع۵: جدول توافقی جنس × مقاومت
print("ع۵:\n", pd.crosstab(uti["sex"], uti["cipro_res"]))  # زن مقاوم = 7

# %% ع۶: تبدیل پهن به بلند
wide = pd.read_csv("../data/M01_crp_wide.csv")
long = wide.melt(id_vars="id", var_name="day", value_name="crp")
long["day"] = long["day"].str.replace("crp_d", "").astype(int)
print("ع۶:", long.shape)                                   # (24, 3)

# %% ع۷: ذخیره
uti.to_pickle("M01_uti_labeled.pkl")
print("ع۷:\n", pd.read_pickle("M01_uti_labeled.pkl").dtypes)
