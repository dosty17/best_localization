import 'package:flutter/services.dart';
import 'translation_loader.dart';

/// Loads translations from CSV files.
///
/// Supports two CSV formats:
///
/// 1. Columns format (one language per column):
/// ```csv
/// key,en,ku,ar
/// hello,Hello,سڵاو,مرحبا
/// world,World,جیهان,عالم
/// welcome,"Welcome, {name}","بەخێربێی، {name}","أهلا، {name}"
/// ```
///
/// 2. Rows format (key-value pairs):
/// ```csv
/// en,hello,Hello
/// en,world,World
/// ku,hello,سڵاو
/// ku,world,جیهان
/// ```
class CsvAssetLoader extends TranslationLoader {
  /// Path to the CSV file.
  ///
  /// Example: `assets/translations/translations.csv`
  final String path;

  /// The delimiter used in the CSV file.
  ///
  /// Default: `,`
  final String delimiter;

  /// Whether to use columns format (true) or rows format (false).
  ///
  /// - Columns format: First row is header, first column is key
  /// - Rows format: Each row is [languageCode, key, value]
  final bool useColumnsFormat;

  /// Creates a CSV asset loader.
  ///
  /// [path]: Path to CSV file
  /// [delimiter]: CSV delimiter (default: ',')
  /// [useColumnsFormat]: Use columns format (default: true)
  CsvAssetLoader({
    required this.path,
    this.delimiter = ',',
    this.useColumnsFormat = true,
  });

  @override
  Future<Map<String, Map<String, Object>>> load() async {
    final csvString = await rootBundle.loadString(path);

    if (useColumnsFormat) {
      return _loadColumnsFormat(csvString);
    } else {
      return _loadRowsFormat(csvString);
    }
  }

  /// Loads translations from columns format CSV.
  Map<String, Map<String, Object>> _loadColumnsFormat(String csvString) {
    final lines =
        csvString.split('\n').where((line) => line.trim().isNotEmpty).toList();

    if (lines.isEmpty) return {};

    // Parse header to get language codes
    final header = _parseCsvLine(lines[0]);
    if (header.length < 2) return {};

    final languageCodes = header.sublist(1); // Skip 'key' column

    // Initialize translations map
    final Map<String, Map<String, Object>> translations = {};
    for (final lang in languageCodes) {
      translations[lang] = {};
    }

    // Parse data rows
    for (int i = 1; i < lines.length; i++) {
      final values = _parseCsvLine(lines[i]);
      if (values.isEmpty) continue;

      final key = values[0];

      for (int j = 1; j < values.length && j <= languageCodes.length; j++) {
        final langCode = languageCodes[j - 1];
        final value = values[j];
        if (value.isNotEmpty) {
          translations[langCode]![key] = value;
        }
      }
    }

    return translations;
  }

  /// Loads translations from rows format CSV.
  Map<String, Map<String, Object>> _loadRowsFormat(String csvString) {
    final lines =
        csvString.split('\n').where((line) => line.trim().isNotEmpty).toList();

    final Map<String, Map<String, Object>> translations = {};

    for (final line in lines) {
      final values = _parseCsvLine(line);
      if (values.length < 3) continue;

      final langCode = values[0];
      final key = values[1];
      final value = values[2];

      translations.putIfAbsent(langCode, () => {});
      translations[langCode]![key] = value;
    }

    return translations;
  }

  /// Parses a single CSV line, handling quoted values.
  List<String> _parseCsvLine(String line) {
    final List<String> result = [];
    final buffer = StringBuffer();
    bool inQuotes = false;

    for (int i = 0; i < line.length; i++) {
      final char = line[i];

      if (char == '"') {
        // Handle escaped quotes
        if (inQuotes && i + 1 < line.length && line[i + 1] == '"') {
          buffer.write('"');
          i++; // Skip next quote
        } else {
          inQuotes = !inQuotes;
        }
      } else if (char == delimiter && !inQuotes) {
        result.add(buffer.toString().trim());
        buffer.clear();
      } else {
        buffer.write(char);
      }
    }

    // Add last field
    result.add(buffer.toString().trim());

    return result;
  }
}

/// Loads translations from a CSV string.
class CsvStringLoader extends TranslationLoader {
  /// The CSV string containing translations.
  final String csvString;

  /// The delimiter used in the CSV.
  final String delimiter;

  /// Whether to use columns format.
  final bool useColumnsFormat;

  CsvStringLoader(
    this.csvString, {
    this.delimiter = ',',
    this.useColumnsFormat = true,
  });

  @override
  Future<Map<String, Map<String, Object>>> load() async {
    final loader = CsvAssetLoader(
      path: '', // Not used for string loader
      delimiter: delimiter,
      useColumnsFormat: useColumnsFormat,
    );

    if (useColumnsFormat) {
      return loader._loadColumnsFormat(csvString);
    } else {
      return loader._loadRowsFormat(csvString);
    }
  }
}
