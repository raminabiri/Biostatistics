# M01 در Python — pandas، نوع category، دادهٔ گمشده و تغییر ساختار

[← ماژول M01](../README.md) | [صفحهٔ مسیر Python](../../../tracks/python.md)

**پیش‌نیاز:** درس‌های نظری [۱.۱ تا ۱.۴](../README.md) و نصب Python + pandas ([صفحهٔ مسیر](../../../tracks/python.md)).
**فایل‌ها:** [`M01_walkthrough.py`](M01_walkthrough.py) (آموزش گام‌به‌گام) و [`M01_solutions.py`](M01_solutions.py) (حل تمرین‌ها). هر دو با Python 3 و pandas 2.3 اجرا و خروجی‌ها کنترل شده‌اند. کد با pandas 3 هم سازگار است؛ تنها تفاوت ظاهری، نمایش ستون‌های متنی به‌صورت `str` به‌جای `object` است.
**اجرا:** از داخل پوشهٔ `python/` (چون مسیر داده `../data/` است): `python M01_walkthrough.py`، یا سلول‌به‌سلول در VS Code (هر `# %%` یک سلول).

---

## مقدمهٔ خیلی کوتاه Python/pandas برای تازه‌کارها

```python
x = 5                     # مقدار 5 را در x بگذار
v = [3, 7, 2]             # فهرست
import pandas as pd       # بارگذاری کتابخانه با نام کوتاه pd
d["age"]                  # ستون age از جدول (DataFrame) به نام d
d["age"].mean()           # «متد»: تابعی که به یک شیء چسبیده است
```

در pandas یک **DataFrame** همان جدول دادهٔ مرتب است: هر ستون یک متغیر، هر سطر یک مشاهده.

---

## بخش آموزشی (فایل `M01_walkthrough.py`)

### گام ۱ — خواندن داده (درس ۱.۱)

```python
uti = pd.read_csv("../data/M01_uti.csv")
print(uti.shape)    # (30, 12)
print(uti.dtypes)
```

`dtypes` نشان می‌دهد pandas هر ستون را چه دیده است: `sex` و `ward` ← `int64` (عدد!)، `organism` ← `object` (متن؛ در pandas 3 به‌صورت `str` نمایش داده می‌شود)، `crp` ← `float64` با ‎-99 به‌عنوان یک عدد واقعی.

### گام ۲ — تعیین نوع متغیر با `category` (درس ۱.۲)

| مفهوم آماری | ابزار pandas |
|---|---|
| اسمی | `.astype("category")` |
| ترتیبی | `pd.Categorical(x, categories=[...], ordered=True)` |
| کمّی | `float64` / `int64` — همان‌طور بماند |

```python
uti["ward"] = pd.Categorical(
    uti["ward"].map({1: "Internal", 2: "Surgery", 3: "ICU"}),
    categories=["Internal", "Surgery", "ICU"])
uti["severity"] = pd.Categorical(
    uti["severity"].map({1: "Mild", 2: "Moderate", 3: "Severe"}),
    categories=["Mild", "Moderate", "Severe"], ordered=True)
```

- `.map({کد: برچسب})` همان **برچسب مقدار** SPSS است.
- `categories=[...]` ترتیب نمایش سطوح را تعیین می‌کند؛ بدون آن، pandas آن‌ها را الفبایی مرتب می‌کند.
- `ordered=True` به pandas می‌گوید Mild < Moderate < Severe.

### گام ۳ — کد گمشده ← `NA` (درس ۱.۴)

```python
print(uti["crp"].describe())                  # min = -99 ← علامت خطر
uti["crp"] = uti["crp"].replace(-99, pd.NA).astype("Float64")
print(uti.isna().sum())                       # تعداد گمشده در هر ستون
```

