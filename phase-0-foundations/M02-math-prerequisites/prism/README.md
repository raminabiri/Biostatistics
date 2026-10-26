# M02 در GraphPad Prism — Transform، Column math و آمار توصیفی

[← ماژول M02](../README.md) | [صفحهٔ مسیر Prism](../../../tracks/prism.md)

**نسخه:** Prism 10 و 11. نام دقیق گزینه‌ها ممکن است بین نسخه‌ها کمی فرق کند.

## ایدهٔ اصلی

Prism ماشین‌حساب عمومی یا «Compute variable» مثل SPSS ندارد. محاسبه روی داده با دو تحلیل انجام می‌شود:

| کار | تحلیل Prism | مسیر |
|---|---|---|
| تابع روی هر مقدار (log، ×K، توان، فرمول دلخواه) | **Transform** | `Analyze > Data Processing > Transform` |
| تفاضل، نسبت یا درصد تفاوت **بین دو ستون** | **Remove baseline and column math** | `Analyze > Data Processing > Remove baseline and column math` |
| میانگین، میانه، جمع، میانگین هندسی | **Descriptive statistics** | `Analyze > Column analyses > Descriptive statistics` |

نتیجهٔ Transform و Column math یک **جدول نتایج جدید** است که خودش می‌تواند ورودی تحلیل بعدی باشد (مثلاً Descriptive statistics روی ستون تبدیل‌شده).

### فرمول دلخواه در Transform

در Transform، گزینهٔ **User-defined Y function** (یا مشابه آن) را انتخاب و فرمول را بنویسید. در فرمول Prism:
- `X` و `Y` مقادیر همان سطرند.
- توان با `^`؛ `log()` پایهٔ ۱۰ و `ln()` طبیعی است؛ `exp()`، `sqrt()`، `abs()` هم هست.

## تمرین‌های عملی (ع۱ تا ع۷)

این تمرین‌ها در هر پنج مسیر **یکسان‌اند** و جواب عددی یکسان دارند. داده: `data/M02_clinic.csv` و `data/M02_genes.csv`.

| شماره | سطح | تمرین | مفهوم (درس) |
|---|---|---|---|
| ع۱ | ۱ | متغیر جدید **BMI** = وزن ÷ (قد به متر)² بسازید. میانگین BMI چیست؟ چند بیمار BMI ≥ ۳۰ دارند؟ | ترتیب عملیات (۲.۲) |
| ع۲ | ۱ | تغییر فشار (sbp_12 − sbp_0) و **درصد تغییر** را بسازید. میانگین هر دو؟ چند بیمار دست‌کم ۱۰ mmHg کاهش داشتند؟ | تغییر مطلق و نسبی (۲.۱) |
| ع۳ | ۱ | قند خون را از mg/dL به mmol/L تبدیل کنید (÷ ۱۸). میانگین در هر دو واحد؟ | تبدیل واحد (۲.۱) |
| ع۴ | ۲ | log₁₀ تری‌گلیسرید را بسازید. میانگین حسابی، میانه، میانگین log₁₀ و **میانگین هندسی** TG را گزارش کنید. | لگاریتم (۲.۳) |
| ع۵ | ۲ | برای سن: n، Σx، x̄، Σx² و Σ(x − x̄)² را حساب کنید. | نماد Σ (۲.۲) |
| ع۶ | ۲ | در `M02_genes.csv` ستون‌های **fold change** (treated/control) و **log₂FC** را بسازید. چند ژن دست‌کم دو برابر تغییر کرده‌اند (\|log₂FC\| ≥ ۱)؟ چند افزایش و چند کاهش؟ | log₂ (۲.۳) |
| ع۷ | ۳ | جدول غلظت دارو را برای t = 0، 2، ...، 24 ساعت بسازید (C₀ = ۱۰۰ mg/L، t½ = ۴ h). اولین ساعتی که غلظت زیر ۱۰ می‌رود؟ زمان دقیق؟ | کاهش نمایی (۲.۴) |

<details>
<summary><b>جواب‌های نهایی (فقط برای کنترل، پس از حل)</b></summary>

| | جواب |
|---|---|
| ع۱ | میانگین BMI = **29.44**؛ BMI ≥ 30: **10** بیمار |
| ع۲ | میانگین تغییر = **−14.96 mmHg**؛ میانگین درصد تغییر = **−10.01٪**؛ کاهش ≥ ۱۰: **17** بیمار |
| ع۳ | **151.42 mg/dL** = **8.41 mmol/L** |
| ع۴ | حسابی **207.71**؛ میانه **208.5**؛ میانگین log₁₀ = **2.2717**؛ هندسی **186.93** mg/dL |
| ع۵ | n = **24**؛ Σx = **1401**؛ x̄ = **58.375**؛ Σx² = **84759**؛ SS = **2975.625** |
| ع۶ | **7** ژن (۶ افزایش، ۱ کاهش: FOS) |
| ع۷ | ساعت **14** (8.84 mg/L)؛ زمان دقیق **13.29** ساعت |

</details>

### حل تمرین‌ها

<details>
<summary><b>حل ع۱ — BMI</b></summary>

