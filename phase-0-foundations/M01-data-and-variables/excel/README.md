# M01 در Excel — ورود داده، برچسب‌گذاری، دادهٔ گمشده و تغییر ساختار

[← ماژول M01](../README.md) | [صفحهٔ مسیر Excel](../../../tracks/excel.md)

**پیش‌نیاز:** درس‌های نظری [۱.۱ تا ۱.۴](../README.md).
**فایل‌ها:**
- [`M01_excel_practice.xlsx`](M01_excel_practice.xlsx): داده‌ها + برگهٔ `answers` برای نوشتن جواب‌های شما
- [`M01_excel_solutions.xlsx`](M01_excel_solutions.xlsx): همهٔ جواب‌ها با **فرمول‌های واقعی** (همهٔ فرمول‌ها با LibreOffice محاسبه و با جواب‌های R و Python مقایسه شده‌اند)

**نسخه:** Excel برای Microsoft 365 یا Excel 2021. فرمول‌های این ماژول در Excel 2016 و LibreOffice Calc هم کار می‌کنند. Power Query (گام ۶) در Excel 2016 به بعد ویندوز و Microsoft 365 مک وجود دارد.

---

## ایدهٔ اصلی: Excel «نوع متغیر» نمی‌شناسد

Excel فقط **عدد** و **متن** می‌شناسد. نه برچسب مقدار دارد، نه سطح اندازه‌گیری، نه کد گمشده. پس در Excel سه کار را **خودمان** انجام می‌دهیم:

| مفهوم آماری | در SPSS | در Excel |
|---|---|---|
| برچسب مقدار | Values | یک **برگهٔ برچسب** + ستون برچسب با `VLOOKUP` |
| سطح اندازه‌گیری | Measure | ستون Measure در **برگهٔ کدبوک** (فقط برای مستندسازی) |
| کد گمشده | Missing | `AVERAGEIF`/`COUNTIFS` با شرط `"<>-99"`، یا جایگزینی ‎-99 با خانهٔ خالی |
| جلوگیری از کد نامعتبر | — | **Data Validation** |

این یعنی در Excel باید منضبط‌تر باشید. Broman و Woo (2018) قواعد کار درست با صفحه‌گسترده را توضیح داده‌اند (منبع ۸).

---

## بخش آموزشی

### گام ۱ — باز کردن CSV (درس ۱.۱)

**روش مطمئن:** `Data > From Text/CSV` ← فایل `data/M01_uti.csv` ← در پیش‌نمایش، **File Origin: 65001: Unicode (UTF-8)** و **Delimiter: Comma** ← **Load**.

> چرا نه دوبار کلیک روی فایل؟ در ویندوزی که تنظیمات منطقه‌ای آن فارسی است، Excel ممکن است ویرگول را جداکننده نشناسد یا اعشار را اشتباه بخواند. روش `From Text/CSV` این مشکل را ندارد.

**شمارش سطر و ستون با فرمول:**
```
=ROWS(A2:A31)        → 30   (تعداد بیمار)
=COUNTA(A1:L1)       → 12   (تعداد متغیر)
```

### گام ۲ — برچسب مقدار با برگهٔ برچسب و VLOOKUP (درس ۱.۲)

1. یک برگهٔ جدید به نام `labels` بسازید با سه ستون: `variable`، `code`، `label` (مثل فایل حل).
2. یک ستون کمکی «کلید» بسازید که نام متغیر و کد را به هم بچسباند: در `D2`:
   ```
   =A2&"|"&B2          → sex|1
   ```
3. در برگهٔ داده، ستون جدید `sex_label` بسازید. در `M2`:
   ```
   =VLOOKUP("sex"&"|"&C2, labels!$D$2:$E$11, 2, FALSE)     → Female
   ```
   و آن را تا سطر ۳۱ پایین بکشید. همین کار را برای `ward`، `severity` و `cipro_res` انجام دهید.

`FALSE` در آخر یعنی «فقط تطابق دقیق»؛ هرگز آن را جا نیندازید. در Microsoft 365 می‌توانید به‌جای VLOOKUP از `XLOOKUP` هم استفاده کنید.

