# =============================================================
# ماژول M03 — جامعه، نمونه و طرح مطالعه | مسیر R | حل تمرین‌های عملی
# Working directory = پوشهٔ همین فایل
# =============================================================

f  <- read.csv("../data/M03_frame.csv")
tr <- read.csv("../data/M03_trial.csv")

# تابع کمکی: خلاصهٔ یک نمونه
summ <- function(x) c(n = nrow(x), mean_sbp = round(mean(x$sbp), 2),
                      prev_htn = round(100 * mean(x$htn), 2))

# ---- ع۱: پارامترهای جامعه ----
summ(f)                                        # N=600, μ=129.88, π=27.50%
round(100 * tapply(f$htn, f$district, mean), 2) # 38.00 24.38 22.86 18.00

# ---- ع۲: نمونهٔ تصادفی ساده (۶۰ کوچک‌ترین u) ----
srs <- f[order(f$u), ][1:60, ]
summ(srs)                                      # 133.12, 33.33%
head(srs$id, 5)                                # 552 542 273 104 361

# ---- ع۳: نمونهٔ سیستماتیک (k = 10، شروع 7) ----
sys_s <- f[f$id %in% seq(7, 600, by = 10), ]
summ(sys_s)                                    # 131.70, 31.67%

# ---- ع۴: نمونهٔ طبقه‌ای متناسب (20/16/14/10) ----
alloc <- round(table(f$district) / nrow(f) * 60)   # 20 16 14 10
alloc
strat <- do.call(rbind, lapply(names(alloc), function(d) {
  x <- f[f$district == as.numeric(d), ]
  x[order(x$u), ][1:alloc[d], ]
}))
summ(strat)                                    # 135.25, 38.33%
table(strat$district)

# ---- ع۵: نمونهٔ خوشه‌ای (بلوک‌های 4، 15، 27) ----
clus <- f[f$block %in% c(4, 15, 27), ]
summ(clus)                                     # 129.28, 33.33%
table(clus$district)                           # محلهٔ 3 نیست

# ---- ع۶: تصادفی‌سازی بلوکی (بلوک 4 تایی؛ 2 کوچک‌ترین u ← A) ----
tr$block <- ceiling(tr$id / 4)
tr$group <- ave(tr$u, tr$block, FUN = function(v) ifelse(rank(v) <= 2, "A", "B"))
tr
table(tr$group)                                # A=12, B=12
tr$id[tr$group == "A"]                         # 2 3 7 8 10 11 14 15 17 20 23 24

# ---- ع۷: نمونهٔ در دسترس (۶۰ اولین مراجعه‌کننده) ----
conv <- f[f$visit_order <= 60, ]
summ(conv)                                     # 148.67, 95.00%
round(100 * mean(conv$htn) - 100 * mean(f$htn), 1)   # سوگیری = +67.5 واحد درصد

# ---- ع۸ (فقط R و Python): شبیه‌سازی ۱۰۰۰ نمونه ----
# این بار خودمان عدد تصادفی می‌سازیم؛ جواب دقیق به بذر بستگی دارد.
set.seed(2026)
B <- 1000
p_srs <- replicate(B, mean(f$htn[sample(nrow(f), 60)]))
p_str <- replicate(B, {
  idx <- unlist(lapply(names(alloc), function(d)
    sample(which(f$district == as.numeric(d)), alloc[d])))
  mean(f$htn[idx])
})
round(100 * c(mean_srs = mean(p_srs), sd_srs = sd(p_srs),
              mean_str = mean(p_str), sd_str = sd(p_str)), 2)
# هر دو روش به‌طور میانگین ≈ 27.5 (بدون سوگیری)؛ پراکندگی طبقه‌ای کمی کمتر است.
hist(100 * p_srs, main = "1000 SRS of n = 60", xlab = "Prevalence (%)")
abline(v = 27.5, lwd = 2)