BMI به **دو** ستون (وزن و قد) نیاز دارد. ترفند Prism: جدول **XY** بسازید که X = قد و Y = وزن.

1. New Data Table ← **XY** ← X: Numbers؛ Y: Enter and plot a single Y value for each point ← Create.
2. ستون `height_cm` را در X و `weight_kg` را در Y بچسبانید.
3. `Analyze > Transform` ← **User-defined Y function** ← `Y = Y/(X/100)^2` ← OK.
4. جدول نتیجه را انتخاب کنید ← `Analyze > Column analyses > Descriptive statistics` ← **Mean = 29.44**.
5. شمارش BMI ≥ ۳۰: روی ستون BMI ← `Frequency distribution` ← Bin width = **30**، مرکز اولین bin = **15** ← دو bin: ۰ تا ۳۰ و ۳۰ تا ۶۰ ← bin دوم: **10**.

</details>

<details>
<summary><b>حل ع۲ — تغییر فشار</b></summary>

1. New Data Table ← **Column** ← دو ستون `Week 0` و `Week 12`؛ هر سطر یک بیمار.
2. `Analyze > Remove baseline and column math` ← **Compute the difference** (Week 12 − Week 0) ← میانگین با Descriptive statistics ← **−14.96**.
3. همین تحلیل با **Percent difference** (درصد تفاوت نسبت به ستون پایه) ← میانگین **−10.01٪**.
4. شمارش کاهش ≥ ۱۰: Frequency distribution روی ستون تفاضل با مرز bin در −10 (مثلاً Bin width = 20، مرکز اولین bin = −20 ← bin «−30 تا −10») ← **17**. اگر نسخهٔ شما مرزهای bin را دقیقاً این‌طور نمی‌گذارد، ستون تفاضل را کپی، در Excel مرتب کنید و بشمارید.

</details>

<details>
<summary><b>حل ع۳ — تبدیل واحد</b></summary>

Column table با ستون قند ← `Transform` ← **Y = Y * K** با K = 1/18 = 0.05556 (یا User-defined: `Y = Y/18`) ← Descriptive statistics روی هر دو ← **151.42** و **8.41**.

</details>

<details>
<summary><b>حل ع۴ — لگاریتم و میانگین هندسی</b></summary>

1. Column table با ستون `tg_mgdl` ← Descriptive statistics ← در گزینه‌ها **Geometric mean** را هم تیک بزنید ← Mean **207.71**، Median **208.5**، Geometric mean **186.93**.
2. `Transform` ← **Y = Log(Y)** ← Descriptive statistics روی نتیجه ← Mean **2.2717**.
3. کنترل: 10^2.2717 = 186.93 ✔.

</details>

<details>
<summary><b>حل ع۵ — Σ</b></summary>

1. Column table با ستون سن ← Descriptive statistics ← گزینه‌های **Sum** و **Mean** ← n = **24** (Number of values)، Σx = **1401**، x̄ = **58.375**.
2. Σx²: `Transform` ← **Y = Y squared** (یا `Y = Y^2`) ← Descriptive statistics ← Sum = **84759**.
3. SS: `Transform` ← User-defined: `Y = (Y - 58.375)^2` ← Sum = **2975.625**. (Prism مستقیم SS نمی‌دهد؛ ولی SD را می‌دهد و SS = SD² × (n − 1)، که در M05 می‌بینید.)

</details>

<details>
<summary><b>حل ع۶ — fold change</b></summary>

1. New Data Table ← **Column** ← ستون‌ها: `Control`، `Treated`؛ نام ژن‌ها در **Row titles**.
2. `Remove baseline and column math` ← **Compute the ratio** (Treated / Control) ← fold change.
3. روی نتیجه: `Transform` ← User-defined: `Y = ln(Y)/ln(2)` ← log₂FC.
4. جدول نتیجه را نگاه کنید: ۶ ژن ≥ ۱ (IL6، TNF، CXCL8، IL1B، CCL2، HMOX1) و ۱ ژن ≤ −۱ (FOS) ← **7**.

</details>

<details>
<summary><b>حل ع۷ — نیمه‌عمر</b></summary>

1. New Data Table ← **XY** ← در ستون X اعداد 0، 2، ...، 24 را وارد کنید؛ در ستون Y برای همهٔ سطرها عدد ۱ بگذارید (فقط تا جدول خالی نباشد).
2. `Transform` ← User-defined: `Y = 100*0.5^(X/4)` ← جدول غلظت‌ها.
3. اولین X با Y < 10: **14** (8.84). زمان دقیق را با ماشین‌حساب یا یکی از نرم‌افزارهای دیگر حساب کنید: 4 × log₂(10) = **13.29**.
4. نمودار: Prism خودش نمودار XY را می‌سازد. در `Format Axes` محور Y را **Log10** کنید ← منحنی به **خط راست** تبدیل می‌شود (درس ۲.۴).

</details>

## محدودیت‌ها در این ماژول

- شمارش «چند مقدار شرط را دارند» (مثل COUNTIF) در Prism مستقیم نیست؛ با Frequency distribution یا مرتب‌سازی انجام می‌شود.
- ساختن داده از فرمول (ع۷) با ترفند جدول XY ممکن است.
