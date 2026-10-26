# M02 در SPSS — Compute Variable، توابع ریاضی و ساختن داده

[← ماژول M02](../README.md) | [صفحهٔ مسیر SPSS](../../../tracks/spss.md)

**فایل:** [`M02_solutions.sps`](M02_solutions.sps). خط `CD` را به مسیر پوشهٔ `data` روی رایانهٔ خودتان تغییر دهید.

## بخش آموزشی

### Compute Variable (ساختن متغیر جدید)

**منو:** `Transform > Compute Variable...`
1. **Target Variable:** نام متغیر جدید (مثلاً `bmi`).
2. **Numeric Expression:** فرمول. می‌توانید متغیرها را از فهرست چپ بکشید و توابع را از فهرست **Function group** (مثلاً *Arithmetic*) انتخاب کنید.
3. **OK** (یا **Paste** برای دیدن Syntax).

**Syntax معادل:**
```
COMPUTE bmi = weight_kg / (height_cm / 100)**2.
EXECUTE.
```

### توابع ریاضی SPSS

| ریاضی | SPSS | نکته |
|---|---|---|
| xⁿ | `x**n` | توان با `**` |
| √x | `SQRT(x)` | |
| log₁₀ | `LG10(x)` | |
| ln | `LN(x)` | |
| log₂ | `LN(x)/LN(2)` | تابع مستقیم ندارد |
| eˣ | `EXP(x)` | |
| 10ˣ | `10**x` | |
| \|x\| | `ABS(x)` | |
| گردکردن | `RND(x, 0.1)` | گرد به نزدیک‌ترین ۰٫۱ |
| شرط (۰/۱) | `COMPUTE obese = (bmi >= 30).` | نتیجهٔ شرط ۱ یا ۰ است |

### Σ و میانگین

`Analyze > Descriptive Statistics > Descriptives` ← **Options** ← تیک **Sum** و **Mean**.
میانگین هندسی: `Analyze > Compare Means > Means` ← **Options** ← **Geometric Mean** را به Cell Statistics ببرید.

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

Syntax کامل: [`M02_solutions.sps`](M02_solutions.sps). روش منویی:

<details>
<summary><b>حل ع۱</b></summary>

1. `Transform > Compute Variable` ← Target: `bmi` ← Expression: `weight_kg / (height_cm / 100)**2` ← OK.
2. `Transform > Compute Variable` ← Target: `obese` ← Expression: `bmi >= 30` ← OK.
3. `Analyze > Descriptive Statistics > Descriptives` ← `bmi` ← **Mean = 29.44**.
4. `Analyze > Descriptive Statistics > Frequencies` ← `obese` ← مقدار ۱: **10** بیمار.

</details>

<details>
<summary><b>حل ع۲</b></summary>

Compute: `sbp_change = sbp_12 - sbp_0`؛ `sbp_pct = sbp_change / sbp_0 * 100`؛ `reduced10 = sbp_change <= -10`.
Descriptives ← میانگین‌ها: **−14.96** و **−10.01**؛ Frequencies `reduced10` ← **17**.

</details>

<details>
<summary><b>حل ع۳</b></summary>

Compute: `glucose_mmol = glucose_mgdl / 18` ← Descriptives ← **151.42** و **8.41**.

</details>

<details>
<summary><b>حل ع۴</b></summary>

1. Compute: `log_tg = LG10(tg_mgdl)`.
2. `Analyze > Compare Means > Means` ← Dependent: `tg_mgdl` ← Options ← Mean، Median، Geometric Mean ← **207.71، 208.50، 186.93**.
3. Descriptives `log_tg` ← **2.2717**.

</details>

<details>
<summary><b>حل ع۵</b></summary>

1. Compute: `age_sq = age**2` ← Descriptives (Mean، Sum) برای `age` و `age_sq` ← n = **24**، Σx = **1401**، x̄ = **58.375**، Σx² = **84759**.
2. برای SS میانگین را به هر سطر اضافه کنید: `Data > Aggregate` ← بدون Break Variable ← Summaries: `age_mean = MEAN(age)` ← **Add aggregated variables to active dataset** ← OK.
3. Compute: `age_dev_sq = (age - age_mean)**2` ← Descriptives (Sum) ← **2975.625**.

</details>

<details>
<summary><b>حل ع۶</b></summary>

فایل `M02_genes.csv` را وارد کنید (مثل M01). Compute: `fc = treated / control`؛ `log2fc = LN(fc) / LN(2)`؛ `changed2x = ABS(log2fc) >= 1` ← Frequencies ← **7**. با `Data > Sort Cases` بر اساس `log2fc` می‌بینید ۶ ژن ≥ ۱ و فقط FOS ≤ −۱ است.

</details>

<details>
<summary><b>حل ع۷</b></summary>

SPSS برای ساختن داده از صفر منوی ساده‌ای ندارد؛ یا ۱۳ عدد (۰ تا ۲۴) را در Data View تایپ کنید، یا از Syntax حلقه استفاده کنید:

```
INPUT PROGRAM.
LOOP t = 0 TO 24 BY 2.
  END CASE.
END LOOP.
END FILE.
END INPUT PROGRAM.
COMPUTE conc = 100 * 0.5**(t / 4).
EXECUTE.
LIST t conc.
```
اولین t با conc < 10: **14** (8.84). زمان دقیق: `4 * LN(10)/LN(2)` = **13.29**.

</details>

## خطاهای رایج

| مشکل | علت | راه‌حل |
|---|---|---|
| متغیر جدید ساخته نشد | `EXECUTE.` یا Run نشده | پس از COMPUTE دستور `EXECUTE.` |
| BMI عجیب | پرانتز جا افتاده | `weight_kg / (height_cm/100)**2` |
| `LG10` برای صفر خطا داد | log صفر تعریف نشده | SPSS آن را system-missing می‌کند؛ تعداد N را چک کنید |
