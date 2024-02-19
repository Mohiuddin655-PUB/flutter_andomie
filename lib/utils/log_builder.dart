// utils.dart

/// A utility class for building structured logs with tags.
part of '../utils.dart';

class LogBuilder {
  final String tag;
  String _builder = '';
  String _attachingSeparator = " = ";
  String _puttingSeparator = " : ";
  String _startingSign = "  -> ";
  String _lineBreak = '\n';

  /// Creates a new instance of [LogBuilder] with the specified [tag].
  LogBuilder(this.tag) {
    _builder = "$tag\n {$_lineBreak";
  }

  /// Gets an instance of [LogBuilder] with the specified [tag].
  static LogBuilder getInstance(String tag) {
    return LogBuilder(tag);
  }

  /// Attaches a name-value pair to the log.
  LogBuilder attach(String name, dynamic value) {
    _builder = "$_builder$_attachingSeparator$value, ";
    return this;
  }

  /// Attaches the final name-value pair to the log and ends the attachment section.
  LogBuilder attachEnd(String name, dynamic value) {
    _builder = "$_builder$name$_attachingSeparator$value ]$_lineBreak";
    return this;
  }

  /// Starts a new attachment section with the specified name.
  LogBuilder attachStart(String name) {
    _builder = "$_builder$_startingSign$name$_attachingSeparator[ ";
    return this;
  }

  /// Sets the separator used for attaching name-value pairs.
  LogBuilder setAttachSeparator(String separator) {
    _attachingSeparator = separator;
    return this;
  }

  /// Puts a name-value pair directly into the log.
  LogBuilder put(String name, dynamic value) {
    if (value is List) {
      return puts(name, value);
    } else {
      _builder = "$_builder"
          "$_startingSign"
          "$name"
          "$_puttingSeparator"
          "$value"
          "$_lineBreak";
    }
    return this;
  }

  /// Puts a name and a list of data directly into the log.
  LogBuilder puts(String name, List<dynamic>? data) {
    if (data != null && data.isNotEmpty) {
      _builder = "$_builder"
          "$_startingSign"
          "$name"
          "$_puttingSeparator";
      if (data.length > 3) {
        _builder = "$_builder[ "
            "${data[0]}, "
            "${data[1]}, "
            "${data[2]}... "
            "${data.length} ]";
      } else {
        _builder = "$_builder$data";
      }
      _builder = "$_builder$_lineBreak";
      return this;
    } else {
      return put(name, "null");
    }
  }

  /// Sets the separator used for putting name-value pairs.
  LogBuilder setPutSeparator(String separator) {
    _puttingSeparator = separator;
    return this;
  }

  /// Sets the starting sign for each log entry.
  LogBuilder setStartingSign(String sign) {
    _startingSign = sign;
    return this;
  }

  /// Sets the line break used in the log.
  LogBuilder setLineBreak(String lineBreak) {
    _lineBreak = lineBreak;
    return this;
  }

  /// Builds and logs the constructed log.
  void build() {
    _builder = "$_builder}\n\n";
    developer.log(_builder, name: tag);
  }
}
