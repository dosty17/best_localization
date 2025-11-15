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
  final Map<String, Map<String, String>> translations;

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
  ///
  /// Returns:
  /// - The translated string if the [key] exists in the current locale.
  /// - The translation from fallbackLocale if the key is missing in current locale.
  /// - `[$key]` if the [key] is missing from both current and fallback locales.
  ///
  /// [locale]: Optional locale to override the current locale for this translation.
  String translate(String key, {Map<String, String>? args, Locale? locale}) {
    // Get the current language code (e.g., 'en', 'ku').
    final languageCode = locale?.languageCode ?? this.locale.languageCode;

    // Try to get translation from current locale
    String? translation = translations[languageCode]?[key];

    // If not found, try fallback locale
    if (translation == null && fallbackLocale != null) {
      translation = translations[fallbackLocale!.languageCode]?[key];
    }

    // If still not found, return key in brackets
    translation ??= '[$key]';

    // Replace placeholders with corresponding values if arguments are provided.
    if (args != null) {
      args.forEach((placeholder, value) {
        translation = translation!.replaceAll('{$placeholder}', value);
      });
    }

    return translation!;
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
  final Map<String, Map<String, String>>? translations;

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
    return BestLocalization(
      locale,
      translationsMap,
      fallbackLocale: fallbackLocale,
    );
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
  ///
  /// Returns:
  /// - The translated string if the [key] exists in the current locale.
  /// - `[$key]` if the [key] is missing from the current locale's translations.
  ///
  /// [locale]: Optional locale to override the current locale for this translation.
  String translate(String key, {Map<String, String>? args, Locale? locale}) {
    return BestLocalization.of(this).translate(key, args: args, locale: locale);
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
