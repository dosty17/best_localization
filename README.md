# Best Localization

<p align="center">
<img width="75%" src="https://i.pinimg.com/1200x/e6/c2/fe/e6c2fe97ea37619eb784ddd48abdb522.jpg">
</p>

<hr>

**Best Localization** is a lightweight and flexible localization package for Flutter. It supports dynamic translations, interpolation, pluralization, remote translations, fallback locales, and custom localization for the Kurdish language, including widgets like Material and Cupertino.

## Features

- **Dynamic Translations**: Translate text based on locale dynamically.
- **Easy Translation Extensions (NEW! 🎉)**: Use `.tr()` on both Strings and Text widgets without context!
- **Pluralization Support (NEW! 🎉)**: Smart plural forms with language-specific rules (zero, one, two, few, many, other).
- **Gender-Specific Translations (NEW! 🎉)**: Support for male, female, and other gender variations.
- **Multiple File Format Support**: Load translations from JSON, CSV, YAML, or XML files.
- **Remote Translations**: Load translations from HTTP API with automatic caching.
- **Fallback Locale**: Automatically fall back to a default language when translations are missing.
- **Translation Key Verification Tool**: Command-line tool to verify translation keys across locales.
- **Interpolation**: Insert dynamic values into translations (e.g., Hello, {name}!).
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
  best_localization: ^2.0.0
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

