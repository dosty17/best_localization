# Translation Loaders Guide

This folder contains various loaders for loading translations from different file formats and sources.

## Available Loaders

### 1. JSON Loader (`json_loader.dart`)

Load translations from JSON files.

#### Single File Format:
```json
{
  "en": {
    "hello": "Hello",
    "world": "World",
    "welcome": "Welcome, {name}"
  },
  "ku": {
    "hello": "سڵاو",
    "world": "جیهان",
    "welcome": "بەخێربێی، {name}"
  }
}
```

#### Multiple Files Format:
```
assets/translations/
  ├── en.json
  ├── ku.json
  └── ar.json
```

**Usage:**
```dart
// Method 1: Using Loaders class (Recommended)
BestLocalizationDelegate.fromLoader(
  Loaders.json(path: 'assets/translations.json')
)

// Method 2: Using factory method
BestLocalizationDelegate.fromJson(
  JsonAssetLoader(path: 'assets/translations.json')
)

// Multiple files
BestLocalizationDelegate.fromLoader(
  Loaders.json(
    path: 'assets/translations',
    supportedLocales: ['en', 'ku', 'ar'],
    useSingleFile: false,
  )
)
```

### 2. CSV Loader (`csv_loader.dart`)

Load translations from CSV files.

#### Columns Format:
```csv
key,en,ku,ar
hello,Hello,سڵاو,مرحبا
world,World,جیهان,عالم
welcome,"Welcome, {name}","بەخێربێی، {name}","أهلا، {name}"
```

#### Rows Format:
```csv
en,hello,Hello
en,world,World
ku,hello,سڵاو
ku,world,جیهان
```

**Usage:**
```dart
// Method 1: Using Loaders class
BestLocalizationDelegate.fromLoader(
  Loaders.csv(path: 'assets/translations.csv')
)

// Method 2: Using factory method
BestLocalizationDelegate.fromCsv(
  CsvAssetLoader(path: 'assets/translations.csv')
)

// Rows format
BestLocalizationDelegate.fromLoader(
  Loaders.csv(
    path: 'assets/translations.csv',
    useColumnsFormat: false,
  )
)
```

### 3. YAML Loader (`yaml_loader.dart`)

Load translations from YAML files.

**Note:** Requires `yaml: '>=3.0.0 <4.0.0'` package.

#### Single File Format:
```yaml
en:
  hello: Hello
  world: World
  user:
    name: Name
    email: Email
ku:
  hello: سڵاو
  world: جیهان
  user:
    name: ناو
    email: ئیمەیڵ
```

#### Multiple Files Format:
```yaml
# en.yaml
hello: Hello
world: World
user:
  name: Name
  email: Email
```

**Usage:**
```dart
// Method 1: Using Loaders class
BestLocalizationDelegate.fromLoader(
  Loaders.yaml(path: 'assets/translations.yaml')
)

// Method 2: Using factory method
BestLocalizationDelegate.fromYaml(
  YamlAssetLoader(path: 'assets/translations.yaml')
)

// Multiple files
BestLocalizationDelegate.fromLoader(
  Loaders.yaml(
    path: 'assets/translations',
    supportedLocales: ['en', 'ku', 'ar'],
    useSingleFile: false,
  )
)
```

**Note:** Nested YAML maps are flattened using dot notation:
```yaml
user:
  name: Name
```
becomes `{'user.name': 'Name'}`

### 4. XML Loader (`xml_loader.dart`)

Load translations from XML files.

**Note:** Requires `xml: '>=6.0.0 <7.0.0'` package.

#### Custom Format (Single File):
```xml
<?xml version="1.0" encoding="UTF-8"?>
<translations>
  <language code="en">
    <string key="hello">Hello</string>
    <string key="world">World</string>
  </language>
  <language code="ku">
    <string key="hello">سڵاو</string>
    <string key="world">جیهان</string>
  </language>
</translations>
```

#### Android Format (Separate Files):
```xml
<!-- en.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<resources>
  <string name="hello">Hello</string>
  <string name="world">World</string>
</resources>
```

**Usage:**
```dart
// Method 1: Using Loaders class
BestLocalizationDelegate.fromLoader(
  Loaders.xml(path: 'assets/translations.xml')
)

// Method 2: Using factory method
BestLocalizationDelegate.fromXml(
  XmlAssetLoader(path: 'assets/translations.xml')
)

// Android format (multiple files)
BestLocalizationDelegate.fromLoader(
  Loaders.xml(
    path: 'assets/translations',
    supportedLocales: ['en', 'ku', 'ar'],
    useSingleFile: false,
    format: 'android',
  )
)
```

### 5. HTTP Loader (`http_loader.dart`) 🆕

Load translations from a remote HTTP endpoint with automatic caching.

**Note:** Requires `http: '>=0.13.0 <2.0.0'` and `shared_preferences: '>=2.0.0 <3.0.0'` packages.

#### Expected API Response Format:
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
  }
}
```

**Usage:**
```dart
// Method 1: Using Loaders class (Recommended)
BestLocalizationDelegate.fromLoader(
  Loaders.remote(
    url: 'https://api.example.com/translations',
    cacheEnabled: true,
    cacheDuration: Duration(hours: 24),
  ),
  fallbackLocale: Locale('en'),
)

