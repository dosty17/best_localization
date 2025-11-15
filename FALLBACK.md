# Fallback Locale Guide

The fallback locale feature allows you to automatically use a default language when a translation key is missing in the current language. This is essential for maintaining a good user experience when translations are incomplete.

## What is Fallback Locale?

When a translation key doesn't exist in the user's selected language, the system will automatically look for that key in the fallback language instead of showing `[missing_key]`.

## Basic Usage

```dart
BestLocalizationDelegate.fromLoader(
  Loaders.json(path: 'assets/translations.json'),
  fallbackLocale: Locale('en'), // English as fallback
)
```

## Example Scenario

### Translation Files

```json
{
  "en": {
    "hello": "Hello",
    "world": "World",
    "new_feature": "New Feature",
    "settings": "Settings"
  },
  "ku": {
    "hello": "سڵاو",
    "world": "جیهان"
    // "new_feature" and "settings" are missing
  },
  "ar": {
    "hello": "مرحبا",
    "world": "عالم",
    "new_feature": "ميزة جديدة"
    // "settings" is missing
  }
}
```

### Behavior

When Kurdish (ku) is selected:
```dart
context.tr('hello')       // Returns: "سڵاو" (from Kurdish)
context.tr('world')       // Returns: "جیهان" (from Kurdish)
context.tr('new_feature') // Returns: "New Feature" (from fallback English)
context.tr('settings')    // Returns: "Settings" (from fallback English)
```

When Arabic (ar) is selected:
```dart
context.tr('hello')       // Returns: "مرحبا" (from Arabic)
context.tr('new_feature') // Returns: "ميزة جديدة" (from Arabic)
context.tr('settings')    // Returns: "Settings" (from fallback English)
```

When English (en) is selected:
```dart
context.tr('hello')       // Returns: "Hello" (from English)
context.tr('new_feature') // Returns: "New Feature" (from English)
context.tr('settings')    // Returns: "Settings" (from English)
```

## Works with All Loaders

The fallback locale feature works with every loader type:

### With JSON Loader
```dart
BestLocalizationDelegate.fromLoader(
  Loaders.json(path: 'assets/translations.json'),
  fallbackLocale: Locale('en'),
)
```

### With CSV Loader
```dart
BestLocalizationDelegate.fromLoader(
  Loaders.csv(path: 'assets/translations.csv'),
  fallbackLocale: Locale('en'),
)
```

### With YAML Loader
```dart
BestLocalizationDelegate.fromLoader(
  Loaders.yaml(path: 'assets/translations.yaml'),
  fallbackLocale: Locale('en'),
)
```

### With XML Loader
```dart
BestLocalizationDelegate.fromLoader(
  Loaders.xml(path: 'assets/translations.xml'),
  fallbackLocale: Locale('en'),
)
```

### With Remote Loader
```dart
BestLocalizationDelegate.fromLoader(
  Loaders.remote(url: 'https://api.example.com/translations'),
  fallbackLocale: Locale('en'),
)
```

### With Map
```dart
BestLocalizationDelegate.fromMap(
  {
    'en': {'hello': 'Hello', 'world': 'World'},
    'ku': {'hello': 'سڵاو'},
  },
  fallbackLocale: Locale('en'),
)
```

### Using Factory Methods
```dart
// With fromJson
BestLocalizationDelegate.fromJson(
  JsonAssetLoader(path: 'assets/translations.json'),
  // Note: Factory methods don't support fallbackLocale parameter
  // Use fromLoader instead for fallback support
)

// Recommended: Use fromLoader with fallback
BestLocalizationDelegate.fromLoader(
  Loaders.json(path: 'assets/translations.json'),
  fallbackLocale: Locale('en'),
)
```

## Use Cases

### 1. Gradual Translation Rollout

Start with English and gradually add other languages:

```dart
// Initial release: Only English
{
  "en": {
    "welcome": "Welcome",
    "login": "Login",
    "signup": "Sign Up"
  }
}

// Later: Add Kurdish (partial)
{
  "en": {
    "welcome": "Welcome",
    "login": "Login",
    "signup": "Sign Up"
  },
  "ku": {
    "welcome": "بەخێربێی"
    // Other translations coming soon
  }
}
```

With `fallbackLocale: Locale('en')`, Kurdish users will see "بەخێربێی" for welcome and English text for other keys until they're translated.

### 2. New Features

When adding new features, you don't have to translate everything immediately:

```dart
{
  "en": {
    "existing_feature": "Existing Feature",
    "new_feature": "New Feature"  // Just added
  },
  "ku": {
    "existing_feature": "تایبەتمەندی هەبوو"
    // "new_feature" not translated yet
  }
}
```

### 3. Regional Variants

Use fallback for regional language variants:

```dart
BestLocalizationDelegate.fromLoader(
  Loaders.json(path: 'assets/translations.json'),
  fallbackLocale: Locale('en'), // Standard English
)

// Support both en_US and en_GB, falling back to en
supportedLocales: [
  Locale('en'),
  Locale('en', 'US'),
  Locale('en', 'GB'),
]
```

### 4. Incomplete Translations

Work with translators incrementally:

```dart
// Phase 1: Core UI
{
  "en": { "login": "Login", "logout": "Logout" },
  "ku": { "login": "چوونەژوورەوە", "logout": "دەرچوون" }
}

// Phase 2: Add settings (only English initially)
{
  "en": {
    "login": "Login",
    "logout": "Logout",
    "settings": "Settings",
    "profile": "Profile"
  },
  "ku": {
    "login": "چوونەژوورەوە",
    "logout": "دەرچوون"
    // Translator working on settings/profile
  }
}
```

## Complete Example

```dart
import 'package:flutter/material.dart';
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
        BestLocalizationDelegate.fromLoader(
          Loaders.json(path: 'assets/translations.json'),
          fallbackLocale: Locale('en'), // Always fall back to English
        ),
        ...kurdishLocalizations,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'),
        Locale('ku'),
        Locale('ar'),
      ],
      locale: Locale('ku'), // Default to Kurdish
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Even if 'app_title' is missing in Kurdish, 
        // it will show the English version
        title: Text(context.tr('app_title')),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(context.tr('home')),
            subtitle: Text(context.tr('home_description')),
          ),
          ListTile(
            title: Text(context.tr('settings')),
            subtitle: Text(context.tr('settings_description')),
          ),
          ListTile(
            title: Text(context.tr('profile')),
            subtitle: Text(context.tr('profile_description')),
          ),
          // All missing translations automatically use English
        ],
      ),
    );
  }
}
```

## Benefits

✅ **Better User Experience**: Always show meaningful text, never `[missing_key]`  
✅ **Faster Development**: Launch with partial translations  
✅ **Easier Maintenance**: Add features without waiting for all translations  
✅ **Translator Friendly**: Translators can work incrementally  
✅ **Flexible Rollout**: Release new languages gradually  
✅ **No Breaking Changes**: Missing keys won't break your app  

## Tips

1. **Choose a Common Fallback**: Use English or your app's primary language
2. **Track Missing Keys**: Log missing translations in development
3. **Prioritize Core UI**: Translate essential features first
4. **Test Both Paths**: Verify both translated and fallback texts display correctly
5. **Document Coverage**: Keep track of translation completion per language

## Without Fallback Locale

If you don't use fallback locale:

```dart
context.tr('missing_key') // Returns: "[missing_key]"
```

## With Fallback Locale

```dart
context.tr('missing_key') // Returns: "Missing Key" (from English fallback)
```

Much better user experience! 🎉
