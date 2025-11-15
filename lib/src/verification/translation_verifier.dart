/// Translation key verification tool for identifying missing, unused, and inconsistent keys
class TranslationVerifier {
  /// Verify translations across multiple locales
  /// Returns a [VerificationReport] containing all issues found
  static VerificationReport verify({
    required Map<String, Map<String, String>> translations,
    String? referenceLocale,
  }) {
    if (translations.isEmpty) {
      return VerificationReport(
        locales: [],
        missingKeys: {},
        extraKeys: {},
        emptyValues: {},
        totalKeys: 0,
        hasIssues: false,
      );
    }

    // Determine reference locale (locale with most keys, or specified one)
    final String baseLocale = referenceLocale ??
        translations.entries
            .reduce((a, b) => a.value.length > b.value.length ? a : b)
            .key;

    final baseKeys = translations[baseLocale]?.keys.toSet() ?? {};
    final Map<String, Set<String>> missingKeys = {};
    final Map<String, Set<String>> extraKeys = {};
    final Map<String, Set<String>> emptyValues = {};

    // Check each locale against base locale
    for (final locale in translations.keys) {
      if (locale == baseLocale) continue;

      final currentKeys = translations[locale]?.keys.toSet() ?? {};

      // Find missing keys (in base but not in current)
      final missing = baseKeys.difference(currentKeys);
      if (missing.isNotEmpty) {
        missingKeys[locale] = missing;
      }

      // Find extra keys (in current but not in base)
      final extra = currentKeys.difference(baseKeys);
      if (extra.isNotEmpty) {
        extraKeys[locale] = extra;
      }

      // Find empty values
      final empty = translations[locale]
              ?.entries
              .where((e) => e.value.trim().isEmpty)
              .map((e) => e.key)
              .toSet() ??
          {};
      if (empty.isNotEmpty) {
        emptyValues[locale] = empty;
      }
    }

    // Check base locale for empty values
    final baseEmpty = translations[baseLocale]
            ?.entries
            .where((e) => e.value.trim().isEmpty)
            .map((e) => e.key)
            .toSet() ??
        {};
    if (baseEmpty.isNotEmpty) {
      emptyValues[baseLocale] = baseEmpty;
    }

    final hasIssues = missingKeys.isNotEmpty ||
        extraKeys.isNotEmpty ||
        emptyValues.isNotEmpty;

    return VerificationReport(
      locales: translations.keys.toList(),
      referenceLocale: baseLocale,
      missingKeys: missingKeys,
      extraKeys: extraKeys,
      emptyValues: emptyValues,
      totalKeys: baseKeys.length,
      hasIssues: hasIssues,
    );
  }

  /// Compare two specific locales
  static LocaleComparison compareLocales({
    required String locale1,
    required String locale2,
    required Map<String, String> translations1,
    required Map<String, String> translations2,
  }) {
    final keys1 = translations1.keys.toSet();
    final keys2 = translations2.keys.toSet();

    final commonKeys = keys1.intersection(keys2);
    final onlyIn1 = keys1.difference(keys2);
    final onlyIn2 = keys2.difference(keys1);

    final differences = <String, KeyDifference>{};
    for (final key in commonKeys) {
      final value1 = translations1[key]!;
      final value2 = translations2[key]!;

      if (value1 != value2) {
        differences[key] = KeyDifference(
          key: key,
          value1: value1,
          value2: value2,
        );
      }
    }

    return LocaleComparison(
      locale1: locale1,
      locale2: locale2,
      commonKeys: commonKeys,
      onlyInLocale1: onlyIn1,
      onlyInLocale2: onlyIn2,
      valueDifferences: differences,
    );
  }

  /// Find duplicate values in a single locale (same translation for different keys)
  static Map<String, List<String>> findDuplicateValues(
    Map<String, String> translations,
  ) {
    final valueToKeys = <String, List<String>>{};

    for (final entry in translations.entries) {
      final value = entry.value.trim();
      if (value.isEmpty) continue;

      valueToKeys.putIfAbsent(value, () => []).add(entry.key);
    }

    // Keep only values that appear more than once
    valueToKeys.removeWhere((value, keys) => keys.length < 2);

    return valueToKeys;
  }

