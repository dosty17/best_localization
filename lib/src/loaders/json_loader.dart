import 'dart:convert';
import 'package:flutter/services.dart';
import 'translation_loader.dart';

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
class JsonAssetLoader extends TranslationLoader {
  /// Path to the JSON file or folder containing JSON files.
  ///
  /// Examples:
  /// - Single file: `assets/translations/translations.json`
  /// - Multiple files: `assets/translations` (will load en.json, ku.json, etc.)
  final String path;

  /// List of supported language codes when using multiple files.
  ///
  /// Example: `['en', 'ku', 'ar']`
  final List<String>? supportedLocales;

  /// Whether to use a single JSON file for all languages.
  ///
  /// - `true`: Load from a single file (e.g., `translations.json`)
  /// - `false`: Load from multiple files (e.g., `en.json`, `ku.json`)
  final bool useSingleFile;

  /// Creates a JSON asset loader.
  ///
  /// [path]: Path to JSON file or folder
  /// [supportedLocales]: Required when [useSingleFile] is false
  /// [useSingleFile]: Whether to use single file format (default: true)
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
  JsonAssetLoader({
    required this.path,
    this.supportedLocales,
    this.useSingleFile = true,
  }) : assert(
          useSingleFile || supportedLocales != null,
          'supportedLocales must be provided when using multiple files',
        );

  @override
  Future<Map<String, Map<String, Object>>> load() async {
    if (useSingleFile) {
      return _loadSingleFile();
    } else {
      return _loadMultipleFiles();
    }
  }

  /// Loads translations from a single JSON file.
  Future<Map<String, Map<String, Object>>> _loadSingleFile() async {
    final jsonString = await rootBundle.loadString(path);
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    final Map<String, Map<String, Object>> translations = {};

    jsonMap.forEach((languageCode, translationsMap) {
      if (translationsMap is Map) {
        translations[languageCode] = Map<String, Object>.from(
          translationsMap.map(
            (key, value) => MapEntry(key.toString(), value),
          ),
        );
      }
    });

    return translations;
  }

  /// Loads translations from multiple JSON files.
  Future<Map<String, Map<String, Object>>> _loadMultipleFiles() async {
    final Map<String, Map<String, Object>> translations = {};

    for (final locale in supportedLocales!) {
      try {
        final filePath =
            path.endsWith('/') ? '$path$locale.json' : '$path/$locale.json';
        final jsonString = await rootBundle.loadString(filePath);
        final Map<String, dynamic> jsonMap = json.decode(jsonString);

        translations[locale] = Map<String, Object>.from(
          jsonMap.map(
            (key, value) => MapEntry(key.toString(), value),
          ),
        );
      } catch (_) {}
    }

    return translations;
  }
}

/// Loads translations from a JSON string.
class JsonStringLoader extends TranslationLoader {
  /// The JSON string containing translations.
  final String jsonString;

  JsonStringLoader(this.jsonString);

  @override
  Future<Map<String, Map<String, Object>>> load() async {
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    final Map<String, Map<String, Object>> translations = {};

    jsonMap.forEach((languageCode, translationsMap) {
      if (translationsMap is Map) {
        translations[languageCode] = Map<String, Object>.from(
          translationsMap.map(
            (key, value) => MapEntry(key.toString(), value),
          ),
        );
      }
    });

    return translations;
  }
}
