import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';
import 'translation_loader.dart';

/// Loads translations from YAML files.
///
/// Supports two YAML formats:
///
/// 1. Single file with all languages:
/// ```yaml
/// en:
///   hello: Hello
///   world: World
///   welcome: "Welcome, {name}"
/// ku:
///   hello: سڵاو
///   world: جیهان
///   welcome: "بەخێربێی، {name}"
/// ```
///
/// 2. Separate files per language:
/// ```yaml
/// # en.yaml
/// hello: Hello
/// world: World
/// welcome: "Welcome, {name}"
/// ```
class YamlAssetLoader extends TranslationLoader {
  /// Path to the YAML file or folder containing YAML files.
  ///
  /// Examples:
  /// - Single file: `assets/translations/translations.yaml`
  /// - Multiple files: `assets/translations` (will load en.yaml, ku.yaml, etc.)
  final String path;

  /// List of supported language codes when using multiple files.
  ///
  /// Example: `['en', 'ku', 'ar']`
  final List<String>? supportedLocales;

  /// Whether to use a single YAML file for all languages.
  ///
  /// - `true`: Load from a single file (e.g., `translations.yaml`)
  /// - `false`: Load from multiple files (e.g., `en.yaml`, `ku.yaml`)
  final bool useSingleFile;

  /// Creates a YAML asset loader.
  ///
  /// [path]: Path to YAML file or folder
  /// [supportedLocales]: Required when [useSingleFile] is false
  /// [useSingleFile]: Whether to use single file format (default: true)
  YamlAssetLoader({
    required this.path,
    this.supportedLocales,
    this.useSingleFile = true,
  }) : assert(
          useSingleFile || supportedLocales != null,
          'supportedLocales must be provided when using multiple files',
        );

  @override
  Future<Map<String, Map<String, String>>> load() async {
    if (useSingleFile) {
      return _loadSingleFile();
    } else {
      return _loadMultipleFiles();
    }
  }

  /// Loads translations from a single YAML file.
  Future<Map<String, Map<String, String>>> _loadSingleFile() async {
    final yamlString = await rootBundle.loadString(path);
    final yamlMap = loadYaml(yamlString);

    final Map<String, Map<String, String>> translations = {};

    if (yamlMap is Map) {
      yamlMap.forEach((languageCode, translationsMap) {
        if (translationsMap is Map) {
          translations[languageCode.toString()] =
              _flattenYamlMap(translationsMap);
        }
      });
    }

    return translations;
  }

  /// Loads translations from multiple YAML files.
  Future<Map<String, Map<String, String>>> _loadMultipleFiles() async {
    final Map<String, Map<String, String>> translations = {};

    for (final locale in supportedLocales!) {
      try {
        final filePath =
            path.endsWith('/') ? '$path$locale.yaml' : '$path/$locale.yaml';
        final yamlString = await rootBundle.loadString(filePath);
        final yamlMap = loadYaml(yamlString);

        if (yamlMap is Map) {
          translations[locale] = _flattenYamlMap(yamlMap);
        }
      } catch (e) {
        print('Error loading translations for $locale: $e');
      }
    }

    return translations;
  }

  /// Flattens a nested YAML map into a single-level map with dot notation.
  ///
  /// Example:
  /// ```yaml
  /// user:
  ///   name: Name
  ///   email: Email
  /// ```
  /// becomes:
  /// ```
  /// {'user.name': 'Name', 'user.email': 'Email'}
  /// ```
  Map<String, String> _flattenYamlMap(Map yamlMap, [String prefix = '']) {
    final Map<String, String> result = {};

    yamlMap.forEach((key, value) {
      final newKey = prefix.isEmpty ? key.toString() : '$prefix.$key';

      if (value is Map) {
        result.addAll(_flattenYamlMap(value, newKey));
      } else {
        result[newKey] = value.toString();
      }
    });

    return result;
  }
}

/// Loads translations from a YAML string.
class YamlStringLoader extends TranslationLoader {
  /// The YAML string containing translations.
  final String yamlString;

  YamlStringLoader(this.yamlString);

  @override
  Future<Map<String, Map<String, String>>> load() async {
    final yamlMap = loadYaml(yamlString);

    final Map<String, Map<String, String>> translations = {};

    if (yamlMap is Map) {
      yamlMap.forEach((languageCode, translationsMap) {
        if (translationsMap is Map) {
          final loader = YamlAssetLoader(path: '', useSingleFile: true);
          translations[languageCode.toString()] =
              loader._flattenYamlMap(translationsMap);
        }
      });
    }

    return translations;
  }
}
