import 'package:best_localization/src/kurdish/kurdish_material_localization_delegate.dart';
import 'package:best_localization/src/kurdish/kurdish_widget_localization_delegate.dart';
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

  /// Creates an instance of [BestLocalization].
  ///
  /// [locale]: The current locale of the application.
  /// [translations]: A map of all translations for each language.
  BestLocalization(this.locale, this.translations);

  /// Translates a given [key] to the string corresponding to the current [locale].
  ///
  /// [key]: The translation key to look up.
  /// [args]: Optional arguments to interpolate into the translated string (e.g., `{name}`).
  ///
  /// Returns:
  /// - The translated string if the [key] exists in the current locale.
  /// - `[$key]` if the [key] is missing from the current locale's translations.
  String translate(String key, {Map<String, String>? args}) {
    // Get the current language code (e.g., 'en', 'ku').
    final languageCode = locale.languageCode;

    // Fetch the translation for the given key or return the fallback `[$key]`.
    String translation = translations[languageCode]?[key] ?? '[$key]';

    // Replace placeholders with corresponding values if arguments are provided.
    if (args != null) {
      args.forEach((placeholder, value) {
        translation = translation.replaceAll('{$placeholder}', value);
      });
    }

    return translation;
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
  final Map<String, Map<String, String>> translations;

  /// Creates an instance of [BestLocalizationDelegate].
  ///
  /// [translations]: A map containing all translations for each language.
  BestLocalizationDelegate({required this.translations});

  /// Checks if the given [locale] is supported by this delegate.
  ///
  /// [locale]: The locale to check.
  ///
  /// Returns:
  /// - `true` if the [locale.languageCode] exists in the [translations] map.
  /// - `false` otherwise.
  @override
  bool isSupported(Locale locale) {
    return translations.containsKey(locale.languageCode);
  }

  /// Loads the [BestLocalization] instance for the given [locale].
  ///
  /// [locale]: The locale for which to load translations.
  ///
  /// Returns:
  /// - A [Future] that resolves to a [BestLocalization] instance.
  @override
  Future<BestLocalization> load(Locale locale) async {
    return BestLocalization(locale, translations);
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
    ];
