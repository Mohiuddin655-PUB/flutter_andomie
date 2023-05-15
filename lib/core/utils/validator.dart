import 'dart:core';

import '../index.dart';

class Validator {
  const Validator._();

  static bool equals(dynamic value, dynamic compareValue) {
    return value == compareValue;
  }

  static bool isMatched(Object matcher, Object value) {
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

  static bool isChecked(dynamic checker, List<dynamic>? list) {
    return Validator.isValidString(checker) &&
        Validator.isValidList(list) &&
        (list ?? []).contains(checker);
  }

  static bool isDigit(String? value) {
    return value != null && Regs.numeric.hasMatch(value);
  }

  static bool isLetter(String? value) {
    return value != null && Regs.letter.hasMatch(value);
  }

  static bool isNumeric(String? value) {
    return value != null && double.tryParse(value) != null;
  }

  static bool isValidPhone(String? phone) {
    return phone != null && phone.isNotEmpty && Regs.phone.hasMatch(phone);
  }

  static bool isValidEmail(String? email) {
    return email != null && email.isNotEmpty && Regs.email.hasMatch(email);
  }

  static bool isValidPassword(String? password, [int minLength = 6]) {
    return password != null &&
        password.isNotEmpty &&
        password.length >= minLength;
  }

  static bool isValidRetypePassword(String? password, String? retypePassword) {
    return isValidPassword(password) && equals(password, retypePassword);
  }

  static bool isValidList(List<dynamic>? list) {
    return list != null && list.isNotEmpty;
  }

  static bool isValidSet<T>(Set<dynamic>? list) {
    return list != null && list.isNotEmpty;
  }

  static bool isValidObject(dynamic value) {
    return value != null;
  }

  static bool isInstance<T>(dynamic value, T instance) {
    return value is T;
  }

  static bool isValidString(String? value, {int maxLength = 0, RegExp? regs}) {
    bool a = value != null &&
        value.isNotEmpty &&
        !equals(value.toLowerCase(), 'null');
    bool b = maxLength <= 0 ? a : a && value.length <= maxLength;
    bool c = regs != null ? regs.hasMatch(value ?? '') : b;
    return c;
  }

  static bool isValidStrings(List<String> values) {
    List<bool> list = [];
    for (String value in values) {
      if (Validator.isValidString(value)) {
        list.add(true);
      }
    }
    return list.length == values.length;
  }

  static bool isValidVerificationCode(String? code) {
    return code != null && code.isNotEmpty && code.length == 6;
  }

  static bool isValidWebURL(String? url) {
    return url != null && url.isNotEmpty && Regs.url.hasMatch(url);
  }

  static bool isRank(double rating, double min) {
    return rating >= min;
  }
}
