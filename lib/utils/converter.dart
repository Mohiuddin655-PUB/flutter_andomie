import 'package:flutter/material.dart';

import '../extensions/string.dart';
import 'number.dart';
import 'replacement.dart';
import 'validator.dart';

/// A utility class for various conversion operations.
/// Provides methods for modifying and converting values.
class Converter {
  const Converter._();

  /// Modifies a value (placeholder function).
  static String? modify(
    String? value, {
    CaseFormat? format,
    CaseType? type,
    String modifier = '',
  }) {
    return value.modify(modifier: modifier, type: type, format: format);
  }

  /// Converts a list of strings to a formatted string.
  ///
  /// Example: ['one', 'two', 'three'] -> 'one, two, and three'
  static String? asString(Iterable<String>? iterable) {
    if (iterable == null || iterable.isEmpty) return null;
    int size = iterable.length;
    int end = size - 1;
    int and = size - 2;
    String buffer = '';
    for (int index = 0; index < size; index++) {
      if (index == and) {
        buffer = '$buffer${iterable.elementAt(index)} and ';
      } else if (index == end) {
        buffer = '$buffer${iterable.elementAt(index)}';
      } else {
        buffer = '$buffer${iterable.elementAt(index)}, ';
      }
    }
    if (buffer.isEmpty) return null;
    return buffer;
  }

  static List<String>? asList(
    String? source, [
    List<String> replacements = const [" and ", " And ", " & "],
  ]) {
    if (source == null || source.isEmpty) return null;
    final replacedData = Replacement.single(source, ',', replacements);
    final data = replacedData.split(",");
    final filtered = data.where((e) => e.isNotEmpty).toList();
    if (filtered.isEmpty) return null;
    return filtered;
  }

  /// Converts a list to a counting number.
  ///
  /// Example: [1, 2, 3] -> 3
  static int toCountingNumber(Iterable? iterable) {
    return iterable != null && iterable.isNotEmpty ? iterable.length : 0;
  }

  /// Converts current and total values to a counting state string.
  ///
  /// Example: (2, 5) -> '2/5'
  static String toCountingState(
    int current,
    int total, [
    String separator = "/",
  ]) {
    return "$current$separator$total";
  }

  /// Converts a list to a counting text.
  ///
  /// Example: [1, 2, 3] -> '3'
  static String toCountingText(Iterable? iterable) {
    return iterable != null && iterable.isNotEmpty ? "${iterable.length}" : "0";
  }

  /// Converts a size and limit to a formatted string with a plus sign if size is greater than limit.
  ///
  /// Example: (8, 5) -> '5+'
  static String toCountingWithPlus(int size, int limit) {
    return size > limit ? "$limit+" : "$size";
  }

  /// Converts a string to contain only letters.
  ///
  /// Example: 'abc123' -> 'abc'
  static String? toLetter(String? value) {
    if (value == null || value.isEmpty) return null;
    String buffer = '';
    for (String character in value.characters) {
      if (Validator.isLetter(character)) buffer = '$buffer$character';
    }
    return buffer;
  }

  /// Converts a string to contain only digits and letters.
  ///
  /// Example: 'abc123!@#' -> 'abc123'
  static String? toDigitWithLetter(String? value) {
    if (value == null || value.isEmpty) return null;
    String buffer = '';
    for (String character in value.characters) {
      if (Validator.isDigit(character) || Validator.isLetter(character)) {
        buffer = '$buffer$character';
      }
    }
    return buffer;
  }

  /// Converts a string to contain only digits and a plus sign.
  ///
  /// Example: '123abc!@#' -> '123+'
  static String? toDigitWithPlus(String? value) {
    if (value == null || value.isEmpty) return null;
    String buffer = '';
    for (String character in value.characters) {
      if (character == '+' || Validator.isDigit(character)) {
        buffer = '$buffer$character';
      }
    }
    return buffer;
  }

