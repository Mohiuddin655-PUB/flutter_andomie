part of '../utils.dart';

class Validator {
  const Validator._();

  static bool equals(Object? value, Object? compareValue) =>
      value == compareValue;

  static bool isChecked(Object? checker, List<dynamic>? list) {
    return checker != null &&
        list != null &&
        list.isNotEmpty &&
        list.contains(checker);
  }

  static bool isMatched(Object? matcher, Object? value) {
    return Validator.isValidObject(matcher) &&
        matcher.toString() == value.toString();
  }

  static bool isMatchedList(List<String>? matchers, List<String>? values) {
    final booleans = <bool>[];
    matchers ??= [];
    values ??= [];
    final mLength = matchers.length;
    final vLength = values.length;
    if (mLength > 0 && mLength == vLength) {
      for (int index = 0; index < vLength; index++) {
        if (Validator.isMatched(matchers[index], values[index])) {
          booleans.add(true);
        }
      }
    }
    return booleans.length == vLength;
  }

  static bool isDigit(String? value) {
    return value != null && Patterns.numeric.hasMatch(value);
  }

  static bool isLetter(String? value) {
    return value != null && Patterns.letter.hasMatch(value);
  }

  static bool isNumeric(String? value) {
    return value != null && double.tryParse(value) != null;
  }

  static bool isValidDay(Object? day) {
    int current = Converter.toInt(day);
    return (current >= 1) && (current <= 31);
  }

  static bool isValidDigit(String? value) {
    return value != null &&
        value.isNotEmpty &&
        equals(value, Converter.toNumeric(value, true));
  }

  static bool isValidEmail(String? email, [RegExp? pattern]) {
    return email != null &&
        email.isNotEmpty &&
        (pattern ?? Patterns.email).hasMatch(email);
  }

  static bool isValidMonth(Object? month) {
    int current = Converter.toInt(month);
    return (current >= 1) && (current <= 12);
  }

  static bool isValidPath(String? path, [RegExp? pattern]) {
    return path != null &&
        path.isNotEmpty &&
        (pattern ?? Patterns.path).hasMatch(path);
  }

  static bool isValidPhone(String? phone, [RegExp? pattern]) {
    return phone != null &&
        phone.isNotEmpty &&
        (pattern ?? Patterns.phone).hasMatch(phone);
  }

  static bool isValidRetypePassword(String? password, String? retypePassword) {
    return isValidPassword(password) && equals(password, retypePassword);
  }

  static bool isValidPassword(
    String? password, {
    int minLength = 6,
    int maxLength = 20,
    RegExp? pattern,
  }) {
    return isValidString(
      password,
      minLength: minLength,
      maxLength: maxLength,
      pattern: pattern,
    );
  }

  static bool isValidUsername(
    String? username, {
    bool withDot = true,
    RegExp? pattern,
  }) {
    if (username != null && username.isNotEmpty) {
      if (withDot) {
        return (pattern ?? Patterns.usernameWithDot).hasMatch(username);
      } else {
        return (pattern ?? Patterns.username).hasMatch(username);
      }
    } else {
      return false;
    }
  }

  static bool isValidYear(Object? year, int requireAge) {
    int current = Converter.toInt(year);
    int currentYear = DateProvider.currentYear;
    return (current > 1900) &&
        (current < currentYear) &&
        ((currentYear - current) >= requireAge);
  }

  static bool isValidDigitWithLetter(String? value) {
    return value != null &&
        value.isNotEmpty &&
        equals(value, Converter.toDigitWithLetter(value));
  }

  static bool isValidDigitWithPlus(String? value) {
    return isValidString(value) &&
        equals(value, Converter.toDigitWithPlus(value));
  }

  static bool isValidLetter(String? value) {
    return value != null &&
        value.isNotEmpty &&
        equals(value, Converter.toLetter(value));
  }

  static bool isValidList(List? list) {
    return list != null && list.isNotEmpty;
  }

  static bool isValidSet(Set? list) {
    return list != null && list.isNotEmpty;
  }

  static bool isValidObject(Object? value) {
    return value != null;
  }

