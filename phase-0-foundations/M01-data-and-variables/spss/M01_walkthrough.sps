* =============================================================.
* ماژول M01 — داده، متغیر و ساختار مجموعه‌داده | مسیر SPSS.
* اجرا: File > Open > Syntax، سپس خط CD زیر را به مسیر پوشهٔ data.
* روی رایانهٔ خودتان تغییر دهید و Run > All را بزنید.
* هر دستور SPSS با نقطه (.) تمام می‌شود.
* =============================================================.

* ---- گام ۱: خواندن فایل CSV (درس ۱.۱) ----.
CD 'C:\biostat\phase-0-foundations\M01-data-and-variables\data'.

GET DATA
  /TYPE=TXT
  /FILE='M01_uti.csv'
  /ENCODING='UTF8'
  /DELIMITERS=","
  /QUALIFIER='"'
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /VARIABLES=
    id F4.0
    age F3.0
    sex F1.0
    ward F1.0
    organism A20
    temp F4.1
    crp F6.1
    wbc F5.1
    pain F2.0
    severity F1.0
    los F3.0
    cipro_res F1.0.
DATASET NAME uti WINDOW=FRONT.

* ---- گام ۲: برچسب متغیر، برچسب مقدار و سطح اندازه‌گیری (درس ۱.۲) ----.
VARIABLE LABELS
  id 'Patient ID'
  age 'Age (years)'
  sex 'Sex'
  ward 'Hospital ward'
  organism 'Isolated organism'
  temp 'Body temperature (C)'
  crp 'C-reactive protein (mg/L)'
  wbc 'White blood cells (x10^9/L)'
  pain 'Pain score (0-10)'
  severity 'Clinical severity'
  los 'Length of stay (days)'
  cipro_res 'Ciprofloxacin resistance'.

VALUE LABELS
  sex 1 'Female' 2 'Male'
  /ward 1 'Internal' 2 'Surgery' 3 'ICU'
  /severity 1 'Mild' 2 'Moderate' 3 'Severe'
  /cipro_res 0 'Susceptible' 1 'Resistant'.

VARIABLE LEVEL
  sex ward organism cipro_res (NOMINAL)
  /severity pain (ORDINAL)
  /age temp crp wbc los (SCALE).

* ---- گام ۳: کد گمشده (درس ۱.۴) ----.
MISSING VALUES crp (-99).
* خانهٔ خالی wbc به‌طور خودکار «گمشدهٔ سیستمی» (نقطه) می‌شود.

DISPLAY DICTIONARY.
DESCRIPTIVES VARIABLES=crp wbc /STATISTICS=MEAN MIN MAX.

* ---- گام ۴: کد عددی ≠ عدد (درس ۱.۲) ----.
* میانگین کد بخش محاسبه می‌شود ولی معنا ندارد.
DESCRIPTIVES VARIABLES=ward /STATISTICS=MEAN.
FREQUENCIES VARIABLES=ward severity.

* ---- گام ۵: ذخیرهٔ فایل .sav (همهٔ برچسب‌ها حفظ می‌شود) ----.
SAVE OUTFILE='M01_uti_labeled.sav'.

* ---- گام ۶: ساختار پهن و بلند (درس ۱.۳) ----.
GET DATA
  /TYPE=TXT
  /FILE='M01_crp_wide.csv'
  /ENCODING='UTF8'
  /DELIMITERS=","
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /VARIABLES=
    id F4.0
    crp_d0 F6.1
    crp_d3 F6.1
    crp_d7 F6.1.
DATASET NAME crpwide WINDOW=FRONT.
LIST.

VARSTOCASES
  /MAKE crp FROM crp_d0 crp_d3 crp_d7
  /INDEX=visit(3)
  /KEEP=id.
* visit = 1, 2, 3 را به روز واقعی تبدیل می‌کنیم.
RECODE visit (1=0) (2=3) (3=7) INTO day.
EXECUTE.
LIST.
