* =============================================================.
* ماژول M04 — آماده‌سازی و پاک‌سازی داده | مسیر SPSS | حل تمرین‌های عملی ع۱ تا ع۷.
* اجرای پروتکل P1 تا P11 (کدبوک). فایل CSV خام فقط خوانده می‌شود.
* خط CD را به مسیر پوشهٔ data تغییر دهید.
* =============================================================.
CD 'C:\biostat\phase-0-foundations\M04-data-preparation-cleaning\data'.

GET DATA /TYPE=TXT /FILE='M04_registry_raw.csv' /ENCODING='UTF8'
  /DELIMITERS="," /ARRANGEMENT=DELIMITED /FIRSTCASE=2
  /VARIABLES= entry_no F4.0 pid F4.0 sex A8 dob SDATE10 visit_date SDATE10
    height_cm F7.2 weight_kg F6.1 sbp F6.0 dbp F6.0 smoker A6 pregnant A6 hba1c F4.1.
DATASET NAME reg WINDOW=FRONT.

* ---- ع۱: غربال ----.
FREQUENCIES VARIABLES=sex smoker.
DESCRIPTIVES VARIABLES=height_cm weight_kg sbp dbp /STATISTICS=MIN MAX.
* انتظار: 42 سطر؛ 11 شکل برای sex؛ 9 شکل برای smoker (با خالی).
* شمارش تکرار شناسه:.
AGGREGATE /OUTFILE=* MODE=ADDVARIABLES /BREAK=pid /n_pid = N.
FREQUENCIES VARIABLES=n_pid.
* انتظار: دو شناسه (12 و 27) هر کدام دو بار.

* ---- ع۲: P1 تکرار کامل ----.
SORT CASES BY entry_no pid sex dob visit_date height_cm weight_kg sbp dbp smoker pregnant hba1c.
MATCH FILES /FILE=* /BY entry_no pid sex dob visit_date height_cm weight_kg sbp dbp smoker pregnant hba1c
  /FIRST=first_exact.
SELECT IF first_exact = 1.
EXECUTE.
* P2: تکرار کلید ← کوچک‌ترین entry_no.
SORT CASES BY pid entry_no.
MATCH FILES /FILE=* /BY pid /FIRST=first_pid.
SELECT IF first_pid = 1.
EXECUTE.
* انتظار: 40 سطر.

* P3 و P4: یکسان‌سازی متن.
COMPUTE sex = CHAR.SUBSTR(UPCASE(LTRIM(RTRIM(sex))), 1, 1).
STRING smk1 (A1).
COMPUTE smk1 = CHAR.SUBSTR(UPCASE(LTRIM(RTRIM(smoker))), 1, 1).
STRING smoker_c (A3).
IF (smk1 = 'Y') smoker_c = 'yes'.
IF (smk1 = 'N') smoker_c = 'no'.
MISSING VALUES smoker_c ('').
EXECUTE.
FREQUENCIES VARIABLES=sex smoker_c.
* انتظار: F 14، M 26؛ yes 4، no 35، گمشده 1.

* ---- ع۳: P5 تا P7 ----.
IF (height_cm < 3) height_cm = height_cm * 100.
IF (height_cm < 120 OR height_cm > 220) height_cm = $SYSMIS.
IF (weight_kg < 30 OR weight_kg > 250) weight_kg = $SYSMIS.
IF (sbp = -99) sbp = $SYSMIS.
IF (sbp < 70 OR sbp > 260) sbp = $SYSMIS.
IF (dbp < 40 OR dbp > 150) dbp = $SYSMIS.
EXECUTE.
DESCRIPTIVES VARIABLES=height_cm weight_kg sbp dbp /STATISTICS=MIN MAX.

* ---- ع۴: P8 تا P11 ----.
COMPUTE flag_bp = (dbp >= sbp).
IF (flag_bp = 1) sbp = $SYSMIS.
IF (flag_bp = 1) dbp = $SYSMIS.
COMPUTE flag_preg = (sex = 'M' AND pregnant = 'yes').
IF (sex = 'M') pregnant = ''.
COMPUTE flag_dob = (dob > visit_date).
IF (flag_dob = 1) dob = $SYSMIS.
COMPUTE age = DATEDIFF(visit_date, dob, "years").
EXECUTE.
FREQUENCIES VARIABLES=flag_bp flag_preg flag_dob.
* انتظار: هر پرچم یک بار (pid 22، 1، 35).
TEMPORARY.
SELECT IF (age < 18).
LIST pid age.
* انتظار: pid 3، سن 17.
SELECT IF (MISSING(age) OR age >= 18).
EXECUTE.
* انتظار: 39 سطر.

