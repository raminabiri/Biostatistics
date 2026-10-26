* =============================================================.
* ماژول M03 — جامعه، نمونه و طرح مطالعه | مسیر SPSS | حل تمرین‌های عملی ع۱ تا ع۷.
* خط CD را به مسیر پوشهٔ data روی رایانهٔ خودتان تغییر دهید.
* ایده: برای هر روش نمونه‌گیری یک متغیر ۰/۱ می‌سازیم (۱ = در نمونه)
* و میانگین‌ها را با MEANS برای گروه ۱ می‌خوانیم.
* =============================================================.
CD 'C:\biostat\phase-0-foundations\M03-population-sampling-study-design\data'.

GET DATA /TYPE=TXT /FILE='M03_frame.csv' /ENCODING='UTF8'
  /DELIMITERS="," /ARRANGEMENT=DELIMITED /FIRSTCASE=2
  /VARIABLES= id F4.0 district F1.0 block F2.0 sex F1.0 age F3.0 smoker F1.0
    sbp F4.0 htn F1.0 visit_order F4.0 u F8.6.
DATASET NAME frame WINDOW=FRONT.

* ---- ع۱: پارامترهای جامعه ----.
DESCRIPTIVES VARIABLES=sbp htn /STATISTICS=MEAN.
MEANS TABLES=htn BY district /CELLS=MEAN COUNT.
* انتظار: میانگین sbp = 129.88؛ میانگین htn = 0.275 (27.5٪).
* شیوع محله‌ها: 0.380، 0.244، 0.229، 0.180.

* ---- ع۲: تصادفی ساده (60 کوچک‌ترین u) ----.
RANK VARIABLES=u (A) /RANK INTO rank_u /PRINT=NO.
COMPUTE in_srs = (rank_u <= 60).
EXECUTE.
MEANS TABLES=sbp htn BY in_srs /CELLS=MEAN COUNT.
* انتظار (گروه 1): n=60، sbp=133.12، htn=0.3333.

* ---- ع۳: سیستماتیک (k=10، شروع 7) ----.
COMPUTE in_sys = (MOD(id - 7, 10) = 0).
EXECUTE.
MEANS TABLES=sbp htn BY in_sys /CELLS=MEAN COUNT.
* انتظار: n=60، sbp=131.70، htn=0.3167.

* ---- ع۴: طبقه‌ای متناسب ----.
RANK VARIABLES=u (A) BY district /RANK INTO rank_d /PRINT=NO.
AGGREGATE /OUTFILE=* MODE=ADDVARIABLES /BREAK=district /n_d = N.
COMPUTE alloc = RND(n_d / 600 * 60).
COMPUTE in_strat = (rank_d <= alloc).
EXECUTE.
CROSSTABS /TABLES=district BY in_strat.
MEANS TABLES=sbp htn BY in_strat /CELLS=MEAN COUNT.
* انتظار: 20/16/14/10 نفر؛ sbp=135.25، htn=0.3833.

* ---- ع۵: خوشه‌ای (بلوک‌های 4، 15، 27) ----.
COMPUTE in_cluster = ANY(block, 4, 15, 27).
EXECUTE.
MEANS TABLES=sbp htn BY in_cluster /CELLS=MEAN COUNT.
CROSSTABS /TABLES=district BY in_cluster.
* انتظار: sbp=129.28، htn=0.3333؛ محلهٔ 3 در نمونه نیست.

* ---- ع۷: در دسترس (60 اولین مراجعه‌کننده) ----.
COMPUTE in_conv = (visit_order <= 60).
EXECUTE.
MEANS TABLES=sbp htn BY in_conv /CELLS=MEAN COUNT.
* انتظار: sbp=148.67، htn=0.95.

* ---- ع۶: تصادفی‌سازی بلوکی ----.
GET DATA /TYPE=TXT /FILE='M03_trial.csv' /ENCODING='UTF8'
  /DELIMITERS="," /ARRANGEMENT=DELIMITED /FIRSTCASE=2
  /VARIABLES= id F3.0 u F8.6.
DATASET NAME trial WINDOW=FRONT.
COMPUTE blk = TRUNC((id - 1) / 4) + 1.
EXECUTE.
RANK VARIABLES=u (A) BY blk /RANK INTO r_blk /PRINT=NO.
STRING grp (A1).
IF (r_blk <= 2) grp = 'A'.
IF (r_blk > 2) grp = 'B'.
EXECUTE.
LIST id u blk r_blk grp.
FREQUENCIES VARIABLES=grp.
* انتظار: A = 12، B = 12؛ گروه A: 2 3 7 8 10 11 14 15 17 20 23 24.

* ---- نکته برای پژوهش واقعی: نمونهٔ تصادفی با بذر ----.
* SET SEED=2026.
* SAMPLE 60 FROM 600.
* (این دستور نمونه را جایگزین داده می‌کند؛ پیش از آن DATASET COPY بگیرید.)
