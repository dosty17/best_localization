# Translation Key Verification Tool 🔍

The Translation Key Verification Tool helps you maintain translation quality by identifying missing keys, duplicate values, inconsistencies, and potential typos across different locale files.

## Table of Contents
- [Overview](#overview)
- [Installation](#installation)
- [Command-Line Usage](#command-line-usage)
- [Programmatic Usage](#programmatic-usage)
- [Verification Methods](#verification-methods)
- [CI/CD Integration](#cicd-integration)
- [Examples](#examples)

## Overview

### What Can It Verify?

The verification tool can detect:
- ✅ **Missing Keys**: Keys present in reference locale but missing in other locales
- ✅ **Extra Keys**: Keys present in a locale but not in the reference locale
- ✅ **Empty Values**: Keys with empty or whitespace-only translations
- ✅ **Duplicate Values**: Same translation used for different keys
- ✅ **Similar Keys**: Keys with similar names (potential typos or duplicates)
- ✅ **Coverage Percentage**: Translation completion percentage per locale

## Installation

### For Command-Line Usage

Activate the package globally (one-time setup):
```bash
flutter pub global activate best_localization
```

### For Programmatic Usage

Add to your `pubspec.yaml`:
```yaml
dependencies:
  best_localization: ^1.0.2
```

Then import:
```dart
import 'package:best_localization/best_localization.dart';
```

## Command-Line Usage

### 1. Verify All Translations

Verify all translation files in a directory:
```bash
dart run best_localization:verify_translations verify assets/languages
```

**Output:**
```
📋 Translation Verification Report
══════════════════════════════════════════════════
Reference Locale: en
Total Keys: 150
Locales: en, ku, ar
══════════════════════════════════════════════════

❌ Missing Keys:
  ku: 3 missing
    - new_feature
    - settings.advanced
    - error.network_timeout
  ar: 2 missing
    - new_feature
    - settings.advanced

⚠️  Empty Values:
  ar: 1 empty
    - coming_soon

══════════════════════════════════════════════════
Summary:
  Missing: 5 keys
  Extra: 0 keys
  Empty: 1 keys
```

### 2. Set Reference Locale

Specify which locale to use as reference (default: locale with most keys):
```bash
dart run best_localization:verify_translations verify assets/languages --reference en
```

### 3. JSON Output for CI/CD

Output results as JSON for automated processing:
```bash
dart run best_localization:verify_translations verify assets/languages --json
```

**JSON Output:**
```json
{
  "locales": ["en", "ku", "ar"],
  "referenceLocale": "en",
  "totalKeys": 150,
  "hasIssues": true,
  "missingKeys": {
    "ku": ["new_feature", "settings.advanced"],
    "ar": ["new_feature"]
  },
  "extraKeys": {},
  "emptyValues": {
    "ar": ["coming_soon"]
  },
  "coverage": {
    "en": 100.0,
    "ku": 98.0,
    "ar": 99.3
  }
}
```

### 4. Compare Two Locales

Compare two specific translation files:
```bash
dart run best_localization:verify_translations compare assets/languages/en.json assets/languages/ku.json
```

**Output:**
```
🔍 Locale Comparison: en vs ku
══════════════════════════════════════════════════
Common Keys: 147
Only in en: 3
Only in ku: 0
Value Differences: 0
══════════════════════════════════════════════════

Keys only in en:
  - new_feature
  - settings.advanced
  - error.network_timeout
```

### 5. Find Duplicate Values

Find keys that have the same translation (useful for finding redundant translations):
```bash
dart run best_localization:verify_translations duplicates assets/languages/en.json
```

**Output:**
```
⚠️  Found 2 duplicate values:

Value: "Submit"
Keys:
  - button.submit
  - form.send
  - action.confirm

Value: "Cancel"
Keys:
  - button.cancel
  - dialog.close
```

### 6. Find Similar Keys

Find keys with similar names (potential typos or duplicates):
```bash
dart run best_localization:verify_translations similar assets/languages/en.json
```

**With custom threshold:**
```bash
dart run best_localization:verify_translations similar assets/languages/en.json --threshold 0.9
```

**Output:**
```
⚠️  Found 3 groups of similar keys:

Base: user_name
Similar:
  - username
  - user_nane

Base: error_message
Similar:
  - error_mesage
  - errormessage
```

### Exit Codes

The CLI tool uses standard exit codes:
- `0` - Success (no issues found)
- `1` - Issues found or error occurred

Perfect for CI/CD pipelines!

## Programmatic Usage

### Basic Verification

```dart
import 'package:best_localization/best_localization.dart';

void main() async {
  // Load translations
  final translations = {
    'en': {
      'hello': 'Hello',
      'welcome': 'Welcome',
      'new_feature': 'New Feature',
    },
    'ku': {
      'hello': 'سڵاو',
      'welcome': 'بەخێربێیت',
      // 'new_feature' is missing
    },
    'ar': {
      'hello': 'مرحبا',
      'welcome': 'أهلا',
      'new_feature': '', // Empty value
    },
  };

  // Verify all locales
  final report = TranslationVerifier.verify(
    translations: translations,
    referenceLocale: 'en',
  );

  // Print formatted report
  print(report.generateReport());

  // Check if issues exist
  if (report.hasIssues) {
    print('⚠️  Translation issues detected!');
    
    // Get coverage for each locale
    for (final locale in report.locales) {
      print('$locale: ${report.getCoverage(locale).toStringAsFixed(1)}%');
    }
    
    // Export as JSON
    final jsonReport = report.toJson();
    print(jsonEncode(jsonReport));
  }
}
```

### Load from Files

```dart
import 'dart:convert';
import 'dart:io';

Future<void> verifyTranslationFiles() async {
  // Load JSON files
  final enFile = File('assets/languages/en.json');
  final kuFile = File('assets/languages/ku.json');
  
  final enJson = jsonDecode(await enFile.readAsString());
  final kuJson = jsonDecode(await kuFile.readAsString());
  
  final translations = {
    'en': enJson.map((k, v) => MapEntry(k.toString(), v.toString())),
    'ku': kuJson.map((k, v) => MapEntry(k.toString(), v.toString())),
  };
  
  // Verify
  final report = TranslationVerifier.verify(
    translations: translations,
    referenceLocale: 'en',
  );
  
  // Access specific issues
  report.missingKeys.forEach((locale, keys) {
    print('$locale is missing ${keys.length} keys:');
    for (final key in keys) {
      print('  - $key');
    }
  });
}
```

### Compare Two Locales

```dart
void compareLocales() {
  final enTranslations = {
    'hello': 'Hello',
    'welcome': 'Welcome',
    'goodbye': 'Goodbye',
  };
  
  final kuTranslations = {
    'hello': 'سڵاو',
    'welcome': 'بەخێربێیت',
    'farewell': 'ماڵئاوا',
  };
  
  final comparison = TranslationVerifier.compareLocales(
    locale1: 'en',
    locale2: 'ku',
    translations1: enTranslations,
    translations2: kuTranslations,
  );
  
  print(comparison.generateReport());
  
  // Access specific data
  print('Common keys: ${comparison.commonKeys.length}');
  print('Only in en: ${comparison.onlyInLocale1}');
  print('Only in ku: ${comparison.onlyInLocale2}');
}
```

### Find Duplicates

```dart
void findDuplicates() {
  final translations = {
    'button.submit': 'Submit',
    'form.send': 'Submit',
    'action.confirm': 'Submit',
    'button.cancel': 'Cancel',
    'dialog.close': 'Close',
  };
  
  final duplicates = TranslationVerifier.findDuplicateValues(translations);
  
  duplicates.forEach((value, keys) {
    print('Value "$value" is used in:');
    for (final key in keys) {
      print('  - $key');
    }
  });
}
```

### Find Similar Keys

```dart
void findSimilarKeys() {
  final translations = {
    'user_name': 'User Name',
    'username': 'Username',
    'error_message': 'Error Message',
    'errormessage': 'Error',
  };
  
  final similarGroups = TranslationVerifier.findSimilarKeys(
    translations,
    threshold: 0.8, // 80% similarity
  );
  
  for (final group in similarGroups) {
    print('Base key: ${group.baseKey}');
    print('Similar keys:');
    for (final key in group.similarKeys) {
      print('  - $key');
    }
  }
}
```

## Verification Methods

### TranslationVerifier.verify()

Main verification method that checks all aspects:

```dart
VerificationReport verify({
  required Map<String, Map<String, String>> translations,
  String? referenceLocale,
})
```

**Parameters:**
- `translations`: Map of locale → translations
- `referenceLocale`: Reference locale (optional, defaults to locale with most keys)

**Returns:** `VerificationReport` with:
- `locales`: List of all locales
- `referenceLocale`: The reference locale used
- `missingKeys`: Keys missing per locale
- `extraKeys`: Extra keys per locale
- `emptyValues`: Keys with empty values per locale
- `totalKeys`: Total number of keys in reference
- `hasIssues`: Whether any issues were found

### TranslationVerifier.compareLocales()

Compare two specific locales:

```dart
LocaleComparison compareLocales({
  required String locale1,
  required String locale2,
  required Map<String, String> translations1,
  required Map<String, String> translations2,
})
```

**Returns:** `LocaleComparison` with:
- `commonKeys`: Keys present in both
- `onlyInLocale1`: Keys only in first locale
- `onlyInLocale2`: Keys only in second locale
- `valueDifferences`: Keys with different values

### TranslationVerifier.findDuplicateValues()

Find duplicate translation values:

```dart
Map<String, List<String>> findDuplicateValues(
  Map<String, String> translations,
)
```

**Returns:** Map of value → list of keys using that value

### TranslationVerifier.findSimilarKeys()

Find similar key names (potential typos):

```dart
List<SimilarKeyGroup> findSimilarKeys(
  Map<String, String> translations, {
  double threshold = 0.8,
})
```

**Parameters:**
- `translations`: The translations to check
- `threshold`: Similarity threshold (0.0 to 1.0)

**Returns:** List of similar key groups

## CI/CD Integration

### GitHub Actions

```yaml
name: Verify Translations

on: [push, pull_request]

jobs:
  verify:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.10.0'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Activate best_localization
        run: flutter pub global activate best_localization
      
      - name: Verify translations
        run: |
          dart run best_localization:verify_translations verify assets/languages --reference en
          
      - name: Generate JSON report
        if: failure()
        run: |
          dart run best_localization:verify_translations verify assets/languages --json > translation-report.json
      
      - name: Upload report
        if: failure()
        uses: actions/upload-artifact@v2
        with:
          name: translation-report
          path: translation-report.json
```

### GitLab CI

```yaml
verify_translations:
  image: cirrusci/flutter:latest
  script:
    - flutter pub get
    - flutter pub global activate best_localization
    - dart run best_localization:verify_translations verify assets/languages --reference en
  only:
    - merge_requests
    - master
```

### Pre-commit Hook

Create `.git/hooks/pre-commit`:
```bash
#!/bin/bash

# Verify translations before commit
dart run best_localization:verify_translations verify assets/languages

if [ $? -ne 0 ]; then
  echo "❌ Translation verification failed! Fix issues before committing."
  exit 1
fi

echo "✅ Translation verification passed!"
```

Make it executable:
```bash
chmod +x .git/hooks/pre-commit
```

## Examples

### Example 1: Pre-release Check

```dart
// scripts/verify_translations.dart
import 'dart:io';
import 'dart:convert';
import 'package:best_localization/best_localization.dart';

void main() async {
  print('🔍 Verifying translations before release...\n');
  
  // Load all translation files
  final directory = Directory('assets/languages');
  final translations = <String, Map<String, String>>{};
  
  await for (final file in directory.list()) {
    if (file is File && file.path.endsWith('.json')) {
      final locale = file.path.split('/').last.replaceAll('.json', '');
      final content = await file.readAsString();
      final json = jsonDecode(content) as Map<String, dynamic>;
      translations[locale] = json.map((k, v) => MapEntry(k, v.toString()));
    }
  }
  
  // Verify
  final report = TranslationVerifier.verify(
    translations: translations,
    referenceLocale: 'en',
  );
  
  // Print report
  print(report.generateReport());
  
  // Check coverage
  print('\n📊 Coverage Report:');
  for (final locale in report.locales) {
    final coverage = report.getCoverage(locale);
    final icon = coverage >= 95 ? '✅' : coverage >= 80 ? '⚠️' : '❌';
    print('$icon $locale: ${coverage.toStringAsFixed(1)}%');
  }
  
  // Exit with error if issues found
  if (report.hasIssues) {
    print('\n❌ Translation verification failed!');
    exit(1);
  }
  
  print('\n✅ All translations verified successfully!');
}
```

Run before release:
```bash
dart scripts/verify_translations.dart
```

### Example 2: Quality Assurance Dashboard

```dart
import 'package:best_localization/best_localization.dart';

class TranslationQualityDashboard {
  final Map<String, Map<String, String>> translations;
  
  TranslationQualityDashboard(this.translations);
  
  void generateReport() {
    print('📊 Translation Quality Dashboard\n');
    
    // Overall verification
    final report = TranslationVerifier.verify(
      translations: translations,
      referenceLocale: 'en',
    );
    
    // Coverage
    print('Coverage:');
    for (final locale in report.locales) {
      print('  $locale: ${report.getCoverage(locale).toStringAsFixed(1)}%');
    }
    print('');
    
    // Duplicates per locale
    print('Duplicate Values:');
    for (final entry in translations.entries) {
      final duplicates = TranslationVerifier.findDuplicateValues(entry.value);
      print('  ${entry.key}: ${duplicates.length} duplicate values');
    }
    print('');
    
    // Similar keys (potential typos)
    print('Potential Typos:');
    for (final entry in translations.entries) {
      final similar = TranslationVerifier.findSimilarKeys(entry.value);
      print('  ${entry.key}: ${similar.length} groups of similar keys');
    }
    print('');
    
    // Summary
    print('Summary:');
    print('  Total Locales: ${report.locales.length}');
    print('  Reference Keys: ${report.totalKeys}');
    print('  Issues Found: ${report.hasIssues ? 'Yes' : 'No'}');
  }
}
```

### Example 3: Translation Review Tool

```dart
import 'package:flutter/material.dart';
import 'package:best_localization/best_localization.dart';

class TranslationReviewPage extends StatefulWidget {
  @override
  _TranslationReviewPageState createState() => _TranslationReviewPageState();
}

class _TranslationReviewPageState extends State<TranslationReviewPage> {
  VerificationReport? report;
  
  @override
  void initState() {
    super.initState();
    _loadAndVerify();
  }
  
  Future<void> _loadAndVerify() async {
    // Load translations (from assets, API, etc.)
    final translations = await _loadTranslations();
    
    // Verify
    final verificationReport = TranslationVerifier.verify(
      translations: translations,
      referenceLocale: 'en',
    );
    
    setState(() {
      report = verificationReport;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (report == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Translation Review'),
        backgroundColor: report!.hasIssues ? Colors.orange : Colors.green,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Coverage cards
          ...report!.locales.map((locale) {
            final coverage = report!.getCoverage(locale);
            return Card(
              child: ListTile(
                title: Text(locale.toUpperCase()),
                subtitle: LinearProgressIndicator(value: coverage / 100),
                trailing: Text('${coverage.toStringAsFixed(1)}%'),
              ),
            );
          }),
          
          // Missing keys
          if (report!.missingKeys.isNotEmpty) ...[
            SizedBox(height: 16),
            Text('Missing Keys', style: Theme.of(context).textTheme.headlineSmall),
            ...report!.missingKeys.entries.map((entry) {
              return ExpansionTile(
                title: Text('${entry.key} (${entry.value.length})'),
                children: entry.value.map((key) {
                  return ListTile(
                    dense: true,
                    title: Text(key),
                  );
                }).toList(),
              );
            }),
          ],
          
          // Empty values
          if (report!.emptyValues.isNotEmpty) ...[
            SizedBox(height: 16),
            Text('Empty Values', style: Theme.of(context).textTheme.headlineSmall),
            ...report!.emptyValues.entries.map((entry) {
              return ExpansionTile(
                title: Text('${entry.key} (${entry.value.length})'),
                children: entry.value.map((key) {
                  return ListTile(
                    dense: true,
                    title: Text(key),
                  );
                }).toList(),
              );
            }),
          ],
        ],
      ),
    );
  }
  
  Future<Map<String, Map<String, String>>> _loadTranslations() async {
    // Implement your translation loading logic
    return {};
  }
}
```

## Best Practices

1. **Set a Reference Locale**: Always specify a reference locale (usually English) for consistent verification.

2. **Run Before Releases**: Add verification to your release checklist or CI/CD pipeline.

3. **Set Coverage Goals**: Aim for at least 95% coverage for all locales.

4. **Check for Duplicates**: Regularly check for duplicate values to maintain consistency.

5. **Monitor Similar Keys**: Use similarity detection to catch typos early.

6. **Automate Verification**: Add pre-commit hooks or CI checks to catch issues before they're committed.

7. **Review Empty Values**: Don't leave empty translations - use the fallback locale or proper placeholder text.

8. **Use JSON Output**: In CI/CD, use JSON output for automated processing and reporting.

## Troubleshooting

### Command Not Found

If you get "command not found" error:
```bash
# Make sure global bin is in PATH
export PATH="$PATH":"$HOME/.pub-cache/bin"

# Or use full path
dart run best_localization:verify_translations
```

### False Positives for Similar Keys

Adjust the similarity threshold:
```bash
# More strict (fewer matches)
dart run best_localization:verify_translations similar assets/en.json --threshold 0.95

# More lenient (more matches)
dart run best_localization:verify_translations similar assets/en.json --threshold 0.7
```

### Large Translation Files

For very large files, consider:
- Breaking them into smaller modules
- Using the programmatic API for custom filtering
- Verifying specific subsets at a time

## Contributing

Found a bug or have a feature request? Please open an issue on [GitHub](https://github.com/dosty17/best_localization/issues).

## License

This package is licensed under the MIT License.
