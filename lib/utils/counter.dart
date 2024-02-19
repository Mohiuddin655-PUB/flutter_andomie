/// A utility class for handling counting values and converting them to abbreviated forms.
part of '../utils.dart';

/// Enumeration representing different counter formats.
enum Counter {
  k,
  km,
  kmb;

  /// Converts the given [value] to abbreviated form for "K" count.
  static String toKCount(int value) => value.toKCount;

  /// Converts the given [value] to abbreviated form for "KM" count.
  static String toKMCount(int value) => value.toKMCount;

  /// Converts the given [value] to abbreviated form for "KMB" count.
  static String toKMBCount(int value) => value.toKMBCount;
}

/// Extension on [int] to convert counting values to abbreviated forms.
extension CounterExtension on int {
  /// Converts the integer to abbreviated form for "K" count.
  String get toKCount {
    if (this >= 1000) {
      return "${this ~/ 1000}K";
    }

    return "$this";
  }

  /// Converts the integer to abbreviated form for "KM" count.
  String get toKMCount {
    if (this >= 1000 && this < 1000000) {
      return "${this ~/ 1000}K";
    }

    if (this >= 1000000) {
      return "${this ~/ 1000000}M";
    }

    return "$this";
  }

  /// Converts the integer to abbreviated form for "KMB" count.
  String get toKMBCount {
    if (this >= 1000 && this < 1000000) {
      return "${this ~/ 1000}K";
    }

    if (this >= 1000000 && this < 1000000000) {
      return "${this ~/ 1000000}M";
    }

    if (this >= 1000000000) {
      return "${this ~/ 1000000000}B";
    }

    return "$this";
  }
}
