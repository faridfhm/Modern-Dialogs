# 🎨 TModernDialogs for Delphi VCL

A modern, highly-customizable, dynamic dialog & notification component for **Delphi VCL** applications. Fully supports **RTL / LTR**, multi-language localization, flat UI buttons, rounded forms, and notification timers with visual progress bars.

یک کامپوننت مدرن، زیبا و انعطاف‌پذیر برای نمایش دیالوگ‌ها، پیام‌ها و اعلان‌ها در برنامه‌های **دلفی (VCL)** با پشتیبانی کامل از زبان‌های راست‌به‌چپ (**فارسی/عربی**) و چپ‌به‌راست.

---

[![Delphi](https://img.shields.io/badge/Delphi-VCL%20Supported-055296.svg?logo=delphi)](https://www.embarcadero.com/products/delphi)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Language](https://img.shields.io/badge/Language-Pascal%20%2F%20Delphi-red.svg)](#)
[![GitHub Release](https://img.shields.io/github/v/release/yourusername/TModernDialogs)](https://github.com/yourusername/TModernDialogs/releases)

---

## 📌 Table of Contents
- [Features](#-key-features)
- [Screenshots](#-screenshots)
- [Installation](#-installation)
- [Quick Start](#-quick-start)
- [Properties & Customization](#-properties--customization)
- [Requirements](#-requirements)
- [Contributing](#-contributing)
- [License](#-license)
- [Persian Documentation](#-مستندات-فارسی)

---

## ✨ Key Features

- **Modern UI Design** – Borderless forms with rounded corners, drop shadows, and flat buttons.
- **Full RTL & LTR Support** – Intelligent layout for right‑to‑left (Persian/Arabic) and left‑to‑right languages.
- **Built‑in Localization** – Ready‑to‑use translations for:
  - 🇮🇷 Persian (`dlPersian`)
  - 🇬🇧 English (`dlEnglish`)
  - 🇦🇪 Arabic (`dlArabic`)
  - 🇧🇷 Brazilian Portuguese (`dlPortugueseBR`)
  - ⚙️ Custom language support (`dlCustom`)
- **Notification Mode** – Auto‑dismissing messages with a countdown timer and progress bar.
- **Message Types** – Info, Success, Warning, Error, and Question/Confirm.
- **Full Customization** – Font, background color, accent color, icon colors, button texts, and more.

---

## 📸 Screenshots

> *Replace the placeholder links with actual screenshots from your `screenshots/` folder.*

| RTL (Persian / Arabic) | LTR (English) |
| :---: | :---: |
| ![Persian Sample](https://via.placeholder.com/350x200?text=RTL+Dialog+Persian) | ![English Sample](https://via.placeholder.com/350x200?text=LTR+Dialog+English) |

---

## 🚀 Installation

### Method 1 – Manual (IDE)

1. Download or clone this repository.
2. Open your Delphi IDE.
3. Open the package file (`.dpk`) located in the `packages/` folder.
4. Right‑click the package project in the Project Manager and select **Install**.
5. The component will appear on the component palette (e.g., under a custom tab).

### Method 2 – Using [DPM](https://github.com/DelphiPackageManager/DPM) (Recommended)

If you have DPM installed, simply run:

```bash
dpm install TModernDialogs
