part of '../utils.dart';

class LogBuilder {
  final String tag;
  String _builder = '';
  String _attachingSeparator = " = ";
  String _puttingSeparator = " : ";
  String _startingSign = "  -> ";
  String _lineBreak = '\n';

  LogBuilder(this.tag) {
    _builder = "$tag\n {$_lineBreak";
  }

  static LogBuilder getInstance(String tag) {
    return LogBuilder(tag);
  }

  LogBuilder attach(String name, dynamic value) {
    _builder = "$_builder$_attachingSeparator$value, ";
    return this;
  }

  LogBuilder attachEnd(String name, dynamic value) {
    _builder = "$_builder$name$_attachingSeparator$value ]$_lineBreak";
    return this;
  }

  LogBuilder attachStart(String name) {
    _builder = "$_builder$_startingSign$name$_attachingSeparator[ ";
    return this;
  }

  LogBuilder setAttachSeparator(String separator) {
    _attachingSeparator = separator;
    return this;
  }

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

  LogBuilder setPutSeparator(String separator) {
    _puttingSeparator = separator;
    return this;
  }

  LogBuilder setStartingSign(String sign) {
    _startingSign = sign;
    return this;
  }

  LogBuilder setLineBreak(String lineBreak) {
    _lineBreak = lineBreak;
    return this;
  }

  void build() {
    _builder = "$_builder}\n\n";
    developer.log(_builder, name: tag);
  }
}