  /// Find keys that are similar (potential duplicates or typos)
  static List<SimilarKeyGroup> findSimilarKeys(
    Map<String, String> translations, {
    double threshold = 0.8,
  }) {
    final keys = translations.keys.toList();
    final groups = <SimilarKeyGroup>[];

    for (int i = 0; i < keys.length; i++) {
      final key1 = keys[i];
      final similar = <String>[];

      for (int j = i + 1; j < keys.length; j++) {
        final key2 = keys[j];
        final similarity = _calculateSimilarity(key1, key2);

        if (similarity >= threshold) {
          similar.add(key2);
        }
      }

      if (similar.isNotEmpty) {
        groups.add(SimilarKeyGroup(
          baseKey: key1,
          similarKeys: similar,
        ));
      }
    }

    return groups;
  }

  /// Calculate Levenshtein similarity between two strings
  static double _calculateSimilarity(String s1, String s2) {
    if (s1 == s2) return 1.0;
    if (s1.isEmpty || s2.isEmpty) return 0.0;

    final distance = _levenshteinDistance(s1, s2);
    final maxLength = s1.length > s2.length ? s1.length : s2.length;

    return 1.0 - (distance / maxLength);
  }

  /// Calculate Levenshtein distance between two strings
  static int _levenshteinDistance(String s1, String s2) {
    final len1 = s1.length;
    final len2 = s2.length;

    final matrix = List.generate(
      len1 + 1,
      (i) => List.filled(len2 + 1, 0),
    );

    for (int i = 0; i <= len1; i++) {
      matrix[i][0] = i;
    }

    for (int j = 0; j <= len2; j++) {
      matrix[0][j] = j;
    }

    for (int i = 1; i <= len1; i++) {
      for (int j = 1; j <= len2; j++) {
        final cost = s1[i - 1] == s2[j - 1] ? 0 : 1;

        matrix[i][j] = [
          matrix[i - 1][j] + 1, // deletion
          matrix[i][j - 1] + 1, // insertion
          matrix[i - 1][j - 1] + cost, // substitution
        ].reduce((a, b) => a < b ? a : b);
      }
    }

    return matrix[len1][len2];
  }
}

/// Report containing all verification results
class VerificationReport {
  /// List of all locales verified
  final List<String> locales;

  /// Reference locale used for comparison
  final String? referenceLocale;

  /// Keys missing in each locale (compared to reference)
  final Map<String, Set<String>> missingKeys;

  /// Extra keys in each locale (not in reference)
  final Map<String, Set<String>> extraKeys;

  /// Keys with empty values in each locale
  final Map<String, Set<String>> emptyValues;

  /// Total number of keys in reference locale
  final int totalKeys;

  /// Whether any issues were found
  final bool hasIssues;

  const VerificationReport({
    required this.locales,
    this.referenceLocale,
    required this.missingKeys,
    required this.extraKeys,
    required this.emptyValues,
    required this.totalKeys,
    required this.hasIssues,
  });

  /// Generate a formatted report string
  String generateReport() {
    if (!hasIssues) {
      return '✅ All translations are in sync! No issues found.\n'
          'Verified ${locales.length} locales with $totalKeys keys each.';
    }

    final buffer = StringBuffer();
    buffer.writeln('📋 Translation Verification Report');
    buffer.writeln('═' * 50);
    buffer.writeln('Reference Locale: $referenceLocale');
    buffer.writeln('Total Keys: $totalKeys');
    buffer.writeln('Locales: ${locales.join(", ")}');
    buffer.writeln('═' * 50);
    buffer.writeln();

    // Missing keys
    if (missingKeys.isNotEmpty) {
      buffer.writeln('❌ Missing Keys:');
      for (final entry in missingKeys.entries) {
        buffer.writeln('  ${entry.key}: ${entry.value.length} missing');
        for (final key in entry.value) {
          buffer.writeln('    - $key');
        }
        buffer.writeln();
      }
    }

    // Extra keys
    if (extraKeys.isNotEmpty) {
      buffer.writeln('➕ Extra Keys (not in reference):');
      for (final entry in extraKeys.entries) {
        buffer.writeln('  ${entry.key}: ${entry.value.length} extra');
        for (final key in entry.value) {
          buffer.writeln('    - $key');
        }
        buffer.writeln();
      }
    }

    // Empty values
    if (emptyValues.isNotEmpty) {
      buffer.writeln('⚠️  Empty Values:');
      for (final entry in emptyValues.entries) {
        buffer.writeln('  ${entry.key}: ${entry.value.length} empty');
        for (final key in entry.value) {
          buffer.writeln('    - $key');
        }
        buffer.writeln();
      }
    }

    // Summary
    buffer.writeln('═' * 50);
    buffer.writeln('Summary:');
    buffer.writeln(
        '  Missing: ${missingKeys.values.fold<int>(0, (sum, set) => sum + set.length)} keys');
    buffer.writeln(
        '  Extra: ${extraKeys.values.fold<int>(0, (sum, set) => sum + set.length)} keys');
    buffer.writeln(
        '  Empty: ${emptyValues.values.fold<int>(0, (sum, set) => sum + set.length)} keys');

    return buffer.toString();
  }

