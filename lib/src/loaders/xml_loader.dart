import 'package:flutter/services.dart';
import 'package:xml/xml.dart';
import 'translation_loader.dart';

/// Loads translations from XML files.
///
/// Supports two XML formats:
///
/// 1. Single file with all languages:
/// ```xml
/// <?xml version="1.0" encoding="UTF-8"?>
/// <translations>
///   <language code="en">
///     <string key="hello">Hello</string>
///     <string key="world">World</string>
///   </language>
///   <language code="ku">
///     <string key="hello">سڵاو</string>
///     <string key="world">جیهان</string>
///   </language>
/// </translations>
/// ```
///
/// 2. Separate files per language (Android strings.xml style):
/// ```xml
/// <!-- en.xml -->
/// <?xml version="1.0" encoding="UTF-8"?>
/// <resources>
///   <string name="hello">Hello</string>
///   <string name="world">World</string>
/// </resources>
/// ```
class XmlAssetLoader extends TranslationLoader {
  /// Path to the XML file or folder containing XML files.
  ///
  /// Examples:
  /// - Single file: `assets/translations/translations.xml`
  /// - Multiple files: `assets/translations` (will load en.xml, ku.xml, etc.)
  final String path;

  /// List of supported language codes when using multiple files.
  ///
  /// Example: `['en', 'ku', 'ar']`
  final List<String>? supportedLocales;

  /// Whether to use a single XML file for all languages.
  ///
  /// - `true`: Load from a single file (e.g., `translations.xml`)
  /// - `false`: Load from multiple files (e.g., `en.xml`, `ku.xml`)
  final bool useSingleFile;

  /// The XML format to use.
  ///
  /// - `android`: Android strings.xml format (`<resources><string name="key">value</string></resources>`)
  /// - `custom`: Custom format with language code attribute
  final String format;

  /// Creates an XML asset loader.
  ///
  /// [path]: Path to XML file or folder
  /// [supportedLocales]: Required when [useSingleFile] is false
  /// [useSingleFile]: Whether to use single file format (default: true)
  /// [format]: XML format ('android' or 'custom', default: 'custom')
  XmlAssetLoader({
    required this.path,
    this.supportedLocales,
    this.useSingleFile = true,
    this.format = 'custom',
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

  /// Loads translations from a single XML file.
  Future<Map<String, Map<String, Object>>> _loadSingleFile() async {
    final xmlString = await rootBundle.loadString(path);
    final document = XmlDocument.parse(xmlString);

    final Map<String, Map<String, Object>> translations = {};

    if (format == 'android') {
      // Not typical for single file Android format, but supported
      final strings = document.findAllElements('string');
      translations['default'] = {};
      for (final element in strings) {
        final key = element.getAttribute('name');
        final value = element.innerText;
        if (key != null) {
          translations['default']![key] = value;
        }
      }
    } else {
      // Custom format with language nodes
      final languages = document.findAllElements('language');
      for (final langElement in languages) {
        final langCode = langElement.getAttribute('code');
        if (langCode == null) continue;

        translations[langCode] = {};

        final strings = langElement.findElements('string');
        for (final stringElement in strings) {
          final key = stringElement.getAttribute('key');
          final value = stringElement.innerText;
          if (key != null) {
            translations[langCode]![key] = value;
          }
        }
      }
    }

    return translations;
  }

  /// Loads translations from multiple XML files.
  Future<Map<String, Map<String, Object>>> _loadMultipleFiles() async {
    final Map<String, Map<String, Object>> translations = {};

    for (final locale in supportedLocales!) {
      try {
        final filePath =
            path.endsWith('/') ? '$path$locale.xml' : '$path/$locale.xml';
        final xmlString = await rootBundle.loadString(filePath);
        final document = XmlDocument.parse(xmlString);

        translations[locale] = {};

        if (format == 'android') {
          // Android strings.xml format
          final strings = document.findAllElements('string');
          for (final element in strings) {
            final key = element.getAttribute('name');
            final value = element.innerText;
            if (key != null) {
              translations[locale]![key] = value;
            }
          }
        } else {
          // Custom format
          final strings = document.findAllElements('string');
          for (final element in strings) {
            final key = element.getAttribute('key');
            final value = element.innerText;
            if (key != null) {
              translations[locale]![key] = value;
            }
          }
        }
      } catch (_) {}
    }

    return translations;
  }
}

/// Loads translations from an XML string.
class XmlStringLoader extends TranslationLoader {
  /// The XML string containing translations.
  final String xmlString;

  /// The XML format to use.
  final String format;

  XmlStringLoader(this.xmlString, {this.format = 'custom'});

  @override
  Future<Map<String, Map<String, Object>>> load() async {
    final document = XmlDocument.parse(xmlString);

    final Map<String, Map<String, Object>> translations = {};

    if (format == 'android') {
      final strings = document.findAllElements('string');
      translations['default'] = {};
      for (final element in strings) {
        final key = element.getAttribute('name');
        final value = element.innerText;
        if (key != null) {
          translations['default']![key] = value;
        }
      }
    } else {
      // Custom format with language nodes
      final languages = document.findAllElements('language');
      for (final langElement in languages) {
        final langCode = langElement.getAttribute('code');
        if (langCode == null) continue;

        translations[langCode] = {};

        final strings = langElement.findElements('string');
        for (final stringElement in strings) {
          final key = stringElement.getAttribute('key');
          final value = stringElement.innerText;
          if (key != null) {
            translations[langCode]![key] = value;
          }
        }
      }
    }

    return translations;
  }
}
