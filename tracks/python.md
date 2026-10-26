# مسیر Python

**Python** زبان برنامه‌نویسی عمومی است که با کتابخانه‌های `pandas`، `scipy`، `statsmodels`، `pingouin`، `matplotlib`/`seaborn` و `scikit-learn` به ابزار کاملی برای تحلیل آماری و یادگیری ماشین تبدیل می‌شود.

## نصب و آماده‌سازی

1. **Miniforge** (یا Anaconda) را نصب کنید. نسخهٔ آزمایش‌شده در دوره: Python 3.12+ و pandas 2.3.
2. یک محیط برای دوره بسازید:
   ```bash
   conda create -n biostat python=3.12 pandas scipy statsmodels matplotlib seaborn jupyterlab
   conda activate biostat
   ```
3. محیط کار پیشنهادی: **VS Code** با افزونهٔ Python، یا **JupyterLab**.
   در VS Code هر خط `# %%` در اسکریپت یک «سلول» است و با Shift+Enter اجرا می‌شود.
4. اسکریپت‌ها را **از داخل پوشهٔ خودشان** اجرا کنید (مسیر داده نسبی است: `../data/`).

## سیاست کتابخانه‌ها

- فاز ۰ فقط `pandas` لازم دارد.
- کتابخانه‌های بعدی در ابتدای هر ماژول معرفی می‌شوند.

## ماژول‌ها در مسیر Python

| شناسه | عنوان | پوشه |
|---|---|---|
| M01 | داده، متغیر و ساختار مجموعه‌داده | [python/](../phase-0-foundations/M01-data-and-variables/python/README.md) |
| M02 | ریاضیات پیش‌نیاز | [python/](../phase-0-foundations/M02-math-prerequisites/python/README.md) |
| M03 | جامعه، نمونه و طرح مطالعه | [python/](../phase-0-foundations/M03-population-sampling-study-design/python/README.md) |
| M04 | آماده‌سازی و پاک‌سازی داده | [python/](../phase-0-foundations/M04-data-preparation-cleaning/python/README.md) |
