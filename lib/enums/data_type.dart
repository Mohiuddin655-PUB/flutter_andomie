enum DataType {
  INT,
  DOUBLE,
  STRING,
  BOOL,
  JSON,
  OBJECT,
  INTS,
  DOUBLES,
  STRINGS,
  BOOLS,
  JSONS,
  OBJECTS,
  NULL,
  OTHER;

  factory DataType._parseStr(String value) {
    if (value.isBool) return DataType.BOOL;
    if (value.isInt) return DataType.INT;
    if (value.isDouble) return DataType.DOUBLE;
    return DataType.STRING;
  }

  factory DataType._parseStrings(Iterable<String> strings) {
    if (strings.isBooleans) return DataType.BOOLS;
    if (strings.isInts) return DataType.INTS;
    if (strings.isDoubles) return DataType.DOUBLES;
    return DataType.OBJECTS;
  }

  factory DataType.detect(Object? value, {bool parseable = false}) {
    if (value == null) return DataType.NULL;
    if (value is int) return DataType.INT;
    if (value is double) return DataType.DOUBLE;
    if (value is String) {
      if (parseable) return DataType._parseStr(value);
      return DataType.STRING;
    }
    if (value is bool) return DataType.BOOL;
    if (value is Iterable<int>) return DataType.INTS;
    if (value is Iterable<double>) return DataType.DOUBLES;
    if (value is Iterable<String>) {
      if (parseable) return DataType._parseStrings(value);
      return DataType.STRINGS;
    }
    if (value is Iterable<bool>) return DataType.BOOLS;
    if (value is Map<String, dynamic>) return DataType.JSON;
    if (value is Iterable<Map<String, dynamic>>) return DataType.JSONS;
    if (value is Iterable) return DataType.OBJECTS;
    if (value is Map) return DataType.OBJECT;
    return DataType.OTHER;
  }
}

extension DataTypeStringHelper on String? {
  String get _ => (this ?? "").trim().toLowerCase();

  bool get isBool {
    return RegExp(r'^(true|false)$', caseSensitive: false).hasMatch(_);
  }

  bool get isInt {
    return RegExp(r'^-?\d+$').hasMatch(_);
  }

  bool get isDouble {
    return RegExp(r'^-?\d*\.\d+$').hasMatch(_);
  }

  bool get isNum {
    return RegExp(r'^-?\d+(\.\d+)?$').hasMatch(_);
  }
}

extension DataTypeStringsHelper on Iterable<String>? {
  Iterable<String> get _ => this ?? [];

  bool get isBooleans => _.every((e) => e.isBool);

  bool get isInts => _.every((e) => e.isInt);

  bool get isDoubles => _.every((e) => e.isDouble);

  bool get isNumbers => _.every((e) => e.isNum);

  List<bool> get booleans => _.map(bool.tryParse).whereType<bool>().toList();

  List<int> get ints => _.map(int.tryParse).whereType<int>().toList();

  List<double> get doubles {
    return _.map(double.tryParse).whereType<double>().toList();
  }

  List<num> get numbers => _.map(num.tryParse).whereType<num>().toList();
}

extension DataTypeHelper on Object? {
  DataType get dataType => DataType.detect(this);

  DataType dataTypeWithOptions({bool parseable = false}) {
    return DataType.detect(this, parseable: parseable);
  }
}
