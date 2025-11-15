/// Abstract base class for all translation loaders.
///
/// Implement this class to create custom loaders for different file formats.
abstract class TranslationLoader {
  /// Loads translations from a source.
  ///
  /// Returns a map where:
  /// - Key: language code (e.g., 'en', 'ku', 'ar')
  /// - Value: Map of translation keys and their values
  ///
  /// Example:
  /// ```dart
  /// {
  ///   'en': {'hello': 'Hello', 'world': 'World'},
  ///   'ku': {'hello': 'سڵاو', 'world': 'جیهان'}
  /// }
  /// ```
  Future<Map<String, Map<String, String>>> load();
}
