# M03 در SPSS — انتخاب نمونه، Rank Cases و تصادفی‌سازی

[← ماژول M03](../README.md) | [صفحهٔ مسیر SPSS](../../../tracks/spss.md)

**فایل:** [`M03_solutions.sps`](M03_solutions.sps). خط `CD` را به مسیر پوشهٔ `data` تغییر دهید.

## بخش آموزشی

### ایدهٔ کار در SPSS

برای هر روش نمونه‌گیری یک **متغیر ۰/۱** می‌سازیم (۱ = در نمونه). سپس با `Analyze > Compare Means > Means` میانگین `sbp` و `htn` را برای گروه ۱ می‌خوانیم. میانگین متغیر ۰/۱ همان نسبت است (۰٫۳۳ یعنی ۳۳٪).

### ابزارهای منویی

| کار | منو |
|---|---|
| رتبه‌بندی (کلی یا درون گروه) | `Transform > Rank Cases` ← Variable: `u`؛ By: `district` (برای رتبه درون محله) |
| ساختن متغیر ۰/۱ | `Transform > Compute Variable` ← مثلاً `in_srs = rank_u <= 60` |
| تعداد هر گروه را به هر سطر اضافه کردن | `Data > Aggregate` ← Break: `district` ← `n_d = N` ← Add aggregated variables to active dataset |
| میانگین برای گروه‌ها | `Analyze > Compare Means > Means` ← Dependent: `sbp htn`؛ Independent: `in_srs` |
| انتخاب موقت سطرها | `Data > Select Cases > If condition is satisfied` |
| نمونهٔ تصادفی واقعی | `Transform > Random Number Generators` (تعیین بذر) ← `Data > Select Cases > Random sample of cases` |

### توابع مفید Compute

| تابع | معنا | مثال |
|---|---|---|
| `MOD(a, b)` | باقی‌ماندهٔ تقسیم | `MOD(id - 7, 10) = 0` ← سیستماتیک |
| `ANY(x, a, b, c)` | آیا x یکی از این مقادیر است؟ | `ANY(block, 4, 15, 27)` |
| `TRUNC(x)` | قسمت صحیح | `TRUNC((id - 1)/4) + 1` ← شمارهٔ بلوک |
| `RND(x)` | گرد کردن | `RND(n_d/600*60)` |

## تمرین‌های عملی (ع۱ تا ع۷)

این تمرین‌ها در هر پنج مسیر **یکسان‌اند** و جواب عددی یکسان دارند. داده: `data/M03_frame.csv` (کل جامعهٔ ۶۰۰ نفره) و `data/M03_trial.csv`. **«تصادفی» در این تمرین‌ها یعنی استفاده از ستون آمادهٔ `u`** (کدبوک).

| شماره | سطح | تمرین | درس |
|---|---|---|---|
| ع۱ | ۱ | **پارامترهای جامعه:** میانگین فشار سیستولی (μ) و شیوع فشار خون بالا (π) کل ۶۰۰ نفر؛ شیوع در هر محله. | ۳.۱ |
| ع۲ | ۱ | **تصادفی ساده:** ۶۰ نفر با کوچک‌ترین `u`. میانگین فشار و شیوع در نمونه؟ شناسهٔ ۵ نفر اول (به ترتیب u)؟ | ۳.۲ |
| ع۳ | ۱ | **سیستماتیک:** k = 10، شروع از فرد ۷ (افراد 7، 17، ...، 597). میانگین فشار و شیوع؟ | ۳.۲ |
| ع۴ | ۲ | **طبقه‌ای متناسب:** سهم هر محله از ۶۰ نفر را حساب کنید؛ از هر محله همان تعداد با کوچک‌ترین `u` همان محله. میانگین و شیوع؟ | ۳.۲ |
| ع۵ | ۲ | **خوشه‌ای:** همهٔ افراد بلوک‌های ۴، ۱۵ و ۲۷. میانگین و شیوع؟ کدام محله‌ها در نمونه هستند؟ | ۳.۲ |
| ع۶ | ۲ | **تصادفی‌سازی بلوکی** در `M03_trial.csv`: بیماران را به ترتیب `id` در بلوک‌های ۴ تایی بگذارید؛ در هر بلوک ۲ نفر با کوچک‌ترین `u` ← گروه A. چند نفر در هر گروه؟ کدام بیماران A شدند؟ | ۳.۵ |
| ع۷ | ۳ | **در دسترس:** ۶۰ اولین مراجعه‌کننده (`visit_order` ≤ 60). میانگین و شیوع؟ سوگیری نسبت به π چقدر است؟ نتایج ع۲ تا ع۷ را در یک جدول کنار هم بگذارید و تفسیر کنید. | ۳.۳ |

<details>
<summary><b>جواب‌های نهایی (فقط برای کنترل، پس از حل)</b></summary>

