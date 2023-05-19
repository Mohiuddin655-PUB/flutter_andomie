part of '../../utils.dart';

enum Counter {
  K,
  KM,
  KMB;

  static String toKCount(int value) {
    if (value >= 1000) {
      return "${value ~/ 1000}K";
    }

    return "$value";
  }

  static String toKMCount(int value) {
    if (value >= 1000 && value < 1000000) {
      return "${value ~/ 1000}K";
    }

    if (value >= 1000000) {
      return "${value ~/ 1000000}M";
    }

    return "$value";
  }

  static String toKMBCount(int value) {
    if (value >= 1000 && value < 1000000) {
      return "${value ~/ 1000}K";
    }

    if (value >= 1000000 && value < 1000000000) {
      return "${value ~/ 1000000}M";
    }

    if (value >= 1000000000) {
      return "${value ~/ 1000000000}B";
    }

    return "$value";
  }
}
