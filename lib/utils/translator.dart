import 'package:flutter/foundation.dart';

typedef TranslatorHandler = Future<String?>? Function(
  String text,
  String locale,
);

class Translator extends ChangeNotifier {
  Translator({
    TranslatorHandler? handler,
    required String defaultLanguage,
  });

  TranslatorHandler? _translator;
  String _currentLanguage = '';

  final Map<String, Map<String, String>> _cache = {};

  static Translator? _i;

  static Translator get i => _i!;

  static void init({
    required String defaultLanguage,
    required TranslatorHandler translator,
  }) {
    _i = Translator(defaultLanguage: defaultLanguage, handler: translator);
  }

  void setLanguage(String locale) => _currentLanguage = locale;

  void _translateInBackground(String key, String locale) {
    if (key.isEmpty || locale.isEmpty || _translator == null) return;
    try {
      _translator!(key, locale)?.then((translated) {
        if (translated == null || translated.isEmpty) return;
        final localeCache = _cache[locale] ?? {};
        _cache[locale] = {...localeCache, key: translated};
        notifyListeners();
      });
    } catch (_) {}
  }

  String tr(String key) {
    final localeCache = _cache[_currentLanguage] ?? {};
    if (localeCache.containsKey(key)) return localeCache[key] ?? key;
    _cache[_currentLanguage] = {...localeCache, key: key};
    _translateInBackground(key, _currentLanguage);
    return key;
  }
}
