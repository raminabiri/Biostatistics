# M04 در Python — پاک‌سازی با pandas، تاریخ، ادغام و الحاق

[← ماژول M04](../README.md) | [صفحهٔ مسیر Python](../../../tracks/python.md)

**فایل:** [`M04_solutions.py`](M04_solutions.py) (با Python 3، pandas 2.3 اجرا و جواب‌ها کنترل شده‌اند). کل پروتکل P1 تا P11 + دفترچهٔ پاک‌سازی خودکار.

## بخش آموزشی

### غربال

```python
raw = pd.read_csv("../data/M04_registry_raw.csv")
raw["sex"].value_counts(dropna=False)     # کدهای ناهمسان
raw["sbp"].describe()                      # کمینه و بیشینه
raw.duplicated().sum()                     # تکرار کامل
raw[raw["pid"].duplicated(keep=False)]     # همهٔ سطرهای کلید تکراری
```

### حذف تکرار

```python
d = raw.drop_duplicates()                                       # P1
d = d.sort_values(["pid", "entry_no"]).drop_duplicates("pid", keep="first")   # P2
```

### پاک‌سازی متن (`.str`)

```python
d["sex"].str.strip().str.upper().str[0]
d["smoker"].str.strip().str.upper().str[0].map({"Y": "yes", "N": "no"})
```
`.map()` هر مقداری را که در دیکشنری نباشد (از جمله گمشده) `NaN` می‌کند؛ دقیقاً همان P4.

### جایگزینی شرطی با `.loc`

```python
m = d["height_cm"] < 3                          # ماسک True/False
d.loc[m, "height_cm"] = d.loc[m, "height_cm"] * 100
d.loc[~d["weight_kg"].between(30, 250), "weight_kg"] = np.nan
```

### تاریخ و سن

```python
d["dob"] = pd.to_datetime(d["dob"])
(d["visit_date"] - d["dob"]).dt.days            # تفاضل به روز
```
سن کامل: سال‌ها منهای ۱ اگر تولد امسال نرسیده (تابع `full_years` در فایل حل).

### تجمیع، ادغام، الحاق

```python
labs.groupby("pid").agg(mean_ldl=("ldl", "mean"), n_tests=("ldl", "size"))
a.merge(lab_pt, on="pid", how="left", validate="one_to_one")
pd.concat([site1, site2[site1.columns]], ignore_index=True)
```
`validate="one_to_one"` اگر ادغام ناخواسته یک‌به‌چند شود **خطا** می‌دهد: ابزار بسیار خوبی برای کنترل (درس ۴.۴).

## تمرین‌های عملی (ع۱ تا ع۷)

این تمرین‌ها در هر پنج مسیر **یکسان‌اند** و جواب عددی یکسان دارند. پیش از شروع، **پروتکل P1 تا P11** را در [کدبوک](../data/codebook.md) بخوانید. فایل خام را ویرایش نکنید.

| شماره | سطح | تمرین | درس |
|---|---|---|---|
| ع۱ | ۱ | **غربال:** `M04_registry_raw.csv` چند سطر و چند `pid` یکتا دارد؟ چند تکرار کامل و چند تکرار کلید؟ `sex` و `smoker` چند شکل نوشتاری دارند؟ | ۴.۲ |
| ع۲ | ۱ | **P1 تا P4:** تکرارها را حذف و متن را یکسان کنید. چند سطر می‌ماند؟ تعداد زن/مرد و سیگاری yes/no/گمشده؟ | ۴.۲، ۴.۳ |
| ع۳ | ۲ | **P5 تا P7 (بازه):** چند قد به متر بود؟ پس از اجرا، چند قد، وزن و sbp گمشده شد؟ | ۴.۲ |
| ع۴ | ۲ | **P8 تا P11 (سازگاری):** چند مورد dbp ≥ sbp، مرد باردار، تولد بعد از ویزیت و سن زیر ۱۸؟ دادهٔ تحلیل چند بیمار دارد؟ | ۴.۲، ۴.۳ |
| ع۵ | ۲ | **متغیرهای محاسباتی** در دادهٔ تحلیل: میانگین سن، میانگین BMI، تعداد BMI ≥ ۳۰، فراوانی گروه‌های سنی، میانگین sbp (هر کدام با n معتبر). | ۴.۳ |
| ع۶ | ۳ | **تجمیع و ادغام:** `M04_labs.csv` را به سطح بیمار تجمیع کنید (تعداد آزمایش و میانگین LDL) و با دادهٔ تحلیل ادغام چپ کنید. چند بیمار آزمایش ندارند؟ میانگین «میانگین LDL بیماران»؟ توزیع تعداد آزمایش؟ کدام شناسه‌های آزمایش با دادهٔ تحلیل جفت نشدند؟ | ۴.۴ |
| ع۷ | ۳ | **الحاق:** مرکز ۲ را (با همان متغیرهای محاسباتی و ستون `site`) به دادهٔ تحلیل اضافه کنید. تعداد سطر نهایی، تعداد `pid` یکتا و میانگین sbp نهایی؟ | ۴.۴ |

<details>
<summary><b>جواب‌های نهایی (فقط برای کنترل، پس از حل)</b></summary>

