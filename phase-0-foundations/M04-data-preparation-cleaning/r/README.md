# M04 در R — پاک‌سازی تکرارپذیر، تاریخ، ادغام و الحاق

[← ماژول M04](../README.md) | [صفحهٔ مسیر R](../../../tracks/r.md)

**فایل:** [`M04_solutions.R`](M04_solutions.R) (با R 4.6 اجرا و جواب‌ها کنترل شده‌اند). کل پروتکل P1 تا P11 + دفترچهٔ پاک‌سازی خودکار. فقط R پایه لازم است.

## بخش آموزشی

### خواندن داده بدون تغییر خام

```r
raw <- read.csv("../data/M04_registry_raw.csv", na.strings = "", stringsAsFactors = FALSE)
d <- raw          # همهٔ تغییرات روی d؛ raw دست‌نخورده می‌ماند
```

### ابزارهای غربال

```r
table(raw$sex, useNA = "ifany")    # کدهای ناهمسان
summary(raw$sbp)                   # کمینه و بیشینه
sum(duplicated(raw))               # تکرار کامل
raw$pid[duplicated(raw$pid)]       # تکرار کلید
```

### پاک‌سازی متن

```r
toupper(substr(trimws(" male "), 1, 1))   # "M"
```

### جایگزینی شرطی

```r
d$sbp[d$sbp == -99] <- NA                 # کد گمشده
i <- which(d$height_cm < 3)               # کدام سطرها؟
d$height_cm[i] <- d$height_cm[i] * 100    # فقط همان‌ها
```
`which()` شمارهٔ سطرها را برمی‌گرداند و `NA` ها را نادیده می‌گیرد؛ برای ثبت در دفترچه هم از همین شماره‌ها استفاده می‌کنیم.

### تاریخ و سن

```r
d$dob <- as.Date(d$dob)                   # متن YYYY-MM-DD ← تاریخ
d$visit_date - d$dob                      # تفاضل به روز
full_years <- function(from, to) {        # سن کامل
  as.numeric(format(to, "%Y")) - as.numeric(format(from, "%Y")) -
    (format(to, "%m%d") < format(from, "%m%d"))
}
```
(بستهٔ `lubridate` هم توابع آماده دارد: `time_length(interval(dob, visit), "years")`.)

### گروه‌بندی

```r
cut(age, breaks = c(-Inf, 39, 59, Inf), labels = c("<40", "40-59", ">=60"))
```
`cut()` به‌طور پیش‌فرض مرز **راست** را شامل می‌کند: (−∞، ۳۹]، (۳۹، ۵۹]، (۵۹، ∞). برای سن صحیح، این یعنی ۳۹ ← «<40» و ۴۰ ← «40-59» (درس ۴.۳، تمرین ۴.۳.۳).

### تجمیع، ادغام، الحاق

```r
aggregate(ldl ~ pid, data = labs, FUN = mean)          # تجمیع
merge(a, lab_pt, by = "pid", all.x = TRUE)             # ادغام چپ
rbind(site1, site2[, names(site1)])                    # الحاق (ستون‌ها هم‌ترتیب)
```
`all.x = TRUE` ادغام چپ است؛ `all = TRUE` ادغام کامل؛ بدون هیچ‌کدام ادغام داخلی.

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

کد کامل و توضیح‌دار: [`M04_solutions.R`](M04_solutions.R). خلاصهٔ هر بخش:

<details>
<summary><b>حل ع۱ و ع۲</b></summary>

```r
nrow(raw); length(unique(raw$pid)); sum(duplicated(raw))   # 42 40 1
d <- raw[!duplicated(raw), ]                               # P1
d <- d[order(d$pid, d$entry_no), ]
d <- d[!duplicated(d$pid), ]                               # P2 → 40
d$sex <- toupper(substr(trimws(d$sex), 1, 1))              # P3
s <- toupper(substr(trimws(d$smoker), 1, 1))               # P4
d$smoker <- ifelse(s == "Y", "yes", ifelse(s == "N", "no", NA))
table(d$sex); table(d$smoker, useNA = "ifany")
```
مرتب‌سازی بر اساس `pid` و سپس `entry_no` باعث می‌شود `duplicated()` سطر با `entry_no` بزرگ‌تر را «تکراری» بشناسد.

