import 'dart:io';
import 'dart:convert';
import 'package:best_localization/src/verification/translation_verifier.dart';

/// Command-line tool for verifying translation files
void main(List<String> args) async {
  print('🔍 Best Localization - Translation Verifier');
  print('═' * 50);
  print('');

  if (args.isEmpty) {
    _printUsage();
    exit(1);
  }

  final command = args[0].toLowerCase();

  try {
    switch (command) {
      case 'verify':
        await _verifyCommand(args);
        break;
      case 'compare':
        await _compareCommand(args);
        break;
      case 'duplicates':
        await _duplicatesCommand(args);
        break;
      case 'similar':
        await _similarCommand(args);
        break;
      case 'help':
        _printUsage();
        break;
      default:
        print('❌ Unknown command: $command');
        print('');
        _printUsage();
        exit(1);
    }
  } catch (e) {
    print('❌ Error: $e');
    exit(1);
  }
}

/// Verify translations across multiple locale files
Future<void> _verifyCommand(List<String> args) async {
  if (args.length < 2) {
    print('❌ Usage: verify <path> [--reference locale] [--json]');
    print('   Example: verify assets/languages');
    print('   Example: verify assets/languages --reference en');
    exit(1);
  }

  final path = args[1];
  String? referenceLocale;
  bool jsonOutput = false;

  // Parse options
  for (int i = 2; i < args.length; i++) {
    if (args[i] == '--reference' && i + 1 < args.length) {
      referenceLocale = args[i + 1];
      i++;
    } else if (args[i] == '--json') {
      jsonOutput = true;
    }
  }

  final directory = Directory(path);
  if (!await directory.exists()) {
    print('❌ Directory not found: $path');
    exit(1);
  }

  print('📂 Loading translation files from: $path');
  print('');

  final translations = await _loadTranslationsFromDirectory(directory);

  if (translations.isEmpty) {
    print('❌ No translation files found');
    exit(1);
  }

  print('✅ Loaded ${translations.length} locales');
  print('');

  final report = TranslationVerifier.verify(
    translations: translations,
    referenceLocale: referenceLocale,
  );

  if (jsonOutput) {
    print(JsonEncoder.withIndent('  ').convert(report.toJson()));
  } else {
    print(report.generateReport());
  }

  exit(report.hasIssues ? 1 : 0);
}

/// Compare two specific locale files
Future<void> _compareCommand(List<String> args) async {
  if (args.length < 3) {
    print('❌ Usage: compare <file1> <file2>');
    print('   Example: compare assets/languages/en.json assets/languages/ar.json');
    exit(1);
  }

  final file1Path = args[1];
  final file2Path = args[2];

  final file1 = File(file1Path);
  final file2 = File(file2Path);

  if (!await file1.exists()) {
    print('❌ File not found: $file1Path');
    exit(1);
  }

  if (!await file2.exists()) {
    print('❌ File not found: $file2Path');
    exit(1);
  }

  final locale1 = _getLocaleFromPath(file1Path);
  final locale2 = _getLocaleFromPath(file2Path);

  print('📂 Comparing:');
  print('   $locale1: $file1Path');
  print('   $locale2: $file2Path');
  print('');

  final translations1 = await _loadTranslationFile(file1);
  final translations2 = await _loadTranslationFile(file2);

  final comparison = TranslationVerifier.compareLocales(
    locale1: locale1,
    locale2: locale2,
    translations1: translations1,
    translations2: translations2,
  );

  print(comparison.generateReport());

  final hasIssues = comparison.onlyInLocale1.isNotEmpty ||
      comparison.onlyInLocale2.isNotEmpty ||
      comparison.valueDifferences.isNotEmpty;

  exit(hasIssues ? 1 : 0);
}

