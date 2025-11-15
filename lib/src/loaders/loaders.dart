import 'json_loader.dart';
import 'csv_loader.dart';
import 'yaml_loader.dart';
import 'xml_loader.dart';
import 'translation_loader.dart';

/// Convenient loader factory class for loading translations from different formats.
///
/// Use this class to easily create loaders without instantiating individual loader classes.
///
/// Example:
/// ```dart
/// // JSON loader
/// BestLocalizationDelegate.fromLoader(
///   Loaders.json(path: 'assets/translations.json'),
/// )
///
/// // CSV loader
/// BestLocalizationDelegate.fromLoader(
///   Loaders.csv(path: 'assets/translations.csv'),
/// )
/// ```
class Loaders {
  /// Creates a JSON loader from an asset file.
  ///
  /// [path]: Path to JSON file or folder
  /// [supportedLocales]: Required when [useSingleFile] is false
  /// [useSingleFile]: Whether to use single file format (default: true)
  ///
  /// Example:
  /// ```dart
  /// // Single file with all languages
  /// Loaders.json(path: 'assets/translations.json')
  ///
  /// // Multiple files (en.json, ku.json, ar.json)
  /// Loaders.json(
  ///   path: 'assets/translations',
  ///   supportedLocales: ['en', 'ku', 'ar'],
  ///   useSingleFile: false,
  /// )
  /// ```
  static TranslationLoader json({
    required String path,
    List<String>? supportedLocales,
    bool useSingleFile = true,
  }) {
    return JsonAssetLoader(
      path: path,
      supportedLocales: supportedLocales,
      useSingleFile: useSingleFile,
    );
  }

  /// Creates a JSON loader from a JSON string.
  ///
  /// [jsonString]: The JSON string containing translations
  ///
  /// Example:
  /// ```dart
  /// Loaders.jsonString('{"en": {"hello": "Hello"}, "ku": {"hello": "سڵاو"}}')
  /// ```
  static TranslationLoader jsonString(String jsonString) {
    return JsonStringLoader(jsonString);
  }

  /// Creates a CSV loader from an asset file.
  ///
  /// [path]: Path to CSV file
  /// [delimiter]: CSV delimiter (default: ',')
  /// [useColumnsFormat]: Use columns format (default: true)
  ///
  /// Example:
  /// ```dart
  /// // Columns format (key,en,ku,ar)
  /// Loaders.csv(path: 'assets/translations.csv')
  ///
  /// // Rows format (lang,key,value)
  /// Loaders.csv(
  ///   path: 'assets/translations.csv',
  ///   useColumnsFormat: false,
  /// )
  ///
  /// // Custom delimiter
  /// Loaders.csv(
  ///   path: 'assets/translations.tsv',
  ///   delimiter: '\t',
  /// )
  /// ```
  static TranslationLoader csv({
    required String path,
    String delimiter = ',',
    bool useColumnsFormat = true,
  }) {
    return CsvAssetLoader(
      path: path,
      delimiter: delimiter,
      useColumnsFormat: useColumnsFormat,
    );
  }

  /// Creates a CSV loader from a CSV string.
  ///
  /// [csvString]: The CSV string containing translations
  /// [delimiter]: CSV delimiter (default: ',')
  /// [useColumnsFormat]: Use columns format (default: true)
  ///
  /// Example:
  /// ```dart
  /// Loaders.csvString('key,en,ku\nhello,Hello,سڵاو')
  /// ```
  static TranslationLoader csvString(
    String csvString, {
    String delimiter = ',',
    bool useColumnsFormat = true,
  }) {
    return CsvStringLoader(
      csvString,
      delimiter: delimiter,
      useColumnsFormat: useColumnsFormat,
    );
  }

  /// Creates a YAML loader from an asset file.
  ///
  /// [path]: Path to YAML file or folder
  /// [supportedLocales]: Required when [useSingleFile] is false
  /// [useSingleFile]: Whether to use single file format (default: true)
  ///
  /// Example:
  /// ```dart
  /// // Single file with all languages
  /// Loaders.yaml(path: 'assets/translations.yaml')
  ///
  /// // Multiple files (en.yaml, ku.yaml, ar.yaml)
  /// Loaders.yaml(
  ///   path: 'assets/translations',
  ///   supportedLocales: ['en', 'ku', 'ar'],
  ///   useSingleFile: false,
  /// )
  /// ```
  static TranslationLoader yaml({
    required String path,
    List<String>? supportedLocales,
    bool useSingleFile = true,
  }) {
    return YamlAssetLoader(
      path: path,
      supportedLocales: supportedLocales,
      useSingleFile: useSingleFile,
    );
  }

  /// Creates a YAML loader from a YAML string.
  ///
  /// [yamlString]: The YAML string containing translations
  ///
  /// Example:
  /// ```dart
  /// Loaders.yamlString('en:\n  hello: Hello\nku:\n  hello: سڵاو')
  /// ```
  static TranslationLoader yamlString(String yamlString) {
    return YamlStringLoader(yamlString);
  }

  /// Creates an XML loader from an asset file.
  ///
  /// [path]: Path to XML file or folder
  /// [supportedLocales]: Required when [useSingleFile] is false
  /// [useSingleFile]: Whether to use single file format (default: true)
  /// [format]: XML format ('android' or 'custom', default: 'custom')
  ///
  /// Example:
  /// ```dart
  /// // Single file with all languages
  /// Loaders.xml(path: 'assets/translations.xml')
  ///
  /// // Multiple files (en.xml, ku.xml, ar.xml)
  /// Loaders.xml(
  ///   path: 'assets/translations',
  ///   supportedLocales: ['en', 'ku', 'ar'],
  ///   useSingleFile: false,
  /// )
  ///
  /// // Android strings.xml format
  /// Loaders.xml(
  ///   path: 'assets/translations',
  ///   supportedLocales: ['en', 'ku'],
  ///   useSingleFile: false,
  ///   format: 'android',
  /// )
  /// ```
  static TranslationLoader xml({
    required String path,
    List<String>? supportedLocales,
    bool useSingleFile = true,
    String format = 'custom',
  }) {
    return XmlAssetLoader(
      path: path,
      supportedLocales: supportedLocales,
      useSingleFile: useSingleFile,
      format: format,
    );
  }

  /// Creates an XML loader from an XML string.
  ///
  /// [xmlString]: The XML string containing translations
  /// [format]: XML format ('android' or 'custom', default: 'custom')
  ///
  /// Example:
  /// ```dart
  /// Loaders.xmlString('<translations>...</translations>')
  /// ```
  static TranslationLoader xmlString(
    String xmlString, {
    String format = 'custom',
  }) {
    return XmlStringLoader(xmlString, format: format);
  }
}
