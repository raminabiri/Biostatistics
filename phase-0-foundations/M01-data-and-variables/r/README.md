# M01 در R — خواندن داده، factor، دادهٔ گمشده و تغییر ساختار

[← ماژول M01](../README.md) | [صفحهٔ مسیر R](../../../tracks/r.md)

**پیش‌نیاز:** درس‌های نظری [۱.۱ تا ۱.۴](../README.md) و نصب R + RStudio ([صفحهٔ مسیر](../../../tracks/r.md)).
**فایل‌ها:** [`M01_walkthrough.R`](M01_walkthrough.R) (آموزش گام‌به‌گام) و [`M01_solutions.R`](M01_solutions.R) (حل تمرین‌ها). هر دو با R 4.6 اجرا و خروجی‌ها کنترل شده‌اند. فقط R پایه لازم است.

---

## مقدمهٔ خیلی کوتاه R برای تازه‌کارها

```r
x <- 5              # «<-» یعنی مقدار 5 را در x بگذار
x * 2               # 10
v <- c(3, 7, 2)     # c() چند مقدار را کنار هم می‌گذارد (بردار)
mean(v)             # تابع: نام(ورودی)
d$age               # ستون age از جدول (data frame) به نام d
?mean               # راهنمای هر تابع
```

در R یک **data frame** همان جدول دادهٔ مرتب است: هر ستون یک متغیر، هر سطر یک مشاهده.

---

## بخش آموزشی (فایل `M01_walkthrough.R`)

### گام ۱ — خواندن داده (درس ۱.۱)

```r
uti <- read.csv("../data/M01_uti.csv")
dim(uti)        # [1] 30 12
str(uti)
```

`str()` نشان می‌دهد R هر ستون را چه دیده است:

```
 $ sex      : int  1 1 1 2 1 2 1 1 1 1 ...
 $ organism : chr  "E. coli" "Klebsiella" "Proteus" ...
 $ crp      : num  27.8 51.1 48.4 82.5 33.9 24 -99 14.7 ...
```

R فکر می‌کند `sex` یک عدد صحیح (`int`) است و ‎-99 یک CRP واقعی. باید اصلاحش کنیم.

### گام ۲ — تعیین نوع متغیر با `factor` (درس ۱.۲)

| مفهوم آماری | ابزار R |
|---|---|
| اسمی | `factor(x, levels = ..., labels = ...)` |
| ترتیبی | `factor(x, levels = ..., labels = ..., ordered = TRUE)` |
| کمّی | `numeric` (اعشاری) یا `integer` (صحیح) — همان‌طور بماند |

```r
uti$ward <- factor(uti$ward, levels = c(1, 2, 3),
                   labels = c("Internal", "Surgery", "ICU"))
uti$severity <- factor(uti$severity, levels = c(1, 2, 3),
                       labels = c("Mild", "Moderate", "Severe"),
                       ordered = TRUE)
```

- `levels`: کدهای موجود در داده؛ `labels`: نام هر کد (همان **برچسب مقدار** SPSS).
- پس از اجرا، `str(uti)` نشان می‌دهد: `severity : Ord.factor w/ 3 levels "Mild"<"Moderate"<..` — علامت `<` یعنی R ترتیب را می‌داند.

### گام ۳ — کد گمشده ← `NA` (درس ۱.۴)

```r
summary(uti$crp)               # Min = -99 ← علامت خطر
uti$crp[uti$crp == -99] <- NA  # «هر جا crp برابر -99 است، NA بگذار»
colSums(is.na(uti))            # تعداد NA در هر ستون
```

خانهٔ خالی `wbc` را `read.csv` خودش `NA` کرده است. بیشتر توابع R با دیدن `NA` جواب `NA` می‌دهند تا شما آگاهانه تصمیم بگیرید: `mean(uti$crp)` ← `NA`، ولی `mean(uti$crp, na.rm = TRUE)` ← 44.68.

### گام ۴ — کد عددی ≠ عدد

```r
raw <- read.csv("../data/M01_uti.csv")
mean(raw$ward)     # [1] 1.8   ← بی‌معنا
table(uti$ward)    # خلاصهٔ درست
```

