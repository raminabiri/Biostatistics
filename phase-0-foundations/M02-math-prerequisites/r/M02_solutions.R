# =============================================================
# ماژول M02 — ریاضیات پیش‌نیاز | مسیر R | حل تمرین‌های عملی ع۱ تا ع۷
# Working directory = پوشهٔ همین فایل
# (Session > Set Working Directory > To Source File Location)
# =============================================================

d <- read.csv("../data/M02_clinic.csv")
g <- read.csv("../data/M02_genes.csv")

# ---- ع۱: BMI = وزن / (قد به متر)^2 ----
d$bmi <- d$weight_kg / (d$height_cm / 100)^2   # پرانتز را فراموش نکنید!
head(round(d$bmi, 1))
round(mean(d$bmi), 2)          # 29.44
sum(d$bmi >= 30)               # 10 بیمار چاق

# ---- ع۲: تغییر مطلق و درصد تغییر فشار خون ----
d$sbp_change <- d$sbp_12 - d$sbp_0                   # mmHg
d$sbp_pct    <- d$sbp_change / d$sbp_0 * 100         # درصد
round(mean(d$sbp_change), 2)   # -14.96 mmHg
round(mean(d$sbp_pct), 2)      # -10.01 %
sum(d$sbp_change <= -10)       # 17 بیمار دست‌کم 10 mmHg کاهش

# ---- ع۳: تبدیل واحد قند خون ----
d$glucose_mmol <- d$glucose_mgdl / 18
round(mean(d$glucose_mgdl), 2) # 151.42 mg/dL
round(mean(d$glucose_mmol), 2) # 8.41 mmol/L

# ---- ع۴: لگاریتم و میانگین هندسی تری‌گلیسرید ----
d$log_tg <- log10(d$tg_mgdl)   # توجه: log() در R لگاریتم طبیعی است
round(mean(d$tg_mgdl), 2)      # 207.71 میانگین حسابی
median(d$tg_mgdl)              # 208.5
round(mean(d$log_tg), 4)       # 2.2717
round(10^mean(d$log_tg), 2)    # 186.93 میانگین هندسی
round(exp(mean(log(d$tg_mgdl))), 2)  # همان جواب با ln

# ---- ع۵: نمادهای Σ روی سن ----
x <- d$age
length(x)                      # n = 24
sum(x)                         # Σx = 1401
mean(x)                        # x̄ = 58.375
sum(x^2)                       # Σx² = 84759
sum((x - mean(x))^2)           # SS = Σ(x - x̄)² = 2975.625
sum(x - mean(x))               # همیشه صفر (با خطای گرد کردن بسیار کوچک)

# ---- ع۶: fold change و log2 ----
g$fc    <- g$treated / g$control
g$log2fc <- log2(g$fc)
g$fc     <- round(g$fc, 2); g$log2fc <- round(g$log2fc, 2)
g
sum(abs(g$log2fc) >= 1)        # 7 ژن با تغییر دست‌کم دو برابر
sum(g$log2fc >= 1)             # 6 افزایش
sum(g$log2fc <= -1)            # 1 کاهش (FOS)

# ---- ع۷: کاهش نمایی غلظت دارو ----
t    <- seq(0, 24, by = 2)
conc <- 100 * 0.5^(t / 4)
data.frame(t, conc = round(conc, 2))
t[which(conc < 10)[1]]         # 14 ساعت: اولین زمان زیر 10 mg/L
round(4 * log2(10), 2)         # 13.29 ساعت: زمان دقیق
