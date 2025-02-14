import '../contents/language_numerical_digits.dart';
import '../contents/rtl_directional_languages.dart';

enum TranslateType { number }

class Translator {
  String? _language;
  List<String> _rtlLanguages = kRtlTextDirectionalLanguages;
  Map<String, String> _digits = kLanguageNumericalDigits;

  Translator._();

  static Translator? _i;

  static Translator get _ii => _i ??= Translator._();

  static set language(String? value) => _ii._language = value;

  static set rtlLanguages(List<String> value) => _ii._rtlLanguages = value;

  static set digits(Map<String, String> value) => _ii._digits = value;

  static bool isRtlMode([String? language]) {
    language ??= _ii._language;
    return _ii._rtlLanguages.contains(language);
  }

  static String translate(
    String value, {
    String? language,
    TranslateType type = TranslateType.number,
  }) {
    language ??= _ii._language ?? 'en';
    final raw = _ii._digits[language] ?? '';
    if (raw.isEmpty) return value;
    final codes = raw.split('');
    final numbers = value.split('');
    final converted = numbers.map((number) {
      final index = int.tryParse(number);
      if (index == null) return number;
      final code = codes.elementAtOrNull(index);
      if (code == null) return number;
      return code;
    });
    if (isRtlMode(language)) {
      return converted.toList().reversed.toList().join('');
    }
    return converted.join('');
  }
}

extension TranslatorHelper on String? {
  String? get trNumber => translate(type: TranslateType.number);

  String? translate({
    String? language,
    TranslateType type = TranslateType.number,
  }) {
    if (this == null) return null;
    return Translator.translate(
      this!,
      language: language,
      type: type,
    );
  }
}
