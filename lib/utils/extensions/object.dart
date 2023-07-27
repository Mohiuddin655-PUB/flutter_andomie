part of 'extensions.dart';

extension ObjectExtension on Object? {
  bool get isValid => this != null;

  bool get isNotValid => !isValid;

  bool get isMap => this is Map<String, dynamic>;

  bool equals(dynamic compare) => this != null && this == compare;

  T? getValue<T>({String key = "", T? defaultValue}) {
    var root = this;
    if (root is Map<String, dynamic>) {
      var data = root[key];
      if (data is T) {
        return data;
      } else {
        return defaultValue;
      }
    } else {
      if (root is T) {
        return root;
      } else {
        return defaultValue;
      }
    }
  }
}
