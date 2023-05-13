part of 'extensions.dart';

extension StringHelper on String {
  String modify({
    CaseFormat? format,
    CaseType? type,
    String modifier = '',
  }) {
    if (isNotEmpty && format != null) {
      final isSentence = format == CaseFormat.sentence;
      var list = split(format.value);
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
      return this;
    }
  }

  String join(String sub) {
    return '$this$sub';
  }

  String max(int? length) => substring(0, length);

  String get expensiveLowercase => modify(type: CaseType.lowercase);

  String get expensiveVertical => modify(modifier: '\n');

  String get expensiveUppercase => modify(type: CaseType.uppercase);

  String get lowercase => toLowerCase();

  String get uppercase => toUpperCase();

  String get uppercaseByWord => modify(format: CaseFormat.word);

  String get uppercaseBySentence => modify(format: CaseFormat.sentence);
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