**Data Validation (جلوگیری از ورود کد غلط):** ستون `ward` (`D2:D31`) را انتخاب کنید ← `Data > Data Validation` ← Allow: **List** ← Source: `1,2,3` ← OK. حالا اگر کسی `4` تایپ کند، Excel خطا می‌دهد. این همان کنترل کیفیت هنگام ورود داده است (M04).

**سطح اندازه‌گیری:** در برگهٔ `codebook` ستون `measure` را برای هر متغیر بنویسید (Nominal، Ordinal، Scale). Excel از آن استفاده نمی‌کند، ولی شما و همکارانتان استفاده می‌کنید.

### گام ۳ — کد گمشده (درس ۱.۴)

```
=AVERAGE(G2:G31)                    → 35.10   ✘ (‎-99 حساب شده)
=AVERAGEIF(G2:G31,"<>-99")          → 44.68   ✔
=COUNTIFS(G2:G31,"<>-99",G2:G31,"<>")  → 28  (CRP معتبر)
=COUNT(H2:H31)                      → 29     (COUNT خانهٔ خالی را نمی‌شمارد)
```

**روش دوم: جایگزینی ‎-99 با خانهٔ خالی.** ستون `crp` را انتخاب کنید ← `Ctrl+H` ← Find what: `-99` ← Replace with: (خالی) ← **Options** ← تیک **Match entire cell contents** ← Replace All.
تیک «Match entire cell contents» حیاتی است: بدون آن، عددی مثل `-991` هم دست‌کاری می‌شود. این کار را فقط روی **یک کپی** از دادهٔ خام انجام دهید (M04).

### گام ۴ — کد عددی ≠ عدد

```
=AVERAGE(D2:D31)         → 1.8   (میانگین کد بخش؛ بی‌معنا)
=COUNTIF(D2:D31,1)       → 12    (Internal)
=COUNTIF(E2:E31,"E. coli")  → 17
```

**PivotTable (روش سریع‌تر برای جدول فراوانی):** یک خانه از داده را انتخاب کنید ← `Insert > PivotTable` ← OK ← فیلد `ward_label` را به **Rows** و فیلد `id` را به **Values** بکشید ← روی «Sum of id» کلیک کنید ← **Value Field Settings** ← **Count** ← OK.

### گام ۵ — جدول توافقی

با PivotTable: `sex_label` به **Rows**، `cipro_res_label` به **Columns**، `id` به **Values** (Count).
با فرمول:
```
=COUNTIFS(C2:C31,1, L2:L31,1)     → 7   (زن و مقاوم)
```

### گام ۶ — پهن به بلند با Power Query (درس ۱.۳)

1. برگهٔ `crp_wide` را باز کنید، یک خانه از جدول را انتخاب کنید ← `Data > From Table/Range` ← OK (جدول سرستون دارد).
2. در پنجرهٔ Power Query: ستون `id` را انتخاب کنید ← راست‌کلیک ← **Unpivot Other Columns**.
3. ستون `Attribute` را `day` و `Value` را `crp` بنامید. برای تبدیل `crp_d0` به `0`: ستون `day` ← `Transform > Replace Values` ← `crp_d` را با هیچ جایگزین کنید ← نوع ستون را Whole Number کنید.
4. `Home > Close & Load` ← جدول ۲۴ سطری در برگهٔ جدید.

**روش فرمولی** (برای LibreOffice یا Excel بدون Power Query؛ در برگهٔ `crp_long` فایل حل):
```
A2: =INDEX(crp_wide!$A$2:$A$9, INT((ROW()-2)/3)+1)                       (id)
B2: =CHOOSE(MOD(ROW()-2,3)+1, 0, 3, 7)                                   (day)
C2: =INDEX(crp_wide!$B$2:$D$9, INT((ROW()-2)/3)+1, MOD(ROW()-2,3)+1)     (crp)
```
و تا سطر ۲۵ پایین بکشید. منطق: هر بیمار ۳ سطر می‌گیرد؛ `INT(.../3)` شمارهٔ بیمار و `MOD(...,3)` شمارهٔ روز را می‌دهد.

### گام ۷ — ذخیره

