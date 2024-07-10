import 'dart:math';

/// Represents a human-readable format for a numeric value.
final class Readable {
  final num size;
  final String type;
  final int fractionDigits;

  /// Constructs a [Readable] instance with the given [size], [type], and
  /// optional [fractionDigits].
  ///
  /// - [size]: The numeric value to be formatted.
  /// - [type]: The unit of the value (e.g., KB, MB).
  /// - [fractionDigits]: The number of decimal places to include. Default is 1.
  const Readable(
    this.size,
    this.type, [
    this.fractionDigits = 1,
  ]);

  /// Returns the formatted text representation of the [Readable] instance.
  ///
  /// If [fractionDigits] is 0, the value is formatted with no decimal places.
  /// Otherwise, it is formatted with the specified number of decimal places,
  /// and trailing zeros are removed.
  String get text {
    if (fractionDigits == 0) return "${size.toStringAsFixed(0)} $type";
    return "${size.toStringAsFixed(fractionDigits).replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")}${fractionDigits > 1 ? " " : ""}$type";
  }

  @override
  String toString() => text;
}

/// Enum representing various byte units and their conversion values.
enum ByteUnits {
  bytes(name: "bytes", value: 0),
  kb(name: "KB", value: 1),
  mb(name: "MB", value: 2),
  gb(name: "GB", value: 3),
  tb(name: "TB", value: 4),
  pb(name: "PB", value: 5),
  eb(name: "EB", value: 6),
  zb(name: "ZB", value: 7),
  yb(name: "YB", value: 8),
  auto;

  final String name;
  final double value;

  const ByteUnits({
    this.name = '',
    this.value = 0,
  });

  /// Returns the unit value for the byte unit.
  ///
  /// For [bytes], the unit is 1. For other units, it is 1024 raised to the
  /// power of [value].
  num get unit => this == bytes ? 1 : pow(1024, value);

  /// Returns the [ByteUnits] instance at the specified [index].
  ByteUnits operator [](int index) => values.elementAt(index);

  /// Formats the given [value] as a [Readable] instance using the byte unit.
  ///
  /// If the unit is [auto], it automatically determines the most appropriate
  /// unit based on the [value].
  ///
  /// Example:
  /// ```dart
  /// Readable readable = ByteUnits.mb.read(2048);
  /// print(readable); // Output: 2.00 MB
  /// ```
  Readable read(num? value) {
    value ??= 0;
    if (this == auto) {
      if (value <= 0) return Readable(0, bytes.name);
      final i = (value == 0) ? 0 : (log(value) / log(1024)).floor();
      final u = this[i];
      return Readable(value / u.unit, u.name, 2);
    } else {
      return Readable(value / unit, name, 2);
    }
  }

  double write(num? value) {
    value ??= 0;
    if (this == auto) {
      if (value <= 0) return 0;
      final i = (value == 0) ? 0 : (log(value) / log(1024)).floor();
      final u = this[i];
      return (value * u.unit).toDouble();
    } else {
      return (value * unit).toDouble();
    }
  }
}

/// Enum representing various numeric units and their conversion values.
enum NumberUnits {
  none(name: "", value: 0),
  k(name: "K", value: 1),
  m(name: "M", value: 2),
  b(name: "B", value: 3),
  auto;

  final String name;
  final double value;

  const NumberUnits({
    this.name = '',
    this.value = 0,
  });

  /// Returns the unit value for the numeric unit.
  ///
  /// For [none], the unit is 1. For other units, it is 1000 raised to the
  /// power of [value].
  num get unit => this == none ? 1 : pow(1000, value);

  /// Returns the [NumberUnits] instance at the specified [index].
  NumberUnits operator [](int index) => values.elementAt(index);

  /// Formats the given [value] as a [Readable] instance using the numeric unit.
  ///
  /// If the unit is [auto], it automatically determines the most appropriate
  /// unit based on the [value].
  ///
  /// Example:
  /// ```dart
  /// Readable readable = NumberUnits.m.read(1500000);
  /// print(readable); // Output: 1.5 M
  /// ```
  Readable read(num? value) {
    value ??= 0;
    if (this == auto) {
      if (value <= 0) return Readable(0, none.name);
      final i = (value == 0) ? 0 : (log(value) / log(1000)).floor();
      final u = this[i];
      return Readable(value / u.unit, u.name, 1);
    } else {
      return Readable(value / unit, name, 1);
    }
  }

