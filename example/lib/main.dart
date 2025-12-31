import 'package:best_localization/best_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Entry point of the Flutter application.
void main() {
  runApp(const MyApp());
}

/// The root widget of the application.
///
/// This widget sets up the localization delegates, supported locales, and theme.
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

/// State for the [MyApp] widget.
///
/// Handles the initialization of translations and localization settings.
class _MyAppState extends State<MyApp> {
  // ** if you use simple loader
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
        'female': "سڵاو، خاتوون {name}.",
        'neutral': "سڵاو، {name}."
      },
    },
  };
  @override
  Widget build(BuildContext context) {
    // Configure the MaterialApp with localization and theme settings.
    return MaterialApp(
      title: 'Flutter Demo', // Title of the app
      theme: ThemeData(
        // Set the color scheme for the application.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true, // Enable Material 3 design.
      ),
      // Define localization delegates for handling translations.
      localizationsDelegates: [
        // BestLocalizationDelegate.fromJson(
        //   JsonAssetLoader(
        //       path: 'assets/languages',
        //       useSingleFile: false,
        //       supportedLocales: ['en', 'ku', 'ar']),
        // ),
        BestLocalizationDelegate(
            translations: translations), // Custom localization delegate.
        ...kurdishLocalizations, // Kurdish-specific localization.
        GlobalMaterialLocalizations.delegate, // Material widget localization.
        GlobalCupertinoLocalizations.delegate, // Cupertino widget localization.
        GlobalWidgetsLocalizations.delegate, // General widget localization.
      ],
      // Define the supported locales for the app.
      supportedLocales: const [
        Locale('ku'), // Kurdish
        Locale('en'), // English
        Locale('ar'), // Arabic
      ],
      // Set the default locale to Kurdish.
      locale: Locale(
        'ku',
      ),
      // Define the home screen of the app.
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
      ),
    );
  }
}

/// The main screen of the app.
///
/// Displays localized text and a counter.
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  /// The title of the screen, displayed in the app bar.
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/// State for the [MyHomePage] widget.
///
/// Manages the counter and displays localized text.
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0; // Counter value displayed on the screen.

  /// Increment the counter and refresh the UI.
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with a title.
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title), // Display the title passed from MyHomePage.
      ),
      // Main body of the screen.
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Display a localized greeting for a male user.
            Text('items').plural(1),
            Text('items').plural(2),
            Text('welcome').tr(gender: 'male', args: {'name': 'Dosty'}),
            Text('welcome').tr(gender: 'neutral', args: {'name': 'Dosty'}),
            Text(context.translate(
              'hello',
              args: {
                'name': 'Dosty'
              }, // Pass dynamic arguments for interpolation.
            )),
            SizedBox(height: 20), // Add spacing between widgets.
            // Display a static label.
            const Text(
              'You have pushed the button this many times:',
            ),
            // Display the counter value.
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            CupertinoExpansionTile(
                title: Text('Cupertino Expansion Tile'),
                child: Text('Cupertino Expansion Tile Example')),
          ],
        ),
      ),
      // Floating action button to increment the counter.
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter, // Increment counter when pressed.
        tooltip: 'Increment', // Tooltip displayed on hover.
        child: const Icon(Icons.add), // Icon for the button.
      ),
    );
  }
}