| | جواب |
|---|---|
| ع۱ | **42** سطر، **40** pid؛ **1** تکرار کامل (pid 12) و **1** تکرار کلید (pid 27)؛ `sex`: **11** شکل؛ `smoker`: **9** شکل (با خالی) |
| ع۲ | **40** سطر؛ زن **14**، مرد **26**؛ سیگاری yes **4**، no **35**، گمشده **1** |
| ع۳ | قد به متر: **1** (pid 5 ← 168)؛ گمشده: قد **1** (pid 18)، وزن **1** (pid 9)، sbp **2** (pid 31 کد ‎-99، pid 14 مقدار ۱۴۵۰) |
| ع۴ | dbp ≥ sbp: **1** (pid 22)؛ مرد باردار: **1** (pid 1)؛ تولد بعد از ویزیت: **1** (pid 35)؛ زیر ۱۸: **1** (pid 3) ← دادهٔ تحلیل **39** بیمار |
| ع۵ | سن **48.42** (n = 38)؛ BMI **26.43** (n = 37)؛ BMI ≥ 30: **5**؛ گروه‌ها: <40: **14**، 40–59: **14**، ≥60: **10**، نامعلوم: 1؛ sbp **143.00** (n = 36) |
| ع۶ | ۸۳ سطر آزمایش از ۳۶ بیمار؛ ادغام چپ: **39** سطر (بدون تکرار)؛ بدون آزمایش: **5** (pid 4، 15، 23، 30، 38)؛ میانگین LDL بیماران **120.58**؛ تعداد آزمایش: ۱ ← **5**، ۲ ← **12**، ۳ ← **17**؛ بی‌جفت: pid **3** (خارج‌شده به‌خاطر سن) و **99** (ناشناخته) |
| ع۷ | **44** سطر، **44** pid یکتا (مرکز ۱: ۳۹، مرکز ۲: ۵)؛ sbp **143.00** (n = 41) |

دفترچهٔ پاک‌سازی کامل این تمرین‌ها **۱۱ ردیف** دارد (P1، P2، دو P5، P6، دو P7، P8، P9، P10، P11).

</details>

### حل تمرین‌ها

کد کامل: [`M04_solutions.py`](M04_solutions.py). خلاصه:

<details>
<summary><b>حل ع۱ و ع۲</b></summary>

```python
len(raw), raw["pid"].nunique(), raw.duplicated().sum()      # 42 40 1
d = raw.drop_duplicates()
d = d.sort_values(["pid", "entry_no"]).drop_duplicates("pid", keep="first").copy()  # 40
d["sex"] = d["sex"].str.strip().str.upper().str[0]
d["smoker"] = d["smoker"].str.strip().str.upper().str[0].map({"Y": "yes", "N": "no"})
d["sex"].value_counts(); d["smoker"].value_counts(dropna=False)
```

</details>

<details>
<summary><b>حل ع۳</b></summary>

```python
m = d["height_cm"] < 3; d.loc[m, "height_cm"] *= 100                 # pid 5
d.loc[~d["height_cm"].between(120, 220), "height_cm"] = np.nan       # pid 18
d.loc[~d["weight_kg"].between(30, 250), "weight_kg"] = np.nan        # pid 9
d.loc[d["sbp"] == -99, "sbp"] = np.nan                               # pid 31
d.loc[d["sbp"].notna() & ~d["sbp"].between(70, 260), "sbp"] = np.nan # pid 14
```
`between()` برای `NaN` جواب `False` می‌دهد؛ برای همین در sbp، `notna()` را اضافه کرده‌ایم تا NaN ها دوباره «خارج از بازه» شمرده نشوند.

</details>

<details>
<summary><b>حل ع۴</b></summary>

```python
m = d["dbp"] >= d["sbp"]; d.loc[m, ["sbp", "dbp"]] = np.nan          # pid 22
d.loc[d["sex"] == "M", "pregnant"] = np.nan                          # pid 1
d.loc[d["dob"] > d["visit_date"], "dob"] = pd.NaT                    # pid 35
d["age"] = full_years(d["dob"], d["visit_date"])
a = d[d["age"].isna() | (d["age"] >= 18)].copy()                     # 39
```

</details>

<details>
<summary><b>حل ع۵</b></summary>

```python
a["bmi"] = a["weight_kg"] / (a["height_cm"] / 100) ** 2
a["age_group"] = pd.cut(a["age"], [-np.inf, 39, 59, np.inf], labels=["<40", "40-59", ">=60"])
a["age"].mean(), a["bmi"].mean(), (a["bmi"] >= 30).sum(), a["sbp"].mean()
# 48.42, 26.43, 5, 143.0
```

</details>

<details>
<summary><b>حل ع۶</b></summary>

```python
lab_pt = labs.groupby("pid").agg(mean_ldl=("ldl", "mean"), n_tests=("ldl", "size")).reset_index()
mrg = a.merge(lab_pt, on="pid", how="left", validate="one_to_one")   # 39
mrg.loc[mrg["n_tests"].isna(), "pid"].tolist()                       # [4, 15, 23, 30, 38]
round(mrg["mean_ldl"].mean(), 2)                                     # 120.58
sorted(set(lab_pt["pid"]) - set(a["pid"]))                           # [3, 99]
```

</details>

<details>
<summary><b>حل ع۷</b></summary>

```python
a["site"], s2["site"] = 1, 2
final = pd.concat([a, s2[a.columns]], ignore_index=True)
len(final), final["pid"].nunique(), round(final["sbp"].mean(), 2)  # 44 44 143.0
```

</details>

## خطاهای رایج

| مشکل | علت | راه‌حل |
|---|---|---|
| `SettingWithCopyWarning` | تغییر روی بُرش داده | `.copy()` پس از فیلتر |
| `MergeError: not a one-to-one merge` | کلید تکراری در یکی از جدول‌ها | اول تجمیع یا حذف تکرار |
| تاریخ‌ها `NaT` شدند | قالب ناشناخته | `pd.to_datetime(x, format="%d/%m/%Y")` |
| `concat` ستون‌های اضافهٔ پر از NaN ساخت | نام ستون‌ها یکسان نبود | پیش از الحاق نام‌ها را یکسان کنید |
