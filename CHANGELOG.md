# Changelog

All notable changes to this project will be documented in this file.
## [1.0.2] - 2025-11-15
- Enhance readme.md
- Some changes

## [1.0.0] - 2025-11-15

### 🎉 Major Release - New Features

#### Added
- **Multiple File Format Support** 🎉
  - JSON Loader: Load translations from JSON files (single or multiple files)
  - CSV Loader: Load translations from CSV files (columns or rows format)
  - YAML Loader: Load translations from YAML files
  - XML Loader: Load translations from XML files
  - HTTP Loader: Load translations from remote API with caching support

- **Remote Translations** 🎉
  - `HttpLoader` class for fetching translations from API
  - Automatic caching with `shared_preferences`
  - Configurable cache duration (default: 24 hours)
  - Custom HTTP headers support (for authentication)
  - Offline fallback using expired cache
  - Works seamlessly with `Loaders.remote()`

- **Fallback Locale Support** 🎉
  - Added `fallbackLocale` parameter to `BestLocalizationDelegate`
  - Automatic fallback to default language when translation is missing
  - Works with all loader types (JSON, CSV, YAML, XML, HTTP, Map)
  - Better UX for incomplete translations

- **Loaders Class** 🎉
  - Easy-to-use static methods for all loaders
  - `Loaders.json()` - Load from JSON files
  - `Loaders.csv()` - Load from CSV files
  - `Loaders.yaml()` - Load from YAML files
  - `Loaders.xml()` - Load from XML files
  - `Loaders.remote()` - Load from remote API
  - `Loaders.jsonString()` - Load from JSON string
  - `Loaders.csvString()` - Load from CSV string

- **Factory Methods**
  - `BestLocalizationDelegate.fromJson()` - Create delegate from JSON loader
  - `BestLocalizationDelegate.fromCsv()` - Create delegate from CSV loader
  - `BestLocalizationDelegate.fromYaml()` - Create delegate from YAML loader
  - `BestLocalizationDelegate.fromXml()` - Create delegate from XML loader
  - `BestLocalizationDelegate.fromHttp()` - Create delegate from HTTP loader
  - `BestLocalizationDelegate.fromMap()` - Create delegate from map
  - `BestLocalizationDelegate.fromLoader()` - Create delegate from any loader

- **BuildContext Extensions**
  - `context.tr()` - Translate with optional arguments
  - `context.localization` - Get BestLocalization instance
  - `context.currentLocale` - Get current locale
  - `context.languageCode` - Get language code
  - `context.isKurdish` - Check if Kurdish
  - `context.isArabic` - Check if Arabic
  - `context.isEnglish` - Check if English
  - `context.isRTL` - Check if RTL language
  - `context.textDirection` - Get text direction

### Changed
- Updated package dependencies to use flexible version ranges
- Enhanced Kurdish Cupertino localizations with missing properties
- Improved code organization with separate loader files

### Fixed
- Fixed missing implementations in `KurdishCupertinoLocalizations`
- Resolved compatibility issues with different Flutter versions


## [0.0.4] - 2025-06-05

### upate

- update intl to 0.20.2

### fix issues

- cupertino localization error

## [0.0.3] - 2025-03-21

### added

- enhancement

## [0.0.2] - 2024-12-26

### added

- add flutter_localizations installation

## [0.0.1] - 2024-12-25

### Added

- Initial release of `best_localization` package.
- Support for dynamic translations using Dart maps.
- Interpolation for dynamic placeholders (e.g., `Hello, {name}!`).
- Pluralization for managing singular and plural text forms.
- Kurdish (`ku`) localization for Material and Cupertino widgets.
- Seamless integration with Flutter's localization system via `BestLocalizationDelegate`.
- Example implementations for both Material and Cupertino apps.
- Comprehensive date and number formatting for Kurdish using `intl`.

### Fixed

- N/A (First release)

### Changed

- N/A (First release)