- خانهٔ خالی `wbc` را `read_csv` خودش `NaN` کرده است.
- `Float64` (با F بزرگ) نوع عددی pandas است که `pd.NA` را درست نگه می‌دارد.
- برخلاف R، متدهای pandas مثل `.mean()` **به‌طور پیش‌فرض گمشده‌ها را کنار می‌گذارند** (`skipna=True`). راحت است، ولی یعنی pandas به شما هشدار نمی‌دهد که داده گمشده دارد؛ پس همیشه `isna().sum()` را خودتان نگاه کنید.

### گام ۴ — کد عددی ≠ عدد

```python
raw = pd.read_csv("../data/M01_uti.csv")
print(raw["ward"].mean())                         # 1.8 ← بی‌معنا
print(uti["ward"].value_counts(sort=False))       # خلاصهٔ درست
```

پس از تبدیل به `category`، `uti["ward"].mean()` خطا می‌دهد: pandas از شما در برابر این اشتباه محافظت می‌کند.

### گام ۵ — پهن به بلند با `melt` (درس ۱.۳)

```python
wide = pd.read_csv("../data/M01_crp_wide.csv")
long = wide.melt(id_vars="id", var_name="day", value_name="crp")
long["day"] = long["day"].str.replace("crp_d", "").astype(int)
print(long.shape)   # (24, 3)
```

`id_vars`: ستونی که ثابت می‌ماند؛ بقیهٔ ستون‌ها زیر هم می‌روند. نام ستون‌ها (`crp_d0`، ...) در ستون `day` قرار می‌گیرد و با `str.replace` به عدد روز تبدیل می‌شود. (عکس آن: `long.pivot(index="id", columns="day", values="crp")`.)

### گام ۶ — ذخیره با حفظ نوع ستون‌ها

```python
uti.to_pickle("M01_uti_labeled.pkl")
uti = pd.read_pickle("M01_uti_labeled.pkl")
```

`to_csv` همهٔ category ها را به متن تبدیل می‌کند و ترتیب `severity` از دست می‌رود؛ pickle همه‌چیز را نگه می‌دارد. (برای اشتراک‌گذاری بین زبان‌ها، قالب Parquet با کتابخانهٔ `pyarrow` هم مناسب است.)

---

## تمرین‌های عملی (ع۱ تا ع۷)

این تمرین‌ها در هر پنج مسیر **یکسان‌اند**. پیش از نگاه به حل، خودتان کد بنویسید.

| شماره | تمرین |
|---|---|
| ع۱ | `M01_uti.csv` را بخوانید. داده چند سطر و چند ستون دارد؟ |
| ع۲ | `sex`، `ward`، `organism`، `cipro_res` را category و `severity` را category ترتیبی کنید. نوع همهٔ ستون‌ها را نمایش دهید. |
| ع۳ | میانگین CRP را **پیش** و **پس** از تبدیل ‎-99 به `NA` حساب کنید. پس از تبدیل، CRP و WBC هر کدام چند مقدار معتبر دارند؟ |
| ع۴ | میانگین کد `ward` را حساب کنید و توضیح دهید چرا بی‌معناست. سپس جدول فراوانی `ward` و `organism` را بسازید. |
| ع۵ | چند بیمار **زن** به سیپروفلوکساسین **مقاوم** بودند؟ |
| ع۶ | `M01_crp_wide.csv` را به قالب بلند تبدیل کنید. چند سطر به دست می‌آید؟ |
| ع۷ | دادهٔ برچسب‌دار را با pickle ذخیره و دوباره بخوانید. آیا category ها مانده‌اند؟ |

### حل تمرین‌ها

کد کامل: [`M01_solutions.py`](M01_solutions.py)

<details>
<summary><b>حل ع۱</b></summary>

```python
uti = pd.read_csv("../data/M01_uti.csv")
print(uti.shape)
```
```
(30, 12)
```
**جواب: ۳۰ سطر، ۱۲ ستون.**

</details>

<details>
<summary><b>حل ع۲</b></summary>

```python
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
print(uti.dtypes)
print(uti["severity"].cat.ordered)
```
```
id              int64
age             int64
sex          category
ward         category
organism     category
temp          float64
crp           float64
wbc           float64
pain            int64
severity     category
los             int64
cipro_res    category
True
```