> 📚 **For detailed loader documentation**, see [Loader Guide](https://github.com/dosty17/best_localization/blob/main/loader.md)
> 📚 **For remote translations**, see [Remote Loader Guide](https://github.com/dosty17/best_localization/blob/main/loader.md#5-http-loader-http_loaderdart-)
> 📚 **For translation verification**, see [Verification Tool Guide](https://github.com/dosty17/best_localization/blob/main/VERIFICATION.md)

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
        title: Text(context.translate('hello', args: {'name': 'John'})),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Translate text
            Text(context.translate('welcome')),
            
            // Check current language
            if (context.isKurdish) 
              Text('Kurdish language detected!'),
            
            // Get text direction automatically
            Text(
              context.translate('some_text'),
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
- `context.translate('key')` - Translate a key
- `context.translate('key', args: {...})` - Translate with arguments
- `context.plural('key', count)` - Translate with plural form
- `context.localization` - Get BestLocalization instance
- `context.currentLocale` - Get current locale
- `context.languageCode` - Get language code ('en', 'ku', etc.)
- `context.isKurdish` - Check if current language is Kurdish
- `context.isArabic` - Check if current language is Arabic
- `context.isEnglish` - Check if current language is English
- `context.isRTL` - Check if current language is RTL
- `context.textDirection` - Get text direction

#### 4. Easy Translation with .tr() (NEW! 🎉)

Translate strings and Text widgets easily without passing context!

**For Strings:**
```dart
// Simple translation - no context needed!
print('hello'.tr());

// With arguments
print('welcome'.tr(args: {'name': 'John'}));

// With gender
print('greeting'.tr(gender: 'male'));

// With custom locale
print('hello'.tr(locale: Locale('en')));

// With context (optional)
print('hello'.tr(context: context));
```

**For Text Widgets:**
```dart
// Simple translation - no context needed!
Text('hello').tr()

// With arguments
Text('welcome').tr(args: {'name': 'John'})

// With gender
Text('greeting').tr(gender: 'female')

// Plural form
Text('items').plural(5)

// Plural with arguments
Text('money').plural(10, args: {'name': 'Sarah'})

// Using translate() alias
Text('hello').translate()  // Same as .tr()
```

**Usage in Your Widget:**
```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Direct translation - clean and simple!
        Text('welcome'.tr()),
        
        // With styling
        Text('title').tr(args: {'name': 'User'}),
        
        // Plural form
        Text('items').plural(itemCount),
        
        // Gender-specific
        Text('greeting').tr(gender: userGender),
      ],
    );
  }
}
```

#### 5. Pluralization (NEW! 🎉)

Handle plural forms with language-specific rules:

**JSON Structure:**
```json
{
  "day": {
    "zero": "{} дней",
    "one": "{} день",
    "two": "{} дня",
    "few": "{} дня",
    "many": "{} дней",
    "other": "{} дней"
  },
  "money": {
    "zero": "You have no money",
    "one": "You have {} dollar",
    "many": "You have {} dollars",
    "other": "You have {} dollars"
  },
  "money_named_args": {
    "zero": "{name} has no money",
    "one": "{name} has {} dollar",
    "many": "{name} has {} dollars",
    "other": "{name} has {} dollars"
  }
}
```

**Usage:**
```dart
// String plural
'day'.plural(0)   // "0 дней"
'day'.plural(1)   // "1 день"
'day'.plural(5)   // "5 дней"

// With named arguments
'money_named_args'.plural(5, args: {'name': 'John'})  // "John has 5 dollars"
'money_named_args'.plural(1, args: {'name': 'John'})  // "John has 1 dollar"
'money_named_args'.plural(0, args: {'name': 'John'})  // "John has no money"

// Text widget plural
Text('day').plural(itemCount)
Text('money_named_args').plural(balance, args: {'name': userName})

// With context (optional)
'day'.plural(5, context: context)
```

**Supported Plural Forms:**
- `zero` - When count is 0
- `one` - When count is 1
- `two` - When count is 2
- `few` - Language-specific (e.g., 2-4 in Russian)
- `many` - Language-specific (e.g., 5+ in Russian)
- `other` - Default fallback

**Language-Specific Rules:**
- **English**: one (1), other (2+)
- **Russian/Ukrainian**: Complex rules for one/few/many
- **Arabic**: Supports zero, one, two, few, many
- **Polish**: Similar to Russian

#### 6. Gender-Specific Translations (NEW! 🎉)

Support for gender-specific text variations:

**JSON Structure:**
```json
{
  "greeting": {
    "male": "Hi man ;) {}",
    "female": "Hello girl :) {}",
    "other": "Hello {}"
  },
  "welcome_user": {
    "male": "Welcome Mr. {name}",
    "female": "Welcome Ms. {name}",
    "other": "Welcome {name}"
  }
}
```

**Usage:**
```dart
// String gender translation
'greeting'.tr(gender: 'male')    // "Hi man ;) "
'greeting'.tr(gender: 'female')  // "Hello girl :) "
'greeting'.tr(gender: 'other')   // "Hello "

// With arguments
'welcome_user'.tr(gender: 'female', args: {'name': 'Sarah'})  // "Welcome Ms. Sarah"
'welcome_user'.tr(gender: 'male', args: {'name': 'John'})     // "Welcome Mr. John"

// Text widget gender translation
Text('greeting').tr(gender: userGender)
Text('welcome_user').tr(gender: userGender, args: {'name': userName})

// With context (optional)
'greeting'.tr(gender: 'male', context: context)
```

**Dynamic Gender Example:**
```dart
class UserProfile extends StatelessWidget {
  final String userName;
  final String userGender; // 'male', 'female', or 'other'
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('greeting').tr(gender: userGender),
        Text('profile_title').tr(
          gender: userGender,
          args: {'name': userName},
        ),
      ],
    );
  }
}
```

#### 7. Fallback Locale (NEW! 🎉)

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
context.translate('hello')       // Returns "سڵاو" (from Kurdish)
context.translate('new_feature') // Returns "New Feature" (from fallback English)
```

> 📚 **Learn more about Fallback Locale**: [Fallback Locale Guide](https://github.com/dosty17/best_localization/blob/main/FALLBACK.md)

#### 8. Remote Translations (NEW! 🎉)

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

> 📚 **Learn more about Remote Translations**: [Remote Translations Guide](https://github.com/dosty17/best_localization/blob/main/loader.md#5-http-loader-http_loaderdart-)

#### 9. Translation Key Verification Tool (NEW! 🎉)

Verify your translation files to find missing keys, duplicate values, and inconsistencies across locales.

**In Your Code:**
```dart
import 'package:best_localization/best_localization.dart';

// Load your translations
final translations = {
  'en': await JsonAssetLoader(path: 'assets/translations/en.json').load(),
  'ku': await JsonAssetLoader(path: 'assets/translations/ku.json').load(),
  'ar': await JsonAssetLoader(path: 'assets/translations/ar.json').load(),
};

// Verify all locales
final report = TranslationVerifier.verify(
  translations: translations,
  referenceLocale: 'en', // Optional: use English as reference
);

// Print report
print(report.generateReport());

// Get coverage percentage
print('Kurdish coverage: ${report.getCoverage('ku')}%');

// Export as JSON
final jsonReport = report.toJson();
```

**Command-Line Tool:**
```bash
# Activate the package globally (one-time setup)
flutter pub global activate best_localization

# Verify all translations in a directory
dart run best_localization:verify_translations verify assets/languages

# Verify with specific reference locale
dart run best_localization:verify_translations verify assets/languages --reference en

# Compare two translation files
dart run best_localization:verify_translations compare assets/languages/en.json assets/languages/ku.json

# Find duplicate values (same translation for different keys)
dart run best_localization:verify_translations duplicates assets/languages/en.json

# Find similar keys (potential typos)
dart run best_localization:verify_translations similar assets/languages/en.json --threshold 0.8

# Output as JSON for CI/CD integration
dart run best_localization:verify_translations verify assets/languages --json
```

**Verification Report Example:**
```
📋 Translation Verification Report
══════════════════════════════════════════════════
Reference Locale: en
Total Keys: 150
Locales: en, ku, ar
══════════════════════════════════════════════════

❌ Missing Keys:
  ku: 5 missing
    - new_feature
    - settings.advanced
    - error.network_timeout
    
⚠️  Empty Values:
  ar: 2 empty
    - placeholder_text
    - coming_soon

══════════════════════════════════════════════════
Summary:
  Missing: 5 keys
  Extra: 0 keys
  Empty: 2 keys
```

**Use Cases:**
- ✅ **Pre-release verification**: Check translations before publishing
- ✅ **CI/CD integration**: Add as automated test in your pipeline
- ✅ **Translation audit**: Find missing/duplicate translations
- ✅ **Quality assurance**: Ensure consistency across locales
- ✅ **Typo detection**: Find similar keys that might be duplicates

**Available Verification Methods:**
- `TranslationVerifier.verify()` - Verify all locales against reference
- `TranslationVerifier.compareLocales()` - Compare two specific locales
- `TranslationVerifier.findDuplicateValues()` - Find duplicate translations
- `TranslationVerifier.findSimilarKeys()` - Find similar key names (potential typos)

#### 10. Set Keys to Languages Other Than English
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

## Links:
[youtube](https://www.youtube.com/playlist?list=PLwY2YLEPF3yAeT3r_Pdak7DO0PQbvzN_g)\
[facebook](https://www.facebook.com/dosty.pshtiwan18)


