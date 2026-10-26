# =============================================================
# ماژول M04 — آماده‌سازی و پاک‌سازی داده | مسیر Python | حل تمرین‌های عملی
# اجرا از داخل همین پوشه:  python M04_solutions.py
# اجرای پروتکل P1 تا P11 (کدبوک) + دفترچهٔ پاک‌سازی خودکار
# =============================================================
import numpy as np
import pandas as pd

raw = pd.read_csv("../data/M04_registry_raw.csv")   # فایل خام فقط خوانده می‌شود
log = []                                             # دفترچهٔ پاک‌سازی


def log_change(rule, pids, variable, old, new):
    for p, o in zip(pids, old):
        log.append(dict(rule=rule, pid=p, variable=variable, old=str(o), new=str(new)))


# %% ع۱: غربال اولیه
print("ع۱:", len(raw), raw["pid"].nunique(), raw.duplicated().sum())   # 42 40 1
print(raw["sex"].value_counts(dropna=False))                          # 11 شکل
print("smoker forms:", raw["smoker"].nunique(dropna=False))           # 9

# %% ع۲: P1 تا P4
dup = raw[raw.duplicated()]
log_change("P1", dup["pid"], "row", ["exact duplicate"] * len(dup), "removed")
d = raw.drop_duplicates()                                             # P1
d = d.sort_values(["pid", "entry_no"])
key_dup = d[d["pid"].duplicated()]
log_change("P2", key_dup["pid"], "row", "entry_no=" + key_dup["entry_no"].astype(str), "removed")
d = d.drop_duplicates(subset="pid", keep="first").copy()              # P2
print("rows:", len(d))                                                # 40

d["sex"] = d["sex"].str.strip().str.upper().str[0]                    # P3
print(d["sex"].value_counts().to_dict())                              # F 14, M 26
first = d["smoker"].str.strip().str.upper().str[0]                    # P4
d["smoker"] = first.map({"Y": "yes", "N": "no"})                      # بقیه (و گمشده) ← NaN
print(d["smoker"].value_counts(dropna=False).to_dict())               # no 35, yes 4, NaN 1

# %% ع۳: P5 تا P7
m = d["height_cm"] < 3                                                # P5
log_change("P5", d.loc[m, "pid"], "height_cm", d.loc[m, "height_cm"], "x100")
d.loc[m, "height_cm"] = d.loc[m, "height_cm"] * 100
m = ~d["height_cm"].between(120, 220)
log_change("P5", d.loc[m, "pid"], "height_cm", d.loc[m, "height_cm"], np.nan)
d.loc[m, "height_cm"] = np.nan
m = ~d["weight_kg"].between(30, 250)                                  # P6
log_change("P6", d.loc[m, "pid"], "weight_kg", d.loc[m, "weight_kg"], np.nan)
d.loc[m, "weight_kg"] = np.nan
m = d["sbp"] == -99                                                   # P7
log_change("P7", d.loc[m, "pid"], "sbp", d.loc[m, "sbp"], np.nan)
d.loc[m, "sbp"] = np.nan
m = d["sbp"].notna() & ~d["sbp"].between(70, 260)
log_change("P7", d.loc[m, "pid"], "sbp", d.loc[m, "sbp"], np.nan)
d.loc[m, "sbp"] = np.nan
m = d["dbp"].notna() & ~d["dbp"].between(40, 150)
d.loc[m, "dbp"] = np.nan

# %% ع۴: P8 تا P11
m = d["dbp"] >= d["sbp"]                                              # P8 (NaN ← False)
log_change("P8", d.loc[m, "pid"], "sbp,dbp", d.loc[m, "sbp"].astype(str) + " " + d.loc[m, "dbp"].astype(str), np.nan)
d.loc[m, ["sbp", "dbp"]] = np.nan
m = (d["sex"] == "M") & (d["pregnant"] == "yes")                      # P9
log_change("P9", d.loc[m, "pid"], "pregnant", d.loc[m, "pregnant"], np.nan)
d.loc[d["sex"] == "M", "pregnant"] = np.nan
d["dob"] = pd.to_datetime(d["dob"])
d["visit_date"] = pd.to_datetime(d["visit_date"])
m = d["dob"] > d["visit_date"]                                        # P10
log_change("P10", d.loc[m, "pid"], "dob", d.loc[m, "dob"].dt.date, np.nan)
d.loc[m, "dob"] = pd.NaT


