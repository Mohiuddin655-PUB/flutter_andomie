import 'dart:ui';

import '../contents/country_language_codes.dart';

final kLocales = kCountryLanguageCodes.entries.map((e) {
  return Locale(e.value.split("_").first, e.key);
});

final kFilteredLocales = kLocales.fold(<Locale>[], (a, b) {
  if (a.any((e) => b.languageCode == e.languageCode)) return a;
  return a..add(b);
});
