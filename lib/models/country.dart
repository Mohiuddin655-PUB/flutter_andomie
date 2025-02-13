import 'dart:convert';

import '../contents/countries.dart';

class Country {
  final String name;
  final String nameNatively;
  final String isoCode;
  final String iso3Code;
  final String phoneCode;
  final String currencyCode;
  final String currencyName;
  final String currencyNameNatively;
  final String currencySymbol;
  final String languageCode;
  final String languageName;
  final String languageNameNatively;
  final List<String> languages;
  final String digits;
  final double gdp;
  final double population;
  final double wealthiest;
  final String flag;

  const Country({
    this.name = "",
    this.nameNatively = "",
    this.flag = "",
    this.isoCode = "",
    this.iso3Code = "",
    this.phoneCode = "",
    this.currencyCode = "",
    this.currencyName = "",
    this.currencyNameNatively = "",
    this.currencySymbol = "",
    this.languageCode = "",
    this.languageName = "",
    this.languageNameNatively = "",
    this.languages = const [],
    this.digits = "",
    this.gdp = 0,
    this.population = 0,
    this.wealthiest = 0,
  });

  String get locale => "${languageCode}_$isoCode";

  static Country? from(Object? source) {
    if (source is String) {
      if (source.startsWith("{")) {
        source = jsonDecode(source);
      } else {
        return kCountries.map(Country.from).where((e) {
          return e?.locale == source ||
              e?.isoCode == source ||
              e?.languageCode == source ||
              e?.iso3Code == source ||
              e?.currencyCode == source ||
              e?.name == source ||
              e?.languageName == source ||
              e?.currencyName == source ||
              e?.phoneCode == source ||
              e?.currencyNameNatively == source ||
              e?.currencySymbol == source ||
              e?.flag == source ||
              e?.languageNameNatively == source ||
              e?.nameNatively == source;
        }).firstOrNull;
      }
    }
    if (source is! Map) return null;
    final name =
        source['name'] ?? source["countryName"] ?? source["country_name"];

    final nameNatively = source['nameNatively'] ??
        source["name_natively"] ??
        source["country_name_native"];

    final flag = source['flag'];

    final isoCode = source['isoCode'] ??
        source['iso_code'] ??
        source["countryCode"] ??
        source["country_code"];

    final iso3Code = source['iso3Code'] ??
        source['iso3_code'] ??
        source["countryCodeIso3"] ??
        source["country_code_iso3"];

    final phoneCode = source['phoneCode'] ?? source['phone_code'];

    final currencyCode =
        source['currency'] ?? source['currencyCode'] ?? source['currency_code'];

    final currencyName = source['currencyName'] ?? source['currency_name'];

    final currencyNameNatively = source['currencyNameNatively'] ??
        source['currency_name_native'] ??
        source['currency_name_natively'];

    final currencySymbol =
        source['currencySymbol'] ?? source['currency_symbol'];

    final languageCode =
        source["language"] ?? source['languageCode'] ?? source['language_code'];

    final languageName = source['languageName'] ?? source['language_name'];

    final languageNameNatively = source['languageNameNatively'] ??
        source['language_name_natively'] ??
        source['language_name_native'];

    final digits =
        source['digits'] ?? source['country_digits'] ?? source['countryDigits'];

    final gdp = source['gdp'] ?? source['country_gdp'] ?? source['countryGdp'];

    final languages = source['languages'] ??
        source['sub_languages'] ??
        source['subLanguages'];

    final wealthiest = source['wealthiest'] ??
        source['country_wealthiest'] ??
        source['countryWealthiest'];

    final population = source['population'] ??
        source['country_population'] ??
        source['countryPopulation'];

    return Country(
      name: name is String ? name : "",
      nameNatively: nameNatively is String ? nameNatively : "",
      flag: flag is String ? flag : "",
      isoCode: isoCode is String ? isoCode : '',
      iso3Code: iso3Code is String ? iso3Code : '',
      phoneCode: phoneCode is String ? phoneCode : '',
      currencyCode: currencyCode is String ? currencyCode : '',
      currencyName: currencyName is String ? currencyName : '',
      currencyNameNatively:
          currencyNameNatively is String ? currencyNameNatively : '',
      currencySymbol: currencySymbol is String ? currencySymbol : '',
      languageCode: languageCode is String ? languageCode : '',
      languageName: languageName is String ? languageName : '',
      languageNameNatively:
          languageNameNatively is String ? languageNameNatively : '',
      digits: digits is String ? digits : "",
      gdp: gdp is double ? gdp : 0,
      languages:
          languages is List ? languages.map((e) => e.toString()).toList() : [],
      wealthiest: wealthiest is double ? wealthiest : 0,
      population: population is double ? population : 0,
    );
  }

  bool searchCountry(String query) {
    if (query.startsWith("+")) query = query.replaceAll("+", "").trim();
    return isoCode.toLowerCase().startsWith(query.toLowerCase()) ||
        name.toLowerCase().startsWith(query.toLowerCase());
  }

  bool searchCurrency(String query) {
    if (query.startsWith("+")) query = query.replaceAll("+", "").trim();
    return currencyCode.toLowerCase().startsWith(query.toLowerCase()) ||
        currencyName.toLowerCase().startsWith(query.toLowerCase());
  }

  bool searchLanguage(String query) {
    if (query.startsWith("+")) query = query.replaceAll("+", "").trim();
    return languageCode.toLowerCase().startsWith(query.toLowerCase()) ||
        languageName.toLowerCase().startsWith(query.toLowerCase()) ||
        name.toLowerCase().startsWith(query.toLowerCase());
  }

  bool searchPhone(String query) {
    if (query.startsWith("+")) query = query.replaceAll("+", "").trim();
    return phoneCode.toLowerCase().startsWith(query.toLowerCase()) ||
        isoCode.toLowerCase().startsWith(query.toLowerCase()) ||
        name.toLowerCase().startsWith(query.toLowerCase());
  }

  Map<String, dynamic> get source {
    return {
      "name": name,
      "nameNatively": nameNatively,
      "isoCode": isoCode,
      "iso3Code": iso3Code,
      "phoneCode": phoneCode,
      "currencyCode": currencyCode,
      "currencyName": currencyName,
      "currencyNameNatively": currencyNameNatively,
      "currencySymbol": currencySymbol,
      "languageCode": languageCode,
      "languageName": languageName,
      "languageNameNatively": languageNameNatively,
      "flag": flag,
      "digits": digits,
      "gdp": gdp,
      "languages": languages,
      "wealthiest": wealthiest,
      "population": population,
    };
  }

  String get json => jsonEncode(source);

  @override
  int get hashCode => json.hashCode;

  @override
  bool operator ==(Object other) => other is Country && other.json == json;

  @override
  String toString() => '$Country('
      'name:"$name",nameNatively:"$nameNatively",'
      'isoCode:"$isoCode",iso3Code:"$iso3Code",'
      'phoneCode:"$phoneCode",'
      'currencyCode:"$currencyCode",currencyName:"$currencyName",currencyNameNatively:"$currencyNameNatively",currencySymbol:"${currencySymbol.replaceAll("\$", '\\' '\$')}",'
      'languageCode:"$languageCode",languageName:"$languageName",languageNameNatively:"$languageNameNatively", languages: ${languages.map((e) => '"$e"').toList()},'
      'digits: "$digits",'
      'gdp: $gdp,'
      'population: $population,'
      'wealthiest: $wealthiest,'
      'flag:"$flag",'
      ')';
}
