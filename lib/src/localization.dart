import 'package:best_localization/best_localization.dart';
import 'package:best_localization/src/kurdish/kurdish_cupertino_localization_delegate.dart';
import 'package:best_localization/src/kurdish/kurdish_material_localization_delegate.dart';
import 'package:best_localization/src/kurdish/kurdish_widget_localization_delegate.dart';
import 'package:best_localization/src/loaders/translation_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A class that provides localization functionality for Flutter applications.
///
/// [BestLocalization] enables developers to manage translations and retrieve
/// localized strings dynamically based on the current [locale].
class BestLocalization {
  /// Static instance of the current localization
  static BestLocalization? _instance;

  /// Get the current localization instance
  static BestLocalization? get instance => _instance;

  /// The current locale of the application (e.g., `en`, `ar`, `ku`).
  final Locale locale;

  /// A map containing translations for all supported languages.
  ///
  /// The structure is:
  /// ```
  /// {
  ///   'en': {'key1': 'value1', 'key2': 'value2'},
  ///   'ku': {'key1': 'value1', 'key2': 'value2'},
  /// }
  /// ```
  final Map<String, Map<String, dynamic>> translations;

  /// The fallback locale to use when a translation is missing.
  final Locale? fallbackLocale;

  /// Creates an instance of [BestLocalization].
  ///
  /// [locale]: The current locale of the application.
  /// [translations]: A map of all translations for each language.
  /// [fallbackLocale]: The locale to use when a translation is missing.
  BestLocalization(
    this.locale,
    this.translations, {
    this.fallbackLocale,
  });

  /// Translates a given [key] to the string corresponding to the current [locale].
  ///
  /// [key]: The translation key to look up.
  /// [args]: Optional arguments to interpolate into the translated string (e.g., `{name}`).
  /// [gender]: Optional gender for gender-specific translations ('male', 'female', 'other').
  ///
  /// Returns:
  /// - The translated string if the [key] exists in the current locale.
  /// - The translation from fallbackLocale if the key is missing in current locale.
  /// - `[$key]` if the [key] is missing from both current and fallback locales.
  ///
  /// [locale]: Optional locale to override the current locale for this translation.
  String translate(String key,
      {Map<String, String>? args, String? gender, Locale? locale}) {
    // Get the current language code (e.g., 'en', 'ku').
    final languageCode = locale?.languageCode ?? this.locale.languageCode;

    // Try to get translation from current locale
    dynamic translation = translations[languageCode]?[key];

    // If not found, try fallback locale
    if (translation == null && fallbackLocale != null) {
      translation = translations[fallbackLocale!.languageCode]?[key];
    }

    // If still not found, return key in brackets
    if (translation == null) {
      return '[$key]';
    }

    // Handle gender-specific translations
    if (gender != null && translation is Map) {
      final genderKey = gender.toLowerCase();
      translation = translation[genderKey] ?? translation['other'] ?? '[$key]';
    }

    // Convert to string if not already
    String translatedText = translation.toString();

    // Replace placeholders with corresponding values if arguments are provided.
    if (args != null) {
      args.forEach((placeholder, value) {
        translatedText = translatedText.replaceAll('{$placeholder}', value);
      });
    }

    return translatedText;
  }

  /// Translates a given [key] with plural form based on [count].
  ///
  /// [key]: The translation key to look up (should contain plural forms).
  /// [count]: The number to determine the plural form.
  /// [args]: Optional arguments to interpolate into the translated string.
  ///
  /// Plural forms supported: zero, one, two, few, many, other
  ///
  /// Example:
  /// ```dart
  /// localization.plural('day', 0) // "0 дней"
  /// localization.plural('day', 1) // "1 день"
  /// localization.plural('money', 5, args: {'name': 'John'}) // "John has 5 dollars"
  /// ```
  ///
  /// Returns:
  /// - The translated plural string with count interpolated.
  String plural(String key, num count,
      {Map<String, String>? args, Locale? locale}) {
    // Get the current language code (e.g., 'en', 'ku').
    final languageCode = locale?.languageCode ?? this.locale.languageCode;

    // Try to get translation from current locale
    dynamic translation = translations[languageCode]?[key];

    // If not found, try fallback locale
    if (translation == null && fallbackLocale != null) {
      translation = translations[fallbackLocale!.languageCode]?[key];
    }

    // If still not found, return key in brackets
    if (translation == null) {
      return '[$key]';
    }

    // If translation is not a Map, return it as is
    if (translation is! Map) {
      return translation.toString();
    }

    // Determine plural form based on count
    final pluralForm = _getPluralForm(count, languageCode);

    // Get the appropriate plural translation
    String? pluralText;
    for (var form in pluralForm) {
      pluralText = translation[form]?.toString();
      if (pluralText != null) break;
    }

    // Fallback to 'other' if no form found
    pluralText ??= translation['other']?.toString() ?? '[$key]';

    // Replace {} with count
    pluralText = pluralText.replaceAll('{}', count.toString());

    // Replace named placeholders with corresponding values if arguments are provided.
    if (args != null) {
      args.forEach((placeholder, value) {
        pluralText = pluralText!.replaceAll('{$placeholder}', value);
      });
    }

    return pluralText ?? '[$key]';
  }

