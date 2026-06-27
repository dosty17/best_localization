# Kurdish Localization Update Summary

## What Was Changed

Your Kurdish localization now supports **two scripts** for the `ku` language code:

### 1. Sorani (Arabic Script) - `Locale('ku')`
- **Direction:** Right-to-Left (RTL)
- **Script:** Arabic-based (کوردی)
- **Numerals:** Arabic (٠-٩)
- **Example:** "ئاگادارکردنەوە", "گەڕان"

### 2. Kurmanji (Latin Script) - `Locale('ku', 'en')`
- **Direction:** Left-to-Right (LTR)
- **Script:** Latin-based (Kurdî)
- **Numerals:** Western (0-9)
- **Example:** "Hişyarî", "Lêgerîn"

## Files Modified

1. **lib/src/kurdish/kurdish_cupertino_localization_delegate.dart**
   - Added `kuDateSymbolsLatin` for Latin script date symbols
   - Updated delegate to detect script based on `locale.countryCode`
   - Added `isLatin` property to `KurdishCupertinoLocalizations`
   - All string getters now return conditional values based on script

2. **lib/src/kurdish/kurdish_material_localization_delegate.dart**
   - Added `kuDateSymbolsLatin` for Latin script date symbols
   - Updated delegate to detect script based on `locale.countryCode`
   - Added `isLatin` property to `KurdishMaterialLocalizations`
   - All 70+ string getters now return conditional values based on script

3. **lib/src/kurdish/kurdish_widget_localization_delegate.dart**
   - Updated delegate to pass `isLatin` flag
   - Added `isLatin` property to `KurdishWidgetLocalizations`
   - Updated `textDirection` to return LTR for Latin, RTL for Arabic
   - All string getters now return conditional values based on script

## How to Use

### For Sorani (Arabic Script):
```dart
MaterialApp(
  locale: const Locale('ku'),
  // ... rest of your app
)
```

### For Kurmanji (Latin Script):
```dart
MaterialApp(
  locale: const Locale('ku', 'en'),
  // ... rest of your app
)
```

### Toggle Between Scripts:
```dart
// Start with Sorani
Locale currentLocale = const Locale('ku');

// Switch to Kurmanji
currentLocale = const Locale('ku', 'en');

// Switch back to Sorani
currentLocale = const Locale('ku');
```

## Key Implementation Detail

The system checks if the locale has a country code:
- **No country code** (`Locale('ku')`) → Arabic script (Sorani)
- **Any country code** (`Locale('ku', 'en')` or `Locale('ku', 'TR')`) → Latin script (Kurmanji)

```dart
final bool isLatin = locale.countryCode != null && locale.countryCode!.isNotEmpty;
```

## Testing

1. **Example app:** See `example/lib/locale_test.dart` for a complete working example
2. **Documentation:** See `KURDISH_DUAL_SCRIPT.md` for detailed usage guide

## What This Means

- You can now serve Kurdish users who use Arabic script (Sorani)
- You can also serve Kurdish users who use Latin script (Kurmanji)
- The same `ku` language code works for both
- The UI automatically adjusts:
  - Text direction (RTL vs LTR)
  - Number formatting (Arabic vs Western numerals)
  - Month/day names in the appropriate script
  - All localized strings in the correct script

## No Breaking Changes

- Existing `Locale('ku')` usage continues to work exactly as before (Sorani/Arabic)
- You only need to use `Locale('ku', 'en')` if you want the Latin script variant