پس از تبدیل به factor، دستور `mean(uti$ward)` هشدار می‌دهد و `NA` برمی‌گرداند: R از شما در برابر این اشتباه محافظت می‌کند.

### گام ۵ — پهن به بلند (درس ۱.۳)

```r
wide <- read.csv("../data/M01_crp_wide.csv")
long <- reshape(wide, direction = "long",
                varying = c("crp_d0", "crp_d3", "crp_d7"),
                v.names = "crp", timevar = "day", times = c(0, 3, 7),
                idvar = "id")
dim(long)   # [1] 24  3
```

`varying`: ستون‌هایی که باید زیر هم بروند؛ `v.names`: نام ستون مقدار؛ `timevar`/`times`: نام و مقادیر ستون زمان؛ `idvar`: شناسهٔ واحد. روش کوتاه‌تر با بستهٔ `tidyr` در فایل حل آمده است.

### گام ۶ — ذخیره با حفظ factor ها

```r
saveRDS(uti, "M01_uti_labeled.rds")
uti <- readRDS("M01_uti_labeled.rds")
```

`write.csv` همهٔ factor ها را به متن تبدیل می‌کند و ترتیب `severity` از دست می‌رود؛ فایل `.rds` همه‌چیز را نگه می‌دارد (معادل `.sav` در SPSS).

---

## تمرین‌های عملی (ع۱ تا ع۷)

این تمرین‌ها در هر پنج مسیر **یکسان‌اند**. پیش از نگاه به حل، خودتان کد بنویسید.

| شماره | تمرین |
|---|---|
| ع۱ | `M01_uti.csv` را بخوانید. داده چند سطر و چند ستون دارد؟ |
| ع۲ | `sex`، `ward`، `organism`، `cipro_res` را factor و `severity` را factor ترتیبی کنید. با یک دستور نوع همهٔ ستون‌ها را نمایش دهید. |
| ع۳ | میانگین CRP را **پیش** و **پس** از تبدیل ‎-99 به `NA` حساب کنید. پس از تبدیل، CRP و WBC هر کدام چند مقدار معتبر دارند؟ |
| ع۴ | میانگین کد `ward` را حساب کنید و توضیح دهید چرا بی‌معناست. سپس جدول فراوانی `ward` و `organism` را بسازید. |
| ع۵ | چند بیمار **زن** به سیپروفلوکساسین **مقاوم** بودند؟ |
| ع۶ | `M01_crp_wide.csv` را به قالب بلند تبدیل کنید. چند سطر به دست می‌آید؟ |
| ع۷ | دادهٔ برچسب‌دار را در `.rds` ذخیره و دوباره بخوانید. آیا factor ها مانده‌اند؟ |

### حل تمرین‌ها

کد کامل: [`M01_solutions.R`](M01_solutions.R)

<details>
<summary><b>حل ع۱</b></summary>

```r
uti <- read.csv("../data/M01_uti.csv")
dim(uti)
```
```
[1] 30 12
```
**جواب: ۳۰ سطر، ۱۲ ستون.**

</details>

<details>
<summary><b>حل ع۲</b></summary>

```r
uti$sex       <- factor(uti$sex, 1:2, c("Female", "Male"))
uti$ward      <- factor(uti$ward, 1:3, c("Internal", "Surgery", "ICU"))
uti$organism  <- factor(uti$organism)
uti$cipro_res <- factor(uti$cipro_res, 0:1, c("Susceptible", "Resistant"))
uti$severity  <- factor(uti$severity, 1:3, c("Mild", "Moderate", "Severe"),
                        ordered = TRUE)
sapply(uti, function(x) class(x)[1])
```
```
       id       age       sex      ward  organism      temp       crp       wbc 
"integer" "integer"  "factor"  "factor"  "factor" "numeric" "numeric" "numeric" 
     pain  severity       los cipro_res 
"integer" "ordered" "integer"  "factor" 
```