`File > Save As` ← **Excel Workbook (*.xlsx)**. فایل xlsx همهٔ برگه‌ها (داده، برچسب، کدبوک) و فرمول‌ها را نگه می‌دارد. اگر CSV ذخیره کنید، فقط برگهٔ فعال و فقط **مقادیر** می‌ماند.

---

## تمرین‌های عملی (ع۱ تا ع۷)

همان تمرین‌های چهار مسیر دیگر (SPSS، Prism، R، Python)، با همان جواب‌ها. جواب‌ها را در برگهٔ `answers` فایل `M01_excel_practice.xlsx` بنویسید.

| شماره | تمرین |
|---|---|
| ع۱ | `M01_uti.csv` را وارد کنید. داده چند سطر و چند ستون دارد؟ (با فرمول) |
| ع۲ | برگهٔ `labels` را بسازید و ستون‌های برچسب `sex_label`، `ward_label`، `severity_label` و `cipro_res_label` را با VLOOKUP اضافه کنید. برای `ward` قاعدهٔ Data Validation بگذارید. |
| ع۳ | میانگین CRP را با و بدون ‎-99 حساب کنید. CRP و WBC هر کدام چند مقدار معتبر دارند؟ |
| ع۴ | میانگین کد `ward` را حساب کنید و توضیح دهید چرا بی‌معناست. جدول فراوانی `ward` و `organism` را با COUNTIF **و** با PivotTable بسازید. |
| ع۵ | چند بیمار **زن** به سیپروفلوکساسین **مقاوم** بودند؟ (COUNTIFS و PivotTable) |
| ع۶ | `crp_wide` را با Power Query (یا روش فرمولی) به قالب بلند تبدیل کنید. چند سطر به دست می‌آید؟ |
| ع۷ | فایل را xlsx ذخیره کنید، ببندید و باز کنید. سپس یک نسخهٔ CSV هم ذخیره کنید و باز کنید. چه چیزی در CSV از دست رفت؟ |

### حل تمرین‌ها

همهٔ فرمول‌ها در برگهٔ `solutions` فایل [`M01_excel_solutions.xlsx`](M01_excel_solutions.xlsx) آمده‌اند.

<details>
<summary><b>حل ع۱</b></summary>

```
=ROWS(uti!A2:A31)     → 30
=COUNTA(uti!A1:L1)    → 12
```
**جواب: ۳۰ سطر، ۱۲ ستون.** راه سریع دیگر: ستون A را انتخاب کنید؛ نوار وضعیت پایین Excel «Count: 31» نشان می‌دهد (۳۰ داده + ۱ سرستون).

</details>

<details>
<summary><b>حل ع۲</b></summary>

برگهٔ `labels` (ستون‌های D و E ستون کلید و برچسب‌اند):

| variable | code | label | key | label |
|---|---|---|---|---|
| sex | 1 | Female | `=A2&"\|"&B2` ← sex\|1 | Female |
| sex | 2 | Male | sex\|2 | Male |
| ward | 1 | Internal | ward\|1 | Internal |
| ... | | | | |

ستون‌های برچسب در برگهٔ `uti`:
```
M2: =VLOOKUP("sex"&"|"&C2,       labels!$D$2:$E$11, 2, FALSE)
N2: =VLOOKUP("ward"&"|"&D2,      labels!$D$2:$E$11, 2, FALSE)
O2: =VLOOKUP("severity"&"|"&J2,  labels!$D$2:$E$11, 2, FALSE)
P2: =VLOOKUP("cipro_res"&"|"&L2, labels!$D$2:$E$11, 2, FALSE)
```
**کنترل:** سطر بیمار ۱ ← Female، Surgery، Mild، Susceptible. سطر بیمار ۶ ← Male، Internal، Moderate، Resistant.
اگر جایی `#N/A` دیدید، یعنی کدی در داده هست که در برگهٔ برچسب نیست؛ این خودش یک کنترل کیفیت است!

</details>

<details>
<summary><b>حل ع۳</b></summary>

| محاسبه | فرمول | جواب |
|---|---|---|
| میانگین با ‎-99 | `=AVERAGE(G2:G31)` | **35.10** ✘ |
| میانگین بدون ‎-99 | `=AVERAGEIF(G2:G31,"<>-99")` | **44.68** ✔ |
| CRP معتبر | `=COUNTIFS(G2:G31,"<>-99",G2:G31,"<>")` | **28** |
| WBC معتبر | `=COUNT(H2:H31)` | **29** |

