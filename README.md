# Best Localization

<p align="center">
<img width="75%" src="https://i.pinimg.com/1200x/e6/c2/fe/e6c2fe97ea37619eb784ddd48abdb522.jpg">
</p>

<hr>

**Best Localization** is a lightweight and flexible localization package for Flutter. It supports dynamic translations, interpolation, pluralization, remote translations, fallback locales, and custom localization for the Kurdish language, including widgets like Material and Cupertino.

## Features

- **Dynamic Translations**: Translate text based on locale dynamically.
- **Multiple File Format Support (NEW! 🎉)**: Load translations from JSON, CSV, YAML, or XML files.
- **Remote Translations (NEW! 🎉)**: Load translations from HTTP API with automatic caching.
- **Fallback Locale (NEW! 🎉)**: Automatically fall back to a default language when translations are missing.
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
  - Load from remote API (HTTP)
  - Define translations directly in Dart maps
  - Create custom loaders for your specific needs

## Getting Started

### Installation

**1- Add best_localization** <br>To install best_localization package, run the following commands in your terminal:

```bash
flutter pub add best_localization
```

or add `best_localization` to your `pubspec.yaml`:

```yaml
dependencies:
  best_localization: ^0.0.4
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
```json
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

**Option F: From Remote API**
```dart
// Load from your server with automatic caching
Loaders.remote(
  url: 'https://api.example.com/translations',
  cacheEnabled: true,
  cacheDuration: Duration(hours: 24),
)
```

**Don't forget to add assets to pubspec.yaml:**
```yaml
flutter:
  assets:
    - assets/translations/
```

> 📚 **For detailed loader documentation**, see [Loader Guide](lib/src/loaders/README.md)
> 📚 **For remote translations**, see [Remote Loader Guide](lib/src/loaders/README.md#5-http-loader-http_loaderdart-)

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
        // Choose one of the following methods:
        
        // Method 1: Using Loaders class (Recommended)
        BestLocalizationDelegate.fromLoader(
          Loaders.json(path: 'assets/translations.json'),
          fallbackLocale: Locale('en'),
        ),
        
        // Method 2: Using specific factory methods
        // BestLocalizationDelegate.fromJson(
        //   JsonAssetLoader(path: 'assets/translations.json'),
        // ),
        
        // BestLocalizationDelegate.fromCsv(
        //   CsvAssetLoader(path: 'assets/translations.csv'),
        // ),
        
        // BestLocalizationDelegate.fromYaml(
        //   YamlAssetLoader(path: 'assets/translations.yaml'),
        // ),
        
        // BestLocalizationDelegate.fromXml(
        //   XmlAssetLoader(path: 'assets/translations.xml'),
        // ),
        
        // BestLocalizationDelegate.fromHttp(
        //   HttpLoader(url: 'https://api.example.com/translations'),
        // ),
        
        // Method 3: Using a map directly
        // BestLocalizationDelegate.fromMap(
        //   translations,
        //   fallbackLocale: Locale('en'),
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
        Locale('ar'), // Arabic
      ],
      locale: Locale('ku'),
      home: MyHomePage(),
    );
  }
}
```

**All available loader methods:**
- `BestLocalizationDelegate.fromMap()` - Direct map
- `BestLocalizationDelegate.fromJson()` - JSON files
- `BestLocalizationDelegate.fromCsv()` - CSV files
- `BestLocalizationDelegate.fromYaml()` - YAML files
- `BestLocalizationDelegate.fromXml()` - XML files
- `BestLocalizationDelegate.fromHttp()` - Remote API
- `BestLocalizationDelegate.fromLoader()` - Generic loader (with Loaders class)


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

#### 4. Fallback Locale (NEW! 🎉)

Use fallback locale to automatically use a default language when a translation is missing:

```dart
BestLocalizationDelegate.fromLoader(
  Loaders.json(path: 'assets/translations.json'),
  fallbackLocale: Locale('en'), // Falls back to English
)
```

**Example:**
```json
{
  "en": {
    "hello": "Hello",
    "new_feature": "New Feature"
  },
  "ku": {
    "hello": "سڵاو"
    // "new_feature" is missing
  }
}
```

When Kurdish is selected:
```dart
context.tr('hello')       // Returns "سڵاو" (from Kurdish)
context.tr('new_feature') // Returns "New Feature" (from fallback English)
```

> 📚 **Learn more about Fallback Locale**: [Fallback Locale Guide](lib/src/loaders/FALLBACK.md)
> 📚 **Learn more about Remote Translations**: [Remote Translations Examples](lib/src/loaders/REMOTE_FALLBACK_EXAMPLES.md#remote-translations-http-loader)

#### 5. Remote Translations (NEW! 🎉)

Load translations from your server with automatic caching:

```dart
BestLocalizationDelegate.fromLoader(
  Loaders.remote(
    url: 'https://api.example.com/translations',
    cacheEnabled: true,
    cacheDuration: Duration(hours: 24),
    headers: {'Authorization': 'Bearer token'},
  ),
  fallbackLocale: Locale('en'),
)
```

**Benefits:**
- ✅ Update translations without app updates
- ✅ Automatic caching for offline support
- ✅ Custom cache duration
- ✅ Works with authentication

> 📚 **Learn more about Remote Translations**: [Remote Translations Guide](lib/src/loaders/README.md#5-http-loader-http_loaderdart-)

#### 6. Pluralization
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

#### 7. Set Keys to Languages Other Than English
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