/// Find duplicate values in a translation file
Future<void> _duplicatesCommand(List<String> args) async {
  if (args.length < 2) {
    print('❌ Usage: duplicates <file>');
    print('   Example: duplicates assets/languages/en.json');
    exit(1);
  }

  final filePath = args[1];
  final file = File(filePath);

  if (!await file.exists()) {
    print('❌ File not found: $filePath');
    exit(1);
  }

  final locale = _getLocaleFromPath(filePath);
  print('📂 Checking for duplicate values in: $locale');
  print('');

  final translations = await _loadTranslationFile(file);
  final duplicates = TranslationVerifier.findDuplicateValues(translations);

  if (duplicates.isEmpty) {
    print('✅ No duplicate values found!');
    exit(0);
  }

  print('⚠️  Found ${duplicates.length} duplicate values:');
  print('');

  for (final entry in duplicates.entries) {
    print('Value: "${entry.key}"');
    print('Keys:');
    for (final key in entry.value) {
      print('  - $key');
    }
    print('');
  }

  exit(1);
}

/// Find similar keys (potential typos) in a translation file
Future<void> _similarCommand(List<String> args) async {
  if (args.length < 2) {
    print('❌ Usage: similar <file> [--threshold 0.8]');
    print('   Example: similar assets/languages/en.json');
    print('   Example: similar assets/languages/en.json --threshold 0.9');
    exit(1);
  }

  final filePath = args[1];
  double threshold = 0.8;

  // Parse threshold option
  for (int i = 2; i < args.length; i++) {
    if (args[i] == '--threshold' && i + 1 < args.length) {
      threshold = double.tryParse(args[i + 1]) ?? 0.8;
      i++;
    }
  }

  final file = File(filePath);

  if (!await file.exists()) {
    print('❌ File not found: $filePath');
    exit(1);
  }

  final locale = _getLocaleFromPath(filePath);
  print('📂 Checking for similar keys in: $locale');
  print('   Threshold: $threshold');
  print('');

  final translations = await _loadTranslationFile(file);
  final similarGroups = TranslationVerifier.findSimilarKeys(
    translations,
    threshold: threshold,
  );

  if (similarGroups.isEmpty) {
    print('✅ No similar keys found!');
    exit(0);
  }

  print('⚠️  Found ${similarGroups.length} groups of similar keys:');
  print('');

  for (final group in similarGroups) {
    print('Base: ${group.baseKey}');
    print('Similar:');
    for (final key in group.similarKeys) {
      print('  - $key');
    }
    print('');
  }

  exit(1);
}

/// Load all translation files from a directory
Future<Map<String, Map<String, String>>> _loadTranslationsFromDirectory(
  Directory directory,
) async {
  final translations = <String, Map<String, String>>{};

  await for (final entity in directory.list()) {
    if (entity is File && entity.path.endsWith('.json')) {
      final locale = _getLocaleFromPath(entity.path);
      translations[locale] = await _loadTranslationFile(entity);
    }
  }

  return translations;
}

/// Load a single translation file
Future<Map<String, String>> _loadTranslationFile(File file) async {
  final content = await file.readAsString();
  final json = jsonDecode(content) as Map<String, dynamic>;
  return json.map((key, value) => MapEntry(key, value.toString()));
}

/// Extract locale code from file path
String _getLocaleFromPath(String path) {
  final parts = path.split(RegExp(r'[/\\]'));
  final filename = parts.last;
  return filename.replaceAll(RegExp(r'\.(json|yaml|yml|csv|xml)$'), '');
}

/// Print usage information
void _printUsage() {
  print('''
Usage: dart run best_localization:verify_translations <command> [options]

Commands:
  verify <path>           Verify all translation files in a directory
    --reference <locale>  Set reference locale (default: locale with most keys)
    --json                Output as JSON

  compare <file1> <file2> Compare two translation files

  duplicates <file>       Find duplicate values in a file

  similar <file>          Find similar keys (potential typos)
    --threshold <0-1>     Similarity threshold (default: 0.8)

  help                    Show this help message

Examples:
  # Verify all translations in assets/languages
  dart run best_localization:verify_translations verify assets/languages

  # Verify with English as reference
  dart run best_localization:verify_translations verify assets/languages --reference en

  # Compare English and Arabic files
  dart run best_localization:verify_translations compare assets/languages/en.json assets/languages/ar.json

  # Find duplicate values in English
  dart run best_localization:verify_translations duplicates assets/languages/en.json

  # Find similar keys (potential typos)
  dart run best_localization:verify_translations similar assets/languages/en.json

Exit Codes:
  0 - Success (no issues found)
  1 - Issues found or error occurred
''');
}