  /// Determines the plural form based on count and language rules.
  ///
  /// Returns a list of plural forms to try in order of preference.
  List<String> _getPluralForm(num count, String languageCode) {
    final n = count.abs();

    // Handle zero
    if (n == 0) {
      return ['zero', 'other'];
    }

    // Handle one
    if (n == 1) {
      return ['one', 'other'];
    }

    // Handle two
    if (n == 2) {
      return ['two', 'other'];
    }

    // Language-specific plural rules
    switch (languageCode) {
      case 'ru': // Russian
      case 'uk': // Ukrainian
        final mod10 = n % 10;
        final mod100 = n % 100;

        if (mod10 == 1 && mod100 != 11) {
          return ['one', 'other'];
        } else if (mod10 >= 2 && mod10 <= 4 && (mod100 < 10 || mod100 >= 20)) {
          return ['few', 'other'];
        } else {
          return ['many', 'other'];
        }

      case 'ar': // Arabic
        if (n == 0) {
          return ['zero', 'other'];
        } else if (n == 1) {
          return ['one', 'other'];
        } else if (n == 2) {
          return ['two', 'other'];
        } else if (n % 100 >= 3 && n % 100 <= 10) {
          return ['few', 'other'];
        } else if (n % 100 >= 11) {
          return ['many', 'other'];
        }
        return ['other'];

      case 'pl': // Polish
        final mod10 = n % 10;
        final mod100 = n % 100;

        if (n == 1) {
          return ['one', 'other'];
        } else if (mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14)) {
          return ['few', 'other'];
        } else {
          return ['many', 'other'];
        }

      default: // English and most other languages
        if (n == 1) {
          return ['one', 'other'];
        } else {
          return ['many', 'other'];
        }
    }
  }

  /// Provides access to the [BestLocalization] instance from the widget tree.
  ///
  /// This method retrieves the localization instance using Flutter's [Localizations.of].
  ///
  /// [context]: The current build context.
  ///
  /// Returns:
  /// - The [BestLocalization] instance associated with the widget tree.
  static BestLocalization of(BuildContext context) {
    return Localizations.of<BestLocalization>(context, BestLocalization)!;
  }
}

/// A custom localization delegate for [BestLocalization].
///
/// This delegate is responsible for loading the correct translations based on
/// the application's current locale.
class BestLocalizationDelegate extends LocalizationsDelegate<BestLocalization> {
  /// A map of translations for all supported languages.
  final Map<String, Map<String, dynamic>>? translations;

  /// A translation loader to load translations dynamically.
  final TranslationLoader? loader;

  /// The fallback locale to use when a translation is missing.
  ///
  /// Example: `Locale('en')`
  final Locale? fallbackLocale;

  /// Creates an instance of [BestLocalizationDelegate].
  ///
  /// Either [translations] or [loader] must be provided.
  ///
  /// [translations]: A map containing all translations for each language.
  /// [loader]: A translation loader to load translations from files.
  /// [fallbackLocale]: The locale to use when a translation is missing.
  BestLocalizationDelegate({
    this.translations,
    this.loader,
    this.fallbackLocale,
  }) : assert(
          translations != null || loader != null,
          'Either translations or loader must be provided',
        );

  /// Creates a delegate from a translation loader.
  ///
  /// Example:
  /// ```dart
  /// BestLocalizationDelegate.fromLoader(
  ///   Loaders.json(path: 'assets/translations.json'),
  ///   fallbackLocale: Locale('en'),
  /// )
  /// ```
  factory BestLocalizationDelegate.fromLoader(
    TranslationLoader loader, {
    Locale? fallbackLocale,
  }) {
    return BestLocalizationDelegate(
      loader: loader,
      fallbackLocale: fallbackLocale,
    );
  }

