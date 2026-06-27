# Kurdish Localization - Dual Script Support

This library now supports Kurdish language in **two different scripts**:

## Supported Variants

### 1. Sorani (کوردیی ناوەندی) - Arabic Script
Use: `Locale('ku')`

```dart
MaterialApp(
  locale: const Locale('ku'),
  localizationsDelegates: BestLocalization.localizationsDelegates,
  supportedLocales: [Locale('ku')],
  // ...
)
```

**Text Direction:** Right-to-Left (RTL)  
**Script:** Arabic-based Kurdish script  
**Example Text:** "ئاگادارکردنەوە", "گەڕان", "هەڵبژاردن"

### 2. Kurmanji (Kurmancî) - Latin Script
Use: `Locale('ku', 'en')` or any country code

```dart
MaterialApp(
  locale: const Locale('ku', 'en'),
  localizationsDelegates: BestLocalization.localizationsDelegates,
  supportedLocales: [Locale('ku', 'en')],
  // ...
)
```

**Text Direction:** Left-to-Right (LTR)  
**Script:** Latin-based script  
**Example Text:** "Hişyarî", "Lêgerîn", "Hilbijartin"

## How It Works

The library automatically detects which script to use based on the `Locale` object:

- **`Locale('ku')`** → Returns Sorani text in Arabic script (RTL)
- **`Locale('ku', <any_country_code>)`** → Returns Kurmanji text in Latin script (LTR)

Examples with country codes:
```dart
Locale('ku', 'en')  // Kurmanji (Latin)
Locale('ku', 'TR')  // Kurmanji (Latin) - Turkey
Locale('ku', 'IQ')  // Kurmanji (Latin) - Iraq
Locale('ku', 'SY')  // Kurmanji (Latin) - Syria
```

## Implementation Details

### Cupertino, Material, and Widget Localizations

All three Flutter localization types are supported:

1. **CupertinoLocalizations** - iOS-style widgets
2. **MaterialLocalizations** - Material Design widgets
3. **WidgetsLocalizations** - Basic widget localizations

Each delegate checks the locale's `countryCode` property:
```dart
final bool isLatin = locale.countryCode != null && locale.countryCode!.isNotEmpty;
```

### Date and Number Formatting

- **Sorani (Arabic):** Uses Arabic numerals (٠-٩)
- **Kurmanji (Latin):** Uses Western numerals (0-9)

Month names, weekday names, and other date symbols are also different:

**Sorani Months:**
کانونی دووەم, شوبات, ئازار, نیسان, مایس, حوزەیران, تەمموز, ئاب, ئەیلوول, تشرینی یەکەم, تشرینی دووەم, کانونی یەکەم

**Kurmanji Months:**
Çile, Sibat, Adar, Nîsan, Gulan, Pûşper, Tîrmeh, Gelawêj, Rezber, Kewçêr, Sermawez, Berfanbar

## Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:best_localization/best_localization.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('ku'); // Start with Sorani

  void _toggleScript() {
    setState(() {
      _locale = _locale.countryCode == null
          ? const Locale('ku', 'en')  // Switch to Kurmanji
          : const Locale('ku');        // Switch to Sorani
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      supportedLocales: const [
        Locale('ku'),      // Sorani
        Locale('ku', 'en'), // Kurmanji
      ],
      localizationsDelegates: BestLocalization.localizationsDelegates,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Kurdish Demo'),
          actions: [
            IconButton(
              icon: const Icon(Icons.language),
              onPressed: _toggleScript,
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Locale: ${_locale.toString()}'),
              ElevatedButton(
                onPressed: () => showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                ),
                child: const Text('Pick Date'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## Notes

1. **Text Direction:**
   - Sorani: Right-to-Left (RTL)
   - Kurmanji: Left-to-Right (LTR)

2. **Country Code:**
   - The actual country code value doesn't matter for Kurmanji
   - Any non-empty country code triggers Latin script
   - Recommended: Use `'en'` or appropriate country code like `'TR'`, `'IQ'`, `'SY'`

3. **Compatibility:**
   - This works with all Flutter widgets
   - Date pickers, dialogs, buttons, etc. all use the correct script
   - Number formatting adjusts automatically

## Related Locales

If you also have Central Kurdish (ckb), you can include it:

```dart
supportedLocales: const [
  Locale('ku'),       // Kurdish Sorani (Arabic script)
  Locale('ku', 'en'), // Kurdish Kurmanji (Latin script)
  Locale('ckb'),      // Central Kurdish
  Locale('en'),       // English
],
```

## Testing

To test both variants, use the provided `locale_test.dart` example in the `example/lib` folder.