</details>

<details>
<summary><b>حل ع۳</b></summary>

```r
i <- which(d$height_cm < 3); d$height_cm[i] <- d$height_cm[i] * 100      # pid 5
d$height_cm[which(d$height_cm < 120 | d$height_cm > 220)] <- NA          # pid 18
d$weight_kg[which(d$weight_kg < 30 | d$weight_kg > 250)] <- NA           # pid 9
d$sbp[which(d$sbp == -99)] <- NA                                          # pid 31
d$sbp[which(d$sbp < 70 | d$sbp > 260)] <- NA                              # pid 14
```

</details>

<details>
<summary><b>حل ع۴</b></summary>

```r
i <- which(d$dbp >= d$sbp); d$sbp[i] <- NA; d$dbp[i] <- NA               # pid 22
d$pid[which(d$sex == "M" & d$pregnant %in% "yes")]                        # pid 1
d$pregnant[d$sex == "M"] <- NA
d$dob <- as.Date(d$dob); d$visit_date <- as.Date(d$visit_date)
d$dob[which(d$dob > d$visit_date)] <- NA                                  # pid 35
d$age <- full_years(d$dob, d$visit_date)
a <- d[is.na(d$age) | d$age >= 18, ]                                      # 39
```
`%in%` به‌جای `==` برای `pregnant`، چون `NA == "yes"` جواب `NA` می‌دهد ولی `NA %in% "yes"` جواب `FALSE`.

</details>

<details>
<summary><b>حل ع۵</b></summary>

```r
a$bmi <- a$weight_kg / (a$height_cm / 100)^2
a$age_group <- cut(a$age, c(-Inf, 39, 59, Inf), labels = c("<40", "40-59", ">=60"))
mean(a$age, na.rm = TRUE)          # 48.42  (sum(!is.na(a$age)) = 38)
mean(a$bmi, na.rm = TRUE)          # 26.43  (37)
sum(a$bmi >= 30, na.rm = TRUE)     # 5
table(a$age_group, useNA = "ifany")
mean(a$sbp, na.rm = TRUE)          # 143.00 (36)
```

</details>

<details>
<summary><b>حل ع۶</b></summary>

```r
labs <- read.csv("../data/M04_labs.csv")
lab_pt <- merge(aggregate(ldl ~ pid, data = labs, FUN = mean),
                aggregate(cbind(n_tests = ldl) ~ pid, data = labs, FUN = length))
names(lab_pt)[2] <- "mean_ldl"
m <- merge(a, lab_pt, by = "pid", all.x = TRUE)
nrow(m)                                    # 39 ← بدون تکرار
m$pid[is.na(m$n_tests)]                    # 4 15 23 30 38
mean(m$mean_ldl, na.rm = TRUE)             # 120.58
setdiff(lab_pt$pid, a$pid)                 # 3 99
```

</details>

<details>
<summary><b>حل ع۷</b></summary>

```r
s2 <- read.csv("../data/M04_site2.csv", na.strings = "", stringsAsFactors = FALSE)
# همان متغیرهای محاسباتی برای s2 (کد کامل در فایل)
a$site <- 1; s2$site <- 2
final <- rbind(a, s2[, names(a)])
nrow(final); length(unique(final$pid))     # 44 44
mean(final$sbp, na.rm = TRUE)              # 143.00 (41)
```

</details>

## خطاهای رایج

| مشکل | علت | راه‌حل |
|---|---|---|
| `as.Date` نتیجهٔ `NA` داد | قالب تاریخ با پیش‌فرض نمی‌خواند | `as.Date(x, format = "%d/%m/%Y")` |
| تعداد سطر پس از `merge` زیاد شد | ادغام یک‌به‌چند بدون تجمیع | اول `aggregate`، بعد `merge` |
| `rbind` خطای «names do not match» | ستون‌ها متفاوت‌اند | `s2[, names(a)]` و یکسان‌سازی نام‌ها |
| `d$x[d$x > 5] <- NA` خطا با NA | شرط NA دارد | `which()` |
