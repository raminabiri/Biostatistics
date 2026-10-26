# =============================================================
# ماژول M01 — داده، متغیر و ساختار مجموعه‌داده | مسیر R
# اجرای کامل: این فایل را در RStudio باز کنید و
# Session > Set Working Directory > To Source File Location
# را بزنید، سپس خط به خط (Ctrl+Enter) اجرا کنید.
# فقط از R پایه استفاده شده؛ بستهٔ اضافه لازم نیست.
# =============================================================

# ---- گام ۱: خواندن داده (درس ۱.۱) ----
uti <- read.csv("../data/M01_uti.csv")

dim(uti)        # تعداد سطر (مشاهده) و ستون (متغیر)
head(uti, 5)    # پنج سطر اول
str(uti)        # نوعی که R برای هر ستون حدس زده است

# ---- گام ۲: تعیین نوع متغیرها (درس ۱.۲) ----
# متغیرهای اسمی  -> factor
uti$sex       <- factor(uti$sex,  levels = c(1, 2), labels = c("Female", "Male"))
uti$ward      <- factor(uti$ward, levels = c(1, 2, 3),
                        labels = c("Internal", "Surgery", "ICU"))
uti$organism  <- factor(uti$organism)
uti$cipro_res <- factor(uti$cipro_res, levels = c(0, 1),
                        labels = c("Susceptible", "Resistant"))
# متغیر ترتیبی -> ordered factor (ترتیب سطوح معنا دارد)
uti$severity  <- factor(uti$severity, levels = c(1, 2, 3),
                        labels = c("Mild", "Moderate", "Severe"),
                        ordered = TRUE)
# pain (۰ تا ۱۰) و los (روز بستری) را عددی نگه می‌داریم،
# ولی در درس ۱.۲ دیدیم که pain ذاتاً ترتیبی و los شمارشی است.

str(uti)

# ---- گام ۳: داده‌های گمشده (درس ۱.۴) ----
summary(uti$crp)              # کمینه = -99 ! این مقدار واقعی نیست
uti$crp[uti$crp == -99] <- NA # کد گمشده -> NA
summary(uti$crp)
colSums(is.na(uti))           # تعداد گمشده در هر ستون
sum(!is.na(uti$crp))          # تعداد مقادیر معتبر CRP

# ---- گام ۴: کد عددی ≠ عدد (درس ۱.۲) ----
raw <- read.csv("../data/M01_uti.csv")
mean(raw$ward)     # از نظر محاسباتی ممکن است، از نظر علمی بی‌معنا
table(uti$ward)    # خلاصهٔ درست برای متغیر اسمی: فراوانی
table(uti$severity)

# ---- گام ۵: ساختار پهن و بلند (درس ۱.۳) ----
wide <- read.csv("../data/M01_crp_wide.csv")
wide
long <- reshape(wide, direction = "long",
                varying = c("crp_d0", "crp_d3", "crp_d7"),
                v.names = "crp", timevar = "day", times = c(0, 3, 7),
                idvar = "id")
long <- long[order(long$id, long$day), ]
rownames(long) <- NULL
head(long, 6)
dim(long)

# ---- گام ۶: ذخیرهٔ داده با حفظ برچسب‌ها ----
saveRDS(uti, "M01_uti_labeled.rds")   # factor ها حفظ می‌شوند
# بازخوانی: uti <- readRDS("M01_uti_labeled.rds")