  /// Converts a value to a double.
  ///
  /// Example: '3.14' -> 3.14
  static double toDouble(Object? value) {
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    } else if (value is int) {
      return value.toDouble();
    } else if (value is double) {
      return value;
    } else {
      return 0.0;
    }
  }

  /// Converts a value to an integer.
  ///
  /// Example: '42' -> 42
  static int toInt(Object? value) {
    if (value is String) {
      return int.tryParse(value) ?? 0;
    } else if (value is int) {
      return value;
    } else if (value is double) {
      return value.toInt();
    } else {
      return 0;
    }
  }

  /// Converts a counter value to a formatted string with unit.
  ///
  /// Example: (1500, 'item', 'items', Counter.kmb) -> '1.5k items'
  static String toKMB(
    int counter,
    String singularName,
    String pluralName, [
    NumberUnits unit = NumberUnits.auto,
  ]) {
    if (counter > 1) {
      return "${unit.read(counter).text} $pluralName";
    } else {
      return "$counter $singularName";
    }
  }

  /// Converts the length of a list to a formatted string with unit.
  ///
  /// Example: ([1, 2, 3], 'item', 'items', Counter.kmb) -> '3 items'
  static String toKMBFromList(
    List<dynamic> list,
    String singularName,
    String pluralName, [
    NumberUnits unit = NumberUnits.auto,
  ]) {
    return toKMB(list.length, singularName, pluralName, unit);
  }

  /// Converts a comma-separated string or list to a list of a specified type.
  ///
  /// Example: '1,2,3' -> [1, 2, 3]
  static List<T> toList<T>({
    List<dynamic>? list,
    String? value,
    String regex = ",",
  }) {
    if (list != null && list.isNotEmpty && list.first is T) {
      return list.cast<T>();
    } else if (value != null) {
      return value.split(regex).cast<T>();
    } else {
      return [];
    }
  }

  /// Converts prefix, suffix, and type to a formatted email address.
  ///
  /// Example: ('john.doe', 'example', 'com') -> 'john.doe@example.com'
  static String? toMail(
    String prefix,
    String suffix, [
    String type = "com",
  ]) {
    final String mail = "$prefix@$suffix.$type";
    return Validator.isValidEmail(mail) ? mail : null;
  }

  /// Converts a string to contain only numeric characters.
  ///
  /// Example: 'abc123!@#' -> '123'
  static String toNumeric(String? value, [bool onlyDigit = false]) {
    String buffer = '';
    if (value != null) {
      for (String character in value.characters) {
        if (onlyDigit
            ? Validator.isDigit(character)
            : Validator.isNumeric(character)) {
          buffer = '$buffer$character';
        }
      }
    }
    return buffer;
  }

  /// Converts a path string to a list of path segments.
  ///
  /// Example: 'path/to/file' -> ['path', 'to', 'file']
  static List<String> toPathSegments(String path) =>
      toList(value: path, regex: "/");

  /// Converts a list to a reversed list.
  ///
  /// Example: [1, 2, 3] -> [3, 2, 1]
  static List<T> toReversedList<T>(List<T> list) => list.reversed.toList();

  /// Converts a list to a set.
  ///
  /// Example: [1, 2, 3] -> {1, 2, 3}
  static Set<T>? toSet<T>(List<T> list) =>
      list.isNotEmpty ? Set.from(list) : null;

  /// Converts a string to a Uri.
  ///
  /// Example: 'https://example.com' -> Uri object
  static Uri toUri(String url) => Uri.parse(url);

  /// Converts a username by applying regex and replacements.
  ///
  /// Example: ('John Doe', regexList: [' '], replacements: ['_']) -> 'john_doe'
  static String toUserName(
    String name, {
    List<String>? regexList,
    List<String>? replacements,
  }) {
    final String current = Replacement.auto(name).toLowerCase();
    if (replacements != null) {
      return Replacement.multiple(current, replacements, regexList ?? []);
    } else {
      return Replacement.single(current, "", regexList);
    }
  }

  /// Converts a value to the specified type.
  ///
  /// Example: (42) -> 42
  static T? toValue<T>(dynamic value) => value is T ? value : null;
}