  /// Creates a delegate from a CSV loader.
  ///
  /// Example:
  /// ```dart
  /// BestLocalizationDelegate.fromCsv(
  ///  CsvAssetLoader(path: 'assets/translations.csv'),
  /// )
  /// ```
  factory BestLocalizationDelegate.fromCsv(CsvAssetLoader loader) {
    return BestLocalizationDelegate(loader: loader);
  }

  /// Creates a delegate from a JSON loader.
  ///
  /// Example:
  /// ```dart
  /// BestLocalizationDelegate.fromJson(
  ///  JsonAssetLoader(path: 'assets/translations.json'),
  /// )
  /// ```
  /// =====================================
  /// Loads translations from JSON files.
  ///
  /// Supports two JSON formats:
  ///
  /// 1. Single file with all languages:
  /// ```json
  /// {
  ///   "en": {
  ///     "hello": "Hello",
  ///     "world": "World"
  ///   },
  ///   "ku": {
  ///     "hello": "سڵاو",
  ///     "world": "جیهان"
  ///   }
  /// }
  /// ```
  ///
  /// 2. Separate files per language:
  /// ```json
  /// // en.json
  /// {
  ///   "hello": "Hello",
  ///   "world": "World"
  /// }
  /// ```
  ///
  /// What is useSingleFile?
  /// - If true, translations are loaded from a single JSON file containing all languages.
  /// - If false, translations are loaded from multiple JSON files, one per language.
  ///
  /// How use multiple files?
  /// - Provide the [supportedLocales] list with language codes.
  /// - The loader will look for files named `<languageCode>.json` in the specified [path].
  ///
  /// for more details, see the class documentation.
  /// [more info](https://github.com/dosty17/best_localization/blob/main/loader.md#multiple-files-format)

  factory BestLocalizationDelegate.fromJson(JsonAssetLoader loader) {
    return BestLocalizationDelegate(loader: loader);
  }

  /// Creates a delegate from an XML loader.
  ///
  /// Example:
  /// ```dart
  /// BestLocalizationDelegate.fromXml(
  ///  XmlAssetLoader(path: 'assets/translations.xml'),
  /// )
  /// ```
  factory BestLocalizationDelegate.fromXml(XmlAssetLoader loader) {
    return BestLocalizationDelegate(loader: loader);
  }

  /// Creates a delegate from a YAML loader.
  ///
  /// Example:
  /// ```dart
  /// BestLocalizationDelegate.fromYaml(
  ///  YamlAssetLoader(path: 'assets/translations.yaml'),
  /// )
  /// ```
  factory BestLocalizationDelegate.fromYaml(YamlAssetLoader loader) {
    return BestLocalizationDelegate(loader: loader);
  }

  /// Creates a delegate from an HTTP loader.
  ///
  /// Example:
  /// ```dart
  /// BestLocalizationDelegate.fromHttp(
  ///  HttpAssetLoader(url: 'https://api.example.com/translations'),
  /// )
  /// ```
  factory BestLocalizationDelegate.fromHttp(HttpLoader loader) {
    return BestLocalizationDelegate(loader: loader);
  }

  /// Creates a delegate from a map of translations.
  ///
  /// Example:
  /// ```dart
  /// BestLocalizationDelegate.fromMap(
  ///   {'en': {'hello': 'Hello'}, 'ku': {'hello': 'سڵاو'}},
  ///   fallbackLocale: Locale('en'),
  /// )
  /// ```
  factory BestLocalizationDelegate.fromMap(
    Map<String, Map<String, String>> translations, {
    Locale? fallbackLocale,
  }) {
    return BestLocalizationDelegate(
      translations: translations,
      fallbackLocale: fallbackLocale,
    );
  }

  Map<String, Map<String, String>>? _loadedTranslations;

  /// Checks if the given [locale] is supported by this delegate.
  ///
  /// [locale]: The locale to check.
  ///
  /// Returns:
  /// - `true` if the [locale.languageCode] exists in the [translations] map.
  /// - `false` otherwise.
  @override
  bool isSupported(Locale locale) {
    if (translations != null) {
      return translations!.containsKey(locale.languageCode);
    }
    // When using loader, we assume all locales are supported
    // The actual check will be done during load
    return true;
  }