نکته: `AVERAGE` و `COUNT` خانهٔ خالی را خودشان کنار می‌گذارند، ولی ‎-99 را نه.

</details>

<details>
<summary><b>حل ع۴</b></summary>

`=AVERAGE(D2:D31)` ← **1.8**؛ بی‌معنا، چون 1، 2، 3 برچسب‌اند (درس ۱.۲).

| ward | فرمول | فراوانی |
|---|---|---|
| Internal | `=COUNTIF(D2:D31,1)` | 12 |
| Surgery | `=COUNTIF(D2:D31,2)` | 12 |
| ICU | `=COUNTIF(D2:D31,3)` | 6 |

| organism | فرمول | فراوانی |
|---|---|---|
| E. coli | `=COUNTIF(E2:E31,"E. coli")` | 17 |
| Klebsiella | `=COUNTIF(E2:E31,"Klebsiella")` | 9 |
| Proteus | `=COUNTIF(E2:E31,"Proteus")` | 4 |

PivotTable همین اعداد را می‌دهد. درصد: در PivotTable، `Value Field Settings > Show Values As > % of Grand Total` ← 40٪، 40٪، 20٪.

</details>

<details>
<summary><b>حل ع۵</b></summary>

```
=COUNTIFS(C2:C31,1, L2:L31,1)    → 7   (زن، مقاوم)
=COUNTIFS(C2:C31,1, L2:L31,0)    → 13  (زن، حساس)
=COUNTIFS(C2:C31,2, L2:L31,1)    → 4   (مرد، مقاوم)
=COUNTIFS(C2:C31,2, L2:L31,0)    → 6   (مرد، حساس)
```
**جواب: ۷.** جمع چهار خانه = ۳۰ (کنترل).

</details>

<details>
<summary><b>حل ع۶</b></summary>

Power Query: `Unpivot Other Columns` روی همهٔ ستون‌ها به‌جز `id` (گام ۶). یا روش فرمولی برگهٔ `crp_long`.
**جواب: ۲۴ سطر.** سه سطر اول: (1, 0, 94.8)، (1, 3, 46.2)، (1, 7, 12.1)؛ سطر آخر: (8, 7, 6.9).

</details>

<details>
<summary><b>حل ع۷</b></summary>

- **xlsx:** همهٔ برگه‌ها، فرمول‌ها، Data Validation و PivotTable ها می‌مانند.
- **CSV:** فقط برگهٔ فعال و فقط **مقادیر** می‌ماند؛ برگه‌های `labels` و `codebook`، فرمول‌ها (به عدد ثابت تبدیل می‌شوند)، Data Validation و قالب‌بندی از دست می‌روند.
- **نتیجه:** فایل کاری را xlsx نگه دارید؛ CSV فقط برای **انتقال** داده به نرم‌افزار دیگر است.

</details>

---

## خطاهای رایج در Excel

| مشکل | علت | راه‌حل |
|---|---|---|
| همهٔ داده‌ها در ستون A آمدند | جداکنندهٔ فهرست ویندوز ویرگول نیست | از `Data > From Text/CSV` استفاده کنید |
| اعداد اعشاری به تاریخ تبدیل شدند (مثلاً 3.4 ← 3-Apr) | تنظیمات منطقه‌ای | در Power Query نوع ستون را Decimal Number کنید؛ یا ستون را قبل از وارد کردن Text کنید |
| `#N/A` در VLOOKUP | کد در جدول برچسب نیست، یا آخرین آرگومان FALSE نیست | برگهٔ برچسب را کامل کنید |
| کد ژن یا شناسه به عدد/تاریخ تبدیل شد (مثلاً `MARCH1`، `SEPT2`) | تبدیل خودکار Excel | ستون را پیش از ورود Text کنید؛ این مشکل در داده‌های ژنتیک بسیار رایج است |
| میانگین غلط | کد گمشده حساب شده | `AVERAGEIF(...,"<>-99")` یا جایگزینی با خانهٔ خالی |
