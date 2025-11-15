import 'dart:convert';
import 'package:flutter/foundation.dart';
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
  HttpLoader({
    required this.url,
    this.cacheEnabled = true,
    this.cacheDuration = const Duration(hours: 24),
    this.headers,
    String? cacheKey,
  }) : _cacheKey = cacheKey ?? 'best_localization_cache';

  @override
  Future<Map<String, Map<String, String>>> load() async {
    // Try to load from cache first
    if (cacheEnabled) {
      final cachedData = await _loadFromCache();
      if (cachedData != null) {
        if (kDebugMode) {
          print('BestLocalization: Loaded translations from cache');
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

      if (kDebugMode) {
        print('BestLocalization: Loaded translations from remote');
      }

      return data;
    } catch (e) {
      if (kDebugMode) {
        print('BestLocalization: Error loading from remote: $e');
      }

      // Try to load from cache as fallback even if expired
      if (cacheEnabled) {
        final cachedData = await _loadFromCache(ignoreExpiration: true);
        if (cachedData != null) {
          if (kDebugMode) {
            print('BestLocalization: Using expired cache as fallback');
          }
          return cachedData;
        }
      }

      rethrow;
    }
  }

  /// Fetches translations from the remote URL.
  Future<Map<String, Map<String, String>>> _fetchFromRemote() async {
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
  Map<String, Map<String, String>> _parseTranslations(
      Map<String, dynamic> jsonMap) {
    final Map<String, Map<String, String>> translations = {};

    jsonMap.forEach((languageCode, translationsMap) {
      if (translationsMap is Map) {
        translations[languageCode] = Map<String, String>.from(
          translationsMap.map(
            (key, value) => MapEntry(key.toString(), value.toString()),
          ),
        );
      }
    });

    return translations;
  }

  /// Loads translations from local cache.
  Future<Map<String, Map<String, String>>?> _loadFromCache({
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
      if (kDebugMode) {
        print('BestLocalization: Error loading from cache: $e');
      }
      return null;
    }
  }

  /// Saves translations to local cache.
  Future<void> _saveToCache(Map<String, Map<String, String>> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = json.encode(data);

      await prefs.setString(_cacheKey, jsonString);
      await prefs.setInt(
          '${_cacheKey}_time', DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      if (kDebugMode) {
        print('BestLocalization: Error saving to cache: $e');
      }
    }
  }

  /// Clears the cached translations.
  ///
  /// Call this to force a fresh fetch from the remote server.
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cacheKey);
      await prefs.remove('${_cacheKey}_time');
    } catch (e) {
      if (kDebugMode) {
        print('BestLocalization: Error clearing cache: $e');
      }
    }
  }
}