def full_years(dob, visit):
    """سن کامل: اختلاف سال‌ها، منهای ۱ اگر تولد امسال هنوز نرسیده"""
    before_bday = (visit.dt.month < dob.dt.month) | (
        (visit.dt.month == dob.dt.month) & (visit.dt.day < dob.dt.day))
    return visit.dt.year - dob.dt.year - before_bday.astype(int)


d["age"] = full_years(d["dob"], d["visit_date"])                     # P11
under = d[d["age"] < 18]
log_change("P11", under["pid"], "row", ["age<18"] * len(under), "excluded")
a = d[d["age"].isna() | (d["age"] >= 18)].copy()
print("analysis n:", len(a))                                         # 39
print(pd.DataFrame(log))                                             # ۱۱ سطر

# %% ع۵: متغیرهای محاسباتی
a["bmi"] = a["weight_kg"] / (a["height_cm"] / 100) ** 2
a["age_group"] = pd.cut(a["age"], [-np.inf, 39, 59, np.inf], labels=["<40", "40-59", ">=60"])
print("ع۵:", round(a["age"].mean(), 2), a["age"].notna().sum(),     # 48.42 38
      round(a["bmi"].mean(), 2), a["bmi"].notna().sum(),             # 26.43 37
      (a["bmi"] >= 30).sum(),                                         # 5
      round(a["sbp"].mean(), 2), a["sbp"].notna().sum())             # 143.0 36
print(a["age_group"].value_counts(sort=False, dropna=False).to_dict())  # 14 14 10 NaN:1

# %% ع۶: تجمیع آزمایش‌ها و ادغام
labs = pd.read_csv("../data/M04_labs.csv")
print("labs:", len(labs), labs["pid"].nunique())                     # 83 36
lab_pt = labs.groupby("pid").agg(mean_ldl=("ldl", "mean"), n_tests=("ldl", "size")).reset_index()
mrg = a.merge(lab_pt, on="pid", how="left", validate="one_to_one")   # ادغام چپ
print("merged rows:", len(mrg))                                       # 39
print("no labs:", mrg.loc[mrg["n_tests"].isna(), "pid"].tolist())    # [4, 15, 23, 30, 38]
print("mean LDL:", round(mrg["mean_ldl"].mean(), 2))                 # 120.58
print(mrg["n_tests"].value_counts(dropna=False).sort_index().to_dict())  # 1:5 2:12 3:17 NaN:5
print("unmatched lab pids:", sorted(set(lab_pt["pid"]) - set(a["pid"])))  # [3, 99]

# %% ع۷: الحاق مرکز ۲
s2 = pd.read_csv("../data/M04_site2.csv", parse_dates=["dob", "visit_date"])
s2["age"] = full_years(s2["dob"], s2["visit_date"])
s2["bmi"] = s2["weight_kg"] / (s2["height_cm"] / 100) ** 2
s2["age_group"] = pd.cut(s2["age"], [-np.inf, 39, 59, np.inf], labels=["<40", "40-59", ">=60"])
s2.loc[s2["sex"] == "M", "pregnant"] = np.nan
a["site"], s2["site"] = 1, 2
final = pd.concat([a, s2[a.columns]], ignore_index=True)
print("ع۷:", len(final), final["pid"].nunique(),                     # 44 44
      final["site"].value_counts().sort_index().to_dict(),           # {1: 39, 2: 5}
      round(final["sbp"].mean(), 2), final["sbp"].notna().sum())     # 143.0 41

# final.to_csv("M04_final_clean.csv", index=False)
# pd.DataFrame(log).to_csv("M04_cleaning_log.csv", index=False)
