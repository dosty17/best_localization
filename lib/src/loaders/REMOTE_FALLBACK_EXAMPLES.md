# Remote Translations & Fallback Locale Examples

## Remote Translations (HTTP Loader)

Load translations from a remote API with automatic caching.

### Basic Usage

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
        // Load from remote API with caching
        BestLocalizationDelegate.fromLoader(
          Loaders.remote(
            url: 'https://api.example.com/translations',
            cacheEnabled: true,
            cacheDuration: Duration(hours: 24),
          ),
          fallbackLocale: Locale('en'),
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
      home: HomePage(),
    );
  }
}
```

### With Authentication

```dart
BestLocalizationDelegate.fromLoader(
  Loaders.remote(
    url: 'https://api.example.com/translations',
    headers: {
      'Authorization': 'Bearer YOUR_TOKEN',
      'Accept': 'application/json',
    },
    cacheEnabled: true,
  ),
  fallbackLocale: Locale('en'),
)
```

### Disable Caching (Always Fetch Fresh)

```dart
BestLocalizationDelegate.fromLoader(
  Loaders.remote(
    url: 'https://api.example.com/translations',
    cacheEnabled: false, // Always fetch from server
  ),
  fallbackLocale: Locale('en'),
)
```

### Custom Cache Duration

```dart
BestLocalizationDelegate.fromLoader(
  Loaders.remote(
    url: 'https://api.example.com/translations',
    cacheDuration: Duration(hours: 12), // Cache for 12 hours
  ),
  fallbackLocale: Locale('en'),
)
```

### Expected API Response Format

Your API should return JSON in this format:

```json
{
  "en": {
    "hello": "Hello",
    "world": "World",
    "welcome": "Welcome, {name}!"
  },
  "ku": {
    "hello": "سڵاو",
    "world": "جیهان",
    "welcome": "بەخێربێی، {name}!"
  },
  "ar": {
    "hello": "مرحبا",
    "world": "عالم",
    "welcome": "أهلا، {name}!"
  }
}
```

### Clear Cache Manually

```dart
import 'package:best_localization/best_localization.dart';

// Create the loader
final loader = Loaders.remote(
  url: 'https://api.example.com/translations',
) as HttpLoader;

// Later, clear the cache
await loader.clearCache();
```

## Fallback Locale

When a translation key is missing in the current language, the fallback locale will be used.

### Basic Fallback

```dart
BestLocalizationDelegate.fromLoader(
  Loaders.json(path: 'assets/translations.json'),
  fallbackLocale: Locale('en'), // Use English when translation is missing
)
```

### Example

```json
{
  "en": {
    "hello": "Hello",
    "world": "World",
    "new_feature": "New Feature"
  },
  "ku": {
    "hello": "سڵاو",
    "world": "جیهان"
    // "new_feature" is missing
  }
}
```

When Kurdish is selected and you call:
```dart
context.tr('new_feature') // Returns "New Feature" (from fallback English)
context.tr('hello')       // Returns "سڵاو" (from Kurdish)
context.tr('missing_key') // Returns "[missing_key]" (not in any locale)
```

### Fallback with Different Loaders

```dart
// With JSON
BestLocalizationDelegate.fromLoader(
  Loaders.json(path: 'assets/translations.json'),
  fallbackLocale: Locale('en'),
)

// With CSV
BestLocalizationDelegate.fromLoader(
  Loaders.csv(path: 'assets/translations.csv'),
  fallbackLocale: Locale('en'),
)

// With YAML
BestLocalizationDelegate.fromLoader(
  Loaders.yaml(path: 'assets/translations.yaml'),
  fallbackLocale: Locale('en'),
)

// With XML
BestLocalizationDelegate.fromLoader(
  Loaders.xml(path: 'assets/translations.xml'),
  fallbackLocale: Locale('en'),
)

// With Remote
BestLocalizationDelegate.fromLoader(
  Loaders.remote(url: 'https://api.example.com/translations'),
  fallbackLocale: Locale('en'),
)

// With Map
BestLocalizationDelegate.fromMap(
  {'en': {'hello': 'Hello'}, 'ku': {'hello': 'سڵاو'}},
  fallbackLocale: Locale('en'),
)
```

## Complete Example with Remote + Fallback

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
      title: 'Remote Translations Demo',
      
      localizationsDelegates: [
        BestLocalizationDelegate.fromLoader(
          Loaders.remote(
            url: 'https://api.example.com/translations',
            cacheEnabled: true,
            cacheDuration: Duration(hours: 24),
            headers: {
              'Authorization': 'Bearer YOUR_TOKEN',
            },
          ),
          fallbackLocale: Locale('en'), // Fallback to English
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
      
      locale: Locale('ku'), // Default locale
      
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('app_title')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              context.tr('hello'),
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Text(
              context.tr('welcome', args: {'name': 'User'}),
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Force refresh translations
                // You would typically trigger this from settings
              },
              child: Text(context.tr('refresh')),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Benefits

### Remote Translations
- ✅ Update translations without app updates
- ✅ Centralized translation management
- ✅ A/B testing different translations
- ✅ Works offline with cache
- ✅ Automatic retry with cached data

### Fallback Locale
- ✅ Better UX when translations are incomplete
- ✅ Gradual translation rollout
- ✅ Always show something meaningful
- ✅ Easier for translators (can leave gaps)
- ✅ Works with all loader types
