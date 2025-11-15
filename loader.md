# Translation Loaders

This folder contains various loaders for loading translations from different file formats.

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
// Single file
BestLocalizationDelegate.fromLoader(
  JsonAssetLoader(path: 'assets/translations/translations.json')
)

// Multiple files
BestLocalizationDelegate.fromLoader(
  JsonAssetLoader(
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
// Columns format
BestLocalizationDelegate.fromLoader(
  CsvAssetLoader(path: 'assets/translations/translations.csv')
)

// Rows format
BestLocalizationDelegate.fromLoader(
  CsvAssetLoader(
    path: 'assets/translations/translations.csv',
    useColumnsFormat: false,
  )
)
```

### 3. YAML Loader (`yaml_loader.dart`)

Load translations from YAML files.

**Note:** Requires `yaml: ^3.1.2` package.

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
// Single file
BestLocalizationDelegate.fromLoader(
  YamlAssetLoader(path: 'assets/translations/translations.yaml')
)

// Multiple files
BestLocalizationDelegate.fromLoader(
  YamlAssetLoader(
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

**Note:** Requires `xml: ^6.5.0` package.

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
// Custom format (single file)
BestLocalizationDelegate.fromLoader(
  XmlAssetLoader(path: 'assets/translations/translations.xml')
)

// Android format (multiple files)
BestLocalizationDelegate.fromLoader(
  XmlAssetLoader(
    path: 'assets/translations',
    supportedLocales: ['en', 'ku', 'ar'],
    useSingleFile: false,
    format: 'android',
  )
)
```

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
        // Use JSON loader
        BestLocalizationDelegate.fromLoader(
          JsonAssetLoader(path: 'assets/translations/translations.json'),
        ),
        
        // Or use YAML loader
        // BestLocalizationDelegate.fromLoader(
        //   YamlAssetLoader(path: 'assets/translations/translations.yaml'),
        // ),
        
        // Or use CSV loader
        // BestLocalizationDelegate.fromLoader(
        //   CsvAssetLoader(path: 'assets/translations/translations.csv'),
        // ),
        
        // Or use XML loader
        // BestLocalizationDelegate.fromLoader(
        //   XmlAssetLoader(path: 'assets/translations/translations.xml'),
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
        title: Text(context.translate('app_title')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Using extension method
            Text(context.translate('hello')),
            
            // With arguments
            Text(context.translate('welcome', args: {'name': 'John'})),
            
            // Check language
            if (context.isKurdish)
              Text('Kurdish language detected'),
            
            // Get text direction
            Text(
              context.translate('some_text'),
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
