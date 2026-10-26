* =============================================================.
* ماژول M02 — ریاضیات پیش‌نیاز | مسیر SPSS | حل تمرین‌های عملی ع۱ تا ع۷.
* خط CD را به مسیر پوشهٔ data روی رایانهٔ خودتان تغییر دهید.
* در SPSS توان با ** نوشته می‌شود؛ LG10 = لگاریتم پایه ۱۰؛ LN = طبیعی.
* =============================================================.
CD 'C:\biostat\phase-0-foundations\M02-math-prerequisites\data'.

GET DATA /TYPE=TXT /FILE='M02_clinic.csv' /ENCODING='UTF8'
  /DELIMITERS="," /ARRANGEMENT=DELIMITED /FIRSTCASE=2
  /VARIABLES= id F3.0 sex F1.0 age F3.0 weight_kg F5.1 height_cm F4.0
    sbp_0 F4.0 sbp_12 F4.0 glucose_mgdl F4.0 tg_mgdl F4.0.
DATASET NAME clinic WINDOW=FRONT.

* ---- ع۱: BMI ----.
COMPUTE bmi = weight_kg / (height_cm / 100)**2.
COMPUTE obese = (bmi >= 30).
EXECUTE.
DESCRIPTIVES VARIABLES=bmi /STATISTICS=MEAN MIN MAX.
FREQUENCIES VARIABLES=obese.
* انتظار: میانگین BMI = 29.44 و obese = 1 برای 10 بیمار.

* ---- ع۲: تغییر مطلق و درصد تغییر فشار ----.
COMPUTE sbp_change = sbp_12 - sbp_0.
COMPUTE sbp_pct = sbp_change / sbp_0 * 100.
COMPUTE reduced10 = (sbp_change <= -10).
EXECUTE.
DESCRIPTIVES VARIABLES=sbp_change sbp_pct /STATISTICS=MEAN.
FREQUENCIES VARIABLES=reduced10.
* انتظار: -14.96 mmHg و -10.01 درصد؛ reduced10 = 1 برای 17 بیمار.

* ---- ع۳: تبدیل واحد قند ----.
COMPUTE glucose_mmol = glucose_mgdl / 18.
EXECUTE.
DESCRIPTIVES VARIABLES=glucose_mgdl glucose_mmol /STATISTICS=MEAN.
* انتظار: 151.42 و 8.41.

* ---- ع۴: لگاریتم و میانگین هندسی ----.
COMPUTE log_tg = LG10(tg_mgdl).
EXECUTE.
MEANS TABLES=tg_mgdl /CELLS=MEAN MEDIAN GEOMETRIC.
DESCRIPTIVES VARIABLES=log_tg /STATISTICS=MEAN.
* انتظار: میانگین 207.71، میانه 208.50، میانگین هندسی 186.93؛ میانگین log10 = 2.2717.

* ---- ع۵: نمادهای Σ روی سن ----.
COMPUTE age_sq = age**2.
EXECUTE.
DESCRIPTIVES VARIABLES=age age_sq /STATISTICS=MEAN SUM.
* SS: ابتدا میانگین را به همهٔ سطرها اضافه می‌کنیم.
AGGREGATE /OUTFILE=* MODE=ADDVARIABLES /age_mean = MEAN(age).
COMPUTE age_dev_sq = (age - age_mean)**2.
EXECUTE.
DESCRIPTIVES VARIABLES=age_dev_sq /STATISTICS=SUM.
* انتظار: n=24، Σx=1401، x̄=58.375، Σx²=84759، SS=2975.625.

* ---- ع۶: fold change ----.
GET DATA /TYPE=TXT /FILE='M02_genes.csv' /ENCODING='UTF8'
  /DELIMITERS="," /ARRANGEMENT=DELIMITED /FIRSTCASE=2
  /VARIABLES= gene A10 control F7.1 treated F7.1.
DATASET NAME genes WINDOW=FRONT.
COMPUTE fc = treated / control.
COMPUTE log2fc = LN(fc) / LN(2).
COMPUTE changed2x = (ABS(log2fc) >= 1).
EXECUTE.
LIST gene fc log2fc changed2x.
FREQUENCIES VARIABLES=changed2x.
* انتظار: changed2x = 1 برای 7 ژن (6 افزایش، 1 کاهش: FOS).

* ---- ع۷: جدول غلظت دارو (ساختن داده با حلقه) ----.
INPUT PROGRAM.
LOOP t = 0 TO 24 BY 2.
  END CASE.
END LOOP.
END FILE.
END INPUT PROGRAM.
DATASET NAME pk WINDOW=FRONT.
COMPUTE conc = 100 * 0.5**(t / 4).
COMPUTE below10 = (conc < 10).
FORMATS conc (F6.2).
EXECUTE.
LIST t conc below10.
* انتظار: اولین t با below10 = 1 برابر 14 است (8.84 mg/L).
* زمان دقیق = 4 * LN(10)/LN(2) = 13.29 ساعت.
