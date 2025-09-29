import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';

abstract class TranslatorDelegate {
  Future<String> translate(String source, Locale locale);

  Future<String?> cache() async => null;

  void translated(String key, String value) {}

  void save(String value) {}
}

class Translator extends ChangeNotifier {
  Translator({
    TranslatorDelegate? delegate,
    required Locale defaultLocale,
    required Locale fallbackLocale,
  })  : _delegate = delegate,
        _currentLocale = defaultLocale,
        _fallbackLanguage = fallbackLocale {
    if (delegate != null) {
      delegate.cache().then((source) {
        if (source == null || source.isEmpty) return {};
        final x = jsonDecode(source);
        if (x is! Map) return {};
        final entries = x.entries.map((e) {
          final key = e.key;
          final value = e.value;
          if (value is! Map || key is! String) return null;
          final entries = value.entries.map((e) {
            final key = e.key;
            final value = e.value;
            if (value is! String || key is! String) return null;
            return MapEntry(key, value);
          }).whereType<MapEntry<String, String>>();
          return MapEntry<String, Map<String, String>>(
              key, Map.fromEntries(entries));
        }).whereType<MapEntry<String, Map<String, String>>>();
        final cache = Map.fromEntries(entries);
        _cache.addAll(cache);
        notifyListeners();
      });
    }
  }

  final TranslatorDelegate? _delegate;
  final Locale _fallbackLanguage;
  Locale _currentLocale = Locale("en", "US");

  final Map<String, Map<String, String>> _cache = {};

  static Translator? _i;

  static Translator get i => _i!;

  static void init({
    required Locale defaultLocale,
    required Locale fallbackLocale,
    required TranslatorDelegate translator,
  }) {
    _i = Translator(
      defaultLocale: defaultLocale,
      fallbackLocale: fallbackLocale,
      delegate: translator,
    );
  }

  set locale(Locale locale) => _currentLocale = locale;

  final Map<String, Future<String>> _pendingTranslations = {};

  void _translateInBackground(String key, Locale locale) {
    if (key.isEmpty || _delegate == null) return;

    final cacheKey = '${locale.toString()}::$key';
    if (_pendingTranslations.containsKey(cacheKey)) return;

    final translationFuture =
        _delegate!.translate(key, locale).then((translated) {
      if (translated.isEmpty || translated == key) return key;

      final localeCache = _cache[locale.toString()] ?? {};
      _cache[locale.toString()] = {...localeCache, key: translated};

      notifyListeners();
      _delegate!.translated(key, translated);

      return translated;
    }).whenComplete(() {
      _pendingTranslations.remove(cacheKey);
    });

    _pendingTranslations[cacheKey] = translationFuture;
  }

  String tr(String key, [Locale? locale]) {
    locale ??= _currentLocale;
    final localeCache = _cache[locale.toString()] ?? {};
    if (localeCache.containsKey(key)) return localeCache[key] ?? key;
    if (_fallbackLanguage != locale) _cache[locale.toString()] = localeCache;
    _translateInBackground(key, locale);
    return key;
  }

  @override
  void dispose() {
    if (_delegate != null) _delegate!.save(jsonEncode(_cache));
    super.dispose();
  }
}
