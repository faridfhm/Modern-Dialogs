# 🎨 TModernDialogs for Delphi VCL

A modern, highly-customizable, dynamic dialog & notification component for **Delphi VCL** applications. Fully supports **RTL / LTR**, multi-language localization, flat UI buttons, rounded forms, and notification timers with visual progress bars.

یک کامپوننت مدرن، زیبا و انعطاف‌پذیر برای نمایش دیالوگ‌ها، پیام‌ها و اعلان‌ها در برنامه‌های **دلفی (VCL)** با پشتیبانی کامل از زبان‌های راست‌به‌چپ (**فارسی/عربی**) و چپ‌به‌راست.

---

[![Delphi](https://img.shields.io/badge/Delphi-VCL%20Supported-055296.svg?logo=delphi)](https://www.embarcadero.com/products/delphi)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Language](https://img.shields.io/badge/Language-Pascal%20%2F%20Delphi-red.svg)](#)

---

## ✨ ویژگی‌های کلیدی (Key Features)

* **طراحی مدرن و مینیمال (Modern UI):** فرم‌های بدون فریم (Borderless) با گوشه‌های گرد، سایه (Drop Shadow) و دکمه‌های فلت جذاب.
* **پشتیبانی کامل از راست‌به‌چپ (Full RTL & LTR Support):** چیدمان کاملاً هوشمند متون، آیکون‌ها، نوار شاخص (Accent Bar) و دکمه‌ها بر اساس جهت زبان.
* **چندزبانه پیش‌فرض (Multi-Language Localization):**
  * 🇮🇷 فارسی (`dlPersian`)
  * 🇬🇧 انگلیسی (`dlEnglish`)
  * 🇦🇪 عربی (`dlArabic`)
  * 🇧🇷 پرتغالی (`dlPortugueseBR`)
  * ⚙️ قابلیت تعریف زبان سفارشی (`dlCustom`)
* **حالت اعلان هوشمند (Notification Mode):** امکان نمایش پیام‌های خودکار با تایمر معکوس (Countdown Timer) و نوار پیشرفت (Progress Bar).
* **انواع پیام‌ها (Message Types):**
  * ℹ️ Info (اطلاعات)
  * ✅ Success (موفقیت)
  * ⚠️ Warning (هشدار)
  * ❌ Error (خطا)
  * ❓ Question / Confirm (تأیید/پرسش)
* **شخصی‌سازی کامل:** امکان تغییر فونت، رنگ زمینه‌، رنگ Accent، رنگ آیکون‌ها و متون دکمه‌ها.

---

## 📸 پیش‌نمایش (Screenshots)

> *تصاویر محیط کامپوننت را می‌توانید در پوشه `screenshots` قرار داده و لینک آن‌ها را در این بخش بگذارید.*

| RTL (Persian / Arabic) | LTR (English) |
| :---: | :---: |
| ![Persian Sample](https://via.placeholder.com/350x200?text=RTL+Dialog+Persian) | ![English Sample](https://via.placeholder.com/350x200?text=LTR+Dialog+English) |

---

## 🚀 نحوه استفاده (Quick Start)

### ۱. افزودن یونیت به پروژه
فایل `uModernDialogs.pas` را به پروژه خود اضافه کرده و آن را در بخش `uses` یونیت مربوطه فراخوانی کنید:

```delphi
uses
  uModernDialogs;
