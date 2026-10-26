# =============================================================
# ماژول M04 — آماده‌سازی و پاک‌سازی داده | مسیر R | حل تمرین‌های عملی
# Working directory = پوشهٔ همین فایل
# اجرای پروتکل P1 تا P11 (کدبوک) + دفترچهٔ پاک‌سازی خودکار
# =============================================================

raw <- read.csv("../data/M04_registry_raw.csv", na.strings = "",
                stringsAsFactors = FALSE)        # فایل خام فقط خوانده می‌شود

# دفترچهٔ پاک‌سازی: هر تغییر یک سطر
cleaning_log <- data.frame(rule = character(), pid = integer(),
                           variable = character(), old = character(),
                           new = character())
log_change <- function(rule, pid, variable, old, new) {
  if (length(pid) == 0) return(invisible())
  cleaning_log <<- rbind(cleaning_log, data.frame(rule = rule, pid = pid,
    variable = variable, old = as.character(old), new = as.character(new)))
}

# ---- ع۱: غربال اولیه ----
nrow(raw)                          # 42 سطر
length(unique(raw$pid))            # 40 بیمار
sum(duplicated(raw))               # 1 تکرار کامل
length(unique(raw$sex))            # 11 شکل نوشتاری برای جنس!
table(raw$sex, useNA = "ifany")
length(unique(raw$smoker))         # 9 (با گمشده)

# ---- ع۲: P1 تا P4 ----
log_change("P1", raw$pid[duplicated(raw)], "row", "exact duplicate", "removed")
d <- raw[!duplicated(raw), ]                                   # P1
d$pid[duplicated(d$pid)]                                       # تکرار کلید: 27
d <- d[order(d$pid, d$entry_no), ]
log_change("P2", d$pid[duplicated(d$pid)], "row", "entry_no=42", "removed")
d <- d[!duplicated(d$pid), ]                                   # P2: کوچک‌ترین entry_no
nrow(d)                                                        # 40

d$sex <- toupper(substr(trimws(d$sex), 1, 1))                  # P3
table(d$sex)                                                   # F 14, M 26
s <- toupper(substr(trimws(d$smoker), 1, 1))                   # P4
d$smoker <- ifelse(s == "Y", "yes", ifelse(s == "N", "no", NA))
table(d$smoker, useNA = "ifany")                               # no 35, yes 4, NA 1

# ---- ع۳: P5 تا P7 (بازه) ----
i <- which(d$height_cm < 3)                                    # P5: متر ← سانتی‌متر
log_change("P5", d$pid[i], "height_cm", d$height_cm[i], d$height_cm[i] * 100)
d$height_cm[i] <- d$height_cm[i] * 100
i <- which(d$height_cm < 120 | d$height_cm > 220)
log_change("P5", d$pid[i], "height_cm", d$height_cm[i], NA); d$height_cm[i] <- NA
i <- which(d$weight_kg < 30 | d$weight_kg > 250)               # P6
log_change("P6", d$pid[i], "weight_kg", d$weight_kg[i], NA); d$weight_kg[i] <- NA
i <- which(d$sbp == -99)                                       # P7
log_change("P7", d$pid[i], "sbp", d$sbp[i], NA); d$sbp[i] <- NA
i <- which(d$sbp < 70 | d$sbp > 260)
log_change("P7", d$pid[i], "sbp", d$sbp[i], NA); d$sbp[i] <- NA
i <- which(d$dbp < 40 | d$dbp > 150)
log_change("P7", d$pid[i], "dbp", d$dbp[i], NA); d$dbp[i] <- NA

# ---- ع۴: P8 تا P11 (سازگاری) ----
i <- which(d$dbp >= d$sbp)                                     # P8
log_change("P8", d$pid[i], "sbp,dbp", paste(d$sbp[i], d$dbp[i]), NA)
d$sbp[i] <- NA; d$dbp[i] <- NA
i <- which(d$sex == "M" & d$pregnant %in% "yes")               # P9
log_change("P9", d$pid[i], "pregnant", "yes", NA)
d$pregnant[d$sex == "M"] <- NA
d$dob <- as.Date(d$dob); d$visit_date <- as.Date(d$visit_date)
i <- which(d$dob > d$visit_date)                               # P10
log_change("P10", d$pid[i], "dob", d$dob[i], NA); d$dob[i] <- NA