  /// Get coverage percentage for a specific locale
  double getCoverage(String locale) {
    if (totalKeys == 0) return 0.0;

    final missing = missingKeys[locale]?.length ?? 0;
    final empty = emptyValues[locale]?.length ?? 0;

    final valid = totalKeys - missing - empty;
    return (valid / totalKeys) * 100;
  }

  /// Generate JSON report
  Map<String, dynamic> toJson() {
    return {
      'locales': locales,
      'referenceLocale': referenceLocale,
      'totalKeys': totalKeys,
      'hasIssues': hasIssues,
      'missingKeys': missingKeys.map((k, v) => MapEntry(k, v.toList())),
      'extraKeys': extraKeys.map((k, v) => MapEntry(k, v.toList())),
      'emptyValues': emptyValues.map((k, v) => MapEntry(k, v.toList())),
      'coverage': {
        for (final locale in locales) locale: getCoverage(locale),
      },
    };
  }
}

/// Comparison result between two locales
class LocaleComparison {
  final String locale1;
  final String locale2;
  final Set<String> commonKeys;
  final Set<String> onlyInLocale1;
  final Set<String> onlyInLocale2;
  final Map<String, KeyDifference> valueDifferences;

  const LocaleComparison({
    required this.locale1,
    required this.locale2,
    required this.commonKeys,
    required this.onlyInLocale1,
    required this.onlyInLocale2,
    required this.valueDifferences,
  });

  /// Generate formatted comparison report
  String generateReport() {
    final buffer = StringBuffer();
    buffer.writeln('🔍 Locale Comparison: $locale1 vs $locale2');
    buffer.writeln('═' * 50);
    buffer.writeln('Common Keys: ${commonKeys.length}');
    buffer.writeln('Only in $locale1: ${onlyInLocale1.length}');
    buffer.writeln('Only in $locale2: ${onlyInLocale2.length}');
    buffer.writeln('Value Differences: ${valueDifferences.length}');
    buffer.writeln('═' * 50);
    buffer.writeln();

    if (onlyInLocale1.isNotEmpty) {
      buffer.writeln('Keys only in $locale1:');
      for (final key in onlyInLocale1) {
        buffer.writeln('  - $key');
      }
      buffer.writeln();
    }

    if (onlyInLocale2.isNotEmpty) {
      buffer.writeln('Keys only in $locale2:');
      for (final key in onlyInLocale2) {
        buffer.writeln('  - $key');
      }
      buffer.writeln();
    }

    if (valueDifferences.isNotEmpty) {
      buffer.writeln('Different values:');
      for (final diff in valueDifferences.values) {
        buffer.writeln('  $diff');
      }
    }

    return buffer.toString();
  }
}

/// Represents a difference in translation values
class KeyDifference {
  final String key;
  final String value1;
  final String value2;

  const KeyDifference({
    required this.key,
    required this.value1,
    required this.value2,
  });

  @override
  String toString() => '$key:\n    [$value1]\n    [$value2]';
}

/// Group of similar keys (potential duplicates or typos)
class SimilarKeyGroup {
  final String baseKey;
  final List<String> similarKeys;

  const SimilarKeyGroup({
    required this.baseKey,
    required this.similarKeys,
  });

  @override
  String toString() => '$baseKey → ${similarKeys.join(", ")}';
}
