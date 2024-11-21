import 'package:flutter/material.dart';

extension StringExtension on String? {
  String get use => this ?? "";

  bool get isValid => use.isNotEmpty;

  bool get isNotValid => !isValid;

  String get expensiveLowercase => modify(type: CaseType.lowercase);

  String get expensiveVertical => modify(modifier: '\n');

  String get expensiveUppercase => modify(type: CaseType.uppercase);

  String get lowercase => use.toLowerCase();

  String get uppercase => use.toUpperCase();

  String get uppercaseByWord => modify(format: CaseFormat.word);

  String get uppercaseBySentence => modify(format: CaseFormat.sentence);

  String? get cleanedText {
    if (this == null) return null;
    return this!
        .replaceAll(RegExp(r'\s*,\s*'), ', ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  List<String> get list => use
      .replaceAll(RegExp(r'\b(and|And|AND)\b', caseSensitive: false), ',')
      .replaceAll(RegExp(r'\s*,\s*'), ',')
      .replaceAll(RegExp(r'\s+'), ' ')
      .replaceAll(RegExp(r',+'), ',')
      .trim()
      .split(",");

  String modify({
    CaseFormat? format,
    CaseType? type,
    String modifier = '',
  }) {
    if (isValid && format != null) {
      final isSentence = format == CaseFormat.sentence;
      var list = use.split(format.value);
      var result = '';
      if (list.isNotEmpty) {
        for (int index = 0; index < list.length; index++) {
          final item = list[index];
          final target = item.isNotEmpty ? item.characters.first : '';
          final characters = item.characters.toList();
          if (characters.isNotEmpty) {
            var v = type != null
                ? type == CaseType.uppercase
                    ? target.toUpperCase()
                    : target.toLowerCase()
                : target;
            characters.removeAt(0);
            characters.insert(0, v);
            String value = '';
            for (String c in characters) {
              value = "$value$c";
            }

            if (index == list.length - 1) {
              result = '$result$value';
            } else {
              if (isSentence) {
                result = '$result$value. $modifier';
              } else {
                result = '$result$value $modifier';
              }
            }
          }
        }
      }
      return result;
    } else {
      return use;
    }
  }

  String join(String sub) => '$this$sub';

  String max(int? length) => use.substring(0, length);
}

enum CaseType {
  lowercase,
  uppercase;
}

enum CaseFormat {
  expensive(''),
  word(' '),
  sentence('. ');

  const CaseFormat(this.value);

  final String value;
}
