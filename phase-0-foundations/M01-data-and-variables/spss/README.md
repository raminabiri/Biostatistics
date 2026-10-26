# M01 در SPSS — ورود داده، تعریف متغیرها، دادهٔ گمشده و تغییر ساختار

[← ماژول M01](../README.md) | [صفحهٔ مسیر SPSS](../../../tracks/spss.md)

**پیش‌نیاز:** درس‌های نظری [۱.۱ تا ۱.۴](../README.md). اگر SPSS را هنوز نصب نکرده‌اید، [صفحهٔ مسیر SPSS](../../../tracks/spss.md) را ببینید.
**فایل‌ها:** [`M01_walkthrough.sps`](M01_walkthrough.sps) (آموزش گام‌به‌گام) و [`M01_solutions.sps`](M01_solutions.sps) (حل تمرین‌ها).
**نسخه:** SPSS Statistics 27 به بعد.

---

## بخش آموزشی

### گام ۱ — وارد کردن فایل CSV (درس ۱.۱)

**روش منویی:**

1. `File > Import Data > CSV Data...`
2. فایل `data/M01_uti.csv` را انتخاب کنید.
3. در پنجرهٔ Read CSV File:
   - تیک **First line contains variable names** فعال باشد.
   - Delimiter between values: **Comma**؛ Decimal symbol: **Period**.
4. **OK** (یا **Paste** برای دیدن Syntax).

(در نسخه‌های قدیمی‌تر: `File > Open > Data`، نوع فایل CSV، و پیمودن مراحل Text Import Wizard.)

**نتیجه:** پنجرهٔ **Data View**: هر سطر یک بیمار (مشاهده)، هر ستون یک متغیر. پایین پنجره را ببینید: دو زبانه دارد، **Data View** و **Variable View**.

**روش Syntax:** بخش «گام ۱» در `M01_walkthrough.sps`. فقط خط `CD` را به مسیر پوشهٔ `data` روی رایانهٔ خودتان تغییر دهید.

### گام ۲ — تعریف متغیرها در Variable View (درس ۱.۲)

زبانهٔ **Variable View** را باز کنید. هر **سطر** این جدول یک **متغیر** است و ستون‌هایش ویژگی‌های آن متغیرند. همین جدول، کدبوک داخل فایل SPSS است:

| ستون Variable View | کاربرد | مثال برای `ward` |
|---|---|---|
| Name | نام کوتاه متغیر | `ward` |
| Type | نوع ذخیره: Numeric یا String | Numeric |
| Label | برچسب کامل (در خروجی‌ها نمایش داده می‌شود) | Hospital ward |
| **Values** | **برچسب مقدار**: معنای هر کد | 1 = Internal، 2 = Surgery، 3 = ICU |
| **Missing** | **کد گمشده** | None |
| **Measure** | **سطح اندازه‌گیری**: Nominal، Ordinal یا Scale | Nominal |

**تعریف برچسب مقدار (Values):**
1. در سطر `ward`، روی خانهٔ ستون **Values** کلیک و دکمهٔ `...` را بزنید.
2. Value: `1`، Label: `Internal` ← **Add**. همین را برای 2 و 3 تکرار کنید ← **OK**.
3. همین کار را برای `sex`، `severity` و `cipro_res` انجام دهید (کدبوک را ببینید).

**تعیین Measure:** روی خانهٔ ستون **Measure** هر متغیر کلیک و یکی از سه گزینه را انتخاب کنید:

| Measure | متغیرها |
|---|---|
| Nominal (🟢 سه دایرهٔ رنگی) | sex، ward، organism، cipro_res |
| Ordinal (📶 میله‌های پلکانی) | severity، pain |
| Scale (📏 خط‌کش) | age، temp، crp، wbc، los |

**نکته:** SPSS برای فاصله‌ای و نسبی فقط یک گزینه دارد: **Scale**.

**دیدن برچسب‌ها:** به Data View برگردید و `View > Value Labels` را بزنید (یا دکمهٔ برچسب در نوار ابزار). به‌جای 1 و 2 کلمه‌های Female و Male را می‌بینید. داده تغییر نکرده؛ فقط نمایش عوض شده است.

### گام ۳ — تعریف کد گمشده (درس ۱.۴)

1. Variable View، سطر `crp`، ستون **Missing** ← `...`
2. **Discrete missing values** ← در خانهٔ اول `-99` ← **OK**.

