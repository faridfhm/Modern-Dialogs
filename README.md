# `ModernDialogs4D`

A Delphi (VCL) unit/package for showing modern-styled message dialogs (Info / Success / Warning / Error / Question) as well as a floating auto-dismissing notification with a countdown — as a replacement for the default `MessageDlg` / `ShowMessage`. The unit features rounded corners, a colored accent bar, a badge icon, full right-to-left (RTL) support, and multi-language text (Persian, Arabic, English, Brazilian Portuguese).

---

## 1. Installation & Usage

The `uModernDialogs.pas` unit is part of the Delphi package **`ModernDialogs4D`**, and is meant to be used by installing that package in the Delphi IDE (rather than adding the `.pas` file directly to a project).

### 1.1. Installing the Package

1. Open the `ModernDialogs4D.dpk` package project (which contains the `uModernDialogs.pas` unit) in the Delphi IDE.
2. Right-click the package and choose **Install** so the package is installed into the IDE and the `TModernDialogs` component is added to the Component Palette.
3. Add the package's output folder (containing the `.bpl`/`.dcp` files) to Delphi's **Library Path** so it can also be used from other projects.
4. Once installed successfully, the `TModernDialogs` component becomes visible in the Component Palette (usually under the package's own tab) and can be dragged onto a form.

> Note: installing a package (Install) is different from adding it as a *Required Package* (runtime package) to another project. If you only need to use it programmatically (without dropping the component in the Object Inspector), simply add `ModernDialogs4D` as a *Requires* entry in your project, or link the package statically.

### 1.2. Using It in Code

1. Add `uModernDialogs` to the `uses` clause of your form or unit.
2. Create an instance of the `TModernDialogs` class — either by dragging the component from the palette onto a form (after installing the package), or dynamically in code.
3. Use the ready-made methods (`Info`, `Success`, `Warning`, `Error`, `Confirm`, `ShowNotification`) or the general-purpose `Ask` method.

```pascal
uses
  uModernDialogs;

var
  Dlg: TModernDialogs;
begin
  Dlg := TModernDialogs.Create(nil);
  try
    Dlg.Language := dlPersian;          // set language (automatically switches to RTL)
    Dlg.Font.Name := 'Segoe UI';
    Dlg.Font.Size := 10;

    Dlg.Info('The operation completed successfully.');
    Dlg.Success('The file was saved successfully.');
    Dlg.Warning('Disk space is running low.');
    Dlg.Error('Could not connect to the server.');

    if Dlg.Confirm('Are you sure you want to delete this item?') then
      // proceed with deletion

    Dlg.ShowNotification('Changes saved.', 3000); // 3-second notification
  finally
    Dlg.Free;
  end;
end;
```

> Note: since `TModernDialogs` descends from `TComponent`, you can keep a single instance alive on a form (as a field or an invisible component) and reuse it repeatedly; it doesn't need to be created and freed every time.

---

## 2. Data Types

### `TAppMessageType`
Specifies the message kind, which affects the accent bar color, badge color, and icon:

| Value | Meaning |
|---|---|
| `mtInfo` | Informational (orange, `i` icon) |
| `mtSuccess` | Success (green, `✔` icon) |
| `mtWarning` | Warning (blue, `⚠` icon) |
| `mtError` | Error (purple/blue, `✘` icon) |
| `mtQuestion` | Question (yellow, `؟` icon) |

### `TDialogLanguage`
The language of the dialog's default texts (titles and button labels):

| Value | Language | Text direction |
|---|---|---|
| `dlEnglish` | English (default) | Left-to-right |
| `dlPortugueseBR` | Brazilian Portuguese | Left-to-right |
| `dlPersian` | Persian | Right-to-left |
| `dlArabic` | Arabic | Right-to-left |
| `dlCustom` | Custom (texts are empty — you must fill them in yourself) | Left-to-right |

Changing `Language` (except to `dlCustom`) automatically updates the component's `BiDiMode` to match that language. Conversely, if you set `BiDiMode` directly, `Language` automatically switches to `dlCustom`.

### `TDialogTranslation`
A record holding all translatable strings (`TitleInfo`, `TitleSuccess`, `TitleWarning`, `TitleError`, `TitleConfirm`, `TitleNotify`, `BtnOk`, `BtnClose`, `BtnYes`, `BtnNo`, `CountdownFmt`, `BiDiMode`). The constant array `TRANSLATIONS` holds the values for each language.

---

## 3. The `TAppMessageItemStyle` Class

Holds the visual style for a message type (descends from `TPersistent`, editable in the Object Inspector):

| Property | Type | Description |
|---|---|---|
| `AccentColor` | `TColor` | Color of the dialog's side accent bar |
| `BadgeColor` | `TColor` | Background color of the icon's circular badge |
| `IconChar` | `string` | Character/glyph shown inside the badge |
| `IconColor` | `TColor` | Color of the icon glyph itself |

Each of the five message types (`Info/Success/Warning/Error/Question`) has its own style instance, initialized with default colors in the `TModernDialogs` constructor. You can change these values at design time or at run time.

---

## 4. The Main Class: `TModernDialogs`

### Published Properties

| Property | Type | Default | Description |
|---|---|---|---|
| `Font` | `TFont` | Segoe UI, 9 | Base font used by all dialogs |
| `BackgroundColor` | `TColor` | `clWhite` | Background color of the dialog body |
| `Language` | `TDialogLanguage` | `dlEnglish` | Language of default texts |
| `BiDiMode` | `TBiDiMode` | `bdLeftToRight` | Layout direction (RTL/LTR) |
| `StyleInfo` | `TAppMessageItemStyle` | — | Style for the Info type |
| `StyleSuccess` | `TAppMessageItemStyle` | — | Style for the Success type |
| `StyleWarning` | `TAppMessageItemStyle` | — | Style for the Warning type |
| `StyleError` | `TAppMessageItemStyle` | — | Style for the Error type |
| `StyleQuestion` | `TAppMessageItemStyle` | — | Style for the Question type |

### Methods

#### `function Ask(const ATitle, AMessage: string; AMsgType: TAppMessageType; const AButtons: array of string): Integer;`
The core method for showing a dialog. Displays a modal dialog with a title, message, and custom set of buttons.
- **Returns:** the index of the button the user clicked (0 for the first button, 1 for the second, etc.).
- The first button (index 0) is automatically styled as the "primary" button and receives initial focus.

```pascal
case Dlg.Ask('Choose', 'Which option do you want?', mtQuestion, ['Yes', 'No', 'Cancel']) of
  0: ShowMessage('Yes was selected');
  1: ShowMessage('No was selected');
  2: ShowMessage('Cancelled');
end;
```

#### `procedure Info(const Msg: string; const ATitle: string = '');`
Shows an informational dialog with a single OK button. If `ATitle` is empty, the current language's default title (`TitleInfo`) is used.

#### `procedure Success(const Msg: string; const ATitle: string = '');`
Shows a success dialog with a single Close button.

#### `procedure Warning(const Msg: string; const ATitle: string = '');`
Shows a warning dialog with a single OK button.

#### `procedure Error(const Msg: string; const ATitle: string = '');`
Shows an error dialog with a single Close button.

#### `function Confirm(const Msg: string; const ATitle: string = ''): Boolean;`
Shows a confirmation dialog with Yes/No buttons.
- **Returns:** `True` if the user clicks "Yes" (the first button), `False` otherwise.

#### `procedure ShowNotification(const Msg: string; TimeoutMs: Integer = 3000);`
Shows a button-less notification that automatically closes after `TimeoutMs` milliseconds. A progress bar and a countdown text (based on the current language's `CountdownFmt`) are shown at the bottom of the dialog.

#### `function GetTranslation: TDialogTranslation;`
Returns the translation record for the current `Language`; useful for accessing default texts (titles, button labels, countdown format).

#### `function GetStyle(AType: TAppMessageType): TAppMessageItemStyle;`
Returns the style object corresponding to the given message type (`StyleInfo`, `StyleSuccess`, etc.).

---

## 5. Internal (Implementation) Classes

These classes are part of the internal implementation and are not normally called directly by consumers of the unit:

- **`TFlatButton`** (descends from `TCustomControl`): a custom flat button with hover/pressed/focus effects, used at the bottom of dialogs.
- **`TfrmModernDialog`** (descends from `TForm`): a borderless form (`bsNone`) with rounded corners and a drop shadow that makes up the dialog's main body. Its `Execute` method handles layout, text measurement, positioning relative to the active form, and modal display.

Unit-level helper functions:
- `AlterColor(C: TColor; Percent: Integer): TColor` — lightens/darkens a color by a given percentage (used for hover and border effects).
- `CalcTextHeight(...)` — calculates the required height for a multi-line text block, used to auto-size the dialog.

---

## 6. Important Notes & Limitations

- This unit is **VCL-based** and Windows-only (it depends on `Winapi.Windows`).
- Dialogs are shown **modally** (`ShowModal`) and block program execution until closed, except for `ShowNotification`, which closes itself automatically after the timeout.
- The dialog's height is calculated automatically based on the message text length; the width is fixed at `360` pixels.
- To use texts in a language other than the four built-in ones, set `Language := dlCustom` and assign your own values to `TRANSLATIONS[dlCustom]`, or use the `Ask` method directly with a custom title and button captions.
- Colors are written directly as hexadecimal RGB values in the code (not via the Windows color system); to change the color palette of any message type, simply modify the relevant `StyleXXX` properties at design time or run time.
- For RTL forms (Persian/Arabic), simply set `Language` to `dlPersian` or `dlArabic`; the layout of the icon, text, and buttons automatically mirrors to right-to-left.

---

## 7. Full Example

```pascal
procedure TForm1.btnSaveClick(Sender: TObject);
var
  Dlg: TModernDialogs;
begin
  Dlg := TModernDialogs.Create(Self);
  try
    Dlg.Language := dlEnglish;
    Dlg.Font.Name := 'Segoe UI';
    Dlg.Font.Size := 10;

    if not Dlg.Confirm('Do you want to save the changes?') then
      Exit;

    try
      // ... save operation ...
      Dlg.ShowNotification('Changes saved successfully.', 2500);
    except
      on E: Exception do
        Dlg.Error('Error while saving: ' + E.Message);
    end;
  finally
    Dlg.Free;
  end;
end;
```