  double write(num? value) {
    value ??= 0;
    if (this == auto) {
      if (value <= 0) return 0;
      final i = (value == 0) ? 0 : (log(value) / log(1000)).floor();
      final u = this[i];
      return (value * u.unit).toDouble();
    } else {
      return (value * unit).toDouble();
    }
  }
}

/// A utility class for converting numeric values to human-readable formats.
class Number {
  const Number._();

  /// Converts a numeric value to a human-readable byte format.
  ///
  /// Example:
  /// ```dart
  /// Readable readableBytes = Number.toReadableBytes(2048);
  /// print(readableBytes); // Output: 2.00 KB
  /// ```
  static Readable toReadableBytes(
    num? value, {
    ByteUnits unit = ByteUnits.auto,
  }) {
    return unit.read(value);
  }

  /// Converts a numeric value to a human-readable number format.
  ///
  /// Example:
  /// ```dart
  /// Readable readableNumber = Number.toReadableNumber(1500000);
  /// print(readableNumber); // Output: 1.5 M
  /// ```
  static Readable toReadableNumber(
    num? value, {
    NumberUnits unit = NumberUnits.auto,
  }) {
    return unit.read(value);
  }

  static double toRealBytes(num? value, ByteUnits unit) {
    return unit.write(value);
  }

  static double toRealNumber(num? value, NumberUnits unit) {
    return unit.write(value);
  }
}

/// Extension methods on [num] for converting to human-readable formats.
extension NumberHelper on num? {
  /// Converts the number to a human-readable byte format.
  ///
  /// Example:
  /// ```dart
  /// Readable readableBytes = 2048.toReadableBytes;
  /// print(readableBytes); // Output: 2.00 KB
  /// ```
  Readable get toReadableBytes => ByteUnits.auto.read(this);

  /// Converts the number to a human-readable number format.
  ///
  /// Example:
  /// ```dart
  /// Readable readableNumber = 1500000.toReadableNumber;
  /// print(readableNumber); // Output: 1.5 M
  /// ```
  Readable get toReadableNumber => NumberUnits.auto.read(this);

  /// If [fractionDigits] is 0, the value is formatted with no decimal places.
  /// Otherwise, it is formatted with the specified number of decimal places,
  /// and trailing zeros are removed.
  ///
  /// Example:
  /// ```dart
  /// String number = null.text;
  /// print(number); // Output:
  ///
  /// number = 15.0005.text;
  /// print(number); // Output: 15
  ///
  /// number = 15.0505.text;
  /// print(number); // Output: 15.05
  /// ```
  String get text => toText(2);

  /// If [fractionDigits] is 0, the value is formatted with no decimal places.
  /// Otherwise, it is formatted with the specified number of decimal places,
  /// and trailing zeros are removed.
  ///
  /// Example:
  /// ```dart
  /// String number = null.toText(2);
  /// print(number); // Output:
  ///
  /// number = 15.0005.toText(2);
  /// print(number); // Output: 15
  ///
  /// number = 15.0505.toText(2);
  /// print(number); // Output: 15.05
  /// ```
  String toText([int fractionDigits = 2]) {
    if (this == null) return "";
    if (this is int) return toString();
    final value = this ?? 0.0;
    if (fractionDigits == 0) return value.toStringAsFixed(0);
    return "${value.toStringAsFixed(fractionDigits).replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")}${fractionDigits > 1 ? " " : ""}";
  }
}

extension NumberHelperForIterable on Iterable? {
  /// Converts the number to a human-readable byte format.
  ///
  /// Example:
  /// ```dart
  /// Readable readableBytes = 2048.toReadableBytes;
  /// print(readableBytes); // Output: 2.00 KB
  /// ```
  Readable get toReadableBytes => ByteUnits.auto.read(this?.length);

  /// Converts the number to a human-readable number format.
  ///
  /// Example:
  /// ```dart
  /// Readable readableNumber = 1500000.toReadableNumber;
  /// print(readableNumber); // Output: 1.5 M
  /// ```
  Readable get toReadableNumber => NumberUnits.auto.read(this?.length);
}

extension StringNumberHelper on String? {
  int get asInt => int.tryParse(this ?? "0") ?? 0;

  double get asDouble => double.tryParse(this ?? "0") ?? 0;
}