حالا ‎-99 هنوز در Data View دیده می‌شود ولی در همهٔ محاسبات کنار گذاشته می‌شود (User-missing). خانهٔ خالی `wbc` (بیمار ۱۲) را SPSS خودش با نقطه (`.`) نشان می‌دهد (System-missing).

**بررسی:** `Analyze > Descriptive Statistics > Descriptives` ← `crp` و `wbc` را به لیست Variable(s) ببرید ← **OK**. ستون **N** باید ۲۸ و ۲۹ باشد.

### گام ۴ — کد عددی ≠ عدد (درس ۱.۲)

1. `Analyze > Descriptive Statistics > Descriptives` ← `ward` ← OK. میانگین = **1.80**. SPSS بدون اعتراض حساب می‌کند؛ تشخیص بی‌معنا بودن آن با شماست.
2. `Analyze > Descriptive Statistics > Frequencies` ← `ward` و `severity` ← OK. این خلاصهٔ درست است.

### گام ۵ — ذخیره

`File > Save As` ← نوع **SPSS Statistics (*.sav)** ← نام `M01_uti_labeled.sav`. فایل `.sav` همهٔ برچسب‌ها، کدهای گمشده و سطح‌های اندازه‌گیری را نگه می‌دارد؛ CSV هیچ‌کدام را نگه نمی‌دارد.

### گام ۶ — تبدیل قالب پهن به بلند (درس ۱.۳)

1. فایل `data/M01_crp_wide.csv` را مثل گام ۱ باز کنید (۸ سطر، ۴ ستون).
2. `Data > Restructure...` ← **Restructure selected variables into cases** ← Next.
3. Number of Variable Groups: **One** ← Next.
4. Case Group Identification: **Use selected variable** ← `id`.
   Variables to be Transposed: Target Variable را `crp` بنامید و `crp_d0`، `crp_d3`، `crp_d7` را (به همین ترتیب) به آن ببرید ← Next.
5. Number of Index Variables: **One** ← Next ← Index type: **Sequential numbers**، نام Index را `visit` بگذارید ← **Finish**.
6. حالا ۲۴ سطر دارید. برای تبدیل `visit` (1، 2، 3) به روز واقعی (0، 3، 7):
   `Transform > Recode into Different Variables` ← `visit` ← Output Variable Name: `day` ← Change ← **Old and New Values**: 1→0، 2→3، 3→7 ← Continue ← OK.

معادل Syntax: دستور `VARSTOCASES` در گام ۶ فایل walkthrough.

---

## تمرین‌های عملی (ع۱ تا ع۷)

این تمرین‌ها در هر پنج مسیر نرم‌افزاری **یکسان‌اند**. اول با منوها حل کنید، بعد با Syntax.

| شماره | تمرین |
|---|---|
| ع۱ | `M01_uti.csv` را وارد کنید. داده چند سطر و چند ستون دارد؟ |
| ع۲ | برای `sex`، `ward`، `severity`، `cipro_res` برچسب مقدار بگذارید و Measure همهٔ متغیرها را طبق تمرین ۱.۲.۲ تنظیم کنید. |
| ع۳ | میانگین CRP را **پیش** و **پس** از تعریف ‎-99 به‌عنوان گمشده حساب کنید. پس از تعریف، CRP و WBC هر کدام چند مقدار معتبر دارند؟ |
| ع۴ | میانگین کد `ward` را حساب کنید و توضیح دهید چرا بی‌معناست. سپس جدول فراوانی `ward` و `organism` را بسازید. |
| ع۵ | چند بیمار **زن** به سیپروفلوکساسین **مقاوم** بودند؟ (راهنما: جدول توافقی) |
| ع۶ | `M01_crp_wide.csv` را به قالب بلند تبدیل کنید. چند سطر به دست می‌آید؟ |
| ع۷ | دادهٔ برچسب‌دار را ذخیره کنید، فایل را ببندید و دوباره باز کنید. آیا برچسب‌ها مانده‌اند؟ |

### حل تمرین‌ها

<details>
<summary><b>حل ع۱</b></summary>

`File > Import Data > CSV Data` (گام ۱). در Data View شمارهٔ آخرین سطر **30** است؛ در Variable View **12** سطر (متغیر) هست.
**جواب: ۳۰ سطر (بیمار) و ۱۲ ستون (متغیر).**

</details>

<details>
<summary><b>حل ع۲</b></summary>

مراحل گام ۲. خلاصهٔ تنظیمات:

