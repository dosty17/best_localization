import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'translation_loader.dart';

/// Loads translations from a remote HTTP endpoint.
///
/// Supports caching translations locally to improve performance and enable offline access.
///
/// Example:
/// ```dart
/// HttpLoader(
///   url: 'https://api.example.com/translations',
///   cacheEnabled: true,
///   cacheDuration: Duration(hours: 24),
/// )
/// ```
class HttpLoader extends TranslationLoader {
  /// The URL to fetch translations from.
  ///
  /// The endpoint should return JSON in the format:
  /// ```json
  /// {
  ///   "en": {"hello": "Hello", "world": "World"},
  ///   "ku": {"hello": "سڵاو", "world": "جیهان"}
  /// }
  /// ```
  final String url;

  /// Whether to cache translations locally.
  ///
  /// Default: `true`
  final bool cacheEnabled;

  /// How long cached translations remain valid.
  ///
  /// Default: 24 hours
  final Duration cacheDuration;

  /// Custom HTTP headers to include in the request.
  ///
  /// Example:
  /// ```dart
  /// headers: {
  ///   'Authorization': 'Bearer token',
  ///   'Accept-Language': 'en',
  /// }
  /// ```
  final Map<String, String>? headers;

  /// The cache key used to store translations.
  final String _cacheKey;

  /// Creates an HTTP loader.
  ///
  /// [url]: The endpoint URL
  /// [cacheEnabled]: Enable local caching (default: true)
  /// [cacheDuration]: Cache validity duration (default: 24 hours)
  /// [headers]: Custom HTTP headers
  /// [cacheKey]: Custom cache key (default: 'best_localization_cache')
  ///
  /// What is cacheEnabled?
  /// - If true, translations will be cached locally using SharedPreferences.
  /// - If false, translations will be fetched from the remote server on each load.
  ///
  /// What is cacheDuration?
  /// - The duration for which cached translations are considered valid.
  /// - After this duration, the loader will attempt to refresh translations from the server.
  HttpLoader({
    required this.url,
    this.cacheEnabled = false,
    this.cacheDuration = const Duration(hours: 24),
    this.headers,
    String? cacheKey,
  }) : _cacheKey = cacheKey ?? 'best_localization_cache';

  @override
  Future<Map<String, Map<String, Object>>> load() async {
    // Try to load from cache first
    if (cacheEnabled) {
      final cachedData = await _loadFromCache();
      if (cachedData != null) {
        // Check if cache is expired, refresh in background
        if (await _isCacheExpired()) {
          // Refresh cache in background without blocking
          _refreshCache();
        }

        return cachedData;
      }
    }

    // Fetch from remote
    try {
      final data = await _fetchFromRemote();

      // Save to cache
      if (cacheEnabled) {
        await _saveToCache(data);
      }

      return data;
    } catch (e) {
      // Try to load from cache as fallback even if expired
      if (cacheEnabled) {
        final cachedData = await _loadFromCache(ignoreExpiration: true);
        if (cachedData != null) {
          return cachedData;
        }
      }

      rethrow;
    }
  }

  /// Checks if the cache has expired.
  Future<bool> _isCacheExpired() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheTime = prefs.getInt('${_cacheKey}_time');
      if (cacheTime == null) return true;

      final cacheDate = DateTime.fromMillisecondsSinceEpoch(cacheTime);
      final now = DateTime.now();

      return now.difference(cacheDate) > cacheDuration;
    } catch (e) {
      return true;
    }
  }

  /// Refreshes the cache in the background.
  Future<void> _refreshCache() async {
    try {
      final data = await _fetchFromRemote();
      await _saveToCache(data);
    } catch (_) {}
  }

  /// Fetches translations from the remote URL.
  Future<Map<String, Map<String, Object>>> _fetchFromRemote() async {
    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      return _parseTranslations(jsonMap);
    } else {
      throw Exception(
        'Failed to load translations: ${response.statusCode} ${response.reasonPhrase}',
      );
    }
  }

  /// Parses JSON response into translations map.
  Map<String, Map<String, Object>> _parseTranslations(
      Map<String, dynamic> jsonMap) {
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

  /// Loads translations from local cache.
  Future<Map<String, Map<String, Object>>?> _loadFromCache({
    bool ignoreExpiration = false,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Check if cache exists
      final cachedJson = prefs.getString(_cacheKey);
      if (cachedJson == null) return null;

      // Check expiration
      if (!ignoreExpiration) {
        final cacheTime = prefs.getInt('${_cacheKey}_time');
        if (cacheTime == null) return null;

        final cacheDate = DateTime.fromMillisecondsSinceEpoch(cacheTime);
        final now = DateTime.now();

        if (now.difference(cacheDate) > cacheDuration) {
          // Cache expired
          return null;
        }
      }

      // Parse cached data
      final Map<String, dynamic> jsonMap = json.decode(cachedJson);
      return _parseTranslations(jsonMap);
    } catch (e) {
      return null;
    }
  }

  /// Saves translations to local cache.
  Future<void> _saveToCache(Map<String, Map<String, Object>> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = json.encode(data);

      await prefs.setString(_cacheKey, jsonString);
      await prefs.setInt(
          '${_cacheKey}_time', DateTime.now().millisecondsSinceEpoch);
    } catch (_) {}
  }

  /// Clears the cached translations.
  ///
  /// Call this to force a fresh fetch from the remote server.
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cacheKey);
      await prefs.remove('${_cacheKey}_time');
    } catch (_) {}
  }
}
