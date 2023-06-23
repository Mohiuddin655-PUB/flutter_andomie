part of 'models.dart';

class LanguageInfo {
  String? _code;
  String? _iso;
  String? _name;

  String get code => _code ?? '';

  String get iso => _iso ?? '';

  String get name => _name ?? '';

  set code(String value) => _code = value;

  set name(String value) => _name = value;

  set iso(String value) => _iso = value;
}