  /// Loads the [BestLocalization] instance for the given [locale].
  ///
  /// [locale]: The locale for which to load translations.
  ///
  /// Returns:
  /// - A [Future] that resolves to a [BestLocalization] instance.
  @override
  Future<BestLocalization> load(Locale locale) async {
    if (loader != null && _loadedTranslations == null) {
      _loadedTranslations = await loader!.load();
    }

    final translationsMap = _loadedTranslations ?? translations!;
    final localization = BestLocalization(
      locale,
      translationsMap,
      fallbackLocale: fallbackLocale,
    );

    // Update the static instance
    BestLocalization._instance = localization;

    return localization;
  }

  /// Indicates whether this delegate should reload when a new delegate is provided.
  ///
  /// Always returns `false` as the translations are static and do not require reloading.
  @override
  bool shouldReload(covariant LocalizationsDelegate<BestLocalization> old) =>
      false;
}

/// A list of custom localization delegates for Kurdish localization.
///
/// This includes:
/// - [KurdishMaterialLocalizations]: Provides Kurdish translations for Material widgets.
/// - [KurdishWidgetLocalizations]: Provides Kurdish translations for general widgets.
List<LocalizationsDelegate> get kurdishLocalizations => [
      KurdishMaterialLocalizations.delegate,
      KurdishWidgetLocalizations.delegate,
      KurdishCupertinoLocalizations.delegate,
    ];

extension LocalizationExtension on BuildContext {
  /// Get the BestLocalization instance from the current context
  BestLocalization get localization => BestLocalization.of(this);

  /// Translates a given [key] to the string corresponding to the current [locale].
  ///
  /// [key]: The translation key to look up.
  /// [args]: Optional arguments to interpolate into the translated string (e.g., `{name}`).
  /// [gender]: Optional gender for gender-specific translations ('male', 'female', 'other').
  ///
  /// Returns:
  /// - The translated string if the [key] exists in the current locale.
  /// - `[$key]` if the [key] is missing from the current locale's translations.
  ///
  /// [locale]: Optional locale to override the current locale for this translation.
  String translate(String key,
      {Map<String, String>? args, String? gender, Locale? locale}) {
    return BestLocalization.of(this)
        .translate(key, args: args, gender: gender, locale: locale);
  }

  /// Translates a given [key] with plural form based on [count].
  ///
  /// [key]: The translation key to look up (should contain plural forms).
  /// [count]: The number to determine the plural form.
  /// [args]: Optional arguments to interpolate into the translated string.
  String plural(String key, num count,
      {Map<String, String>? args, Locale? locale}) {
    return BestLocalization.of(this)
        .plural(key, count, args: args, locale: locale);
  }

  /// Get current locale
  Locale get currentLocale => BestLocalization.of(this).locale;

  /// Get current language code (e.g., 'en', 'ku', 'ar')
  String get languageCode => BestLocalization.of(this).locale.languageCode;

  /// Check if current language is Kurdish
  bool get isKurdish => languageCode == 'ku';

  /// Check if current language is Arabic
  bool get isArabic => languageCode == 'ar';

  /// Check if current language is English
  bool get isEnglish => languageCode == 'en';

  /// Check if current language is RTL (Right-to-Left)
  bool get isRTL => languageCode == 'ar' || languageCode == 'ku';

  /// Get text direction based on current language
  TextDirection get textDirection =>
      isRTL ? TextDirection.rtl : TextDirection.ltr;
}

/// Extension on String to provide translation functionality
extension StringTranslationExtension on String {
  /// Translates the string using the current locale
  ///
  /// [args]: Optional arguments to interpolate into the translated string
  /// [gender]: Optional gender for gender-specific translations ('male', 'female', 'other')
  /// [locale]: Optional locale to override the current locale
  /// [context]: Optional BuildContext (uses static instance if not provided)
  ///
  /// Example:
  /// ```dart
  /// 'hello'.tr()
  /// 'welcome'.tr(args: {'name': 'John'})
  /// 'gender'.tr(gender: 'male') // "Hi man ;) "
  /// 'hello'.tr(context: context) // with context
  /// ```
  String tr(
      {Map<String, String>? args,
      String? gender,
      Locale? locale,
      BuildContext? context}) {
    final localization = context != null
        ? BestLocalization.of(context)
        : BestLocalization.instance;

    if (localization == null) {
      throw Exception('BestLocalization instance not found. '
          'Make sure BestLocalizationDelegate is added to MaterialApp.localizationsDelegates');
    }

    return localization.translate(this,
        args: args, gender: gender, locale: locale);
  }