// Method 2: Using factory method
BestLocalizationDelegate.fromHttp(
  HttpLoader(
    url: 'https://api.example.com/translations',
    cacheEnabled: true,
    cacheDuration: Duration(hours: 24),
  )
)

// With authentication
BestLocalizationDelegate.fromLoader(
  Loaders.remote(
    url: 'https://api.example.com/translations',
    headers: {
      'Authorization': 'Bearer YOUR_TOKEN',
      'Accept': 'application/json',
    },
  )
)

// Disable caching (always fetch fresh)
BestLocalizationDelegate.fromLoader(
  Loaders.remote(
    url: 'https://api.example.com/translations',
    cacheEnabled: false,
  )
)

// Custom cache duration
BestLocalizationDelegate.fromLoader(
  Loaders.remote(
    url: 'https://api.example.com/translations',
    cacheDuration: Duration(hours: 12),
  )
)
```

**Features:**
- ✅ Automatic caching with `shared_preferences`
- ✅ Configurable cache duration (default: 24 hours)
- ✅ Custom HTTP headers support (for authentication)
- ✅ Offline fallback using expired cache
- ✅ Manual cache clearing
- ✅ Works with any REST API endpoint
- ✅ Update translations without app updates

**Clear Cache:**
```dart
final loader = Loaders.remote(
  url: 'https://api.example.com/translations',
) as HttpLoader;

await loader.clearCache();
```

**How it works:**
1. First request: Fetches from API and caches locally
2. Subsequent requests: Uses cache if valid (within cache duration)
3. Cache expired: Fetches fresh data from API
4. No internet + expired cache: Uses expired cache as fallback
5. Manual clear: Force refresh from API on next load

> 📚 **Learn more about Remote Translations**: [Remote Translations Guide](REMOTE_FALLBACK_EXAMPLES.md#remote-translations-http-loader)

## Creating Custom Loaders

You can create your own loader by extending the `TranslationLoader` abstract class:

```dart
import 'package:best_localization/best_localization.dart';

class MyCustomLoader extends TranslationLoader {
  @override
  Future<Map<String, Map<String, String>>> load() async {
    // Your custom loading logic here
    return {
      'en': {'hello': 'Hello'},
      'ku': {'hello': 'سڵاو'},
    };
  }
}

// Usage
BestLocalizationDelegate.fromLoader(MyCustomLoader())
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
      title: 'Best Localization Demo',
      
      // Supported locales
      supportedLocales: [
        Locale('en'),
        Locale('ku'),
        Locale('ar'),
      ],
      
      // Localization delegates
      localizationsDelegates: [
        // Choose one loader:
        
        // JSON
        BestLocalizationDelegate.fromJson(
          JsonAssetLoader(path: 'assets/translations.json'),
        ),
        
        // Or CSV
        // BestLocalizationDelegate.fromCsv(
        //   CsvAssetLoader(path: 'assets/translations.csv'),
        // ),
        
        // Or YAML
        // BestLocalizationDelegate.fromYaml(
        //   YamlAssetLoader(path: 'assets/translations.yaml'),
        // ),
        
        // Or XML
        // BestLocalizationDelegate.fromXml(
        //   XmlAssetLoader(path: 'assets/translations.xml'),
        // ),
        
        // Or Remote (NEW!)
        // BestLocalizationDelegate.fromHttp(
        //   HttpLoader(url: 'https://api.example.com/translations'),
        // ),
        
        // Or using Loaders class
        // BestLocalizationDelegate.fromLoader(
        //   Loaders.json(path: 'assets/translations.json'),
        //   fallbackLocale: Locale('en'),
        // ),
        
        // Kurdish localizations
        ...kurdishLocalizations,
        
        // Default Flutter localizations
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      
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
            // Using extension method
            Text(context.tr('hello')),
            
            // With arguments
            Text(context.tr('welcome', args: {'name': 'John'})),
            
            // Check language
            if (context.isKurdish)
              Text('Kurdish language detected'),
            
            // Get text direction
            Text(
              context.tr('some_text'),
              textDirection: context.textDirection,
            ),
          ],
        ),
      ),
    );
  }
}
```

## Don't Forget!

Add your translation files to `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/translations/
    # Or specific files
    - assets/translations/translations.json
    - assets/translations/en.json
    - assets/translations/ku.json
```

## Available Factory Methods

All loaders can be created using factory methods:

1. **`BestLocalizationDelegate.fromMap()`** - Direct map
2. **`BestLocalizationDelegate.fromJson()`** - JSON files
3. **`BestLocalizationDelegate.fromCsv()`** - CSV files
4. **`BestLocalizationDelegate.fromYaml()`** - YAML files
5. **`BestLocalizationDelegate.fromXml()`** - XML files
6. **`BestLocalizationDelegate.fromHttp()`** - Remote API
7. **`BestLocalizationDelegate.fromLoader()`** - Generic loader (with Loaders class)

## Learn More

- **Fallback Locale**: See [FALLBACK.md](FALLBACK.md) for detailed examples and use cases
- **Remote Translations**: See [REMOTE_FALLBACK_EXAMPLES.md](REMOTE_FALLBACK_EXAMPLES.md) for advanced remote loading examples
- **Main Documentation**: See [README.md](../../../README.md)
