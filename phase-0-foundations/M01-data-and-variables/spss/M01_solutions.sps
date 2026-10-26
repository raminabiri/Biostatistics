* =============================================================.
* ماژول M01 | مسیر SPSS | حل تمرین‌های عملی ع۱ تا ع۷ (روش Syntax).
* روش منویی هر تمرین در spss/README.md آمده است.
* خط CD را به مسیر پوشهٔ data روی رایانهٔ خودتان تغییر دهید.
* =============================================================.
CD 'C:\biostat\phase-0-foundations\M01-data-and-variables\data'.

* ---- ع۱: خواندن فایل؛ ابعاد داده در عنوان پنجرهٔ Data View و در خروجی N ----.
GET DATA /TYPE=TXT /FILE='M01_uti.csv' /ENCODING='UTF8'
  /DELIMITERS="," /QUALIFIER='"' /ARRANGEMENT=DELIMITED /FIRSTCASE=2
  /VARIABLES= id F4.0 age F3.0 sex F1.0 ward F1.0 organism A20 temp F4.1
    crp F6.1 wbc F5.1 pain F2.0 severity F1.0 los F3.0 cipro_res F1.0.
DATASET NAME uti WINDOW=FRONT.
* انتظار: 30 مورد (case) و 12 متغیر.
SHOW N.

* ---- ع۲: برچسب مقدار و سطح اندازه‌گیری ----.
VALUE LABELS sex 1 'Female' 2 'Male'
  /ward 1 'Internal' 2 'Surgery' 3 'ICU'
  /severity 1 'Mild' 2 'Moderate' 3 'Severe'
  /cipro_res 0 'Susceptible' 1 'Resistant'.
VARIABLE LEVEL sex ward organism cipro_res (NOMINAL)
  /severity pain (ORDINAL) /age temp crp wbc los (SCALE).
DISPLAY DICTIONARY.

* ---- ع۳: پیش و پس از تعریف کد گمشده ----.
DESCRIPTIVES VARIABLES=crp /STATISTICS=MEAN.
* انتظار: N=30، Mean=35.10 (اشتباه).
MISSING VALUES crp (-99).
DESCRIPTIVES VARIABLES=crp wbc /STATISTICS=MEAN.
* انتظار: crp با N=28 و Mean=44.68؛ wbc با N=29.

* ---- ع۴ ----.
DESCRIPTIVES VARIABLES=ward /STATISTICS=MEAN.
* انتظار: 1.80 — بی‌معنا.
FREQUENCIES VARIABLES=ward organism.
* انتظار: 12/12/6 و 17/9/4.

* ---- ع۵ ----.
CROSSTABS /TABLES=sex BY cipro_res /CELLS=COUNT.
* انتظار: Female × Resistant = 7.

* ---- ع۷ (پیش از ع۶ چون ع۶ فایل دیگری باز می‌کند) ----.
SAVE OUTFILE='M01_uti_labeled.sav'.

* ---- ع۶ ----.
GET DATA /TYPE=TXT /FILE='M01_crp_wide.csv' /ENCODING='UTF8'
  /DELIMITERS="," /ARRANGEMENT=DELIMITED /FIRSTCASE=2
  /VARIABLES= id F4.0 crp_d0 F6.1 crp_d3 F6.1 crp_d7 F6.1.
DATASET NAME crpwide WINDOW=FRONT.
VARSTOCASES /MAKE crp FROM crp_d0 crp_d3 crp_d7 /INDEX=visit(3) /KEEP=id.
RECODE visit (1=0) (2=3) (3=7) INTO day.
EXECUTE.
SHOW N.
* انتظار: 24 مورد.