  /// Translates the string with plural form based on count
  ///
  /// [count]: The number to determine the plural form
  /// [args]: Optional arguments to interpolate into the translated string
  /// [locale]: Optional locale to override the current locale
  /// [context]: Optional BuildContext (uses static instance if not provided)
  ///
  /// Example:
  /// ```dart
  /// 'day'.plural(0) // "0 дней"
  /// 'day'.plural(1) // "1 день"
  /// 'money_named_args'.plural(5, args: {'name': 'John'}) // "John has 5 dollars"
  /// ```
  String plural(num count,
      {Map<String, String>? args, Locale? locale, BuildContext? context}) {
    final localization = context != null
        ? BestLocalization.of(context)
        : BestLocalization.instance;

    if (localization == null) {
      throw Exception('BestLocalization instance not found. '
          'Make sure BestLocalizationDelegate is added to MaterialApp.localizationsDelegates');
    }

    return localization.plural(this, count, args: args, locale: locale);
  }
}

/// Extension on Text widget to provide translation functionality
extension TextTranslationExtension on Text {
  /// Creates a Text widget with translated content
  ///
  /// [args]: Optional arguments to interpolate into the translated string
  /// [gender]: Optional gender for gender-specific translations ('male', 'female', 'other')
  /// [locale]: Optional locale to override the current locale
  /// [context]: Optional BuildContext (uses static instance if not provided)
  ///
  /// Example:
  /// ```dart
  /// Text('hello').tr()
  /// Text('welcome').tr(args: {'name': 'John'})
  /// Text('gender').tr(gender: 'male') // "Hi man ;) "
  /// Text('hello').tr(context: context) // with context
  /// ```
  Text tr(
      {Map<String, String>? args,
      String? gender,
      Locale? locale,
      BuildContext? context}) {
    final localization = context != null
        ? BestLocalization.of(context)
        : BestLocalization.instance;

    if (localization == null) {
      throw Exception('BestLocalization instance not found. '
          'Make sure BestLocalizationDelegate is added to MaterialApp.localizationsDelegates');
    }

    final translatedText = localization.translate(
      data ?? '',
      args: args,
      gender: gender,
      locale: locale,
    );

    return Text(
      translatedText,
      key: key,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: this.locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
      semanticsIdentifier: semanticsIdentifier,
      textScaleFactor: textScaleFactor,
    );
  }

  /// Creates a Text widget with translated content
  ///
  /// [args]: Optional arguments to interpolate into the translated string
  /// [gender]: Optional gender for gender-specific translations ('male', 'female', 'other')
  /// [locale]: Optional locale to override the current locale
  /// [context]: Optional BuildContext (uses static instance if not provided)
  ///
  /// Example:
  /// ```dart
  /// Text('hello').tr()
  /// Text('welcome').tr(args: {'name': 'John'})
  /// Text('gender').tr(gender: 'male') // "Hi man ;) "
  /// Text('hello').tr(context: context) // with context
  /// ```
  Text translate(
      {Map<String, String>? args,
      String? gender,
      Locale? locale,
      BuildContext? context}) {
    return tr(args: args, context: context, gender: gender, locale: locale);
  }

  /// Creates a Text widget with plural translation
  ///
  /// [count]: The number to determine the plural form
  /// [args]: Optional arguments to interpolate into the translated string
  /// [locale]: Optional locale to override the current locale
  /// [context]: Optional BuildContext (uses static instance if not provided)
  ///
  /// Example:
  /// ```dart
  /// Text('day').plural(0) // "0 дней"
  /// Text('day').plural(1) // "1 день"
  /// Text('money_named_args').plural(5, args: {'name': 'John'})
  /// ```
  Text plural(num count,
      {Map<String, String>? args, Locale? locale, BuildContext? context}) {
    final localization = context != null
        ? BestLocalization.of(context)
        : BestLocalization.instance;

    if (localization == null) {
      throw Exception('BestLocalization instance not found. '
          'Make sure BestLocalizationDelegate is added to MaterialApp.localizationsDelegates');
    }

    final translatedText = localization.plural(
      data ?? '',
      count,
      args: args,
      locale: locale,
    );

    return Text(
      translatedText,
      key: key,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: this.locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
      semanticsIdentifier: semanticsIdentifier,
      textScaleFactor: textScaleFactor,
    );
  }
}
