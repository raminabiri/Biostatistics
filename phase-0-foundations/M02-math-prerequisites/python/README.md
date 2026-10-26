# M02 در Python — Python به‌عنوان ماشین‌حساب و ساختن ستون جدید

[← ماژول M02](../README.md) | [صفحهٔ مسیر Python](../../../tracks/python.md)

**فایل:** [`M02_solutions.py`](M02_solutions.py) (با Python 3، pandas 2.3 و numpy اجرا و جواب‌ها کنترل شده‌اند). اجرا از داخل پوشهٔ `python/`.

## بخش آموزشی

### Python به‌عنوان ماشین‌حساب

```python
import numpy as np

2 + 3 * 4**2          # 50   (توان در Python با ** است، نه ^)
np.sqrt(81)           # 9.0
np.log10(1000)        # 3.0
np.log2(8)            # 3.0
np.log(np.e)          # 1.0  ← np.log یعنی ln
np.exp(2)             # 7.389
10**2.5               # 316.2
round(25.652, 1)      # 25.7
7.5e9                 # نماد علمی
abs(-3)               # 3
```

> **دام:** در Python، `^` توان **نیست** (عملگر XOR است): `2^3` جواب ۱ می‌دهد! همیشه `**` بنویسید.

### محاسبه روی ستون‌ها

pandas هم مثل R «برداری» کار می‌کند:

```python
import pandas as pd
d = pd.read_csv("../data/M02_clinic.csv")
d["bmi"] = d["weight_kg"] / (d["height_cm"] / 100) ** 2
```

| نماد ریاضی | Python |
|---|---|
| Σx | `x.sum()` |
| x̄ | `x.mean()` |
| Σx² | `(x**2).sum()` |
| Σ(x − x̄)² | `((x - x.mean())**2).sum()` |
| n | `len(x)` |
| تعداد شرط درست | `(x >= 30).sum()` |
| میانگین هندسی | `10 ** np.log10(x).mean()` یا `scipy.stats.gmean(x)` |

### ساختن دنبالهٔ عددی

```python
t = np.arange(0, 25, 2)     # 0, 2, ..., 24  (عدد پایانی خودش شامل نمی‌شود، پس 25)
conc = 100 * 0.5 ** (t / 4)
```

## تمرین‌های عملی (ع۱ تا ع۷)

این تمرین‌ها در هر پنج مسیر **یکسان‌اند** و جواب عددی یکسان دارند. داده: `data/M02_clinic.csv` و `data/M02_genes.csv`.

| شماره | سطح | تمرین | مفهوم (درس) |
|---|---|---|---|
| ع۱ | ۱ | متغیر جدید **BMI** = وزن ÷ (قد به متر)² بسازید. میانگین BMI چیست؟ چند بیمار BMI ≥ ۳۰ دارند؟ | ترتیب عملیات (۲.۲) |
| ع۲ | ۱ | تغییر فشار (sbp_12 − sbp_0) و **درصد تغییر** را بسازید. میانگین هر دو؟ چند بیمار دست‌کم ۱۰ mmHg کاهش داشتند؟ | تغییر مطلق و نسبی (۲.۱) |
| ع۳ | ۱ | قند خون را از mg/dL به mmol/L تبدیل کنید (÷ ۱۸). میانگین در هر دو واحد؟ | تبدیل واحد (۲.۱) |
| ع۴ | ۲ | log₁₀ تری‌گلیسرید را بسازید. میانگین حسابی، میانه، میانگین log₁₀ و **میانگین هندسی** TG را گزارش کنید. | لگاریتم (۲.۳) |
| ع۵ | ۲ | برای سن: n، Σx، x̄، Σx² و Σ(x − x̄)² را حساب کنید. | نماد Σ (۲.۲) |
| ع۶ | ۲ | در `M02_genes.csv` ستون‌های **fold change** (treated/control) و **log₂FC** را بسازید. چند ژن دست‌کم دو برابر تغییر کرده‌اند (\|log₂FC\| ≥ ۱)؟ چند افزایش و چند کاهش؟ | log₂ (۲.۳) |
| ع۷ | ۳ | جدول غلظت دارو را برای t = 0، 2، ...، 24 ساعت بسازید (C₀ = ۱۰۰ mg/L، t½ = ۴ h). اولین ساعتی که غلظت زیر ۱۰ می‌رود؟ زمان دقیق؟ | کاهش نمایی (۲.۴) |

