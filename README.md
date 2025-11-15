# Best Localization

<p align="center">
<img width="75%" src="https://i.pinimg.com/1200x/e6/c2/fe/e6c2fe97ea37619eb784ddd48abdb522.jpg">
</p>

<hr>

**Best Localization** is a lightweight and flexible localization package for Flutter. It supports dynamic translations, interpolation, pluralization, and custom localization for the Kurdish language, including widgets like Material and Cupertino.

## Features

- **Dynamic Translations**: Translate text based on locale dynamically.
- **Multiple File Format Support**: Load translations from JSON, CSV, YAML, or XML files.
- **Interpolation**: Insert dynamic values into translations (e.g., Hello, {name}!).
- **Pluralization**: Handle plural forms for text based on numeric values.
- **BuildContext Extensions**: Easy access to translations without boilerplate code.
- **Custom Localization for Kurdish**:
  - Supports Kurdish (ku) localization for Material and Cupertino widgets.
  - Includes custom date and number formatting.
- **Seamless Integration**:
  - Works with Flutter's native Localizations system.
  - Fully compatible with MaterialApp and CupertinoApp.
- **Flexible Translation Loading**: 
  - Load from assets (JSON, CSV, YAML, XML)
  - Define translations directly in Dart maps
  - Create custom loaders for your specific needs

## Usage

## Getting Started

### Installation

**1- Add best_localization** <br>To install best_localization package, run the following commands in your terminal:

```bash
flutter pub add best_localization
```

or `best_localization` to your `pubspec.yaml`:

```yaml
dependencies:
  best_localization: ^1.0.0
```

**2- Add flutter_localizations** <br> Add the flutter_localizations package to your pubspec.yaml file:
```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
```

### Using the package

#### 1. Initialize Localization

You can load translations in multiple ways:

**Option A: From a Map (Direct)**
```dart
final translations = {
  'en': {
    'hello': 'Hello, {name}!',
    'welcome': 'welcome',
  },
  'ku': {
    'hello': 'سڵاو، {name}!',
    'welcome': 'بەخێربێیت',
  },
  //more language...
};
```

**Option B: From JSON File**
```dart
// Create assets/translations/translations.json
{
  "en": {
    "hello": "Hello, {name}!",
    "welcome": "Welcome"
  },
  "ku": {
    "hello": "سڵاو، {name}!",
    "welcome": "بەخێربێیت"
  }
}
```

**Option C: From CSV File**
```csv
key,en,ku
hello,Hello,سڵاو
welcome,Welcome,بەخێربێیت
```

**Option D: From YAML File**
```yaml
en:
  hello: Hello, {name}!
  welcome: Welcome
ku:
  hello: سڵاو، {name}!
  welcome: بەخێربێیت
```

**Option E: From XML File**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<translations>
  <language code="en">
    <string key="hello">Hello, {name}!</string>
    <string key="welcome">Welcome</string>
  </language>
  <language code="ku">
    <string key="hello">سڵاو، {name}!</string>
    <string key="welcome">بەخێربێیت</string>
  </language>
</translations>
```

**Don't forget to add assets to pubspec.yaml:**
```yaml
flutter:
  assets:
    - assets/translations/
```

#### 2. Add Localization Delegates
Update your MaterialApp or CupertinoApp to include the localization delegates:

```dart
import 'package:best_localization/best_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        // Choose one of the following loaders:
        
        // Using a map directly
        BestLocalizationDelegate.fromMap(translations),
        
        // Or using JSON loader
        BestLocalizationDelegate.fromLoader(
          JsonAssetLoader(path: 'assets/translations/translations.json'),
        ),
        
        // Or using CSV loader
        // BestLocalizationDelegate.fromLoader(
        //   CsvAssetLoader(path: 'assets/translations/translations.csv'),
        // ),
        
        // Or using YAML loader (requires yaml package)
        // BestLocalizationDelegate.fromLoader(
        //   YamlAssetLoader(path: 'assets/translations/translations.yaml'),
        // ),
        
        // Or using XML loader (requires xml package)
        // BestLocalizationDelegate.fromLoader(
        //   XmlAssetLoader(path: 'assets/translations/translations.xml'),
        // ),
        
        // Kurdish localizations
        ...kurdishLocalizations,
        
        // Default Flutter localizations
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ku'), // Kurdish
        Locale('en'), // English
        //more language...
      ],
      locale: Locale('ku'),
      home: MyHomePage(),
    );
  }
}
```


#### 3. Access Translations
Use the BestLocalization.of(context) method or the convenient extension methods:

**Option A: Using Extension Methods (Recommended)**
```dart
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Short and clean syntax
        title: Text(context.tr('hello', args: {'name': 'John'})),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Translate text
            Text(context.tr('welcome')),
            
            // Check current language
            if (context.isKurdish) 
              Text('Kurdish language detected!'),
            
            // Get text direction automatically
            Text(
              context.tr('some_text'),
              textDirection: context.textDirection,
            ),
            
            // Access current language code
            Text('Current language: ${context.languageCode}'),
          ],
        ),
      ),
    );
  }
}
```

**Option B: Using Traditional Method**
```dart
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizer = BestLocalization.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizer.translate('hello', args: {'name': 'John'})),
      ),
      body: Center(
        child: Text(localizer.translate('welcome')),
      ),
    );
  }
}
```

**Available Extension Methods:**
- `context.tr('key')` - Translate a key
- `context.tr('key', args: {...})` - Translate with arguments
- `context.localization` - Get BestLocalization instance
- `context.currentLocale` - Get current locale
- `context.languageCode` - Get language code ('en', 'ku', etc.)
- `context.isKurdish` - Check if current language is Kurdish
- `context.isArabic` - Check if current language is Arabic
- `context.isEnglish` - Check if current language is English
- `context.isRTL` - Check if current language is RTL
- `context.textDirection` - Get text direction

#### 4. Pluralization
Define keys for singular and plural forms in your translations:

```dart
final translations = {
  'en': {
    'items.one': 'One item',
    'items.other': '{count} items',
  },
  'ku': {
    'items.one': 'یەک دانە',
    'items.other': '{count} دانە',
  },
};
```
Access pluralized translations dynamically:
```dart
Text(localizer.translate('items', args: {'count': '2'})); // Output: 2 دانە
```
#### 5. Set Keys to Languages Other Than English
You can define your translation keys in languages other than English. For example:
```dart
final translations = {
  'en': {
    'سڵاو': 'Hello, {name}!',  // Translation for "سڵاو" in English
    'بەخێربێن': 'Welcome',     // Translation for "بەخێربێن" in English
  },
  'ku': {
    'سڵاو': 'سڵاو، {name}!',  // Translation for "سڵاو" in Kurdish
    'بەخێربێن': 'بەخێربێیت',  // Translation for "بەخێربێن" in Kurdish
  },
  // Add more languages here...
};

```

## About the developer
This package was developed by Dosty Pshtiwan, inspired by the flutter_kurdish_localization package created by Amin Samad. It includes Kurdish localization support for Flutter apps and builds upon their foundational work to provide a comprehensive localization solution.

<br>
<img src="https://visitcount.itsvg.in/api?id=dosty-best-localization&label=Visitors&color=12&icon=5&pretty=true" />
<br>

## Links:
[documentattion](https://fersaz.com/flutter/best_localization)\
[youtube](https://www.youtube.com/playlist?list=PLwY2YLEPF3yAeT3r_Pdak7DO0PQbvzN_g)\
[facebook](https://www.facebook.com/dosty.pshtiwan18)


