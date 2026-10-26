# M04 در SPSS — Identify Duplicates، Recode، Date Wizard، Merge و Aggregate

[← ماژول M04](../README.md) | [صفحهٔ مسیر SPSS](../../../tracks/spss.md)

**فایل:** [`M04_solutions.sps`](M04_solutions.sps). کل پروتکل P1 تا P11. خط `CD` را تغییر دهید.

> در SPSS، Syntax همان «دفترچهٔ پاک‌سازی» قابل‌اجراست: هر خط یک قاعده است و با یک بار اجرا همه‌چیز تکرار می‌شود. پس از هر کار منویی، **Paste** را بزنید و Syntax را نگه دارید.

## بخش آموزشی

| کار | منو |
|---|---|
| تکرار کامل یا کلید | `Data > Identify Duplicate Cases` ← Define matching cases by: همهٔ متغیرها (کامل) یا `pid` (کلید)؛ Sort within matching groups by: `entry_no` ← متغیر نشانگر `PrimaryFirst` ساخته می‌شود |
| یکسان‌سازی متن | `Transform > Compute Variable` با توابع `UPCASE`، `LTRIM`، `RTRIM`، `CHAR.SUBSTR` (گروه String) |
| بازکدگذاری | `Transform > Recode into Different Variables` ← Old and New Values (مثلاً Range: Lowest through 39 → 1) |
| جایگزینی شرطی | `Compute Variable` ← دکمهٔ **If...** ← شرط (مثلاً `sbp = -99`) و مقدار `$SYSMIS` |
| سن از تاریخ | `Transform > Date and Time Wizard` ← Calculate with dates and times ← Calculate the number of time units between two dates ← Unit: **Years** (کامل) |
| فیلتر دادهٔ تحلیل | `Data > Select Cases` ← If ← `MISSING(age) OR age >= 18` ← **Filter out** (نه Delete) |
| تجمیع | `Data > Aggregate` ← Break: `pid` ← Summaries: `MEAN(ldl)`، `N` ← Create a new dataset |
| ادغام | `Data > Merge Files > Add Variables` ← فایل/دیتاست دوم ← **One-to-many based on key values** ← Key: `pid` ← Lookup table: دیتاست تجمیع‌شده |
| الحاق | `Data > Merge Files > Add Cases` |

**نکتهٔ مهم ادغام:** هر دو دیتاست باید بر اساس کلید **مرتب** باشند (`Data > Sort Cases`)، وگرنه SPSS خطا می‌دهد یا جفت‌ها اشتباه می‌شوند.

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

Syntax کامل با توضیح هر قاعده: [`M04_solutions.sps`](M04_solutions.sps).

<details>
<summary><b>حل ع۱ و ع۲</b></summary>

1. `Frequencies` روی `sex` و `smoker` ← ۱۱ و ۹ شکل.
2. `Identify Duplicate Cases` با همهٔ متغیرها ← ۱ تکرار کامل (pid 12). با فقط `pid` ← دو گروه تکراری (12 و 27).
3. Syntax حذف (P1 و P2):
```
SORT CASES BY pid entry_no.
MATCH FILES /FILE=* /BY pid /FIRST=first_pid.
SELECT IF first_pid = 1.
```
(تکرار کامل pid 12 هم در همین مرحله حذف می‌شود، چون `entry_no` یکسان دارد؛ Syntax فایل حل دو مرحله را جدا نشان می‌دهد.)
4. یکسان‌سازی: `COMPUTE sex = CHAR.SUBSTR(UPCASE(LTRIM(RTRIM(sex))),1,1).` ← F **14**، M **26**؛ smoker yes **4**، no **35**، گمشده **1**.

</details>

<details>
<summary><b>حل ع۳</b></summary>

```
IF (height_cm < 3) height_cm = height_cm * 100.
IF (height_cm < 120 OR height_cm > 220) height_cm = $SYSMIS.
IF (weight_kg < 30 OR weight_kg > 250) weight_kg = $SYSMIS.
IF (sbp = -99) sbp = $SYSMIS.
IF (sbp < 70 OR sbp > 260) sbp = $SYSMIS.
```
`Descriptives` (Min، Max، N) پیش و پس از اجرا را مقایسه کنید.

</details>

<details>
<summary><b>حل ع۴</b></summary>

```
COMPUTE flag_bp = (dbp >= sbp).          → 1 (pid 22) ← هر دو $SYSMIS
COMPUTE flag_preg = (sex = 'M' AND pregnant = 'yes').   → 1 (pid 1)
COMPUTE flag_dob = (dob > visit_date).   → 1 (pid 35) ← dob = $SYSMIS
COMPUTE age = DATEDIFF(visit_date, dob, "years").
SELECT IF (MISSING(age) OR age >= 18).   → 39 (pid 3 خارج)
```

</details>

<details>
<summary><b>حل ع۵</b></summary>

`Compute` BMI؛ `Recode into Different Variables` برای `age_group` (Lowest–39 → 1؛ 40–59 → 2؛ 60–Highest → 3)؛ `Descriptives` ← سن **48.42** (N 38)، BMI **26.43** (N 37)، sbp **143.00** (N 36)؛ `Frequencies` ← گروه‌ها 14/14/10؛ BMI ≥ 30: **5**.

</details>

<details>
<summary><b>حل ع۶</b></summary>

1. `M04_labs.csv` را وارد کنید ← `Data > Aggregate` ← Break: `pid`؛ `mean_ldl = MEAN(ldl)`، `n_tests = N` ← دیتاست جدید `labs_pt`.
2. هر دو دیتاست را بر اساس `pid` مرتب کنید.
3. `Data > Merge Files > Add Variables` ← دیتاست تحلیل فعال، `labs_pt` به‌عنوان **lookup table** (یک‌به‌چند بر اساس کلید) ← ۳۹ سطر.
4. `Frequencies` روی `n_tests` ← 1: **5**، 2: **12**، 3: **17**، گمشده: **5** (pid 4، 15، 23، 30، 38)؛ `Descriptives` روی `mean_ldl` ← **120.58**.
5. شناسه‌های بی‌جفت: Syntax فایل حل (ادغام کامل با `/IN=`) ← **3** و **99**.

</details>

<details>
<summary><b>حل ع۷</b></summary>

`M04_site2.csv` را وارد و همان متغیرها را بسازید (`site = 2`)؛ در دیتاست تحلیل `site = 1` ← `Data > Merge Files > Add Cases` ← **44** سطر؛ `Descriptives` روی `sbp` ← **143.00** (N 41).

</details>

## خطاهای رایج

| مشکل | علت | راه‌حل |
|---|---|---|
| `Select Cases` داده را پاک کرد | Delete unselected cases | **Filter out** |
| خطای «files are not in ascending order» | دیتاست‌ها مرتب نیستند | `Sort Cases` بر اساس کلید در هر دو |
| تاریخ‌ها system-missing شدند | قالب ورودی اشتباه (مثلاً `DATE11` به‌جای `SDATE10`) | قالب `SDATE10` برای YYYY-MM-DD |
| `Add Cases` متغیرها را جدا نگه داشت | نام یا نوع (عددی/متنی) متفاوت | پیش از الحاق یکسان کنید |
