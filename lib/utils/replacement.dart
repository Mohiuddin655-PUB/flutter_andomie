/// A utility class for performing string replacements.
part of '../utils.dart';

class Replacement {
  const Replacement._();

  /// Automatically replaces characters based on predefined replacement rules.
  ///
  /// Parameters:
  /// - [value]: The input string to perform replacements on.
  ///
  /// Example:
  /// ```dart
  /// String result = Replacement.auto("Hello! How are you?");
  /// print(result); // Output: 'Hello How are you'
  /// ```
  static String auto(String value) {
    for (int index = 0; index < value.length; index++) {
      for (String reg in Regex.none) {
        value = value.replaceAll(reg, "");
      }
      for (String s in Regex.slash) {
        value = value.replaceAll(s, "_");
      }
    }
    return value;
  }

  /// Replaces specific characters in the input string with the specified replacement.
  ///
  /// Parameters:
  /// - [value]: The input string to perform replacements on.
  /// - [replacement]: The string to replace the matched characters with.
  /// - [regex]: A list of regular expressions to match characters for replacement.
  ///
  /// Example:
  /// ```dart
  /// String result = Replacement.single("Hello, World!", "-", ["!"]);
  /// print(result); // Output: 'Hello, World-'
  /// ```
  static String single(
    String value,
    String replacement,
    List<String>? regex,
  ) {
    if (regex != null && regex.isNotEmpty) {
      for (String reg in regex) {
        value = value.replaceAll(reg, replacement);
      }
    }
    return value;
  }

  /// Replaces multiple occurrences of characters in the input string with corresponding replacements.
  ///
  /// Parameters:
  /// - [value]: The input string to perform replacements on.
  /// - [replacements]: A list of strings to replace matched characters with.
  /// - [regex]: A list of regular expressions to match characters for replacement.
  ///
  /// Example:
  /// ```dart
  /// String result = Replacement.multiple("Hello, World!", ["_", "+"], [" ", "!"]);
  /// print(result); // Output: 'Hello+_World_'
  /// ```
  static String multiple(
    String value,
    List<String> replacements,
    List<String> regex,
  ) {
    final valid = Validator.isMatched(regex.length, replacements.length);
    if (regex.isNotEmpty && valid) {
      for (int index = 0; index < value.length; index++) {
        value = value.replaceAll(regex[index], replacements[index]);
      }
    }
    return value;
  }
}

/// A collection of common regular expressions for character removal.
class Regex {
  /// List of characters to remove from the input string.
  static const List<String> none = [
    "!",
    "@",
    "#",
    "\$",
    "^",
    "*",
    "+",
    "=",
    "{",
    "}",
    "[",
    "]",
    "\\",
    "|",
    ":",
    ";",
    "<",
    ">",
    "?",
    "/",
    "%",
    "(",
    ")",
    ".",
  ];

  /// List of characters to replace with underscores in the input string.
  static const List<String> slash = [
    " ",
    "\"",
    "'",
    ",",
    "-",
    "&",
  ];
}
