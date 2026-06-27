import 'package:flutter/material.dart';
import 'package:best_localization/best_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Example demonstrating Kurdish localization with two scripts:
/// 1. Locale('ku') - Kurdish in Arabic script (Sorani)
/// 2. Locale('ku', 'en') - Kurdish in Latin script (Kurmanji)
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Toggle between Sorani (Arabic script) and Kurmanji (Latin script)
  Locale _locale = const Locale('ku'); // Default: Sorani

  void _toggleScript() {
    setState(() {
      if (_locale.countryCode == null || _locale.countryCode!.isEmpty) {
        // Switch to Kurmanji (Latin script)
        _locale = const Locale('ku', 'en');
      } else {
        // Switch to Sorani (Arabic script)
        _locale = const Locale('ku');
      }
    });
  }

  Map<String, Map<String, dynamic>> translations = {
    'en': {
      'hello': 'Hello, {name}!',
      'items': {
        'one': 'One item',
        'two': 'Two items',
        'few': '{} items',
        'many': '{} items',
        'other': '{} items',
      },
      "welcome": {
        'male': "Welcome, Mr. {name}.",
        'female': "Welcome, Ms. {name}.",
        'neutral': "Welcome, {name}."
      },
    },
    'ar': {
      'hello': 'مرحبًا، {name}!',
      'items': {
        'one': 'عنصر واحد',
        'two': 'عنصران',
        'few': '{} عناصر',
        'many': '{} عنصرًا',
        'other': '{} عنصر',
      },
      "welcome": {
        'male': "مرحبًا، السيد {name}.",
        'female': "مرحبًا، السيدة {name}.",
        'neutral': "مرحبًا، {name}."
      },
    },
    'ckb': {
      'hello': 'سڵاو، {name}!',
      'items': {
        'zero': 'سفر شەربەت',
        'one': 'یەک شەربەت',
        'two': 'دوو شەربەت',
        'few': '{} شەربەت',
        'many': '{} شەربەت',
        'other': '{} شەربەت',
      },
      "welcome": {
        'male': "سڵاو، بەڕێز {name}.",
        'female': "سڵاو، خاتوون {name}.",
        'neutral': "سڵاو، {name}."
      },
    },
    'ku': {
      'hello': 'سڵاو، {name}!',
      'items': {
        'zero': 'سفر شەربەت',
        'one': 'یەک شەربەت',
        'two': 'دوو شەربەت',
        'few': '{} شەربەت',
        'many': '{} شەربەت',
        'other': '{} شەربەت',
      },
      "welcome": {
        'male': "سڵاو، بەڕێز {name}.",
      }
    }
  };
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kurdish Localization Demo',
      locale: _locale,
      supportedLocales: const [
        Locale('ku'), // Kurdish Sorani (Arabic script)
        Locale('ku', 'en'), // Kurdish Kurmanji (Latin script)
        Locale('ckb'), // Central Kurdish (if you have it)
        Locale('en'), // English
      ],
      localizationsDelegates: [
        BestLocalizationDelegate(
            translations: translations), // Custom localization delegate.
        ...kurdishLocalizations, // Kurdish-specific localization.
        GlobalMaterialLocalizations.delegate, // Material widget localization.
        GlobalCupertinoLocalizations.delegate, // Cupertino widget localization.
        GlobalWidgetsLocalizations.delegate
      ],
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Kurdish Locale Test'),
          actions: [
            IconButton(
              icon: const Icon(Icons.language),
              onPressed: _toggleScript,
              tooltip: 'Toggle Script',
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Current Locale: ${_locale.toString()}',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                _locale.countryCode == null || _locale.countryCode!.isEmpty
                    ? 'Script: Arabic (Sorani)'
                    : 'Script: Latin (Kurmanji)',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                },
                child: const Text('Show Date Picker'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Alert'),
                      content:
                          const Text('This demonstrates localized dialogs.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('OK'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
