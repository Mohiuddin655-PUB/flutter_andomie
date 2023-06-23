part of 'models.dart';

class Value<T> {
  final String mScreenName;
  final DataType mDataType;
  final T? mData;

  const Value(this.mScreenName, this.mDataType, [this.mData]);
}

class KeyValue {
  final String mKey;
  final dynamic mValue;
  late DataType mType;

  KeyValue(
    this.mKey,
    this.mValue,
  );

  String get key => mKey;

  T? value<T>() => mValue is T ? mValue : null;

  DataType get type {
    if (mValue is bool) {
      return DataType.boolean;
    } else if (mValue is Uint8List) {
      return DataType.byte;
    } else if (mValue is double) {
      return DataType.double;
    } else if (mValue is int) {
      return DataType.int;
    } else if (mValue is String) {
      return DataType.string;
    } else if (mValue is List) {
      return DataType.list;
    } else {
      return DataType.none;
    }
  }
}
