import '../contents/country_codes_in_iso3.dart';
import '../contents/country_currency_codes.dart';
import '../contents/country_currency_names_in_english.dart';
import '../contents/country_currency_names_in_native.dart';
import '../contents/country_currency_symbols.dart';
import '../contents/country_flags.dart';
import '../contents/country_language_codes.dart';
import '../contents/country_names_in_english.dart';
import '../contents/country_names_in_native.dart';
import '../contents/country_nationalities_in_english.dart';
import '../contents/country_nationalities_in_native.dart';
import '../contents/country_phone_codes.dart';
import '../contents/language_names_in_english.dart';
import '../contents/language_names_in_native.dart';
import '../contents/language_numerical_digits.dart';

final kCountries = kCountryNamesInEnglish.keys.map(Country.fromCode);

class Country {
  final String code;
  final String? codeInIso3;
  final String? currencyCode;
  final String? currencyName;
  final String? currencyNameInNative;
  final String? currencySymbol;
  final String? flag;
  final String? languageCode;
  final String? languageName;
  final String? languageNameInNative;
  final String? languageNumericalDigits;
  final String? name;
  final String? nameInNative;
  final String? nationality;
  final String? nationalityInNative;
  final String? phoneCode;

  const Country._(
    this.code, {
    this.codeInIso3,
    this.currencyCode,
    this.currencyName,
    this.currencyNameInNative,
    this.currencySymbol,
    this.flag,
    this.languageCode,
    this.languageName,
    this.languageNameInNative,
    this.languageNumericalDigits,
    this.name,
    this.nameInNative,
    this.nationality,
    this.nationalityInNative,
    this.phoneCode,
  });

  factory Country.fromCode(String code, [String? languageCode]) {
    code = code.toUpperCase();
    languageCode ??= kCountryLanguageCodes[code];
    languageCode = languageCode?.toLowerCase();
    if (["CN", "TW"].contains(code)) {
      languageCode = "zh_$code";
    }

    return Country._(
      code,
      codeInIso3: kCountryCodesInIso3[code],
      currencyCode: kCountryCurrencyCodes[code],
      currencyName: kCountryCurrencyNamesInEnglish[code],
      currencyNameInNative: kCountryCurrencyNamesInNative[code],
      currencySymbol: kCountryCurrencySymbols[code],
      flag: kCountryFlags[code],
      languageCode: languageCode,
      languageName: kLanguageNamesInEnglish[languageCode],
      languageNameInNative: kLanguageNamesInNative[languageCode],
      languageNumericalDigits: kLanguageNumericalDigits[languageCode],
      name: kCountryNamesInEnglish[code],
      nameInNative: kCountryNamesInNative[code],
      nationality: kCountryNationalitiesInEnglish[code],
      nationalityInNative: kCountryNationalitiesInNative[code],
      phoneCode: kCountryPhoneCodes[code],
    );
  }

  static Country? tryParse(String locale) {
    if (locale.trim().isEmpty) return null;
    List<String> codes = [];
    if (locale.contains("_")) {
      codes = locale.split("_");
    } else if (locale.contains("-")) {
      codes = locale.split("-");
    }
    if (codes.length != 2) return null;
    String lc = codes.elementAt(0);
    String cc = codes.elementAt(1);
    return Country.fromCode(cc, lc);
  }

  String get locale => "${languageCode}_$code";

  bool searchCountry(String query) {
    if (query.startsWith("+")) query = query.replaceAll("+", "").trim();
    final name = this.name ?? "";
    return code.toLowerCase().startsWith(query.toLowerCase()) ||
        name.toLowerCase().startsWith(query.toLowerCase());
  }

  bool searchCurrency(String query) {
    if (query.startsWith("+")) query = query.replaceAll("+", "").trim();
    final currencyCode = this.currencyCode ?? "";
    final currencyName = this.currencyName ?? "";
    return currencyCode.toLowerCase().startsWith(query.toLowerCase()) ||
        currencyName.toLowerCase().startsWith(query.toLowerCase());
  }

  bool searchLanguage(String query) {
    if (query.startsWith("+")) query = query.replaceAll("+", "").trim();
    final languageCode = this.languageCode ?? "";
    final languageName = this.languageName ?? "";
    final name = this.name ?? "";
    return languageCode.toLowerCase().startsWith(query.toLowerCase()) ||
        languageName.toLowerCase().startsWith(query.toLowerCase()) ||
        name.toLowerCase().startsWith(query.toLowerCase());
  }

  bool searchPhone(String query) {
    if (query.startsWith("+")) query = query.replaceAll("+", "").trim();
    final phoneCode = this.phoneCode ?? "";
    final name = this.name ?? "";
    return phoneCode.toLowerCase().startsWith(query.toLowerCase()) ||
        code.toLowerCase().startsWith(query.toLowerCase()) ||
        name.toLowerCase().startsWith(query.toLowerCase());
  }

  Map<String, dynamic> get source {
    return {
      "code": code,
      "codeInIso3": codeInIso3,
      "currencyCode": currencyCode,
      "currencyName": currencyName,
      "currencyNameInNative": currencyNameInNative,
      "currencySymbol": currencySymbol,
      "flag": flag,
      "languageCode": languageCode,
      "languageName": languageName,
      "languageNameInNative": languageNameInNative,
      "languageNumericalDigits": languageNumericalDigits,
      "name": name,
      "nameInNative": nameInNative,
      "nationality": nationality,
      "nationalityInNative": nationalityInNative,
      "phoneCode": phoneCode,
    };
  }

  @override
  int get hashCode => source.hashCode;

  @override
  bool operator ==(Object other) => other is Country && other.source == source;

  @override
  String toString() => "$Country($source)";
}