- `1:3` کوتاه‌شدهٔ `c(1, 2, 3)` است؛ آرگومان دوم و سوم `factor()` به ترتیب `levels` و `labels` هستند.
- `organism` از قبل متن است، پس فقط `factor()` لازم دارد (سطوح به ترتیب الفبا).
- `sapply` تابع داده‌شده را روی تک‌تک ستون‌ها اجرا می‌کند.
- `pain` را عمداً عددی نگه داشتیم (درس ۱.۲، دام ۲)؛ اگر بخواهید ترتیبی‌اش کنید: `factor(uti$pain, 0:10, ordered = TRUE)`.

</details>

<details>
<summary><b>حل ع۳</b></summary>

```r
mean(uti$crp)                          # پیش از تبدیل
uti$crp[uti$crp == -99] <- NA
sum(!is.na(uti$crp))                   # تعداد معتبر
round(mean(uti$crp, na.rm = TRUE), 2)  # پس از تبدیل
sum(is.na(uti$wbc))
```
```
[1] 35.1
[1] 28
[1] 44.68
[1] 1
```

- `is.na()` برای هر مقدار TRUE/FALSE می‌دهد؛ `!` آن را برعکس می‌کند؛ `sum()` تعداد TRUE ها را می‌شمارد.
- **جواب:** میانگین از **35.10** (غلط) به **44.68** (درست) رسید. CRP **۲۸** و WBC **۲۹** مقدار معتبر دارند (۳۰ − ۱).

</details>

<details>
<summary><b>حل ع۴</b></summary>

```r
mean(as.integer(uti$ward))   # کد زیرین factor
table(uti$ward)
table(uti$organism)
```
```
[1] 1.8

Internal  Surgery      ICU 
      12       12        6 

   E. coli Klebsiella    Proteus 
        17          9          4 
```
۱٫۸ «بخش» واقعی‌ای نیست؛ کدها برچسب‌اند (درس ۱.۲). درصدها: `prop.table(table(uti$ward)) * 100` ← 40، 40، 20.

</details>

<details>
<summary><b>حل ع۵</b></summary>

```r
table(uti$sex, uti$cipro_res)
```
```
         Susceptible Resistant
  Female          13         7
  Male             6         4
```
**جواب: ۷.**

</details>

<details>
<summary><b>حل ع۶</b></summary>

```r
wide <- read.csv("../data/M01_crp_wide.csv")
long <- reshape(wide, direction = "long",
                varying = c("crp_d0", "crp_d3", "crp_d7"),
                v.names = "crp", timevar = "day", times = c(0, 3, 7),
                idvar = "id")
nrow(long)
```
```
[1] 24
```
**جواب: ۲۴ سطر** (۸ × ۳). با `tidyr`:
```r
library(tidyr)
long2 <- pivot_longer(wide, crp_d0:crp_d7, names_to = "day",
                      names_prefix = "crp_d", values_to = "crp")
```

</details>

<details>
<summary><b>حل ع۷</b></summary>

```r
saveRDS(uti, "M01_uti_labeled.rds")
str(readRDS("M01_uti_labeled.rds"))
```
در خروجی `sex : Factor w/ 2 levels "Female","Male"` و `severity : Ord.factor ...` و `crp : num ... NA ...` دیده می‌شود. **بله، همه‌چیز مانده است.**

</details>

---

## خطاهای رایج در R

| پیام / مشکل | علت | راه‌حل |
|---|---|---|
| `cannot open file '../data/M01_uti.csv': No such file` | Working directory درست نیست | `Session > Set Working Directory > To Source File Location`؛ بررسی با `getwd()` |
| همهٔ سطوح factor به `NA` تبدیل شدند | `levels` با کدهای واقعی داده نمی‌خواند (مثلاً `"1"` در برابر `1`) | `unique(x)` را ببینید و `levels` را مطابق آن بنویسید |
| `mean()` جواب `NA` داد | ستون `NA` دارد | `mean(x, na.rm = TRUE)` |
| `argument is not numeric or logical: returning NA` | میانگین یک factor | درست است! متغیر کیفی میانگین ندارد؛ از `table()` استفاده کنید |