<details>
<summary><b>جواب‌های نهایی (فقط برای کنترل، پس از حل)</b></summary>

| | جواب |
|---|---|
| ع۱ | میانگین BMI = **29.44**؛ BMI ≥ 30: **10** بیمار |
| ع۲ | میانگین تغییر = **−14.96 mmHg**؛ میانگین درصد تغییر = **−10.01٪**؛ کاهش ≥ ۱۰: **17** بیمار |
| ع۳ | **151.42 mg/dL** = **8.41 mmol/L** |
| ع۴ | حسابی **207.71**؛ میانه **208.5**؛ میانگین log₁₀ = **2.2717**؛ هندسی **186.93** mg/dL |
| ع۵ | n = **24**؛ Σx = **1401**؛ x̄ = **58.375**؛ Σx² = **84759**؛ SS = **2975.625** |
| ع۶ | **7** ژن (۶ افزایش، ۱ کاهش: FOS) |
| ع۷ | ساعت **14** (8.84 mg/L)؛ زمان دقیق **13.29** ساعت |

</details>

### حل تمرین‌ها

کد کامل: [`M02_solutions.py`](M02_solutions.py)

<details>
<summary><b>حل ع۱</b></summary>

```python
d["bmi"] = d["weight_kg"] / (d["height_cm"] / 100) ** 2
round(d["bmi"].mean(), 2)     # 29.44
(d["bmi"] >= 30).sum()        # 10
```

</details>

<details>
<summary><b>حل ع۲</b></summary>

```python
d["sbp_change"] = d["sbp_12"] - d["sbp_0"]
d["sbp_pct"] = d["sbp_change"] / d["sbp_0"] * 100
d["sbp_change"].mean()        # -14.96
d["sbp_pct"].mean()           # -10.01
(d["sbp_change"] <= -10).sum()   # 17
```

</details>

<details>
<summary><b>حل ع۳</b></summary>

```python
d["glucose_mmol"] = d["glucose_mgdl"] / 18
d["glucose_mgdl"].mean()      # 151.42
d["glucose_mmol"].mean()      # 8.41
```

</details>

<details>
<summary><b>حل ع۴</b></summary>

```python
d["log_tg"] = np.log10(d["tg_mgdl"])
d["tg_mgdl"].mean()           # 207.71
d["tg_mgdl"].median()         # 208.5
d["log_tg"].mean()            # 2.2717
10 ** d["log_tg"].mean()      # 186.93
```

</details>

<details>
<summary><b>حل ع۵</b></summary>

```python
x = d["age"]
len(x), x.sum(), x.mean()            # 24, 1401, 58.375
(x ** 2).sum()                       # 84759
((x - x.mean()) ** 2).sum()          # 2975.625
```

</details>

<details>
<summary><b>حل ع۶</b></summary>

```python
g = pd.read_csv("../data/M02_genes.csv")
g["fc"] = g["treated"] / g["control"]
g["log2fc"] = np.log2(g["fc"])
(g["log2fc"].abs() >= 1).sum()      # 7
(g["log2fc"] >= 1).sum()            # 6
g[g["log2fc"] <= -1]                # FOS
```

</details>

<details>
<summary><b>حل ع۷</b></summary>

```python
t = np.arange(0, 25, 2)
conc = 100 * 0.5 ** (t / 4)
t[conc < 10][0]               # 14
4 * np.log2(10)               # 13.29
```
`conc < 10` یک آرایهٔ True/False است؛ `t[...]` فقط زمان‌های True را برمی‌دارد و `[0]` اولی را.

</details>

## خطاهای رایج

| مشکل | علت | راه‌حل |
|---|---|---|
| `2^3` جواب ۱ داد | `^` در Python توان نیست | `2**3` |
| میانگین هندسی اشتباه | مخلوط‌کردن `np.log` (ln) با `10**` | هر دو را از یک پایه بگیرید |
| `RuntimeWarning: divide by zero in log` | مقدار صفر | درس ۲.۳، تمرین ۲.۳.۱۳ |