| متغیر | Values | Measure |
|---|---|---|
| sex | 1 Female، 2 Male | Nominal |
| ward | 1 Internal، 2 Surgery، 3 ICU | Nominal |
| organism | (متنی؛ برچسب لازم ندارد) | Nominal |
| cipro_res | 0 Susceptible، 1 Resistant | Nominal |
| severity | 1 Mild، 2 Moderate، 3 Severe | Ordinal |
| pain | — | Ordinal |
| age، temp، crp، wbc، los | — | Scale |

**کنترل:** `Utilities > Variables` یا دستور `DISPLAY DICTIONARY.` همهٔ تنظیمات را در خروجی نشان می‌دهد.

</details>

<details>
<summary><b>حل ع۳</b></summary>

1. **پیش از تعریف:** `Analyze > Descriptive Statistics > Descriptives` ← `crp` ← N = **30**، Mean = **35.10** (Minimum = ‎-99.0 ← علامت خطر!).
2. Missing برای `crp` ← Discrete: `-99` (گام ۳).
3. **پس از تعریف:** همان تحلیل ← N = **28**، Mean = **44.68**.
4. Descriptives برای `wbc` ← N = **29** (خانهٔ خالی خودکار گمشده است).

تفسیر: دو کد ‎-99 میانگین را حدود ۱۰ واحد پایین آورده بود (درس ۱.۴).

</details>

<details>
<summary><b>حل ع۴</b></summary>

1. Descriptives برای `ward` ← Mean = **1.80**. بی‌معناست، چون 1، 2، 3 فقط برچسب‌اند (درس ۱.۲، دام ۱). اگر Measure را Nominal گذاشته باشید، بعضی پنجره‌های SPSS هشدار می‌دهند یا اجازهٔ انتخاب نمی‌دهند؛ Descriptives معمولاً می‌دهد.
2. `Analyze > Descriptive Statistics > Frequencies` ← `ward`، `organism`:

| ward | Frequency | Percent |
|---|---|---|
| Internal | 12 | 40.0 |
| Surgery | 12 | 40.0 |
| ICU | 6 | 20.0 |

| organism | Frequency | Percent |
|---|---|---|
| E. coli | 17 | 56.7 |
| Klebsiella | 9 | 30.0 |
| Proteus | 4 | 13.3 |

</details>

<details>
<summary><b>حل ع۵</b></summary>

`Analyze > Descriptive Statistics > Crosstabs` ← Row(s): `sex`، Column(s): `cipro_res` ← OK.

| | Susceptible | Resistant | Total |
|---|---|---|---|
| Female | 13 | **7** | 20 |
| Male | 6 | 4 | 10 |

**جواب: ۷ بیمار زن مقاوم بودند.** (تحلیل این جدول در M07 و M35.)

</details>

<details>
<summary><b>حل ع۶</b></summary>

`Data > Restructure` (گام ۶) یا Syntax:

```
VARSTOCASES /MAKE crp FROM crp_d0 crp_d3 crp_d7 /INDEX=visit(3) /KEEP=id.
RECODE visit (1=0) (2=3) (3=7) INTO day.
EXECUTE.
```

**جواب: ۲۴ سطر** (۸ بیمار × ۳ روز). سه سطر اول: id = 1 با day = 0، 3، 7 و crp = 94.8، 46.2، 12.1.

</details>

<details>
<summary><b>حل ع۷</b></summary>

`File > Save As` ← `M01_uti_labeled.sav`. پس از بستن و باز کردن دوباره با `File > Open > Data`، در Variable View همهٔ Values، Missing و Measure سر جایشان هستند. **بله، می‌مانند.**
آزمون مقایسه: اگر همان داده را `File > Export > CSV` کنید و دوباره وارد کنید، همهٔ برچسب‌ها از بین می‌رود. به همین دلیل فایل کاری را `.sav` نگه دارید.

</details>

---

## خطاهای رایج در SPSS

| مشکل | علت | راه‌حل |
|---|---|---|
| حروف فارسی در خروجی به شکل `???` | SPSS در حالت Locale است | `Edit > Options > Language` ← Unicode (هیچ فایلی نباید باز باشد) |
| ستون عددی با Type = String وارد شده | یک خانه حاوی متن یا علامت (مثلاً `؟` یا `<5`) بوده | فایل منبع را اصلاح کنید یا `Transform > Automatic Recode` / تغییر Type |
| کد گمشده اثری ندارد | Missing تعریف نشده یا در متغیر اشتباه تعریف شده | Variable View ← Missing |
| خطای Syntax «file not found» | مسیر `CD` اشتباه است | مسیر کامل پوشهٔ `data` را بنویسید |
