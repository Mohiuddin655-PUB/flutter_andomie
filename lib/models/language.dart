import 'dart:ui';

import '../contents/language_names_in_english.dart';
import '../contents/language_names_in_native.dart';
import '../contents/language_numerical_digits.dart';

final kLanguages = kLanguageNamesInEnglish.keys.map(Language.fromCode);

class Language {
  final String code;
  final String? countryCode;
  final String? digits;
  final String? name;
  final String? nameInNative;

  const Language._(
    this.code, {
    this.countryCode,
    this.digits,
    this.name,
    this.nameInNative,
  });

  factory Language.fromCode(String code, [String? countryCode]) {
    if (code.startsWith("zh")) {
      countryCode ??= code.split("_").elementAtOrNull(1);
      countryCode = countryCode?.toUpperCase();
      countryCode = ["CN", "TW"].contains(countryCode) ? countryCode : "CN";
      code = "${code}_$countryCode";
    }

    return Language._(
      code,
      countryCode: countryCode,
      digits: kDigits[code] ?? kLanguageDefaultNumericalDigits,
      name: kLanguageNamesInEnglish[code],
      nameInNative: kLanguageNamesInNative[code],
    );
  }

  static Language? tryParse(String locale) {
    if (locale.trim().isEmpty) return null;
    List<String> codes = [locale];
    if (locale.contains("_")) {
      codes = locale.split("_");
    } else if (locale.contains("-")) {
      codes = locale.split("-");
    }
    if (codes.isEmpty) return null;
    final lc = codes.first;
    final cc = codes.length == 2 ? codes.last : null;
    return Language.fromCode(lc, cc);
  }

  String get locale => "${code}_$countryCode";

  bool search(String query) {
    final name = this.name ?? "";
    final nameInNative = this.nameInNative ?? "";
    final countryCode = this.countryCode ?? "";
    return code.toLowerCase().startsWith(query.toLowerCase()) ||
        name.toLowerCase().startsWith(query.toLowerCase()) ||
        nameInNative.toLowerCase().startsWith(query.toLowerCase()) ||
        countryCode.toLowerCase().startsWith(query.toLowerCase());
  }

  Map<String, dynamic> get source {
    return {
      "code": code,
      "countryCode": countryCode,
      "digits": digits,
      "name": name,
      "nameInNative": nameInNative,
    };
  }

  @override
  int get hashCode => source.hashCode;

  @override
  bool operator ==(Object other) => other is Language && other.source == source;

  @override
  String toString() => "$Language($source)";
}

extension LanguageHelper on Locale {
  Language get language => Language.fromCode(languageCode, countryCode);

  String? get name => language.name;

  String? get nativeName => language.nameInNative;
}
