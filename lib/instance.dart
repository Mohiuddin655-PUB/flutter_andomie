import 'package:flutter_andomie/utils/internet.dart';

typedef OnAndomieDateFormatter = String Function(
  String format,
  String? locale,
  DateTime date,
);

typedef OnAndomieDecimalFormatter = String Function(
  String? locale,
  dynamic number,
);

typedef OnAndomieDecimalParser = num Function(
  String? locale,
  String formattedNumber,
);

class Andomie {
  OnAndomieDateFormatter? _dateFormatter;
  OnAndomieDecimalFormatter? _decimalFormatter;
  OnAndomieDecimalParser? _decimalParser;

  Andomie._();

  static Andomie? _i;

  static Andomie get i => _i ??= Andomie._();

  /// ```dart
  /// Andomie.init(
  ///   // CONNECTIVITY
  ///   connected: ConnectivityProvider.I.isConnected,
  ///   connection: ConnectivityProvider.I.connection,
  ///
  ///   // DATE FORMATTER
  ///   dateFormatter: (format, locale, date) {
  ///      return DateFormat(format, locale).format(date);
  ///   },
  ///
  ///   // DECIMAL NUMBER FORMATTER
  ///   decimalFormatter: (locale, number) {
  ///      return NumberFormat.decimalPattern(locale).format(number);
  ///   },
  ///
  ///   // DECIMAL NUMBER PARSER
  ///   decimalParser: (locale, formattedNumber) {
  ///      return NumberFormat.decimalPattern(locale).parse(formattedNumber);
  ///   },
  /// );
  /// ```
  static void init({
    Future<bool>? connected,
    Stream<bool>? connection,
    OnAndomieDateFormatter? dateFormatter,
    OnAndomieDecimalFormatter? decimalFormatter,
    OnAndomieDecimalParser? decimalParser,
  }) {
    if (dateFormatter != null) i._dateFormatter = dateFormatter;
    if (decimalFormatter != null) i._decimalFormatter = decimalFormatter;
    if (decimalParser != null) i._decimalParser = decimalParser;
    if (connected != null && connection != null) {
      Internet.init(connected: connected, connection: connection);
    }
  }

  static void dispose() {
    Internet.i.dispose();
  }

  /// ```dart
  /// Andomie.dateFormatter = (format, locale, date) {
  ///   return DateFormat(format, locale).format(date);
  /// }
  /// ```
  static set dateFormatter(OnAndomieDateFormatter? value) {
    i._dateFormatter = value;
  }

  static OnAndomieDateFormatter get dateFormatter {
    if (i._dateFormatter != null) return i._dateFormatter!;
    throw UnimplementedError(
      "dateFormatter has not been initialized yet. First, initialize it using:\n\n"
      "$Andomie.init(\n"
      "  dateFormatter: (format, locale, date) {\n"
      "     return DateFormat(format, locale).format(date);\n"
      "  },\n"
      ");\n\n"
      "Or,\n\n"
      "$Andomie.dateFormatter = (format, locale, date) {\n"
      "  return DateFormat(format, locale).format(date);\n"
      "},\n\n"
      "Then, you can use it.\n",
    );
  }

  /// ```dart
  /// Andomie.decimalFormatter = (locale, number) {
  ///   return NumberFormat.decimalPattern(locale).format(number);
  /// }
  /// ```
  static set decimalFormatter(OnAndomieDecimalFormatter? value) {
    i._decimalFormatter = value;
  }

  static OnAndomieDecimalFormatter get decimalFormatter {
    if (i._decimalFormatter != null) return i._decimalFormatter!;
    throw UnimplementedError(
      "decimalFormatter has not been initialized yet. First, initialize it using:\n\n"
      "$Andomie.init(\n"
      "  decimalFormatter: (locale, number) {\n"
      "     return NumberFormat.decimalPattern(locale).format(number);\n"
      "  },\n"
      ");\n\n"
      "Or,\n\n"
      "$Andomie.decimalFormatter = (locale, number) {\n"
      "  return NumberFormat.decimalPattern(locale).format(number);\n"
      "},\n\n"
      "Then, you can use it.\n",
    );
  }

  /// ```dart
  /// Andomie.decimalParser = (locale, formattedNumber) {
  ///   return NumberFormat.decimalPattern(locale).parse(formattedNumber);
  /// }
  /// ```
  static set decimalParser(OnAndomieDecimalParser? value) {
    i._decimalParser = value;
  }

  static OnAndomieDecimalParser get decimalParser {
    if (i._decimalParser != null) return i._decimalParser!;
    throw UnimplementedError(
      "decimalParser has not been initialized yet. First, initialize it using:\n\n"
      "$Andomie.init(\n"
      "  decimalParser: (locale, formattedNumber) {\n"
      "     return NumberFormat.decimalPattern(locale).parse(formattedNumber);\n"
      "  },\n"
      ");\n\n"
      "Or,\n\n"
      "$Andomie.decimalParser = (locale, formattedNumber) {\n"
      "  return NumberFormat.decimalPattern(locale).parse(formattedNumber);\n"
      "},\n\n"
      "Then, you can use it.\n",
    );
  }
}
