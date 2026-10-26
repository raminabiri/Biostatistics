# مسیر R

**R** زبان برنامه‌نویسی رایگان مخصوص آمار است. تقریباً هر روش آماری، از ساده‌ترین تا جدیدترین، در R یا بسته‌های آن موجود است.

## نصب و آماده‌سازی

1. **R** را از سایت CRAN (`cran.r-project.org`) نصب کنید (نسخهٔ آزمایش‌شده در دوره: R 4.6).
2. **RStudio Desktop** را از سایت Posit نصب کنید. RStudio محیط کار است؛ خود R باید جداگانه نصب شده باشد.
3. در RStudio: `File > Open File` و اسکریپت ماژول را باز کنید، سپس
   `Session > Set Working Directory > To Source File Location`.
4. اجرای یک خط یا بخش انتخاب‌شده: **Ctrl+Enter** (مک: Cmd+Enter).

## سیاست بسته‌ها

- فاز ۰ تا ۲ فقط با **R پایه** نوشته شده است تا نصب بسته‌ای لازم نباشد.
- از فاز ۳ به بعد بسته‌ها اضافه می‌شوند و در ابتدای هر اسکریپت با `install.packages()` معرفی می‌شوند.
- روش‌های جایگزین با `tidyverse` به‌صورت «اختیاری» داخل کد آمده‌اند.

## ماژول‌ها در مسیر R

| شناسه | عنوان | پوشه |
|---|---|---|
| M01 | داده، متغیر و ساختار مجموعه‌داده | [r/](../phase-0-foundations/M01-data-and-variables/r/README.md) |
| M02 | ریاضیات پیش‌نیاز | [r/](../phase-0-foundations/M02-math-prerequisites/r/README.md) |
| M03 | جامعه، نمونه و طرح مطالعه | [r/](../phase-0-foundations/M03-population-sampling-study-design/r/README.md) |
| M04 | آماده‌سازی و پاک‌سازی داده | [r/](../phase-0-foundations/M04-data-preparation-cleaning/r/README.md) |
