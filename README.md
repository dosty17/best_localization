# Best Localization

<p align="center">
<img width="75%" src="https://i.pinimg.com/1200x/e6/c2/fe/e6c2fe97ea37619eb784ddd48abdb522.jpg">
</p>

<hr>

**Best Localization** is a lightweight and flexible localization package for Flutter. It supports dynamic translations, interpolation, pluralization, and custom localization for the Kurdish language, including widgets like Material and Cupertino.

## Features

- **Dynamic Translations**: Translate text based on locale dynamically.
- **Interpolation**: Insert dynamic values into translations (e.g., Hello, {name}!).
- **Pluralization**: Handle plural forms for text based on numeric values.
- **Custom Localization for Kurdish**:
  - Supports Kurdish (ku) localization for Material and Cupertino widgets.
  - Includes custom date and number formatting.
- Seamless Integration:
  - Works with Flutter’s native Localizations system.
  - Fully compatible with MaterialApp and CupertinoApp.
- No ARB Files: Manage translations directly in Dart maps, simplifying the workflow.

## Usage

## Getting Started

### Installation

To install best_localization package, run the following commands in your terminal:

```bash
flutter pub add best_localization
```

or `best_localization` to your `pubspec.yaml`:

```yaml
dependencies:
  best_localization: ^1.0.0
```

#### 1. Initialize Localization
Define your translations using Dart maps. Here's an example with Kurdish and English:


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

#### 2. Add Localization Delegates
Update your MaterialApp or CupertinoApp to include the localization delegates:

```dart
import 'package:best_localization/best_localization.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        BestLocalizationDelegate(translations: translations),
        ...kurdishLocalizations,
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
Use the BestLocalization.of(context) method to access translations in your widgets:

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

## About the developer
This package was developed by Dosty Pshtiwan, inspired by the flutter_kurdish_localization package created by Amin Samad. It includes Kurdish localization support for Flutter apps and builds upon their foundational work to provide a comprehensive localization solution.

<br>
<img src="https://visitcount.itsvg.in/api?id=dosty-best-localization&label=Visitors&color=12&icon=5&pretty=true" />
<br>

## Links:
[documentattion](https://fersaz.com/flutter/best_localization)\
[youtube](https://www.youtube.com/playlist?list=PLwY2YLEPF3yAeT3r_Pdak7DO0PQbvzN_g)\
[facebook](https://www.facebook.com/dosty.pshtiwan18)