# P11: سن کامل (سال تقویمی منهای ۱ اگر تولد امسال هنوز نرسیده)
full_years <- function(from, to) {
  as.numeric(format(to, "%Y")) - as.numeric(format(from, "%Y")) -
    (format(to, "%m%d") < format(from, "%m%d"))
}
d$age <- full_years(d$dob, d$visit_date)
d$pid[which(d$age < 18)]                                       # 3
log_change("P11", d$pid[which(d$age < 18)], "row", "age<18", "excluded")
a <- d[is.na(d$age) | d$age >= 18, ]
nrow(a)                                                        # 39

cleaning_log                                                   # دفترچهٔ پاک‌سازی

# ---- ع۵: متغیرهای محاسباتی ----
a$bmi <- a$weight_kg / (a$height_cm / 100)^2
a$age_group <- cut(a$age, breaks = c(-Inf, 39, 59, Inf),
                   labels = c("<40", "40-59", ">=60"))         # 39 و 59 در گروه پایین
round(mean(a$age, na.rm = TRUE), 2); sum(!is.na(a$age))       # 48.42 (n = 38)
round(mean(a$bmi, na.rm = TRUE), 2); sum(!is.na(a$bmi))       # 26.43 (n = 37)
sum(a$bmi >= 30, na.rm = TRUE)                                 # 5
table(a$age_group, useNA = "ifany")                            # 14 14 10 NA:1
round(mean(a$sbp, na.rm = TRUE), 2); sum(!is.na(a$sbp))       # 143.00 (n = 36)

# ---- ع۶: تجمیع آزمایش‌ها و ادغام ----
labs <- read.csv("../data/M04_labs.csv")
nrow(labs); length(unique(labs$pid))                          # 83 سطر، 36 بیمار
lab_pt <- merge(aggregate(ldl ~ pid, data = labs, FUN = mean),
                aggregate(cbind(n_tests = ldl) ~ pid, data = labs, FUN = length))
names(lab_pt)[2] <- "mean_ldl"
m <- merge(a, lab_pt, by = "pid", all.x = TRUE)                # ادغام چپ
nrow(m)                                                        # 39 (بدون تکرار)
m$pid[is.na(m$n_tests)]                                        # 4 15 23 30 38
round(mean(m$mean_ldl, na.rm = TRUE), 2)                       # 120.58
table(m$n_tests, useNA = "ifany")                              # 1:5  2:12  3:17  NA:5
setdiff(lab_pt$pid, a$pid)                                     # 3 99

# ---- ع۷: الحاق مرکز ۲ ----
s2 <- read.csv("../data/M04_site2.csv", na.strings = "", stringsAsFactors = FALSE)
s2$dob <- as.Date(s2$dob); s2$visit_date <- as.Date(s2$visit_date)
s2$age <- full_years(s2$dob, s2$visit_date)
s2$bmi <- s2$weight_kg / (s2$height_cm / 100)^2
s2$age_group <- cut(s2$age, c(-Inf, 39, 59, Inf), labels = c("<40", "40-59", ">=60"))
s2$pregnant[s2$sex == "M"] <- NA
a$site <- 1; s2$site <- 2
final <- rbind(a, s2[, names(a)])                              # ستون‌ها هم‌ترتیب
nrow(final); length(unique(final$pid))                         # 44, 44
table(final$site)                                              # 39, 5
round(mean(final$sbp, na.rm = TRUE), 2); sum(!is.na(final$sbp))   # 143.00 (n = 41)

# ذخیرهٔ خروجی‌ها (فایل خام دست‌نخورده می‌ماند)
# write.csv(final, "M04_final_clean.csv", row.names = FALSE)
# write.csv(cleaning_log, "M04_cleaning_log.csv", row.names = FALSE)