  static bool isInstance<T>(Object? value, T instance) {
    return value != null && value.runtimeType == instance.runtimeType;
  }

  static bool isValidString(
    String? value, {
    int maxLength = 0,
    int minLength = 0,
    RegExp? pattern,
  }) {
    bool a = value != null &&
        value.isNotEmpty &&
        !equals(value.toLowerCase(), 'null');
    bool b = maxLength <= 0 ? a : a && value.length <= maxLength;
    bool c = b && value.length >= minLength;
    bool d = pattern != null ? pattern.hasMatch(value ?? '') : c;
    return d;
  }

  static bool isValidStrings(
    List<String> values, {
    int maxLength = 0,
    int minLength = 0,
    RegExp? regs,
  }) {
    final list = values.where((value) {
      return isValidString(
        value,
        maxLength: maxLength,
        minLength: minLength,
        pattern: regs,
      );
    });
    return list.length == values.length;
  }

  static bool isValidWebURL(String? url) {
    return url != null && url.isNotEmpty && Patterns.url.hasMatch(url);
  }

  static bool isRank(double rating, double min) {
    return rating >= min;
  }
}

extension DoubleValidator on double {
  bool isRank(double min) => Validator.isRank(this, min);
}

extension ListValidator on List? {
  bool get isValidList => Validator.isValidList(this);
}

extension ObjectValidator on Object? {
  bool get isValidDay => Validator.isValidDay(this);

  bool get isValidMonth => Validator.isValidMonth(this);

  bool get isValidObject => Validator.isValidObject(this);

  bool equals(Object? other) => Validator.equals(this, other);

  bool isChecked(List<dynamic>? list) => Validator.isChecked(this, list);

  bool isMatched(Object other) => Validator.isMatched(this, other);

  bool isInstance<T>() => Validator.isInstance(this, T);

  bool isValidYear(int requireAge) => Validator.isValidYear(this, requireAge);
}

extension SetValidator on Set? {
  bool get isValidSet => Validator.isValidSet(this);
}

extension StringValidator on String? {
  bool get isDigit => Validator.isDigit(this);

  bool get isLetter => Validator.isLetter(this);

  bool get isNumeric => Validator.isNumeric(this);

  bool get isValidDigit => Validator.isValidDigit(this);

  bool get isValidDigitWithLetter => Validator.isValidDigitWithLetter(this);

  bool get isValidDigitWithPlus => Validator.isValidDigitWithPlus(this);

  bool get isValidLetter => Validator.isValidLetter(this);

  bool get isValidWebUrl => Validator.isValidWebURL(this);

  bool isValidEmail([RegExp? pattern]) => Validator.isValidEmail(this, pattern);

  bool isValidPath([RegExp? pattern]) => Validator.isValidPath(this, pattern);

  bool isValidPhone([RegExp? pattern]) => Validator.isValidPhone(this, pattern);

  bool isValidRetypePassword(String? other) {
    return Validator.isValidRetypePassword(this, other);
  }

  bool isValidPassword({
    int minLength = 6,
    int maxLength = 20,
    RegExp? pattern,
  }) {
    return Validator.isValidPassword(
      this,
      maxLength: maxLength,
      minLength: minLength,
      pattern: pattern,
    );
  }

  bool isValidString({
    int maxLength = 0,
    int minLength = 0,
    RegExp? pattern,
  }) {
    return Validator.isValidString(
      this,
      maxLength: maxLength,
      minLength: minLength,
      pattern: pattern,
    );
  }

  bool isValidUsername({bool withDot = true, RegExp? pattern}) {
    return Validator.isValidUsername(this, withDot: withDot, pattern: pattern);
  }
}

extension StringsValidator on List<String>? {
  bool isMatchedList(List<String>? matchers) {
    return Validator.isMatchedList(matchers, this);
  }

  bool isValidStrings({
    int maxLength = 0,
    int minLength = 0,
    RegExp? regs,
  }) {
    return Validator.isValidStrings(
      this ?? [],
      maxLength: maxLength,
      minLength: minLength,
      regs: regs,
    );
  }
}