| | n | میانگین فشار (mmHg) | شیوع فشار خون بالا |
|---|---|---|---|
| ع۱ جامعه | 600 | **129.88** | **27.50٪** (محله‌ها: 38.00، 24.38، 22.86، 18.00) |
| ع۲ تصادفی ساده | 60 | **133.12** | **33.33٪** (۵ نفر اول: 552، 542، 273، 104، 361) |
| ع۳ سیستماتیک | 60 | **131.70** | **31.67٪** |
| ع۴ طبقه‌ای (20/16/14/10) | 60 | **135.25** | **38.33٪** |
| ع۵ خوشه‌ای | 60 | **129.28** | **33.33٪** (محله‌های 1، 2، 4؛ محلهٔ 3 نیست) |
| ع۶ تصادفی‌سازی | 24 | — | A = **12**، B = **12**؛ A: 2، 3، 7، 8، 10، 11، 14، 15، 17، 20، 23، 24 |
| ع۷ در دسترس | 60 | **148.67** | **95.00٪** (سوگیری **+67.5** واحد درصد) |

**تفسیر ع۷:** برآوردهای چهار روش احتمالی (۳۱ تا ۳۸٪) به‌دلیل **خطای نمونه‌گیری** با π = ۲۷٫۵٪ فرق دارند؛ اگر نمونه‌گیری را بارها تکرار کنیم، میانگینشان به ۲۷٫۵ می‌رسد. برآورد نمونهٔ در دسترس (۹۵٪) **سوگیری** است: بیماران بیشتر به مرکز مراجعه می‌کنند. یک نمونه از هر روش احتمالی ممکن است به‌طور اتفاقی از روش دیگر بدتر باشد (مثل طبقه‌ای در اینجا)؛ برتری روش‌ها فقط **به‌طور میانگین** در تکرارهای زیاد دیده می‌شود (ع۸ در مسیرهای R و Python).

</details>

### حل تمرین‌ها

Syntax کامل: [`M03_solutions.sps`](M03_solutions.sps). روش منویی:

<details>
<summary><b>حل ع۱</b></summary>

`Analyze > Descriptive Statistics > Descriptives` ← `sbp`، `htn` ← میانگین‌ها **129.88** و **0.275**.
`Analyze > Compare Means > Means` ← Dependent: `htn`؛ Layer: `district` ← 0.380، 0.244، 0.229، 0.180.

</details>

<details>
<summary><b>حل ع۲</b></summary>

1. `Transform > Rank Cases` ← `u` ← Assign Rank 1 to: **Smallest value** ← OK ← متغیر جدید `Ru` ساخته می‌شود.
2. `Compute Variable` ← `in_srs = Ru <= 60`.
3. `Means` ← Dependent: `sbp htn`؛ Independent: `in_srs` ← گروه ۱: n = 60، **133.12**، **0.3333**.
4. ۵ نفر اول: `Data > Sort Cases` بر اساس `u` ← سطرهای اول: 552، 542، 273، 104، 361.

</details>

<details>
<summary><b>حل ع۳</b></summary>

`Compute Variable` ← `in_sys = MOD(id - 7, 10) = 0` ← `Means` ← **131.70**، **0.3167**.

</details>

<details>
<summary><b>حل ع۴</b></summary>

1. `Rank Cases` ← Variable: `u`؛ **By: `district`** ← رتبه درون هر محله (`rank_d`).
2. `Data > Aggregate` ← Break: `district`؛ Summary: `n_d = N` ← **Add aggregated variables to active dataset**.
3. `Compute` ← `alloc = RND(n_d / 600 * 60)` ← 20، 16، 14، 10.
4. `Compute` ← `in_strat = rank_d <= alloc`.
5. `Means` ← **135.25**، **0.3833**.

</details>

<details>
<summary><b>حل ع۵</b></summary>

`Compute` ← `in_cluster = ANY(block, 4, 15, 27)` ← `Means` ← **129.28**، **0.3333**. `Crosstabs` با `district` ← محله‌های ۱، ۲ و ۴.

</details>

<details>
<summary><b>حل ع۶</b></summary>

فایل `M03_trial.csv` را وارد کنید:
1. `Compute` ← `blk = TRUNC((id - 1) / 4) + 1`.
2. `Rank Cases` ← `u` By `blk` ← `r_blk`.
3. `Recode into Different Variables` یا Compute: `r_blk <= 2` ← A، بقیه ← B.
4. `Frequencies` ← A = **12**، B = **12**.

</details>

<details>
<summary><b>حل ع۷</b></summary>

`Compute` ← `in_conv = visit_order <= 60` ← `Means` ← **148.67**، **0.95**.

</details>

## خطاهای رایج

| مشکل | علت | راه‌حل |
|---|---|---|
| Select Cases داده را پاک کرد | گزینهٔ **Delete unselected cases** انتخاب شده | همیشه **Filter out unselected cases** |
| نمونهٔ تصادفی هر بار فرق می‌کند | بذر تعیین نشده | `Transform > Random Number Generators > Set Starting Point > Fixed Value` |
| Rank Cases رتبهٔ ۶۰۰ را به کوچک‌ترین داد | گزینهٔ Largest value انتخاب شده | Assign Rank 1 to: **Smallest value** |