* ---- ع۵: متغیرهای محاسباتی ----.
COMPUTE bmi = weight_kg / (height_cm / 100)**2.
RECODE age (LO THRU 39=1) (40 THRU 59=2) (60 THRU HI=3) INTO age_group.
VALUE LABELS age_group 1 '<40' 2 '40-59' 3 '>=60'.
COMPUTE obese = (bmi >= 30).
EXECUTE.
DESCRIPTIVES VARIABLES=age bmi sbp /STATISTICS=MEAN.
FREQUENCIES VARIABLES=age_group obese.
* انتظار: age 48.42 (N 38)، bmi 26.43 (N 37)، sbp 143.00 (N 36)؛ گروه‌ها 14/14/10؛ obese 5.
DATASET NAME analysis.

* ---- ع۶: تجمیع آزمایش‌ها و ادغام چپ ----.
GET DATA /TYPE=TXT /FILE='M04_labs.csv' /ENCODING='UTF8'
  /DELIMITERS="," /ARRANGEMENT=DELIMITED /FIRSTCASE=2
  /VARIABLES= pid F4.0 test_date SDATE10 ldl F5.0 hdl F5.0.
DATASET NAME labs WINDOW=FRONT.
DATASET DECLARE labs_pt.
AGGREGATE /OUTFILE=labs_pt /BREAK=pid /mean_ldl = MEAN(ldl) /n_tests = N.
DATASET ACTIVATE labs_pt.
SORT CASES BY pid.
DATASET ACTIVATE analysis.
SORT CASES BY pid.
MATCH FILES /FILE=* /TABLE=labs_pt /BY pid.
EXECUTE.
DATASET NAME merged.
DESCRIPTIVES VARIABLES=mean_ldl n_tests /STATISTICS=MEAN.
FREQUENCIES VARIABLES=n_tests.
* انتظار: 39 سطر؛ 5 بیمار بدون آزمایش؛ میانگین mean_ldl = 120.58؛ n_tests: 1→5، 2→12، 3→17.
* شناسه‌های آزمایشِ بی‌جفت (ادغام کامل با پرچم):.
DATASET ACTIVATE labs_pt.
MATCH FILES /FILE=* /IN=in_lab /FILE=merged /IN=in_analysis /BY pid.
SELECT IF (in_lab = 1 AND in_analysis = 0).
LIST pid.
* انتظار: 3 و 99.

* ---- ع۷: الحاق مرکز 2 ----.
GET DATA /TYPE=TXT /FILE='M04_site2.csv' /ENCODING='UTF8'
  /DELIMITERS="," /ARRANGEMENT=DELIMITED /FIRSTCASE=2
  /VARIABLES= entry_no F4.0 pid F4.0 sex A8 dob SDATE10 visit_date SDATE10
    height_cm F7.2 weight_kg F6.1 sbp F6.0 dbp F6.0 smoker_c A3 pregnant A6 hba1c F4.1.
DATASET NAME site2 WINDOW=FRONT.
COMPUTE age = DATEDIFF(visit_date, dob, "years").
COMPUTE bmi = weight_kg / (height_cm / 100)**2.
RECODE age (LO THRU 39=1) (40 THRU 59=2) (60 THRU HI=3) INTO age_group.
IF (sex = 'M') pregnant = ''.
COMPUTE site = 2.
EXECUTE.
DATASET ACTIVATE merged.
COMPUTE site = 1.
EXECUTE.
ADD FILES /FILE=merged /FILE=site2
  /KEEP=pid site sex dob visit_date age age_group height_cm weight_kg bmi sbp dbp smoker_c pregnant hba1c mean_ldl n_tests.
EXECUTE.
DATASET NAME final WINDOW=FRONT.
FREQUENCIES VARIABLES=site.
DESCRIPTIVES VARIABLES=sbp /STATISTICS=MEAN.
* انتظار: 44 سطر (39 + 5)؛ sbp: N 41، میانگین 143.00.
* SAVE OUTFILE='M04_final_clean.sav'.
