# =============================================================
# ماژول M01 | مسیر R | حل تمرین‌های عملی ع۱ تا ع۷
# پیش از نگاه کردن به این فایل، تمرین‌ها را خودتان حل کنید.
# Working directory = پوشهٔ همین فایل
# =============================================================

# ---- ع۱: خواندن فایل و ابعاد داده ----
uti <- read.csv("../data/M01_uti.csv")
dim(uti)                # 30 سطر، 12 ستون
nrow(uti); ncol(uti)

# ---- ع۲: تعریف نوع و برچسب متغیرها ----
uti$sex       <- factor(uti$sex, 1:2, c("Female", "Male"))
uti$ward      <- factor(uti$ward, 1:3, c("Internal", "Surgery", "ICU"))
uti$organism  <- factor(uti$organism)
uti$cipro_res <- factor(uti$cipro_res, 0:1, c("Susceptible", "Resistant"))
uti$severity  <- factor(uti$severity, 1:3, c("Mild", "Moderate", "Severe"),
                        ordered = TRUE)
sapply(uti, function(x) class(x)[1])   # کنترل: نوع هر ستون
is.ordered(uti$severity)               # TRUE

# ---- ع۳: تعریف کد گمشده ----
mean(uti$crp)                          # 35.1 — اشتباه، چون -99 حساب شده
uti$crp[uti$crp == -99] <- NA
sum(!is.na(uti$crp))                   # 28 مقدار معتبر
round(mean(uti$crp, na.rm = TRUE), 2)  # 44.68
sum(is.na(uti$wbc))                    # 1 (خانهٔ خالی خودکار NA شده)

# ---- ع۴: میانگین کد بخش در برابر جدول فراوانی ----
mean(as.integer(uti$ward))             # 1.8 — عددی بی‌معنا
table(uti$ward)                        # 12, 12, 6
table(uti$organism)                    # 17, 9, 4

# ---- ع۵: جدول توافقی جنس × مقاومت ----
table(uti$sex, uti$cipro_res)          # زن مقاوم = 7

# ---- ع۶: تبدیل پهن به بلند ----
wide <- read.csv("../data/M01_crp_wide.csv")
long <- reshape(wide, direction = "long",
                varying = c("crp_d0", "crp_d3", "crp_d7"),
                v.names = "crp", timevar = "day", times = c(0, 3, 7),
                idvar = "id")
nrow(long)                             # 24 = 8 بیمار × 3 روز

# روش جایگزین با tidyr (اختیاری؛ نیاز به install.packages("tidyr")):
# long2 <- tidyr::pivot_longer(wide, crp_d0:crp_d7, names_to = "day",
#                              names_prefix = "crp_d", values_to = "crp")

# ---- ع۷: ذخیره ----
saveRDS(uti, "M01_uti_labeled.rds")
str(readRDS("M01_uti_labeled.rds"))    # برچسب‌ها حفظ شده‌اند