`dtypes` ترتیبی بودن را نشان نمی‌دهد؛ با `.cat.ordered` بررسی می‌کنیم (`True`). `pain` را عمداً عددی نگه داشتیم (درس ۱.۲، دام ۲).

</details>

<details>
<summary><b>حل ع۳</b></summary>

```python
print(round(uti["crp"].mean(), 2))                     # پیش از تبدیل
uti["crp"] = uti["crp"].replace(-99, pd.NA).astype("Float64")
print(uti["crp"].notna().sum())
print(round(float(uti["crp"].mean()), 2))              # پس از تبدیل
print(uti["wbc"].isna().sum())
```
```
35.1
28
44.68
1
```
**جواب:** میانگین از **35.10** (غلط) به **44.68** (درست) رسید. CRP **۲۸** و WBC **۲۹** (۳۰ − ۱) مقدار معتبر دارند.

</details>

<details>
<summary><b>حل ع۴</b></summary>

```python
print(uti["ward"].cat.codes.add(1).mean())   # کدهای 0،1،2 ← 1،2،3
print(uti["ward"].value_counts(sort=False))
print(uti["organism"].value_counts(sort=False))
```
```
1.8
ward
Internal    12
Surgery     12
ICU          6
Name: count, dtype: int64
organism
E. coli       17
Klebsiella     9
Proteus        4
Name: count, dtype: int64
```
۱٫۸ «بخش» واقعی‌ای نیست؛ کدها برچسب‌اند (درس ۱.۲). درصدها: `value_counts(normalize=True) * 100` ← 40، 40، 20.

</details>

<details>
<summary><b>حل ع۵</b></summary>

```python
print(pd.crosstab(uti["sex"], uti["cipro_res"]))
```
```
cipro_res  Resistant  Susceptible
sex                              
Female             7           13
Male               4            6
```
**جواب: ۷.** (ستون‌ها الفبایی مرتب شده‌اند، چون برای `cipro_res` ترتیب `categories` تعیین نکردیم. تمرین اضافه: با `pd.Categorical(..., categories=["Susceptible", "Resistant"])` ترتیب را درست کنید.)

</details>

<details>
<summary><b>حل ع۶</b></summary>

```python
wide = pd.read_csv("../data/M01_crp_wide.csv")
long = wide.melt(id_vars="id", var_name="day", value_name="crp")
long["day"] = long["day"].str.replace("crp_d", "").astype(int)
print(long.shape)
```
```
(24, 3)
```
**جواب: ۲۴ سطر** (۸ × ۳).

</details>

<details>
<summary><b>حل ع۷</b></summary>

```python
uti.to_pickle("M01_uti_labeled.pkl")
print(pd.read_pickle("M01_uti_labeled.pkl").dtypes)
```
همهٔ ستون‌های `category` و `crp` با نوع `Float64` سر جایشان هستند. **بله، مانده‌اند.**

</details>

---

## خطاهای رایج در Python

| پیام / مشکل | علت | راه‌حل |
|---|---|---|
| `FileNotFoundError: ../data/M01_uti.csv` | اسکریپت از پوشهٔ دیگری اجرا شده | با `cd` به پوشهٔ `python/` بروید؛ در VS Code تنظیم «Execute in File Dir» را فعال کنید |
| همهٔ مقادیر پس از `.map()` به `NaN` تبدیل شدند | کلیدهای دیکشنری با نوع داده نمی‌خواند (مثلاً `"1"` در برابر `1`) | `uti["sex"].unique()` را ببینید |
| `TypeError` هنگام `.mean()` روی ستون category | متغیر کیفی میانگین ندارد | درست است! از `value_counts()` استفاده کنید |
| میانگین بدون هشدار حساب شد با اینکه داده گمشده داشت | pandas به‌طور پیش‌فرض `skipna=True` است | همیشه `isna().sum()` را گزارش کنید |
