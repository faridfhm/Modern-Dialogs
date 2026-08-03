<div align="center">

# ModernDialogs4D

**دیالوگ‌های پیام مدرن، بدون کادر و آگاه از راست‌به‌چپ برای Delphi VCL.**
جایگزینی برای `MessageDlg` / `ShowMessage` — با گوشه‌های گرد، رنگ‌های Accent و نوتیفیکیشن با بستن خودکار.

[![Delphi](https://img.shields.io/badge/Delphi-VCL-red?logo=delphi&logoColor=white)](#)
[![Platform](https://img.shields.io/badge/Platform-Windows-0078D6?logo=windows&logoColor=white)](#)
[![RTL Support](https://img.shields.io/badge/RTL-Persian%20%7C%20Arabic-14B8A6)](#)
[![Languages](https://img.shields.io/badge/Localization-5%20languages-8B5CF6)](#)



</div>


## ✨ ویژگی‌های کلیدی

| | |
|---|---|
| 🎨 **طراحی مدرن رابط کاربری** | فرم‌های بدون کادر با گوشه‌های گرد، سایه‌ی افتاده و دکمه‌های مسطح. |
| 🔁 **پشتیبانی کامل از RTL و LTR** | چیدمان هوشمند برای زبان‌های راست‌به‌چپ (فارسی/عربی) و چپ‌به‌راست. |
| ⏱ **حالت نوتیفیکیشن** | پیام‌های با بسته‌شدن خودکار همراه با تایمر شمارش معکوس و نوار پیشرفت. |
| 💬 **انواع پیام** | Info، Success، Warning، Error و Question/Confirm. |
| 🎛 **سفارشی‌سازی کامل** | فونت، رنگ پس‌زمینه، رنگ Accent، رنگ آیکن‌ها، متن دکمه‌ها و موارد دیگر. |
| 🌍 **بومی‌سازی داخلی** | ترجمه‌های آماده — در پایین ببینید. |

### زبان‌های پشتیبانی‌شده

| زبان | ثابت |
|---|---|
| 🇮🇷 فارسی | `dlPersian` |
| 🇬🇧 انگلیسی | `dlEnglish` |
| 🇦🇪 عربی | `dlArabic` |
| 🇧🇷 پرتغالی برزیل | `dlPortugueseBR` |
| ⚙️ سفارشی | `dlCustom` |

---

## 📦 نصب

یونیت `uModernDialogs.pas` بخشی از پکیج دلفی **ModernDialogs4D** است و باید در IDE نصب شود، نه صرفاً به یک پروژه اضافه شود.

1. فایل `ModernDialogs4D.dpk` را در IDE دلفی باز کنید.
2. روی پکیج راست‌کلیک کرده و **Install** را انتخاب کنید. کامپوننت `TModernDialogs` به Component Palette اضافه می‌شود.
3. مسیر خروجی پکیج (`.bpl` / `.dcp`) را به **Library Path** دلفی اضافه کنید تا در پروژه‌های دیگر هم قابل استفاده باشد.

> **نکته:** نصب پکیج (Install) با افزودن آن به‌عنوان *Required Package* در پروژه‌ی دیگر متفاوت است. برای استفاده‌ی صرفاً برنامه‌نویسی بدون کامپوننت طراحی، پکیج را به‌عنوان *Requires* اضافه کنید یا آن را استاتیک لینک کنید.

---

## 🚀 شروع سریع

```pascal
uses
  uModernDialogs;

var
  Dlg: TModernDialogs;
begin
  Dlg := TModernDialogs.Create(nil);
  try
    Dlg.Language := dlPersian;          // تنظیم زبان (خودکار RTL می‌شود)
    Dlg.Font.Name := 'Segoe UI';
    Dlg.Font.Size := 10;

    Dlg.Info('عملیات با موفقیت به پایان رسید.');
    Dlg.Success('فایل با موفقیت ذخیره شد.');
    Dlg.Warning('فضای دیسک رو به اتمام است.');
    Dlg.Error('اتصال به سرور برقرار نشد.');

    if Dlg.Confirm('آیا از حذف این آیتم مطمئن هستید؟') then
      // ادامه‌ی عملیات حذف

    Dlg.ShowNotification('تغییرات ذخیره شد.', 3000);
  finally
    Dlg.Free;
  end;
end;
```

> چون `TModernDialogs` از `TComponent` مشتق شده، یک نمونه را روی فرم نگه دارید و به‌جای ساخت/آزادسازی مکرر، دوباره استفاده کنید.

---

## 📚 مرجع API

### `TAppMessageType`

| مقدار | معنی |
|---|---|
| `mtInfo` | اطلاع‌رسانی — نارنجی، آیکن i |
| `mtSuccess` | موفقیت — سبز، آیکن ✔ |
| `mtWarning` | هشدار — آبی، آیکن ⚠ |
| `mtError` | خطا — بنفش/آبی، آیکن ✘ |
| `mtQuestion` | سؤال — زرد، آیکن ؟ |

### `TDialogLanguage`

| مقدار | زبان | جهت |
|---|---|---|
| `dlEnglish` | انگلیسی (پیش‌فرض) | چپ‌به‌راست |
| `dlPortugueseBR` | پرتغالی برزیل | چپ‌به‌راست |
| `dlPersian` | فارسی | راست‌به‌چپ |
| `dlArabic` | عربی | راست‌به‌چپ |
| `dlCustom` | سفارشی (متن خالی) | چپ‌به‌راست |

تغییر `Language` (به‌جز `dlCustom`) به‌صورت خودکار `BiDiMode` را به‌روزرسانی می‌کند. تنظیم مستقیم `BiDiMode`، زبان را به `dlCustom` تغییر می‌دهد.

### `TModernDialogs` — Properties

| Property | نوع | پیش‌فرض | توضیح |
|---|---|---|---|
| `Font` | `TFont` | Segoe UI, 9 | فونت پایه |
| `BackgroundColor` | `TColor` | `clWhite` | رنگ پس‌زمینه‌ی بدنه |
| `Language` | `TDialogLanguage` | `dlEnglish` | زبان متن‌های پیش‌فرض |
| `BiDiMode` | `TBiDiMode` | `bdLeftToRight` | جهت چیدمان |
| `StyleInfo` / `StyleSuccess` / `StyleWarning` / `StyleError` / `StyleQuestion` | `TAppMessageItemStyle` | — | استایل هر نوع پیام (`AccentColor`, `BadgeColor`, `IconChar`, `IconColor`) |

### `TModernDialogs` — Methods

| متد | بازگشتی | توضیح |
|---|---|---|
| `Ask(ATitle, AMessage, AMsgType, AButtons)` | `Integer` | هسته‌ی نمایش دیالوگ با دکمه‌های دلخواه. اندیس دکمه‌ی کلیک‌شده را برمی‌گرداند (از صفر). |
| `Info(Msg, ATitle = '')` | — | دیالوگ اطلاع‌رسانی با یک دکمه‌ی OK. |
| `Success(Msg, ATitle = '')` | — | دیالوگ موفقیت با یک دکمه‌ی Close. |
| `Warning(Msg, ATitle = '')` | — | دیالوگ هشدار با یک دکمه‌ی OK. |
| `Error(Msg, ATitle = '')` | — | دیالوگ خطا با یک دکمه‌ی Close. |
| `Confirm(Msg, ATitle = '')` | `Boolean` | دیالوگ بله/خیر. `True` اگر «بله» زده شود. |
| `ShowNotification(Msg, TimeoutMs = 3000)` | — | نوتیفیکیشن بدون دکمه با بستن خودکار، نوار پیشرفت و شمارش معکوس. |
| `GetTranslation` | `TDialogTranslation` | رکورد ترجمه‌ی زبان جاری. |
| `GetStyle(AType)` | `TAppMessageItemStyle` | شیء استایل متناظر با نوع پیام. |

```pascal
case Dlg.Ask('انتخاب', 'کدام گزینه را می‌خواهید؟', mtQuestion, ['بله', 'خیر', 'انصراف']) of
  0: ShowMessage('بله انتخاب شد');
  1: ShowMessage('خیر انتخاب شد');
  2: ShowMessage('انصراف داده شد');
end;
```

---

## 🧩 کلاس‌های داخلی

معمولاً مستقیماً استفاده نمی‌شوند:

- **`TFlatButton`** (`TCustomControl`) — دکمه‌ی مسطح با افکت Hover/Pressed/Focus، در پایین دیالوگ‌ها.
- **`TfrmModernDialog`** (`TForm`) — فرم بدون کادر با گوشه‌های گرد و سایه که بدنه‌ی دیالوگ را می‌سازد. متد `Execute` چیدمان، اندازه‌گیری متن، پوزیشن‌دهی و نمایش مودال را انجام می‌دهد.

توابع کمکی: `AlterColor` (روشن/تیره‌کردن رنگ برای افکت Hover/حاشیه) و `CalcTextHeight` (اندازه‌گیری ارتفاع متن چندخطی برای تنظیم خودکار ارتفاع دیالوگ).

---

## ⚠️ نکات و محدودیت‌ها

- مبتنی بر VCL و **فقط ویندوز** (وابسته به `Winapi.Windows`).
- دیالوگ‌ها مودال هستند (`ShowModal`)، به‌جز `ShowNotification` که خودکار بسته می‌شود.
- ارتفاع به‌صورت خودکار بر اساس متن تنظیم می‌شود؛ عرض ثابت ۳۶۰ پیکسل است.
- برای زبان‌های دیگر، `Language := dlCustom` را تنظیم و `TRANSLATIONS[dlCustom]` را مقداردهی کنید، یا مستقیماً `Ask` را با متن دلخواه فراخوانی کنید.
- رنگ‌ها به‌صورت هگزادسیمال در کد نوشته شده‌اند؛ پالت را از طریق properties مربوط به `StyleXXX` تغییر دهید.
- تنظیم `Language` روی `dlPersian` یا `dlArabic` چیدمان را به‌صورت خودکار به RTL می‌چرخاند.

---

## 📄 مثال کامل

```pascal
procedure TForm1.btnSaveClick(Sender: TObject);
var
  Dlg: TModernDialogs;
begin
  Dlg := TModernDialogs.Create(Self);
  try
    Dlg.Language := dlPersian;
    Dlg.Font.Name := 'IRANSans';
    Dlg.Font.Size := 10;

    if not Dlg.Confirm('آیا مایل به ذخیره‌ی تغییرات هستید؟') then
      Exit;

    try
      // ... عملیات ذخیره‌سازی ...
      Dlg.ShowNotification('تغییرات با موفقیت ذخیره شد.', 2500);
    except
      on E: Exception do
        Dlg.Error('خطا در ذخیره‌سازی: ' + E.Message);
    end;
  finally
    Dlg.Free;
  end;
end;
```

---

<div align="center">
<br>

<p align="center">
  <img src="https://raw.githubusercontent.com/faridfhm/Modern-Dialogs/main/images/Image.png" alt="نمونه دیالوگ‌های ModernDialogs4D" width="720">
</p>

<br>

ساخته‌شده برای جامعه‌ی دلفی‌کاران · [English 🇬🇧](README.md)

</div>
